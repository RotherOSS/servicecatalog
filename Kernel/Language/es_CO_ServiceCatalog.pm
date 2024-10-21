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

package Kernel::Language::es_CO_ServiceCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: TileServiceCatalog
    $Self->{Translation}->{'Show details of this service.'} = '';

    # Template: AdminService
    $Self->{Translation}->{'Service depends on the following ticket types'} = '';
    $Self->{Translation}->{'Ticket destination queue'} = '';
    $Self->{Translation}->{'Customer default service'} = '';
    $Self->{Translation}->{'Criticality'} = '';
    $Self->{Translation}->{'Keywords'} = '';
    $Self->{Translation}->{'Service Description'} = '';
    $Self->{Translation}->{'This language is not present or enabled on the system. This service description could be deleted if it is not needed anymore.'} =
        '';
    $Self->{Translation}->{'Remove Service Description Language'} = '';
    $Self->{Translation}->{'Add new service description language'} = '';
    $Self->{Translation}->{'Option Reference'} = '';
    $Self->{Translation}->{'You can use the following options'} = '';
    $Self->{Translation}->{'Within the ServiceCatalogue tile in the customer dashboard, it is possible to show ticket types for preconfigured ticket creation inside the service description. Furthermore, it is possible to restrict the services for other screens using the ticket types set here. If you wish to do this, please activate the options "ServiceCatalog::CreateTypeServiceRelatedAcls" and "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" in the OTOBO system configuration. The restriction is made via automatically generated ACLs, which can be viewed under "Admin -> Access Control Lists (ACL)". If necessary, please adjust the option "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" according to your requirements.'} =
        '';
    $Self->{Translation}->{'If we work service-based, we do not want to offer the customer a choice of queues in the customer portal when creating a ticket, but decide on the basis of the service into which queue (or which team of agents) the ticket should be processed first. In order to use this option sensibly, please deactivate the option "Ticket::Frontend::CustomerTicketMessage###Queue" and set a sensible default queue in the option "Ticket::Frontend::CustomerTicketMessage###QueueDefault". As soon as you set a "Ticket destination queue" here in the service, the ticket will immediately be created in this queue. If the field remains empty, the default queue configured above will be used.'} =
        '';
    $Self->{Translation}->{'If you do not assign services to customers or companies individually, but all services are initially offered to your customers for selection, the step of releasing each service as a "default" service under "Admin -> Customer user <-> Service" (or "Customer <-> Service") can be bypassed here. Of course, in the next step it is possible to restrict the services via ACLs.'} =
        '';
    $Self->{Translation}->{'Here, there is the possibility to automatically calculate the correct ticket priority in the background based on the dynamic field "ITSMCriticality" and "ITSMImpact". Please activate the option "Ticket::EventModulePost###9700-SetDynamicFieldCriticalityFromService" and the option "Ticket::EventModulePost###9800-SetPriorityFromCriticalityAndImpactMatrix". In the next step, you have the possibility using "Admin -> Criticality ↔ Impact ↔ Priority" to set the priority using a matrix.'} =
        '';
    $Self->{Translation}->{'Keywords to facilitate the search for services within the service catalog.'} =
        '';
    $Self->{Translation}->{'Service descriptions (short & long) specified by User Language.'} =
        '';
    $Self->{Translation}->{'Short summary of the service, mainly used in the CustomerDashboard.'} =
        '';
    $Self->{Translation}->{'Description of the service. Screenshots and tables are also allowed. Please ensure the correct width of the image for screenshots. This can be adjusted in the ckeditor after uploading the screenshot. A width of 600px has proven to be useful or you can configure a "max-width" of 95% under Advanced.'} =
        '';
    $Self->{Translation}->{'Add more service catalog fields'} = '';
    $Self->{Translation}->{'You have the option of adding further fields here in the service catalog at any time. To do this, please go to "Admin -> DynamicFields" and create the new field of the object type "Service". You can then activate the field for the customer dashboard under "Admin -> DynamicField Screens" by assigning it under "CustomerDashboardTile ServiceCatalog".'} =
        '';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = '';
    $Self->{Translation}->{'Last changed'} = '';
    $Self->{Translation}->{'Last changed by'} = '';
    $Self->{Translation}->{'Minimum Time Between Incidents'} = '';
    $Self->{Translation}->{'Associated Services'} = '';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = '';
    $Self->{Translation}->{'Current incident state'} = '';
    $Self->{Translation}->{'Associated SLAs'} = '';

    # JS Template: TileServiceCatalogContainer
    $Self->{Translation}->{'Create a new ticket for this service.'} = '';
    $Self->{Translation}->{'Create %s'} = '';
    $Self->{Translation}->{'Show %s sub-service(s)'} = '';
    $Self->{Translation}->{'More details'} = '';
    $Self->{Translation}->{'Sub-Service(s)'} = '';

    # JS Template: TileServiceCatalogDetailed
    $Self->{Translation}->{'sub-service(s) available'} = '';
    $Self->{Translation}->{'Create a new ticket of type %s.'} = '';
    $Self->{Translation}->{'FAQ article on this topic'} = '';
    $Self->{Translation}->{'Additional information'} = '';
    $Self->{Translation}->{'Service hours'} = '';
    $Self->{Translation}->{'o\'clock'} = '';
    $Self->{Translation}->{'No additional data are available.'} = '';
    $Self->{Translation}->{'Further information'} = '';

    # JS Template: TileServiceCatalogModal
    $Self->{Translation}->{'Search catalog'} = '';

    # Perl Module: Kernel/Modules/CustomerTileServiceCatalog.pm
    $Self->{Translation}->{'Description not available.'} = '';
    $Self->{Translation}->{'Need FileID!'} = '';

    # Perl Module: Kernel/Modules/AgentITSMServiceZoom.pm
    $Self->{Translation}->{'No ServiceID is given!'} = '';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = '';
    $Self->{Translation}->{'operational'} = '';
    $Self->{Translation}->{'warning'} = '';
    $Self->{Translation}->{'incident'} = '';

    # JS File: Core.Agent.Admin.Service
    $Self->{Translation}->{'Do you really want to delete this service description language?'} =
        '';

    # JS File: Core.Customer.TileServiceCatalog
    $Self->{Translation}->{'Results for %s'} = '';

    # SysConfig
    $Self->{Translation}->{'Additional settings for the service catalog.'} = '';
    $Self->{Translation}->{'CustomerTileServiceCatalog AJAX Module.'} = '';
    $Self->{Translation}->{'Dynamic fields shown in the service catalog screen of the customer interface.'} =
        '';
    $Self->{Translation}->{'Event module registration. Currently, the criticality of the service can also be set in the service, but this has no effect. Therefore, this event module has been implemented that automatically updates the DynamicField Criticality in a ticket as soon as a service has been assigned. Please activate the SysConfig option SetPriorityFromCriticalityAndImpactMatrix to set the priority in the next step based an Criticality and Impact.'} =
        '';
    $Self->{Translation}->{'Event module registration. Currently, the criticality of the service can also be set in the service, but this has no effect. Therefore, this event module has been implemented that automatically updates the priority regarding Criticality and Impact in a ticket.'} =
        '';
    $Self->{Translation}->{'Show services with the following ticket type last.'} = '';
    $Self->{Translation}->{'The FAQ field that should be used as the description of an FAQ article in the sidebar (e.g. Field1, Field2, Field3...).'} =
        '';
    $Self->{Translation}->{'This option allows you to automatically generate ACLs for different interfaces when creating services. Services will then only be displayed if the ticket type stored in the service has been selected. The \"AddBulkACL\" console script can also be used to create ACLs for services that have already been create.'} =
        '';
    $Self->{Translation}->{'This option makes it possible to preconfigure the automatically generated ACL\\'s. The aim is to only display the services that have also been assigned to the service in the service catalog. To use this function, please first enable the \"ServiceCatalog::CreateTypeServiceRelatedAcls\" option. \"GenerateInitalACLToDisableAllServices\" generates an ACL that initially hides all services. The value \"Possible\" or \"PossibleAdd\" can be set for the key \"ConfigChange\". The \"DeployNewACL"\ key decides whether the changed ACL should also be deployed immediately. \"ACLValidID"\ (1, 2, 3) sets the ACL\\'s to valid, invalid or temporarily invalid.'} =
        '';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Additional information',
    'All',
    'Close this dialog',
    'Create %s',
    'Create Ticket',
    'Create a new ticket for this service.',
    'Create a new ticket of type %s.',
    'Details',
    'Do you really want to delete this service description language?',
    'FAQ article on this topic',
    'First Response Time',
    'Further information',
    'More details',
    'No additional data are available.',
    'OK',
    'Results',
    'Results for %s',
    'Search',
    'Search catalog',
    'Service Information',
    'Service hours',
    'Show %s sub-service(s)',
    'Show details of this service.',
    'Show or hide the content',
    'Solution Time',
    'Sub-Service(s)',
    'hour(s)',
    'o\'clock',
    'sub-service(s) available',
    );

}

1;
