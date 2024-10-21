// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
// --
// $origin: otobo - 4dade81e7e04433cb2aed36af0c8727d822a1c61 - var/httpd/htdocs/js/Core.Agent.Admin.Service.js
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
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.Service
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special function for AdminService module.
 */
 Core.Agent.Admin.Service = (function (TargetNS) {

    /*
    * @name Init
    * @memberof Core.Agent.Admin.Service
    * @function
    * @description
    *      This function initializes table filter.
    */
    TargetNS.Init = function () {
        Core.UI.Table.InitTableFilter($('#FilterServices'), $('#Services'));

        // init checkbox to include invalid elements
        $('input#IncludeInvalid').off('change').on('change', function () {
            var URL = Core.Config.Get("Baselink") + 'Action=' + Core.Config.Get("Action") + ';IncludeInvalid=' + ( $(this).is(':checked') ? 1 : 0 );
            window.location.href = URL;
        });

// Service Catalog
        // bind click function to add button
        $('.LanguageAdd').off('change.Service').on('change.Service', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        // bind click function to remove button
        $('.LanguageRemove').off('click.Service').on('click.Service', function () {

            if (window.confirm(Core.Language.Translate('Do you really want to delete this service description language?'))) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });
// EO Service Catalog
    };

    
// Service Catalog
   /**
     * @name AddLanguage
     * @memberof Core.Agent.Admin.Service
     * @function
     * @param {string} LanguageID - short name of the language like es_MX.
     * @param {string} Language - full name of the language like Spanish (Mexico).
     * @returns {Bool} Returns false to prevent event bubbling.
     * @description
     *      This function add a new service description language.
     */
   TargetNS.AddLanguage = function(LanguageID, Language){

        var $Clone = $('.Template').clone();

        if (Language === '-'){
            return false;
        }

        // remove unnecessary classes
        $Clone.removeClass('Hidden Template');

        // add title
        $Clone.find('.Title').html(Language);

        // update remove link
        $Clone.find('#Template_Language_Remove').attr('name', LanguageID + '_Language_Remove');
        $Clone.find('#Template_Language_Remove').attr('id', LanguageID + '_Language_Remove');

        // set hidden language field
        $Clone.find('.LanguageID').attr('name', 'LanguageID');
        $Clone.find('.LanguageID').val(LanguageID);

        // update subject label
        $Clone.find('#Template_Label_DescriptionShort').attr('for', LanguageID + '_DescriptionShort');
        $Clone.find('#Template_Label_DescriptionShort').attr('id', LanguageID + '_Label_DescriptionShort');

        // update subject field
        $Clone.find('#Template_DescriptionShort').attr('name', LanguageID + '_DescriptionShort');
        $Clone.find('#Template_DescriptionShort').addClass('Validate_Required');
        $Clone.find('#Template_DescriptionShort').attr('id', LanguageID + '_DescriptionShort');
        $Clone.find('#Template_DescriptionShortError').attr('id', LanguageID + '_DescriptionShortError');

        // update body label
        $Clone.find('#Template_Label_DescriptionLong').attr('for', LanguageID + '_DescriptionLong');
        $Clone.find('#Template_Label_DescriptionLong').attr('id', LanguageID + '_Label_DescriptionLong');

        // update body field
        $Clone.find('#Template_DescriptionLong').attr('name', LanguageID + '_DescriptionLong');
        $Clone.find('#Template_DescriptionLong').addClass('RichText');
        $Clone.find('#Template_DescriptionLong').attr('id', LanguageID + '_DescriptionLong');

        // append to container
        $('.ServiceLanguageContainer').append($Clone);

        // initialize the rich text editor if set
        if (parseInt(Core.Config.Get('RichTextSet'), 10) === 1) {
            Core.UI.RichTextEditor.InitAllEditors();
        }

        // bind click function to remove button
        $('.LanguageRemove').off('click.Service').on('click.Service', function () {

            if (window.confirm(Core.Language.Translate('Do you really want to delete this service description language?'))) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });

        TargetNS.LanguageSelectionRebuild();

        Core.UI.InitWidgetActionToggle();

        return false;
    };

    /**
     * @name RemoveLanguage
     * @memberof Core.Agent.Admin.Service
     * @function
     * @param {jQueryObject} Object - JQuery object used to remove the language block
     * @description
     *      This function removes a service description language.
     */
    TargetNS.RemoveLanguage = function (Object) {
        Object.closest('.ServiceLanguage').remove();
        TargetNS.LanguageSelectionRebuild();
    };

    /**
     * @name LanguageSelectionRebuild
     * @memberof Core.Agent.Admin.Service
     * @function
     * @returns {Boolean} Returns true.
     * @description
     *      This function rebuilds language selection, only show available languages.
     */
    TargetNS.LanguageSelectionRebuild = function () {

        // get original selection with all possible fields and clone it
        var $Languages = $('#LanguageOrig option').clone();

        $('#Language').empty();

        // strip all already used attributes
        $Languages.each(function () {
            if (!$('.ServiceLanguageContainer label#' + $(this).val() + '_Label_DescriptionShort').length) {
                $('#Language').append($(this));
            }
        });

        $('#Language').trigger('redraw.InputField');

        // bind click function to add button
        $('.LanguageAdd').off('change.Service').on('change.Service', function () {
            TargetNS.AddLanguage($(this).val(), $('.LanguageAdd option:selected').text());
            return false;
        });

        return true;
    };    
// EO Service Catalog

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.Service || {}));
