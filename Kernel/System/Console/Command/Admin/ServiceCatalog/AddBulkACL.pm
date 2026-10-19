# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Service',
    'Kernel::System::Type',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add new ACLs that filter the list of services based on the ticket type.');

    # there are no options

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # nothing to do
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding new ACLs...</yellow>\n");

    my $TypeObject    = $Kernel::OM->Get('Kernel::System::Type');
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    # Get all services.
    my $ServiceList = $ServiceObject->ServiceListGet(
        Valid  => 1,
        UserID => 1,
    );

    SERVICEGET:
    for my $Service ( $ServiceList->@* ) {

        # TODO: checked whether services without ticket types can really be skipped
        next SERVICEGET unless IsArrayRefWithData( $Service->{TicketTypeIDs} );

        # Create ACL if config is enabled
        # We create one ACL per ticket type.
        $ServiceObject->UpdateTypeServiceACL(
            TicketTypeIDs => $Service->{TicketTypeIDs},
            ServiceID     => $Service->{ServiceID},
            ServiceValid  => $Service->{ValidID},
            UserID        => 1,
        );
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
