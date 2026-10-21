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

package Kernel::Language::ja_ServiceCatalog;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminSLAImportExport
    $Self->{Translation}->{'Here you can export a configuration file of SLAs to import these on another system. The configuration file is exported in yml format.'} =
        'ここでは、SLA の設定ファイルをエクスポートして、他のシステムにインポートできます。設定ファイルは yml 形式でエクスポートされます。';
    $Self->{Translation}->{'SLAs List'} = 'SLA 一覧';

    # Template: AdminServiceImportExport
    $Self->{Translation}->{'Here you can export a configuration file of services to import these on another system. The configuration file is exported in yml format.'} =
        'ここでは、サービスの設定ファイルをエクスポートして、他のシステムにインポートできます。設定ファイルは yml 形式でエクスポートされます。';
    $Self->{Translation}->{'Services List'} = 'サービス一覧';

    # Template: TileServiceCatalog
    $Self->{Translation}->{'Show details of this service.'} = 'このサービスの詳細を表示します。';

    # Template: AdminSLA
    $Self->{Translation}->{'Here you can upload a configuration file to import SLAs to your system. The file needs to be in .yml format as exported by SLA management module.'} =
        'ここでは、SLA をシステムにインポートするための設定ファイルをアップロードできます。ファイルは、SLA 管理モジュールでエクスポートした .yml 形式である必要があります。';
    $Self->{Translation}->{'SLAs Import'} = 'SLA のインポート';
    $Self->{Translation}->{'SLAs Export'} = 'SLA のエクスポート';
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'インシデント間の最小時間';

    # Template: AdminService
    $Self->{Translation}->{'Here you can upload a configuration file to import services to your system. The file needs to be in .yml format as exported by the service management module.'} =
        'ここでは、サービスをシステムにインポートするための設定ファイルをアップロードできます。ファイルは、サービス管理モジュールでエクスポートした .yml 形式である必要があります。';
    $Self->{Translation}->{'Services Import'} = 'サービスのインポート';
    $Self->{Translation}->{'Services Export'} = 'サービスのエクスポート';
    $Self->{Translation}->{'Criticality'} = '重要度';
    $Self->{Translation}->{'Service depends on the following ticket types'} = 'サービスが依存するチケットタイプ';
    $Self->{Translation}->{'Ticket destination queue'} = 'チケットの宛先キュー';
    $Self->{Translation}->{'Customer default service'} = '顧客のデフォルトサービス';
    $Self->{Translation}->{'Keywords'} = 'キーワード';
    $Self->{Translation}->{'Service Description'} = 'サービスの説明';
    $Self->{Translation}->{'This language is not present or enabled on the system. This service description could be deleted if it is not needed anymore.'} =
        'この言語はシステムに存在しないか、有効になっていません。不要であれば、このサービスの説明を削除できます。';
    $Self->{Translation}->{'Remove Service Description Language'} = 'サービスの説明の言語を削除';
    $Self->{Translation}->{'Add new service description language'} = 'サービスの説明の言語を追加';
    $Self->{Translation}->{'Option Reference'} = 'オプションのリファレンス';
    $Self->{Translation}->{'You can use the following options'} = '次のオプションを使用できます';
    $Self->{Translation}->{'Within the ServiceCatalogue tile in the customer dashboard, it is possible to show ticket types for preconfigured ticket creation inside the service description. Furthermore, it is possible to restrict the services for other screens using the ticket types set here. If you wish to do this, please activate the options "ServiceCatalog::CreateTypeServiceRelatedAcls" and "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" in the OTOBO system configuration. The restriction is made via automatically generated ACLs, which can be viewed under "Admin -> Access Control Lists (ACL)". If necessary, please adjust the option "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" according to your requirements.'} =
        '顧客ダッシュボードの ServiceCatalogue タイルでは、サービスの説明内に、あらかじめ設定したチケット作成用のチケットタイプを表示できます。さらに、ここで設定したチケットタイプを使用して、他の画面でのサービスを制限することもできます。その場合は、OTOBO のシステム設定でオプション "ServiceCatalog::CreateTypeServiceRelatedAcls" と "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" を有効にしてください。制限は自動生成される ACL によって行われ、"Admin -> Access Control Lists (ACL)" で確認できます。必要に応じて、オプション "ServiceCatalog::CreateTypeServiceRelatedAcls::Options" を要件に合わせて調整してください。';
    $Self->{Translation}->{'If we work service-based, we do not want to offer the customer a choice of queues in the customer portal when creating a ticket, but decide on the basis of the service into which queue (or which team of agents) the ticket should be processed first. In order to use this option sensibly, please deactivate the option "Ticket::Frontend::CustomerTicketMessage###Queue" and set a sensible default queue in the option "Ticket::Frontend::CustomerTicketMessage###QueueDefault". As soon as you set a "Ticket destination queue" here in the service, the ticket will immediately be created in this queue. If the field remains empty, the default queue configured above will be used.'} =
        'サービスベースで運用する場合、顧客ポータルでチケットを作成する際に顧客にキューを選ばせるのではなく、サービスに基づいて、チケットを最初にどのキュー（どの担当者チーム）で処理するかを決めたいはずです。このオプションを有効に活用するには、オプション "Ticket::Frontend::CustomerTicketMessage###Queue" を無効にし、オプション "Ticket::Frontend::CustomerTicketMessage###QueueDefault" に適切なデフォルトキューを設定してください。ここでサービスに "Ticket destination queue"（チケットの宛先キュー）を設定すると、チケットはすぐにこのキューに作成されます。空欄の場合は、上記で設定したデフォルトキューが使用されます。';
    $Self->{Translation}->{'If you do not assign services to customers or companies individually, but all services are initially offered to your customers for selection, the step of releasing each service as a "default" service under "Admin -> Customer user <-> Service" (or "Customer <-> Service") can be bypassed here. Of course, in the next step it is possible to restrict the services via ACLs.'} =
        'サービスを顧客や企業ごとに個別に割り当てず、最初からすべてのサービスを顧客に選択肢として提供する場合は、"Admin -> Customer user <-> Service"（または "Customer <-> Service"）で各サービスを "default" サービスとして公開する手順をここで省略できます。もちろん、次のステップで ACL によってサービスを制限することも可能です。';
    $Self->{Translation}->{'Here, there is the possibility to automatically calculate the correct ticket priority in the background based on the dynamic field "ITSMCriticality" and "ITSMImpact". Please activate the option "Ticket::EventModulePost###9700-SetDynamicFieldCriticalityFromService" and the option "Ticket::EventModulePost###9800-SetPriorityFromCriticalityAndImpactMatrix". In the next step, you have the possibility using "Admin -> Criticality ↔ Impact ↔ Priority" to set the priority using a matrix.'} =
        'ここでは、ダイナミックフィールド "ITSMCriticality" と "ITSMImpact" に基づいて、正しいチケットの優先度をバックグラウンドで自動計算させることができます。オプション "Ticket::EventModulePost###9700-SetDynamicFieldCriticalityFromService" と "Ticket::EventModulePost###9800-SetPriorityFromCriticalityAndImpactMatrix" を有効にしてください。次のステップで、"Admin -> Criticality ↔ Impact ↔ Priority" を使用して、マトリックスで優先度を設定できます。';
    $Self->{Translation}->{'Keywords to facilitate the search for services within the service catalog.'} =
        'サービスカタログ内でサービスを検索しやすくするためのキーワード。';
    $Self->{Translation}->{'Service descriptions (short & long) specified by User Language.'} =
        'ユーザーの言語ごとに指定するサービスの説明（短い説明と詳しい説明）。';
    $Self->{Translation}->{'Short summary of the service, mainly used in the CustomerDashboard.'} =
        'サービスの短い概要。主に CustomerDashboard で使用されます。';
    $Self->{Translation}->{'Description of the service. Screenshots and tables are also allowed. Please ensure the correct width of the image for screenshots. This can be adjusted in the ckeditor after uploading the screenshot. A width of 600px has proven to be useful or you can configure a "max-width" of 95% under Advanced.'} =
        'サービスの説明。スクリーンショットや表も使用できます。スクリーンショットの場合は、画像の幅が適切になるようにしてください。幅は、スクリーンショットをアップロードした後に CKEditor で調整できます。幅 600px が実用的です。または、詳細設定で "max-width" を 95% に設定することもできます。';
    $Self->{Translation}->{'Add more service catalog fields'} = 'サービスカタログのフィールドを追加';
    $Self->{Translation}->{'You have the option of adding further fields here in the service catalog at any time. To do this, please go to "Admin -> DynamicFields" and create the new field of the object type "Service". You can then activate the field for the customer dashboard under "Admin -> DynamicField Screens" by assigning it under "CustomerDashboardTile ServiceCatalog".'} =
        'ここでは、いつでもサービスカタログにフィールドを追加できます。そのためには、"Admin -> DynamicFields" でオブジェクトタイプ "Service" の新しいフィールドを作成してください。その後、"Admin -> DynamicField Screens" で "CustomerDashboardTile ServiceCatalog" に割り当てることで、顧客ダッシュボードでそのフィールドを有効にできます。';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'SLA 情報';
    $Self->{Translation}->{'Last changed'} = '最終更新日時';
    $Self->{Translation}->{'Last changed by'} = '最終更新者';
    $Self->{Translation}->{'Associated Services'} = '関連するサービス';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'サービス情報';
    $Self->{Translation}->{'Current incident state'} = '現在のインシデント状況';
    $Self->{Translation}->{'Associated SLAs'} = '関連する SLA';

    # JS Template: TileServiceCatalogContainer
    $Self->{Translation}->{'Create a new ticket for this service.'} = 'このサービスの新規チケットを作成します。';
    $Self->{Translation}->{'Create %s'} = '%s を作成';
    $Self->{Translation}->{'Show %s sub-service(s)'} = '%s 件のサブサービスを表示';
    $Self->{Translation}->{'More details'} = '詳細';
    $Self->{Translation}->{'Sub-Service(s)'} = 'サブサービス';

    # JS Template: TileServiceCatalogDetailed
    $Self->{Translation}->{'sub-service(s) available'} = '件のサブサービスがあります';
    $Self->{Translation}->{'Create a new ticket of type %s.'} = 'タイプ %s の新規チケットを作成します。';
    $Self->{Translation}->{'FAQ article on this topic'} = 'このトピックに関する FAQ 記事';
    $Self->{Translation}->{'Additional information'} = '追加情報';
    $Self->{Translation}->{'Service hours'} = 'サービス時間';
    $Self->{Translation}->{'o\'clock'} = '時';
    $Self->{Translation}->{'No additional data are available.'} = '追加データはありません。';
    $Self->{Translation}->{'Further information'} = 'その他の情報';

    # JS Template: TileServiceCatalogModal
    $Self->{Translation}->{'Search catalog'} = 'カタログを検索';

    # Perl Module: Kernel/Modules/CustomerTileServiceCatalog.pm
    $Self->{Translation}->{'Description not available.'} = '説明はありません。';
    $Self->{Translation}->{'Need FileID!'} = 'FileID が必要です！';

    # Perl Module: Kernel/Modules/AgentITSMServiceZoom.pm
    $Self->{Translation}->{'No ServiceID is given!'} = 'ServiceID が指定されていません！';
    $Self->{Translation}->{'ServiceID %s not found in database!'} = 'ServiceID %s がデータベースに見つかりません！';
    $Self->{Translation}->{'operational'} = '稼働中';
    $Self->{Translation}->{'warning'} = '警告';
    $Self->{Translation}->{'incident'} = 'インシデント';

    # JS File: Core.Agent.Admin.Service
    $Self->{Translation}->{'Do you really want to delete this service description language?'} =
        'このサービスの説明の言語を本当に削除しますか？';

    # JS File: Core.Customer.TileServiceCatalog
    $Self->{Translation}->{'Results for %s'} = '%s の検索結果';

    # SysConfig
    $Self->{Translation}->{'Additional settings for the service catalog.'} = 'サービスカタログの追加設定。';
    $Self->{Translation}->{'Autoload configuration for SLA import and export functions.'} = 'SLA のインポート／エクスポート機能用の自動読み込み設定。';
    $Self->{Translation}->{'Autoload configuration for Service import and export functions.'} =
        'サービスのインポート／エクスポート機能用の自動読み込み設定。';
    $Self->{Translation}->{'CustomerTileServiceCatalog AJAX Module.'} = 'CustomerTileServiceCatalog の AJAX モジュール。';
    $Self->{Translation}->{'Define a list of dynamic field object types which are allowed to be assigned to actions of this package via the dynamic field screens interface.'} =
        'ダイナミックフィールド画面インタフェースを介して、このパッケージのアクションに割り当てることができるダイナミックフィールドのオブジェクトタイプの一覧を定義します。';
    $Self->{Translation}->{'Dynamic fields shown in the service catalog screen of the customer interface.'} =
        '顧客インタフェースのサービスカタログ画面に表示するダイナミックフィールド。';
    $Self->{Translation}->{'Event module registration. Currently, the criticality of the service can also be set in the service, but this has no effect. Therefore, this event module has been implemented that automatically updates the DynamicField Criticality in a ticket as soon as a service has been assigned. Please activate the SysConfig option SetPriorityFromCriticalityAndImpactMatrix to set the priority in the next step based an Criticality and Impact.'} =
        'イベントモジュールの登録。現在、サービスの重要度はサービス側でも設定できますが、効果はありません。そのため、サービスが割り当てられた時点でチケットのダイナミックフィールド Criticality を自動的に更新するイベントモジュールを実装しています。次のステップで重要度と影響度に基づいて優先度を設定するには、システム設定オプション SetPriorityFromCriticalityAndImpactMatrix を有効にしてください。';
    $Self->{Translation}->{'Event module registration. Currently, the criticality of the service can also be set in the service, but this has no effect. Therefore, this event module has been implemented that automatically updates the priority regarding Criticality and Impact in a ticket.'} =
        'イベントモジュールの登録。現在、サービスの重要度はサービス側でも設定できますが、効果はありません。そのため、チケットの重要度と影響度に応じて優先度を自動的に更新するイベントモジュールを実装しています。';
    $Self->{Translation}->{'Find the right service for your ticket'} = 'チケットに合ったサービスを探す';
    $Self->{Translation}->{'Show services with the following ticket type last.'} = '次のチケットタイプのサービスを最後に表示します。';
    $Self->{Translation}->{'The FAQ field that should be used as the description of an FAQ article in the sidebar (e.g. Field1, Field2, Field3...).'} =
        'サイドバーで FAQ 記事の説明として使用する FAQ のフィールド（例: Field1、Field2、Field3...）。';
    $Self->{Translation}->{'This option allows you to automatically generate ACLs for different interfaces when creating services. Services will then only be displayed if the ticket type stored in the service has been selected. The "AddBulkACL" console script can also be used to create ACLs for services that have already been create.'} =
        'このオプションにより、サービスの作成時に各インタフェース用の ACL を自動生成できます。その場合、サービスに登録されたチケットタイプが選択されたときにのみ、そのサービスが表示されます。すでに作成済みのサービスの ACL を作成するには、コンソールスクリプト "AddBulkACL" も使用できます。';
    $Self->{Translation}->{'This option makes it possible to preconfigure the automatically generated ACLs. The aim is to only display the services that have also been assigned to the service in the service catalog. To use this function, please first enable the "ServiceCatalog::CreateTypeServiceRelatedAcls" option. "GenerateInitalACLToDisableAllServices" generates an ACL that initially hides all services. The value "Possible" or "PossibleAdd" can be set for the key "ConfigChange". The "DeployNewACL" key decides whether the changed ACL should also be deployed immediately. "ACLValidID" (1, 2, 3) sets the ACLs to valid, invalid or temporarily invalid.'} =
        'このオプションにより、自動生成される ACL を事前に設定できます。目的は、サービスカタログでサービスに割り当てられたものだけを表示することです。この機能を使用するには、まず "ServiceCatalog::CreateTypeServiceRelatedAcls" オプションを有効にしてください。"GenerateInitalACLToDisableAllServices" は、最初にすべてのサービスを非表示にする ACL を生成します。キー "ConfigChange" には "Possible" または "PossibleAdd" を設定できます。キー "DeployNewACL" は、変更した ACL をすぐにデプロイするかどうかを決定します。"ACLValidID"（1、2、3）は、ACL を有効、無効、一時的に無効のいずれかに設定します。';
    $Self->{Translation}->{'Tile registration for the CustomerDashboard. Module is required.'} =
        'CustomerDashboard のタイル登録。Module は必須です。';


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
