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

use Kernel::System::SLA ();    ## no perlimports

package Kernel::System::SLA;   ## no critic (Modules::RequireFilenameMatchesPackage)

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::GeneralCatalog',
    'Kernel::System::SLA',
    'Kernel::System::Service',
    'Kernel::System::Valid',
);

sub ExportSLAs {
    my ( $Self, %Param ) = @_;

    my $UserID = $Self->{UserID} || $Param{UserID};

    my %SLAFilter;
    if ( IsArrayRefWithData( $Param{SLAs} ) ) {
        %SLAFilter = map { $_ => 1 } $Param{SLAs}->@*;
    }

    my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

    my %SLAList = $SLAObject->SLAList(
        Valid  => 0,
        UserID => $UserID,
    );

    my %ExportData;
    SLAID:
    for my $SLAID ( sort keys %SLAList ) {

        my %SLAData = $SLAObject->SLAGet(
            SLAID  => $SLAID,
            UserID => $UserID,
        );

        if (%SLAFilter) {
            next SLAID unless $SLAFilter{ $SLAData{Name} };
        }

        # translate IDs into names or name-like identifiers
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
        my $ValidObject   = $Kernel::OM->Get('Kernel::System::Valid');

        ATTRIBUTE:
        for my $Attribute ( keys %SLAData ) {

            next ATTRIBUTE unless $Attribute =~ /ID/;

            if ( $Attribute eq 'ValidID' ) {
                my $Valid = $ValidObject->ValidLookup(
                    ValidID => $SLAData{ValidID},
                );
                $SLAData{Valid} = $Valid;
                delete $SLAData{ValidID};
            }
            elsif ( $Attribute eq 'ServiceIDs' ) {
                if ( IsArrayRefWithData( $SLAData{ServiceIDs} ) ) {
                    my @Services;
                    for my $ServiceID ( $SLAData{ServiceIDs}->@* ) {
                        push @Services, $ServiceObject->ServiceLookup(
                            ServiceID => $ServiceID,
                        );
                    }
                    $SLAData{Services} = \@Services;
                    delete $SLAData{ServiceIDs};
                }
            }
        }

        # observation showed that Type and TypeID both are usually present
        delete $SLAData{TypeID};

        delete $SLAData{ChangeBy};
        delete $SLAData{ChangeTime};
        delete $SLAData{CreateBy};
        delete $SLAData{CreateTime};
        delete $SLAData{SLAID};

        $ExportData{ $SLAData{Name} } = \%SLAData;
    }

    return \%ExportData;
}

sub ImportSLAs {
    my ( $Self, %Param ) = @_;

    my $UserID = $Self->{UserID} || $Param{UserID};

    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ServiceObject        = $Kernel::OM->Get('Kernel::System::Service');
    my $SLAObject            = $Kernel::OM->Get('Kernel::System::SLA');
    my $ValidObject          = $Kernel::OM->Get('Kernel::System::Valid');
    my %SLAList              = $SLAObject->SLAList(
        Valid  => 0,
        UserID => $UserID,
    );
    my %SLALookup   = reverse %SLAList;
    my $SLATypeList = $GeneralCatalogObject->ItemList(
        Class => 'ITSM::SLA::Type',
        Valid => 0,
    );
    my %SLATypeLookup = reverse $SLATypeList->%*;

    SLANAME:
    for my $SLAName ( keys $Param{SLAs}->%* ) {
        my $SLAData = $Param{SLAs}{$SLAName};

        my $SLAID = $SLALookup{ $SLAData->{Name} };

        # skip if SLA with same name exists and overwrite is not set
        next SLANAME if ( !$Param{OverwriteExistingEntities} && $SLAID );

        # translate named data back to IDs
        $SLAData->{TypeID} = $SLATypeLookup{ $SLAData->{Type} };
        if ( IsArrayRefWithData( $SLAData->{Services} ) ) {
            my @ServiceIDs;
            for my $Service ( $SLAData->{Services}->@* ) {
                push @ServiceIDs, $ServiceObject->ServiceLookup(
                    Name => $Service,
                );
            }
            $SLAData->{ServiceIDs} = \@ServiceIDs;
        }
        $SLAData->{ValidID} = $ValidObject->ValidLookup(
            Valid => $SLAData->{Valid},
        );

        if ($SLAID) {

            my $Success = $SLAObject->SLAUpdate(
                $SLAData->%*,
                SLAID  => $SLAID,
                UserID => $UserID,
            );
            return unless $Success;
        }
        else {
            my $SLAID = $SLAObject->SLAAdd(
                $SLAData->%*,
                UserID => $UserID,
            );
            return unless $SLAID;
        }
    }

    return 1;
}

1;
