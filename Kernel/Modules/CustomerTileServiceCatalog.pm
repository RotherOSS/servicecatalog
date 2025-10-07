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

package Kernel::Modules::CustomerTileServiceCatalog;

use strict;
use warnings;

use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

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

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ServiceObject   = $Kernel::OM->Get('Kernel::System::Service');

    # get params
    my $ServiceID = $ParamObject->GetParam( Param => "ServiceID" );

    # ---------------------------------------------------------- #
    # HTMLView Subaction
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        if ( !$ServiceID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Needed ServiceID!",
            );
            return;
        }

        my %Service = $ServiceObject->ServiceGet(
            ServiceID => $ServiceID,
            UserID    => $Self->{UserID},
        );

        # check if the user has permission on this service.
        my %ServiceList = $ServiceObject->CustomerUserServiceMemberList(
            CustomerUserLogin => $Self->{UserID},
            Result            => 'HASH',
        );

        if ( !$ServiceList{ $Service{ServiceID} } ) {
            return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
        }

        # Add _blank target to Links in Long Description
        $Service{DescriptionLong} = $LayoutObject->HTMLLinkQuote(
            String => $Service{Descriptions}{$LayoutObject->{UserLanguage}}{DescriptionLong}
                || $Service{Descriptions}{$Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage')}{DescriptionLong}
                || $Service{Descriptions}{'en'}{DescriptionLong} || $LayoutObject->{LanguageObject}->Translate( 'Description not available.' ),
        );
        
        $Service{DescriptionLong}
            =~ s{ index[.]pl [?] Action=AgentITSMServiceZoom }{customer.pl?Action=CustomerTileServiceCatalog}gxms;

        # build base URL for inline images
        my $SessionID = '';
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
            $Service{DescriptionLong} =~ s{
                (Action=CustomerTileServiceCatalog;Subaction=DownloadAttachment;ServiceID=\d+;FileID=\d+)
            }{$1$SessionID}gmsx;
        }

        my %HTMLFile = $LayoutObject->RichTextDocumentServe(
            Data => {
                Content     => $Service{DescriptionLong},
                ContentType => 'text/html; charset="utf-8"',
            },
            URL                => 'Action=CustomerTileServiceCatalog;Subaction=HTMLView;ServiceID=' . $ServiceID,
            Attachments        => {},
            LoadInlineContent  => 1,
            LoadExternalImages => 1,
        );

        # add needed HTML headers
        $Service{DescriptionLong} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentComplete(
            String            => $Service{DescriptionLong},
            Charset           => 'utf-8',
            CustomerInterface => 1,
            CustomerUIStyles  => 1,
        );

        # return complete HTML as an attachment
        return $LayoutObject->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $Service{DescriptionLong},
        );
    }
    elsif ( $Self->{Subaction} eq 'DynamicFieldView' ) {

        # add support for dynamic fields
        my @DynamicFieldList;
        my $DynamicFieldFilter = {
            %{ $ConfigObject->Get("CustomerDashboard::Configuration::ServiceCatalog")->{DynamicField} || {} },
        };

        # get the dynamic fields for service object
        my $DynamicFieldLookup = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Service'],
            FieldFilter => $DynamicFieldFilter || {},
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

        my $Output = $LayoutObject->Output(
            TemplateFile => 'Dashboard/TileServiceCatalogDynamicFields',
            Data         => {%Param},
        );

        # return complete HTML as an attachment
        return $LayoutObject->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $Output,
        );
    }

    # ---------------------------------------------------------- #
    # DownloadAttachment Subaction
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'DownloadAttachment' ) {
        my $FileID = $ParamObject->GetParam( Param => 'FileID' );

        if ( !defined $FileID ) {
            return $LayoutObject->CustomerFatalError(
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
            return $LayoutObject->CustomerFatalError();
        }
    }

    return $LayoutObject->Redirect(
        OP =>
            "Action=CustomerDashboard",
    );
}

1;
