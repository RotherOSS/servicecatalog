# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::Output::HTML::CustomerDashboard::TileServiceCatalog;

use strict;
use warnings;

use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::DateTime',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::FAQ',
    'Kernel::System::HTMLUtils',
    'Kernel::System::LinkObject',
    'Kernel::System::Package',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::Ticket',
    'Kernel::System::Type',
    'Kernel::System::Valid',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::LinkObject',
    'Kernel::System::Package'
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SLAObject      = $Kernel::OM->Get('Kernel::System::SLA');
    my $PackageObject  = $Kernel::OM->Get('Kernel::System::Package');

    my $DefaultTimeZone = $Kernel::OM->Create('Kernel::System::DateTime')->OTOBOTimeZoneGet();

    # Get customer user.
    $Param{CustomerUser} = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Param{UserID},
    );

    # Only get information of SLAs or calendars once and save them in hashes.
    my %SLAIDs = $SLAObject->SLAList(
        Valid  => 1,
        UserID => 1,
    );

    # Get all SLA and associated calendar information.
    my %ServiceList;
    my %SLAList;
    my %CalendarList;
    my @WeekDays = ( 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' );    # FIXME/Improve: Work with CalendarWeekDayStart
    for my $SLAID ( keys %SLAIDs ) {
        my %SLAData = $SLAObject->SLAGet(
            SLAID  => $SLAID,
            UserID => 1,
        );
        $SLAList{$SLAID} = \%SLAData;

        # Get all services which use this SLA.
        for my $ServiceID ( @{ $SLAData{ServiceIDs} } ) {
            push @{ $ServiceList{$ServiceID}{SLAIDs} }, $SLAID;
        }

        # Calendar does not exist yet.
        if ( $SLAData{Calendar} && !$CalendarList{ $SLAData{Calendar} } ) {

            # Get the calendar and the time zone.
            my $Calendar = $ConfigObject->Get( 'TimeWorkingHours::Calendar' . $SLAData{Calendar} );
            $Calendar->{TimeZone} = $ConfigObject->Get( 'TimeZone::Calendar' . $SLAData{Calendar} ) || $DefaultTimeZone;

            # Get working days and hours for the week. E.g.: Mo-Fr 12–19, Sat 13–19.
            my %Run;
            for my $Index ( 0 .. ( scalar @WeekDays - 1 ) ) {
                my $Day = $Calendar->{ $WeekDays[$Index] };

                # The day has working hours.
                if ( IsArrayRefWithData($Day) ) {
                    my $FirstHour = $Day->[0];
                    my $LastHour  = $Day->[-1];

                    # We need one hour more, cause the calendar means inclusive the last hour
                    $LastHour++;

                    # First day of the run.
                    if ( !$Run{StartDay} ) {
                        $Run{StartDay}  = $WeekDays[$Index];
                        $Run{FirstHour} = $FirstHour;
                        $Run{LastHour}  = $LastHour;
                    }

                    # The current date has different working hours than the last day of the run.
                    elsif ( $FirstHour != $Run{FirstHour} || $LastHour != $Run{LastHour} ) {

                        # Set the last day to yesterday and reset the run.
                        $Run{LastDay} = $WeekDays[ ( $Index - 1 ) ];
                        push @{ $Calendar->{WorkingHours} }, {%Run};
                        undef %Run;

                        $Run{StartDay}  = $WeekDays[$Index];
                        $Run{FirstHour} = $FirstHour;
                        $Run{LastHour}  = $LastHour;
                    }
                }
                else {
                    # No data for the day. Check if the run needs to be stopped.
                    if ( $Run{StartDay} ) {
                        $Run{LastDay} = $WeekDays[ ( $Index - 1 ) ];
                        push @{ $Calendar->{WorkingHours} }, {%Run};
                        undef %Run;
                    }
                }

                # It's the last day of the week.
                if ( $Index == 6 ) {

                    # If the run is still going on, close it.
                    if ( $Run{StartDay} ) {
                        $Run{LastDay} = $WeekDays[$Index];
                        push @{ $Calendar->{WorkingHours} }, {%Run};
                    }
                }
            }

            $CalendarList{ $SLAData{Calendar} } = $Calendar;
        }
    }

    # Iterate through all avaliable services and filter out the sevices and parameters we need.
    my $ServiceListRefArray = $Kernel::OM->Get('Kernel::System::Service')->ServiceListGet(
        Valid  => 1,
        UserID => 1,
    );

    my %ServiceListRef;

    my %TypeList = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
        Valid => 1,
    );

    # Get all service IDs of the customer.
    my %ServiceIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
        Action         => 'CustomerDashboard',
        CustomerUserID => $Param{UserID},
        QueueID        => 1,
    );

    my $Settings = $ConfigObject->Get('CustomerDashboard::Configuration::ServiceCatalog') || {};
    SERVICEREF:
    for my $ServiceRef ( @{$ServiceListRefArray} ) {
        $ServiceListRef{ $ServiceRef->{ServiceID} } = $ServiceRef;

        # Check if the customer has permission on this service.
        next SERVICEREF if !$ServiceIDs{ $ServiceRef->{ServiceID} };
        my %Service = ();

        # Get all needed parameters
        for my $Needed (qw(ServiceID NameShort Descriptions TicketTypeIDs ParentID Keywords)) {
            if ( $ServiceRef->{$Needed} ) {
                if ( $Needed eq 'TicketTypeIDs' ) {

                    # Get names of all assigned types.
                    for my $TypeID ( @{ $ServiceRef->{$Needed} } ) {
                        my $TypeName = $LanguageObject->Translate( $TypeList{$TypeID} );

                        # Check if the assigned type ID is still valid.
                        if ($TypeName) {
                            $Service{TicketType}{$TypeName} = {
                                ID      => $TypeID,
                                Classes => $Settings->{ $TypeList{$TypeID} },
                            };
                        }
                    }
                } elsif ( $Needed eq 'Descriptions' ) {
                    $Service{DescriptionShort} = $ServiceRef->{$Needed}->{$LayoutObject->{UserLanguage}}->{DescriptionShort} ||
                        $ServiceRef->{$Needed}->{$Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage')}->{DescriptionShort} ||
                        $ServiceRef->{$Needed}->{'en'}->{DescriptionShort} || $LayoutObject->{LanguageObject}->Translate( 'Description not available.' );

                    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

                    my $IconFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                        Name => 'ServiceIcon',
                    );

                    if ($IconFieldConfig) {
                        my $IconValue = $DynamicFieldBackendObject->ValueGet(
                            DynamicFieldConfig => $IconFieldConfig,
                            ObjectID           => $Service{ServiceID},
                        );

                        if ($IconValue) {
                            $Service{ServiceIconClass} = $IconValue;
                        }
                    }

                    $Service{DescriptionLong} = $ServiceRef->{$Needed}->{$LayoutObject->{UserLanguage}}->{DescriptionLong} ||
                        $ServiceRef->{$Needed}->{$Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage')}->{DescriptionLong} ||
                        $ServiceRef->{$Needed}->{'en'}->{DescriptionLong} || $LayoutObject->{LanguageObject}->Translate( 'Description not available.' );
                }
                else {
                    $Service{$Needed} = $ServiceRef->{$Needed};
                }
            }
        }

        # Get all calendar and SLA information for this service.
        my $SLAIDs = $ServiceList{ $Service{ServiceID} }{SLAIDs};

        my %DontSet;
        SLAID:
        for my $SLAID ( @{$SLAIDs} ) {
            my $SLA      = $SLAList{$SLAID};
            my $Calendar = $CalendarList{ $SLA->{Calendar} };

            # This service is linked to at least two SLAs with different first response times.
            if ( $Service{FirstResponseTime} && $Service{FirstResponseTime} ne $SLA->{FirstResponseTime} ) {
                undef $Service{FirstResponseTime};
                $DontSet{FirstResponseTime} = 1;
            }
            elsif ( !$DontSet{FirstResponseTime} ) {
                $Service{FirstResponseTime} = $SLA->{FirstResponseTime};
            }

            # This service is linked to at least two SLAs with different solution times.
            if ( $Service{SolutionTime} && $Service{SolutionTime} ne $SLA->{SolutionTime} ) {
                undef $Service{SolutionTime};
                $DontSet{SolutionTime} = 1;
            }
            elsif ( !$DontSet{SolutionTime} ) {
                $Service{SolutionTime} = $SLA->{SolutionTime};
            }

            # SLA does not have a calendar.
            next SLAID if !$Calendar;

            # This service is linked to at least two SLA calendars with different time zones.
            if ( $Service{TimeZone} && $Calendar->{TimeZone} && $Service{TimeZone} ne $Calendar->{TimeZone} ) {
                undef $Service{TimeZone};
                undef $Service{WorkingHours};
                $DontSet{TimeZone}     = 1;
                $DontSet{WorkingHours} = 1;
            }
            elsif ( !$DontSet{TimeZone} ) {
                $Service{TimeZone} = $Calendar->{TimeZone};
            }

            # This service is linked to at least two different calendars.
            if ( $Service{WorkingHours} ) {

                # Check if working hours are the same.
                INDEX:
                for my $Index ( 0 .. ( scalar @{ $Service{WorkingHours} } - 1 ) ) {
                    if (
                        !$Service{WorkingHours}[$Index] || !$Calendar->{WorkingHours}[$Index]    # Check if runs exist.
                        || $#{ $Service{WorkingHours} } != $#{ $Calendar->{WorkingHours} }       # One run is longer or shorter.
                                                                                                 # Check if they have the same values.
                        || $Service{WorkingHours}[$Index]{StartDay} ne $Calendar->{WorkingHours}[$Index]{StartDay}
                        || $Service{WorkingHours}[$Index]{LastDay} ne $Calendar->{WorkingHours}[$Index]{LastDay}
                        || $Service{WorkingHours}[$Index]{FirstHour} ne $Calendar->{WorkingHours}[$Index]{FirstHour}
                        || $Service{WorkingHours}[$Index]{LastHour} ne $Calendar->{WorkingHours}[$Index]{LastHour}
                        )
                    {
                        undef $Service{WorkingHours};
                        $DontSet{WorkingHours} = 1;
                        last INDEX;
                    }
                }
            }
            elsif ( !$DontSet{WorkingHours} ) {
                $Service{WorkingHours} = $Calendar->{WorkingHours};
            }
        }

        # Check if FAQ modul is installed, if yes we check service related faq messages
        my $FAQInstalled = $PackageObject->PackageIsInstalled(
            Name => 'FAQ',
        );

        # FAQ package is installed
        if ($FAQInstalled) {

            my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

            # Get FAQ interface state list
            my $InterfaceStates = $FAQObject->StateTypeList(
                Types  => $ConfigObject->Get('FAQ::Customer::StateTypes'),
                UserID => $Param{UserID},
            );

            # Get all linked FAQ articles.
            my %LinkKeyList = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkKeyList(
                Object1 => 'Service',
                Key1    => $Service{ServiceID},
                Object2 => 'FAQ',
                State   => 'Valid',
                UserID  => 1,
            );

            # For each LinkKeyList, get the FAQ article.
            for my $LinkKey ( keys %LinkKeyList ) {
                my %FAQData = $FAQObject->FAQGet(
                    ItemID     => $LinkKey,
                    ItemFields => 1,
                    UserID     => $Param{UserID},
                );

                # Check if the user has permission to see this FAQ.
                my @ValidIDs      = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
                my %ValidIDLookup = map { $_ => 1 } @ValidIDs;

                # Check user permission
                my $Permission = $FAQObject->CheckCategoryCustomerPermission(
                    CustomerUser => $Param{CustomerUser},
                    CategoryID   => $FAQData{CategoryID},
                    UserID       => $Param{UserID},
                );

                # Permission check
                if (
                    $Permission
                    && $FAQData{Approved}
                    && $ValidIDLookup{ $FAQData{ValidID} }
                    && $InterfaceStates->{ $FAQData{StateTypeID} }
                    )
                {
                    # Filter out information we don't need.
                    my %FilteredFAQData = ();

                    # Get the config for the FAQ fields we want to display.
                    my $DescriptionFieldToDisplay = $Settings->{FAQDescriptionField} || 'Field1';
                    KEY:
                    for my $Key ( ( 'ItemID', 'Title', $DescriptionFieldToDisplay, 'CategoryName' ) ) {
                        next KEY if !$FAQData{$Key};

                        if ( $Key eq $DescriptionFieldToDisplay ) {

                            # Remove HTML tags.
                            $FilteredFAQData{Description} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
                                String => $FAQData{$Key},
                            );

                            # If the field is longer than 70 characters, add an ellipsis.
                            if ( length( $FilteredFAQData{Description} ) > 45 ) {
                                $FilteredFAQData{Description} = substr( $FilteredFAQData{Description}, 0, 45 ) . '...';
                            }
                        }
                        else {
                            $FilteredFAQData{$Key} = $FAQData{$Key};
                        }
                    }
                    push @{ $Service{FAQs} }, \%FilteredFAQData;
                }
            }
        }

        # Save the service in a list.
        $ServiceList{ $Service{ServiceID} } = \%Service;
    }

    # Add support for dynamic fields.
    my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("CustomerDashboard::Configuration::ServiceCatalog")->{DynamicField} || {} },
    };

    # Get dynamic fields for service object.
    my $DynamicFieldLookup = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Service'],
        FieldFilter => $DynamicFieldFilter || {},
    );
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Get the dynamic field values for every service.
    for my $ServiceID ( keys %ServiceList ) {
        my @DynamicFieldList;

        # # Get the dynamic field values for this service.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicFieldLookup} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # Get the label;
            my $Label = $DynamicFieldConfig->{Label};

            # Get field value.
            my $Value = $DynamicFieldBackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ServiceID,
            );

            my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                LayoutObject       => $LayoutObject,
                ValueMaxChars      => 130,
            );

            # Set field value.
            if ( $Label && $ValueStrg->{Value} ) {
                push @DynamicFieldList, {
                    $ValueStrg->%*,
                    Label => $Label,
                };
            }
        }

        # Add the dynamic field values to the service.
        if ( IsArrayRefWithData( \@DynamicFieldList ) ) {
            $ServiceList{$ServiceID}->{DynamicField} = \@DynamicFieldList;
        }
    }

    # Get the basic information for every parent Service, even if the the customer user does not have permission to see it.
    SERVICEID:
    for my $ServiceID ( keys %ServiceList ) {
        my $ParentID = $ServiceList{$ServiceID}{ParentID};
        next SERVICEID if !$ParentID;

        if ( $ServiceList{$ParentID} && $ServiceList{$ParentID}{ServiceID} ) {
            next SERVICEID;
        }

        # Get sure that we can select every subservice of this service.
        SERVICEDATA:
        while (1) {
            my %Service = ();

            for my $Needed (qw(ServiceID NameShort DescriptionShort DescriptionLong ParentID)) {
                if ( $ServiceListRef{$ParentID}{$Needed} ) {
                    $Service{$Needed} = $ServiceListRef{$ParentID}{$Needed};
                }
            }

            $Service{NotSelectable}             = 1;

            my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

            my $IconFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                Name => 'ServiceIcon',
            );

            if ($IconFieldConfig) {
                my $IconValue = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $IconFieldConfig,
                    ObjectID           => $Service{ServiceID},
                );

                if ($IconValue) {
                    $Service{ServiceIconClass} = $IconValue;
                }
            }

            $ServiceList{ $Service{ServiceID} } = \%Service;
            $ParentID                           = $Service{ParentID};

            # Parent reached.
            if ( !$Service{ParentID} || ( $ServiceList{$ParentID} && $ServiceList{$ParentID}{ServiceID} ) ) {
                last SERVICEDATA;
            }
        }
    }


    # TODO: Names have to be translated somewhere for the breadcrumb, we need to prevent translation of those translated values
    for my $ServiceID ( keys %ServiceList ) {
        $ServiceList{$ServiceID}{NameShort} = $LayoutObject->Output(
            Template => '[%  Translate(Data.Name) | html %]',
            Data     => {
                Name => $ServiceList{$ServiceID}{NameShort},
            },
        );
    }

    # Show all first level services, sorted by the name.
    my %ParentIDs;
    SERVICEID:
    for my $ServiceID ( keys %ServiceList ) {
        next SERVICEID if $ServiceList{$ServiceID}{ParentID};

        # One of these can be undef if the parent service is disabled.
        next SERVICEID if !$ServiceList{$ServiceID};
        next SERVICEID if !$ServiceList{$ServiceID}{NameShort};

        $ParentIDs{$ServiceID} = $ServiceList{$ServiceID}{NameShort};
    }

    my %ReversedParentIDs = reverse %ParentIDs;
    my $NumberOfServices  = 0;
    SERVICENAME:
    for my $ServiceName ( sort values %ParentIDs ) {
        my $ServiceID = $ReversedParentIDs{$ServiceName};
        next SERVICENAME if !$ServiceID;
        $NumberOfServices++;

        if ( $NumberOfServices <= 3 ) {

            # Create the parent list.
            $LayoutObject->Block(
                Name => 'ParentService',
                Data => $ServiceList{$ServiceID},
            );
        }
    }

    if ( $NumberOfServices >= 4 ) {
        $LayoutObject->Block(
            Name => 'ParentServiceMore',
            Data => {
                NumberOfServices => $NumberOfServices - 3,
            },
        );
    }

    # Create navigation field for services.
    $ServiceIDs{'All'} = $LayoutObject->{LanguageObject}->Translate('All');
    my $ServiceStrg = $LayoutObject->BuildSelection(
        Data         => \%ServiceIDs,
        Name         => 'ServiceID',
        Class        => 'Modernize ',
        PossibleNone => 1,
        TreeView     => 1,
        Sort         => 'TreeView',
        Translation  => 0,
        Max          => 200,
    );

    $LayoutObject->AddJSData(
        Key   => 'ServiceList',
        Value => $LayoutObject->JSONEncode(
            Data => \%ServiceList,
        ),
    );

    $LayoutObject->AddJSData(
        Key   => 'ServiceStrg',
        Value => $LayoutObject->JSONEncode(
            Data => $ServiceStrg,
        ),
    );

    if ( $Settings->{SortByTicketType} ) {
        $LayoutObject->AddJSData(
            Key   => 'SortByTicketType',
            Value => $LanguageObject->Translate( $Settings->{SortByTicketType} ),
        );
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'Dashboard/TileServiceCatalog',
        Data         => {
            TileID => $Param{TileID},
            %{ $Param{Config} },
        },
    );

    return $Content;
}

1;
