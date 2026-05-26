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

package Kernel::Language::hu_ServiceCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminSLAImportExport
    $Self->{Translation}->{'Here you can export a configuration file of SLAs to import these on another system. The configuration file is exported in yml format.'} =
        'Itt exportálhatja az SLA-k beállítófájlját, hogy azokat egy másik rendszerbe importálhassa. A beállítófájl YAML formátumban kerül exportálásra.';
    $Self->{Translation}->{'SLAs List'} = 'SLA-k listája';

    # Template: AdminServiceImportExport
    $Self->{Translation}->{'Here you can export a configuration file of services to import these on another system. The configuration file is exported in yml format.'} =
        'Itt exportálhatja a szolgáltatások beállítófájlját, hogy azokat egy másik rendszerbe importálhassa. A beállítófájl YAML formátumban kerül exportálásra.';
    $Self->{Translation}->{'Services List'} = 'Szolgáltatások listája';

    # Template: TileServiceCatalog
    $Self->{Translation}->{'Show details of this service.'} = 'A szolgáltatás részleteinek megjelenítése.';

    # Template: AdminSLA
    $Self->{Translation}->{'Here you can upload a configuration file to import SLAs to your system. The file needs to be in .yml format as exported by SLA management module.'} =
        'Itt tölthet fel egy beállítófájlt az SLA-k importálásához a rendszerre. A fájlnak .yml formátumban kell lennie, ahogy az SLA-kezelő modul exportálta.';
    $Self->{Translation}->{'SLAs Import'} = 'SLA-k importálása';
    $Self->{Translation}->{'SLAs Export'} = 'SLA-k exportálása';
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'Az incidensek közti legkisebb idő';

    # Template: AdminService
    $Self->{Translation}->{'Here you can upload a configuration file to import services to your system. The file needs to be in .yml format as exported by the service management module.'} =
        '';
    $Self->{Translation}->{'Services Import'} = 'Szolgáltatások importálása';
    $Self->{Translation}->{'Services Export'} = 'Szolgáltatások exportálása';
    $Self->{Translation}->{'Criticality'} = 'Kritikusság';
    $Self->{Translation}->{'Service depends on the following ticket types'} = 'A szolgáltatás a következő jegytípusoktól függ';
    $Self->{Translation}->{'Ticket destination queue'} = 'Jegy célvárólistája';
    $Self->{Translation}->{'Customer default service'} = 'Ügyfél alapértelmezett szolgáltatása';
    $Self->{Translation}->{'Keywords'} = 'Kulcsszavak';
    $Self->{Translation}->{'Service Description'} = 'Szolgáltatás leírása';
    $Self->{Translation}->{'This language is not present or enabled on the system. This service description could be deleted if it is not needed anymore.'} =
        'Ez a nyelv nincs jelen vagy nincs engedélyezve a rendszeren. Ez a szolgáltatásleírás törölhető, ha többé nincs rá szükség.';
    $Self->{Translation}->{'Remove Service Description Language'} = 'Szolgáltatásleírás-nyelv eltávolítása';
    $Self->{Translation}->{'Add new service description language'} = 'Új szolgáltatásleírás-nyelv hozzáadása';
    $Self->{Translation}->{'Option Reference'} = 'Beállítások hivatkozása';
    $Self->{Translation}->{'You can use the following options'} = 'A következő beállításokat használhatja';
    $Self->{Translation}->{'Within the ServiceCatalogue tile in the customer dashboard, it is possible to show ticket types for preconfigured ticket creation inside the service description. Furthermore, it is possible to restrict the services for other screens using the ticket types set here. If you wish to do this, please activate the options "ServiceCatalog::CreateTypeServiceRelatedAcls" and "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" in the OTOBO system configuration. The restriction is made via automatically generated ACLs, which can be viewed under "Admin -> Access Control Lists (ACL)". If necessary, please adjust the option "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" according to your requirements.'} =
        'Az ügyfél vezérlőpultján lévő „ServiceCatalogue” csempén belül lehetőség van megjeleníteni a jegytípusokat az előre beállított jegylétrehozásához a szolgáltatás leírásán belül. Ezenfelül lehetőség van a szolgáltatások korlátozására más képernyőknél az itt beállított jegytípusok használatával. Ha ezt szeretné megtenni, akkor aktiválja a „ServiceCatalog::CreateTypeServiceRelatedAcls” és a „ServiceCatalog::CreateTypeServiceRelatedAcls::Options” beállításokat az OTOBO rendszerbeállításaiban. A korlátozás automatikusan előállított ACL-eken keresztül történik, amelyek az „Adminisztráció → Hozzáférés-vezérlési listák (ACL)” alatt tekinthetők meg. Ha szükséges, akkor állítsa be a „ServiceCatalog::CreateTypeServiceRelatedAcls::Options” beállítást az igényeinek megfelelően.';
    $Self->{Translation}->{'If we work service-based, we do not want to offer the customer a choice of queues in the customer portal when creating a ticket, but decide on the basis of the service into which queue (or which team of agents) the ticket should be processed first. In order to use this option sensibly, please deactivate the option "Ticket::Frontend::CustomerTicketMessage###Queue" and set a sensible default queue in the option "Ticket::Frontend::CustomerTicketMessage###QueueDefault". As soon as you set a "Ticket destination queue" here in the service, the ticket will immediately be created in this queue. If the field remains empty, the default queue configured above will be used.'} =
        'Ha szolgáltatásalapú rendszerben dolgozunk, akkor nem szeretnénk felajánlani az ügyfélnek a várólisták közötti választást az ügyfélportálon a jegy létrehozásakor, hanem a szolgáltatás alapján szeretnénk eldönteni, hogy melyik várólistába (vagy melyik ügyintézői csapatnak) kell elsőként feldolgozni a jegyet. Ahhoz, hogy ezt a lehetőséget észszerűen lehessen használni, kapcsolja ki a „Ticket::Frontend::CustomerTicketMessage###Queue” beállítást, és állítson be észszerű alapértelmezett várólistát a „Ticket::Frontend::CustomerTicketMessage###QueueDefault” beállításban. Amint itt a szolgáltatásban beállít egy „Jegy célvárólistája” értéket, a jegy azonnal ebben a várólistában lesz létrehozva. Ha a mező üres marad, akkor a fent beállított alapértelmezett várólista lesz használva.';
    $Self->{Translation}->{'If you do not assign services to customers or companies individually, but all services are initially offered to your customers for selection, the step of releasing each service as a "default" service under "Admin -> Customer user <-> Service" (or "Customer <-> Service") can be bypassed here. Of course, in the next step it is possible to restrict the services via ACLs.'} =
        'Ha nem rendel hozzá egyenként szolgáltatásokat az ügyfelekhez vagy a vállalatokhoz, hanem az összes szolgáltatást eleve felajánlja az ügyfeleinek választásra, akkor az „Adminisztráció → Ügyfél-felhasználó ↔ Szolgáltatás” (vagy „Ügyfél ↔ Szolgáltatás”) alatt az egyes szoláltatások „alapértelmezett” szolgáltatásként történő kiadásának lépése itt megkerülhető. Természetesen a következő lépésben lehetőség van a szolgáltatások ACL-eken keresztül történő korlátozására.';
    $Self->{Translation}->{'Here, there is the possibility to automatically calculate the correct ticket priority in the background based on the dynamic field "ITSMCriticality" and "ITSMImpact". Please activate the option "Ticket::EventModulePost###9700-SetDynamicFieldCriticalityFromService" and the option "Ticket::EventModulePost###9800-SetPriorityFromCriticalityAndImpactMatrix". In the next step, you have the possibility using "Admin -> Criticality ↔ Impact ↔ Priority" to set the priority using a matrix.'} =
        'Itt lehetőség van arra, hogy automatikusan kiszámítsa a megfelelő jegyprioritást a háttérben az „ITSMCriticality” és „ITSMImpact” dinamikus mezők alapján. Aktiválja a „Ticket::EventModulePost###9700-SetDynamicFieldCriticalityFromService” és a „Ticket::EventModulePost###9800-SetPriorityFromCriticalityAndImpactMatrix” beállításokat. A következő lépésben lehetősége van az „Adminisztráció → Kritikusság ↔ Hatás ↔ Prioritás” használatával egy mátrix segítségével beállítani a prioritást.';
    $Self->{Translation}->{'Keywords to facilitate the search for services within the service catalog.'} =
        'Kulcsszavak a szolgáltatások keresésének megkönnyítéséhez a szolgáltatáskatalóguson belül.';
    $Self->{Translation}->{'Service descriptions (short & long) specified by User Language.'} =
        'A felhasználó nyelve által megadott szolgáltatásleírások (rövid és hosszú).';
    $Self->{Translation}->{'Short summary of the service, mainly used in the CustomerDashboard.'} =
        'A szolgáltatás rövid összefoglalása, amely elsősorban az ügyfél vezérlőpultján van használva.';
    $Self->{Translation}->{'Description of the service. Screenshots and tables are also allowed. Please ensure the correct width of the image for screenshots. This can be adjusted in the ckeditor after uploading the screenshot. A width of 600px has proven to be useful or you can configure a "max-width" of 95% under Advanced.'} =
        'A szolgáltatás leírása. Képernyőképek és táblázatok is megengedettek. Győződjön meg arról, hogy a képek szélessége megfelelő legyen a képernyőképeknél. Ez a CKEditor szerkesztőben állítható be a képernyőkép feltöltése után. A 600 képpontos szélesség jól bevált, vagy beállíthatja a „max-width” értéket 95%-ra a „Speciális” menüpont alatt.';
    $Self->{Translation}->{'Add more service catalog fields'} = 'További szolgáltatáskatalógus mezők hozzáadása';
    $Self->{Translation}->{'You have the option of adding further fields here in the service catalog at any time. To do this, please go to "Admin -> DynamicFields" and create the new field of the object type "Service". You can then activate the field for the customer dashboard under "Admin -> DynamicField Screens" by assigning it under "CustomerDashboardTile ServiceCatalog".'} =
        'Lehetősége van további mezőket hozzáadnia bármikor itt, a szolgáltatáskatalógusban. Ehhez menjen az „Adminisztráció → Dinamikus mezők” modulhoz, és hozza létre a „Szolgáltatás” objektumtípusú új mezőt. Ezután aktiválhatja a mezőt az ügyfél vezérlőpultjához az „Adminisztráció → Dinamikus mezők képernyői” alatt azáltal, hogy hozzárendeli a mezőt a „CustomerDashboardTile ServiceCatalog” alatt.';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA információk';
    $Self->{Translation}->{'Last changed'} = 'Utoljára módosítva';
    $Self->{Translation}->{'Last changed by'} = 'Utoljára módosította';
    $Self->{Translation}->{'Associated Services'} = 'Hozzárendelt szolgáltatások';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'Szolgáltatásinformációk';
    $Self->{Translation}->{'Current incident state'} = 'Jelenlegi incidensállapot';
    $Self->{Translation}->{'Associated SLAs'} = 'Hozzárendelt SLA-k';

    # JS Template: TileServiceCatalogContainer
    $Self->{Translation}->{'Create a new ticket for this service.'} = 'Új jegy létrehozása ehhez a szolgáltatáshoz.';
    $Self->{Translation}->{'Create %s'} = '%s létrehozása';
    $Self->{Translation}->{'Show %s sub-service(s)'} = '%s alszolgáltatásainak megjelenítése';
    $Self->{Translation}->{'More details'} = 'További részletek';
    $Self->{Translation}->{'Sub-Service(s)'} = 'Alszolgáltatások';

    # JS Template: TileServiceCatalogDetailed
    $Self->{Translation}->{'sub-service(s) available'} = 'alszolgáltatás érhető el';
    $Self->{Translation}->{'Create a new ticket of type %s.'} = 'Új %s típusú jegy létrehozása.';
    $Self->{Translation}->{'FAQ article on this topic'} = 'GyIK bejegyzés ebben a témában';
    $Self->{Translation}->{'Additional information'} = 'További információk';
    $Self->{Translation}->{'Service hours'} = 'Szolgáltatási idő';
    $Self->{Translation}->{'o\'clock'} = 'óra';
    $Self->{Translation}->{'No additional data are available.'} = 'Nem érhetők el további adatok.';
    $Self->{Translation}->{'Further information'} = 'További információk';

    # JS Template: TileServiceCatalogModal
    $Self->{Translation}->{'Search catalog'} = 'Katalógus keresése';

    # Perl Module: Kernel/Modules/CustomerTileServiceCatalog.pm
    $Self->{Translation}->{'Description not available.'} = 'Leírás nem érhető el.';
    $Self->{Translation}->{'Need FileID!'} = 'Fájlazonosító szükséges!';

    # Perl Module: Kernel/Modules/AgentITSMServiceZoom.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'Nincs szolgáltatásazonosító megadva!';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'A(z) %s szolgáltatásazonosító nem található az adatbázisban!';
    $Self->{Translation}->{'operational'} = 'üzemképes';
    $Self->{Translation}->{'warning'} = 'figyelmeztetés';
    $Self->{Translation}->{'incident'} = 'incidens';

    # JS File: Core.Agent.Admin.Service
    $Self->{Translation}->{'Do you really want to delete this service description language?'} =
        'Valóban törölni szeretné ezt a szolgáltatásleírás-nyelvet?';

    # JS File: Core.Customer.TileServiceCatalog
    $Self->{Translation}->{'Results for %s'} = 'Találatok erre: %s';

    # SysConfig
    $Self->{Translation}->{'Additional settings for the service catalog.'} = 'További beállítások a szolgáltatáskatalógushoz.';
    $Self->{Translation}->{'Autoload configuration for SLA import and export functions.'} = 'Automatikus betöltési beállítás az SLA importálása és exportálása funkciókhoz.';
    $Self->{Translation}->{'Autoload configuration for Service import and export functions.'} =
        'Automatikus betöltési beállítás a szolgáltatás importálása és exportálása funkciókhoz.';
    $Self->{Translation}->{'CustomerTileServiceCatalog AJAX Module.'} = 'Ügyfélcsempe-szolgáltatáskatalógus AJAX-modul.';
    $Self->{Translation}->{'Dynamic fields shown in the service catalog screen of the customer interface.'} =
        'Az ügyfélfelület szolgáltatáskatalógus képernyőjén megjelenített dinamikus mezők.';
    $Self->{Translation}->{'Event module registration. Currently, the criticality of the service can also be set in the service, but this has no effect. Therefore, this event module has been implemented that automatically updates the DynamicField Criticality in a ticket as soon as a service has been assigned. Please activate the SysConfig option SetPriorityFromCriticalityAndImpactMatrix to set the priority in the next step based an Criticality and Impact.'} =
        'Eseménymodul regisztráció. Jelenleg a szolgáltatás kritikussága beállítható a szolgáltatásban is, de ennek nincs hatása. Ezért került megvalósításra ez az eseménymodul, amely automatikusan frissíti a kritikusság dinamikus mezőt a jegyben, amint egy szolgáltatás hozzárendelésre kerül. Aktiválja a „SetPriorityFromCriticalityAndImpactMatrix” rendszerbeállítási lehetőséget, hogy beállítsa a prioritást a következő lépésben egy kritikusság és hatás alapján.';
    $Self->{Translation}->{'Event module registration. Currently, the criticality of the service can also be set in the service, but this has no effect. Therefore, this event module has been implemented that automatically updates the priority regarding Criticality and Impact in a ticket.'} =
        'Eseménymodul regisztráció. Jelenleg a szolgáltatás kritikussága beállítható a szolgáltatásban is, de ennek nincs hatása. Ezért került megvalósításra ez az eseménymodul, amely automatikusan frissíti a prioritást a kritikusságra és hatásra vonatkozóan a jegyben.';
    $Self->{Translation}->{'Show services with the following ticket type last.'} = 'A következő jegytípusokkal rendelkező szolgáltatások megjelenítése utoljára.';
    $Self->{Translation}->{'The FAQ field that should be used as the description of an FAQ article in the sidebar (e.g. Field1, Field2, Field3...).'} =
        'Az a GyIK mező, amelyet egy GyIK bejegyzés leírásaként kell használni az oldalsávban (például Mező1, Mező2, Mező3 stb.).';
    $Self->{Translation}->{'This option allows you to automatically generate ACLs for different interfaces when creating services. Services will then only be displayed if the ticket type stored in the service has been selected. The "AddBulkACL" console script can also be used to create ACLs for services that have already been create.'} =
        'Ez a beállítás lehetővé teszi ACL-ek automatikus előállítását a különböző felületekhez a szolgáltatások létrehozásakor. A szolgáltatások ezután csak akkor jelennek meg, ha a szolgáltatásban tárolt jegytípust kiválasztották. Az „AddBulkACL” konzolparancs is használható a már létrehozott szolgáltatásokhoz tartozó ACL-ek létrehozására.';
    $Self->{Translation}->{'This option makes it possible to preconfigure the automatically generated ACLs. The aim is to only display the services that have also been assigned to the service in the service catalog. To use this function, please first enable the "ServiceCatalog::CreateTypeServiceRelatedAcls" option. "GenerateInitalACLToDisableAllServices" generates an ACL that initially hides all services. The value "Possible" or "PossibleAdd" can be set for the key "ConfigChange". The "DeployNewACL" key decides whether the changed ACL should also be deployed immediately. "ACLValidID" (1, 2, 3) sets the ACLs to valid, invalid or temporarily invalid.'} =
        'Ez a beállítás lehetővé teszi az automatikusan előállított ACL-ek előzetes beállítását. A cél az, hogy csak olyan szolgáltatások jelenjenek meg, amelyek hozzá is lettek rendelve a szolgáltatáshoz a szolgáltatáskatalógusban. A funkció használatához először engedélyezze a „ServiceCatalog::CreateTypeServiceRelatedAcls” beállítást. A „GenerateInitalACLToDisableAllServices” olyan ACL-t állít elő, amely kezdetben elrejti az összes szolgáltatást. A „Possible” vagy „PossibleAdd” érték állítható be a „ConfigChange” kulcshoz. A „DeployNewACL” kulcs dönti el, hogy a megváltoztatott ACL-t is azonnal üzembe kell-e állítani. Az „ACLValidID” (1, 2, 3) állítja be az ACL-eket érvényesre, érvénytelenre vagy átmenetileg érvénytelenre.';
    $Self->{Translation}->{'Tile registration for the CustomerDashboard. Module is required.'} =
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
