# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

## no critic (Modules::RequireExplicitPackage)

use Kernel::System::Service ();    ## no perlimports

package Kernel::System::Service;   ## no critic (Modules::RequireFilenameMatchesPackage)

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::Type',
    'Kernel::System::Valid',
);

sub ExportServices {
    my ( $Self, %Param ) = @_;

    my $UserID = $Self->{UserID} || $Param{UserID};

    my %ServiceFilter;
    if ( IsArrayRefWithData( $Param{Services} ) ) {
        %ServiceFilter = map { $_ => 1 } $Param{Services}->@*;
    }

    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    my %ServiceList = $ServiceObject->ServiceList(
        Valid  => 0,
        UserID => $UserID,
    );

    my %ExportData;
    SERVICEID:
    for my $ServiceID ( sort keys %ServiceList ) {

        my %ServiceData = $ServiceObject->ServiceGet(
            ServiceID => $ServiceID,
            UserID    => $UserID,
        );

        if (%ServiceFilter) {
            next SERVICEID unless $ServiceFilter{ $ServiceData{Name} };
        }

        # translate IDs into names or name-like identifiers
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
        my $TypeObject  = $Kernel::OM->Get('Kernel::System::Type');
        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        ATTRIBUTE:
        for my $Attribute ( keys %ServiceData ) {

            next ATTRIBUTE unless $Attribute =~ /ID/;

            if ( $Attribute eq 'ValidID' ) {
                my $Valid = $ValidObject->ValidLookup(
                    ValidID => $ServiceData{ValidID},
                );
                $ServiceData{Valid} = $Valid;
                delete $ServiceData{ValidID};
            }
            elsif ( $Attribute eq 'QueueID' ) {
                my $Queue = $QueueObject->QueueLookup(
                    QueueID => $ServiceData{QueueID},
                );
                $ServiceData{Queue} = $Queue;
                delete $ServiceData{QueueID};
            }
            elsif ( $Attribute eq 'TypeID' ) {
                my $Type = $TypeObject->TypeLookup(
                    TypeID => $ServiceData{TypeID},
                );
                $ServiceData{Type} = $Type;
                delete $ServiceData{TypeID};
            }
        }

        delete $ServiceData{ChangeTime};
        delete $ServiceData{CreateTime};
        delete $ServiceData{Email};
        delete $ServiceData{QueueID};
        delete $ServiceData{Realname};

        $ExportData{ $ServiceData{Name} } = \%ServiceData;
    }

    return \%ExportData;
}

sub ImportServices {
    my ( $Self, %Param ) = @_;

    my $UserID = $Self->{UserID} || $Param{UserID};

    my $QueueObject   = $Kernel::OM->Get('Kernel::System::Queue');
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
    my $TypeObject    = $Kernel::OM->Get('Kernel::System::Type');
    my $ValidObject   = $Kernel::OM->Get('Kernel::System::Valid');
    my %QueueList     = $QueueObject->QueueList(
        Valid => 0,
    );
    my %QueueLookup = reverse %QueueList;
    my %ServiceList = $ServiceObject->ServiceList(
        Valid  => 0,
        UserID => $UserID,
    );
    my %ServiceLookup = reverse %ServiceList;

    SERVICENAME:
    for my $ServiceName ( keys $Param{Services}->%* ) {
        my $ServiceData = $Param{Services}{$ServiceName};

        # in case of child service, check if all parent services are present
        #   either in the system or in the import data
        my @NameElements = split( /::/, $ServiceData->{Name} );

        # TODO likely not needed, check
        # # check if service levels conform to system configuration
        # my $MaxQueueLevel = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::MaxQueueLevel');
        # if ( scalar @NameElements > $MaxQueueLevel ) {
        #     next QUEUENAME;
        # }

        if ( scalar @NameElements > 1 ) {
            my $NameStrg = '';
            for my $Index ( 0 .. $#NameElements - 1 ) {
                $NameStrg .= $NameElements[$Index];

                if ( !$QueueLookup{$NameStrg} && !$Param{Queues}{$NameStrg} ) {

                    # parent element not found, skipping
                    next QUEUENAME;
                }
            }
        }

        my $ServiceID = $ServiceLookup{ $ServiceData->{Name} };

        # skip if service with same name exists and overwrite is not set
        next SERVICENAME if ( !$Param{OverwriteExistingEntities} && $ServiceID );

        # translate named data back to IDs
        $ServiceData->{QueueID} = $QueueObject->QueueLookup(
            Queue => $ServiceData->{Queue},
        );
        $ServiceData->{TypeID} = $TypeObject->TypeLookup(
            Type => $ServiceData->{Type},
        );
        $ServiceData->{ValidID} = $ValidObject->ValidLookup(
            Valid => $ServiceData->{Valid},
        );

        if ($ServiceID) {

            my $Success = $ServiceObject->ServiceUpdate(
                $ServiceData->%*,
                ServiceID => $ServiceID,
                UserID    => $UserID,
            );
            return unless $Success;
        }
        else {
            my $ServiceID = $ServiceObject->ServiceAdd(
                $ServiceData->%*,
                UserID => $UserID,
            );
            return unless $ServiceID;
        }
    }

    return 1;
}

1;
