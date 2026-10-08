# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

use strict;
use warnings;
use utf8;

# core modules
use File::Basename qw(basename);

# CPAN modules
use Test2::V0;
use List::AllUtils qw(zip);
use Test2::Tools::Explain;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
my $TypeObject    = $Kernel::OM->Get('Kernel::System::Type');
my $UserObject    = $Kernel::OM->Get('Kernel::System::User');
my $ACLObject     = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

# get helper object, restore database at end of the script
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# create new users for the tests
my @UserIDs;
{

    # disable email checks to create new user
    my $CheckEmailAddressesOrg = $ConfigObject->Get('CheckEmailAddresses') || 1;
    $ConfigObject->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    @UserIDs = map {
        $UserObject->UserAdd(
            UserFirstname => 'Service' . $_,
            UserLastname  => 'UnitTest',
            UserLogin     => 'UnitTest-Service-' . $_ . $RandomID,
            UserEmail     => 'UnitTest-Service-' . $_ . $RandomID . '@localhost',
            ValidID       => 1,
            ChangeUserID  => 1,
        );
    } ( 0 .. 1 );

    # restore original email check param
    $ConfigObject->Set(
        Key   => 'CheckEmailAddresses',
        Value => $CheckEmailAddressesOrg,
    );
}

# create ticket types
my @TicketTypeNames = map { join '_', 'Unittest', 'Type', basename(__FILE__), $RandomID, $_ } ( 0 .. 1 );
my @TicketTypeIDs   = map {
    $TypeObject->TypeAdd(
        Name    => $_,
        ValidID => 1,
        UserID  => 1,
    );
} @TicketTypeNames;
my %TicketTypeID2Name = zip @TicketTypeIDs, @TicketTypeNames;

# create services with all test ticket types
my @ServiceNames = map { join '_', 'Unittest', 'Service', basename(__FILE__), $RandomID, $_ } ( 0 .. 1 );
my @ServiceIDs   = map {
    $ServiceObject->ServiceAdd(
        Name          => $_,
        ValidID       => 1,
        UserID        => 1,
        TypeID        => 2,                 # ITSM::Service::Type from ITSMCore
        Criticality   => '3 normal',        # added by ITSMCore
        TicketTypeIDs => \@TicketTypeIDs,
        Descriptions  => {                  # added by ServiceCatalog
            en => {
                DescriptionShort => "short desc for $_",
                DescriptionLong  => "long description for $_",
                ContentType      => 'text/html',
            },
        },

    );
} @ServiceNames;
my %ServiceID2Name = zip @ServiceIDs, @ServiceNames;

note 'retrieval of the ticket types';

for my $ServiceID (@ServiceIDs) {
    subtest "ServiceGet() for ServiceID $ServiceID" => sub {
        my %Service = $ServiceObject->ServiceGet(
            ServiceID => $ServiceID,
            UserID    => 1,
        );

        is( $Service{ServiceID},     $ServiceID,                  'ServiceID' );
        is( $Service{Name},          $ServiceID2Name{$ServiceID}, 'Name' );
        is( $Service{TicketTypeIDs}, \@TicketTypeIDs,             'TicketTypeIDs' );
    };
}

subtest "no zzz ACL for the test ticket types" => sub {
    my $ACLs = $ACLObject->ACLListGet(
        UserID     => $UserIDs[0],
        ObjectType => ['Ticket'],
    );
    my %ACLName2ID = map { $_->{Name} => $_->{ID} } $ACLs->@*;
    my $Prefix     = 'zzz - Show Service based on Ticket-Type: ';
    for my $TicketTypeName (@TicketTypeNames) {
        ok( !$ACLName2ID{ $Prefix . $TicketTypeName }, "no zzz ACL for $TicketTypeName" );
    }
};

note "add the zzz ACLs for the service 0";
{
    my $ServiceID = $ServiceIDs[0];

    my %Service = $ServiceObject->ServiceGet(
        ServiceID => $ServiceID,
        UserID    => 1,
    );
    is( $Service{TicketTypeIDs}, \@TicketTypeIDs, 'TicketTypeIDs' );

    # Create the zzz ACLs
    $ServiceObject->UpdateTypeServiceACL(
        TicketTypeIDs => $Service{TicketTypeIDs},
        ServiceID     => $Service{ServiceID},
        ServiceValid  => $Service{ValidID},
        UserID        => 1,
    );

    subtest "zzz ACLs for service 0" => sub {
        my $ACLs = $ACLObject->ACLListGet(
            UserID     => $UserIDs[0],
            ObjectType => ['Ticket'],
        );
        my %ACLName2ID = map { $_->{Name} => $_->{ID} } $ACLs->@*;
        my $Prefix     = 'zzz - Show Service based on Ticket-Type: ';

        # Service 0 has all ticket types. So there should be ACLs
        # for all ticket types and the service should be included in the ACL.
        TICKET_TYPE_NAME:
        for my $TicketTypeName (@TicketTypeNames) {
            my $ACLID = $ACLName2ID{ $Prefix . $TicketTypeName };
            ok( $ACLID, "zzz ACL for $TicketTypeName" );

            next TICKET_TYPE_NAME unless $ACLID;

            my $ACL = $ACLObject->ACLGet(
                ID     => $ACLID,
                UserID => 1,
            );
            diag explain $ACL;
            like(
                $ACL,
                {
                    'ConfigChange' => {
                        'Possible' => {
                            'Ticket' => {
                                'Service' => [ $ServiceID2Name{$ServiceID} ],
                            }
                        }
                    },
                },
                'Service 0 is possible'
            );
        }
    };
}

note "add the zzz ACLs for service 1";
{
    my $ServiceID = $ServiceIDs[1];

    my %Service = $ServiceObject->ServiceGet(
        ServiceID => $ServiceID,
        UserID    => 1,
    );
    is( $Service{TicketTypeIDs}, \@TicketTypeIDs, 'TicketTypeIDs' );

    # Create the zzz ACLs
    $ServiceObject->UpdateTypeServiceACL(
        TicketTypeIDs => $Service{TicketTypeIDs},
        ServiceID     => $Service{ServiceID},
        ServiceValid  => $Service{ValidID},
        UserID        => 1,
    );

    subtest "zzz ACLs for service 1" => sub {
        my $ACLs = $ACLObject->ACLListGet(
            UserID     => $UserIDs[0],
            ObjectType => ['Ticket'],
        );
        my %ACLName2ID = map { $_->{Name} => $_->{ID} } $ACLs->@*;
        my $Prefix     = 'zzz - Show Service based on Ticket-Type: ';

        # Service 0 and 1 have all ticket types. So there should be ACLs
        # for all ticket types and both services should be included in the ACL.
        TICKET_TYPE_NAME:
        for my $TicketTypeName (@TicketTypeNames) {
            my $ACLID = $ACLName2ID{ $Prefix . $TicketTypeName };
            ok( $ACLID, "zzz ACL for $TicketTypeName" );

            next TICKET_TYPE_NAME unless $ACLID;

            my $ACL = $ACLObject->ACLGet(
                ID     => $ACLID,
                UserID => 1,
            );
            diag explain $ACL;
            like(
                $ACL,
                {
                    'ConfigChange' => {
                        'Possible' => {
                            'Ticket' => {
                                'Service' => [@ServiceNames],    # both services now
                            }
                        }
                    },
                },
                'Service 0 and 1 is possible'
            );
        }
    };
}

note "claim that service 0 is invalid";
{
    my $ServiceID = $ServiceIDs[0];

    my %Service = $ServiceObject->ServiceGet(
        ServiceID => $ServiceID,
        UserID    => 1,
    );
    is( $Service{TicketTypeIDs}, \@TicketTypeIDs, 'TicketTypeIDs' );

    # Create the zzz ACLs
    $ServiceObject->UpdateTypeServiceACL(
        TicketTypeIDs => $Service{TicketTypeIDs},
        ServiceID     => $Service{ServiceID},
        ServiceValid  => 2,                         # invalid
        UserID        => 1,
    );

    subtest "zzz ACLs for service 1" => sub {
        my $ACLs = $ACLObject->ACLListGet(
            UserID     => $UserIDs[0],
            ObjectType => ['Ticket'],
        );
        my %ACLName2ID = map { $_->{Name} => $_->{ID} } $ACLs->@*;
        my $Prefix     = 'zzz - Show Service based on Ticket-Type: ';

        # Service 0 is invalid So there should be ACLs
        # for all ticket types and only service 1 should be included in the ACL.
        TICKET_TYPE_NAME:
        for my $TicketTypeName (@TicketTypeNames) {
            my $ACLID = $ACLName2ID{ $Prefix . $TicketTypeName };
            ok( $ACLID, "zzz ACL for $TicketTypeName" );

            next TICKET_TYPE_NAME unless $ACLID;

            my $ACL = $ACLObject->ACLGet(
                ID     => $ACLID,
                UserID => 1,
            );
            diag explain $ACL;
            like(
                $ACL,
                {
                    'ConfigChange' => {
                        'Possible' => {
                            'Ticket' => {
                                'Service' => [ $ServiceNames[1] ],    # only service 1
                            }
                        }
                    },
                },
                'Service 0 is no longer possible'
            );
        }
    };
}

done_testing;
