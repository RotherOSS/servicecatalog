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

package var::packagesetup::ServiceCatalog;

use strict;
use warnings;

use Kernel::Output::Template::Provider;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

var::packagesetup::Survey - code to execute during package installation

=head1 DESCRIPTION

All functions

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::Survey');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the fresh configuration values.
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # always discard the config object before package code is executed,
    # to make sure that the config object will be created newly, so that it
    # will use the recently written new config from the package
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Config'],
    );

    return $Self;
}

=head2 CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CodeUpgradeFromLowerThan_10_1_14()

This function is only executed if the installed module version is smaller than 10.1.14.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_10_1_14();

=cut

sub CodeUpgradeFromLowerThan_10_1_14 {    ## no critic qw(OTOBO::RequireCamelCase)
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Language     = $ConfigObject->Get('DefaultLanguage') || 'en';
    my $ContentType  = $ConfigObject->Get('Frontend::RichText') ? 'text/html' : 'text/plain';

    my $Success = $DBObject->Do(
        SQL => "INSERT INTO service_description (service_id, description_short, description_long, content_type, language) 
                SELECT id, description_short, description_long, '$ContentType', '$Language' FROM service WHERE description_short <> '' ORDER BY id ASC"
    );

    if ( $Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( 
            Priority 	=> 'error',
            Message 	=> 'Service catalog descriptions migrated successfully to the Service description table!'
        );
    } else {
        $Kernel::OM->Get('Kernel::System::Log')->Log( 
            Priority 	=> 'error',
            Message 	=> 'There was a problem migrating service catalog descriptions from Service table. Please review error log.'
        );
        return;
    }

    return 1;
}


=head2 CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

1;