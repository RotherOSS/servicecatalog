// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
// --
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.TicketZoom
 * @memberof Core.Agent
 * @author
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
Core.Agent.ITSMServiceZoom = (function (TargetNS) {

     TargetNS.ResizeIframe = function(Iframe) {
        Iframe = isJQueryObject(Iframe) ? Iframe.get(0) : Iframe;

        var $IframeContent = $(Iframe.contentDocument || Iframe.contentWindow.document),
            NewHeight = $IframeContent.height();
        if (!NewHeight || isNaN(NewHeight)) {
            NewHeight = 100;
        }
        else {
            if (NewHeight > 600) {
                NewHeight = 600;
            }
        }

        NewHeight = parseInt(NewHeight, 10);
        $(Iframe).height(NewHeight + 'px');
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.ITSMServiceZoom || {}));
