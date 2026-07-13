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

# Currently, the criticality of the service can also be set in the service, but this has no effect.
# Therefore, this event module has been implemented that automatically updates the DynamicField Criticality
# in a ticket as soon as a service has been assigned.

# Please activate the SysConfig option Service::SetDynamicFieldCriticality for this purpose.

package Kernel::System::Ticket::Event::SetPriorityFromCriticalityAndImpactMatrix;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::ITSMCIPAllocate',
    'Kernel::System::Service',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed! in Data",
            );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
        Silence       => 1,
        UserID        => 1,
    );

    return if !%Ticket;
    return if !IsStringWithData( $Ticket{DynamicField_ITSMImpact} ) || !IsStringWithData( $Ticket{DynamicField_ITSMCriticality} );

    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    my %ServiceData = $ServiceObject->ServiceGet(
        ServiceID => $Ticket{ServiceID},
        UserID    => 1,
    );

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $CIPAllocateObject         = $Kernel::OM->Get('Kernel::System::ITSMCIPAllocate');

    my $PriorityID = $CIPAllocateObject->PriorityAllocationGet(
        Criticality => $Ticket{DynamicField_ITSMCriticality},
        Impact      => $Ticket{DynamicField_ITSMImpact},
    );

    return if $PriorityID eq $Ticket{PriorityID};

    my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPrioritySet(
        TicketID   => $Param{Data}->{TicketID},
        PriorityID => $PriorityID,
        UserID     => 1,
    );

    return 1;
}

1;
