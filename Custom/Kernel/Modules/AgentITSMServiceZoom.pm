# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::AgentITSMServiceZoom;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData); # Rother OSS

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $ServiceID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ServiceID' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$ServiceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ServiceID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get service
    my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
        ServiceID     => $ServiceID,
        IncidentState => 1,
        UserID        => $Self->{UserID},
    );
    if ( !$Service{ServiceID} ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'ServiceID %s not found in database!', $ServiceID ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# ---
# Rother OSS / ServiceCatalog
# ---
   # ---------------------------------------------------------- #
    # HTMLView Subaction
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        my %HTMLFile = $LayoutObject->RichTextDocumentServe(
            Data => {
                Content     => $Service{DescriptionLong},
                ContentType => 'text/html; charset="utf-8"',
            },
            URL                => 'Action=AgentITSMServiceZoom;Subaction=HTMLView;ServiceID=' . $ServiceID,
            Attachments        => {},
            LoadInlineContent  => 1,
            LoadExternalImages => 1,
        );

        # add needed HTML headers
        $Service{DescriptionLong} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentComplete(
            String  => $Service{DescriptionLong},
            Charset => 'utf-8',
        );

        # return complete HTML as an attachment
        return $LayoutObject->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $Service{DescriptionLong},
        );
    }
    # ---------------------------------------------------------- #
    # DownloadAttachment Subaction
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        my $FileID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FileID' );

        if ( !defined $FileID ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Need FileID!'),
            );
        }

        # Get attachments.
        my %File = $Kernel::OM->Get('Kernel::System::Service')->AttachmentGet(
            ServiceID => $ServiceID,
            FileID    => $FileID,
            UserID    => $Self->{UserID},
        );
        if (%File) {
            return $LayoutObject->Attachment(%File);
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "No such attachment ($FileID)! May be an attack!!!",
                Priority => 'error',
            );
            return $LayoutObject->ErrorScreen();
        }
    }

    # build dynamic fields.
    my @DynamicFieldList;
    my $DynamicFieldLookup = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'Service',
    );

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldLookup} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        my $ValueGet = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $ServiceID,
            UserID             => $Self->{UserID},
        );

        next DYNAMICFIELD if !$ValueGet;

        # use translation here to be able to reduce the character length in the template
        my $Label = $LayoutObject->{LanguageObject}->Translate( $DynamicField->{Label} );

        my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicField,
            Value              => $ValueGet,
            LayoutObject       => $LayoutObject,
            ValueMaxChars      => 130,
        );

        push @DynamicFieldList, {
            $DynamicField->{Name} => $ValueStrg->{Title},
            Name                  => $DynamicField->{Name},
            Title                 => $ValueStrg->{Title},
            Value                 => $ValueStrg->{Value},
            Label                 => $Label,
            Link                  => $ValueStrg->{Link},
            LinkPreview           => $ValueStrg->{LinkPreview},
            TitleFieldConfig      => ( $DynamicField->{FieldType} eq 'Title' ) ? $DynamicField->{Config} : undef,

            # Include unique parameter with dynamic field name in case of collision with others.
            #   Please see bug#13362 for more information.
            "DynamicField_$DynamicField->{Name}" => $ValueStrg->{Title},
        };
    }

    # output dynamic fields
    FIELD:
    for my $Field (@DynamicFieldList) {

        # handle titles separately
        if ( $Field->{TitleFieldConfig} ) {
            my $Style = "padding-left:4px;font-size:$Field->{TitleFieldConfig}{FontSize}px;color:$Field->{TitleFieldConfig}{FontColor};";

            if ( $Field->{TitleFieldConfig}{CBFontStyleUnderLineValue} ) {
                $Style .= "text-decoration:underline;";
            }
            if ( $Field->{TitleFieldConfig}{CBFontStyleItalicValue} ) {
                $Style .= "font-style:italic;";
            }
            if ( $Field->{TitleFieldConfig}{CBFontStyleBoldValue} ) {
                $Style .= "font-weight:bold;";
            }

            $LayoutObject->Block(
                Name => 'TicketDynamicField',
                Data => {
                    Text       => $Field->{Label},
                    Style      => $Style,
                    TitleField => 1,
                },
            );

            next FIELD;
        }

        $LayoutObject->Block(
            Name => 'ServiceDynamicField',
            Data => {
                Label => $Field->{Label},
            },
        );

        if ( $Field->{Link} ) {
            $LayoutObject->Block(
                Name => 'ServiceDynamicFieldLink',
                Data => {
                    $Field->{Name} => $Field->{Title},
                    Value          => $Field->{Value},
                    Title          => $Field->{Title},
                    Link           => $Field->{Link},
                    LinkPreview    => $Field->{LinkPreview},

                    # Include unique parameter with dynamic field name in case of collision with others.
                    #   Please see bug#13362 for more information.
                    "DynamicField_$Field->{Name}" => $Field->{Title},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'ServiceDynamicFieldPlain',
                Data => {
                    Value => $Field->{Value},
                    Title => $Field->{Title},
                },
            );
        }
    }
# EOC ServiceCatalog

    # run config item menu modules
    if ( ref $ConfigObject->Get('ITSMService::Frontend::MenuModule') eq 'HASH' ) {
        my %Menus   = %{ $ConfigObject->Get('ITSMService::Frontend::MenuModule') };
        my $Counter = 0;
        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Kernel::OM->Get('Kernel::System::Main')->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    ServiceID => $Self->{ServiceID},
                );

                # set classes
                if ( $Menus{$Menu}->{Target} ) {
                    if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                        $Menus{$Menu}->{MenuClass} = 'AsPopup';
                    }
                    elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                        $Menus{$Menu}->{MenuClass} = 'HistoryBack';
                    }
                }

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Service => \%Service,
                    Counter => $Counter,
                    Config  => $Menus{$Menu},
                );
            }
            else {
                return $LayoutObject->FatalError();
            }
        }
    }

    # get sla object
    my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

    # get sla list
    my %SLAList = $SLAObject->SLAList(
        ServiceID => $ServiceID,
        UserID    => $Self->{UserID},
    );
    if (%SLAList) {

        # output row
        $LayoutObject->Block(
            Name => 'SLA',
        );

        for my $SLAID ( sort { $SLAList{$a} cmp $SLAList{$b} } keys %SLAList ) {

            # get sla data
            my %SLA = $SLAObject->SLAGet(
                SLAID  => $SLAID,
                UserID => $Self->{UserID},
            );

            # output row
            $LayoutObject->Block(
                Name => 'SLARow',
                Data => {
                    %SLA,
                },
            );
        }
    }

    # get linked objects
    my $LinkListWithData = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkListWithData(
        Object => 'Service',
        Key    => $ServiceID,
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # get link table view mode
    my $LinkTableViewMode = $ConfigObject->Get('LinkObject::ViewMode');

    # create the link table
    my $LinkTableStrg = $LayoutObject->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
        Object           => 'Service',
        Key              => $ServiceID,
    );

    # output the link table
    if ($LinkTableStrg) {
        $LayoutObject->Block(
            Name => 'LinkTable' . $LinkTableViewMode,
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # set incident signal
    my %InciSignals = (
        Translatable('operational') => 'greenled',
        Translatable('warning')     => 'yellowled',
        Translatable('incident')    => 'redled',
    );

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # get create user data
    $Service{CreateByName} = $UserObject->UserName(
        UserID => $Service{CreateBy},
    );

    # get change user data
    $Service{ChangeByName} = $UserObject->UserName(
        UserID => $Service{ChangeBy},
    );

    # store last screen
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # output header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # generate output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentITSMServiceZoom',
        Data         => {
            %Param,
            %Service,
            CurInciSignal => $InciSignals{ $Service{CurInciStateType} },
        },
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
