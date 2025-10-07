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

package Kernel::System::Console::Command::Admin::ServiceCatalog::AddBulkACL;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Service',
    'Kernel::System::Type',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add new Ticket-Type Ticket-Service ACLs.');

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding new ACLs...</yellow>\n");
    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    # Get all services.
    my $ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceListGet(
        Valid  => 1,
        UserID => 1,
    );

    SERVICEGET:
    for my $ServiceGet ( @$ServiceList ) {
        next SERVICEGET if !IsArrayRefWithData($ServiceGet->{TicketTypeIDs} );

        my @TicketTypeIDs = $ServiceGet->{TicketTypeIDs}->@*;
        for my $TID ( @TicketTypeIDs ) {

            # Create Acl if config is enabled
            # We create one Acl per Ticket-Type
            my $Success = $ServiceObject->UpdateTypServiceACL(
                TicketTypeID => $TID,
                ServiceID   => $ServiceGet->{ServiceID},
                ServiceValid => $ServiceGet->{ValidID},
                UserID => 1,
            );

        }
    }
    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
