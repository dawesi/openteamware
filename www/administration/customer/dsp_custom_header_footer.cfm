<!--- //

	custom header/footer
	
	// --->
	
<cfinclude template="../dsp_inc_select_company.cfm">

<!--- load data ... --->

<cfset a_cmp_content = application.components.cmp_content />

<form action="customer/act_save_custom_elements.cfm" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">

<h4>Mail Header (RemoteEdit, Calendar Invitation, ...)</h4>
<input type="checkbox" name="frm_clear_mail_header" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<br />
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmmailheader";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'mail_header');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>Mail Footer (RemoteEdit, Calendar Invitation, ...)</h4>
<input type="checkbox" name="frm_clear_mail_footer" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmmailfooter";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'mail_footer');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>Startpage</h4>
<input type="checkbox" name="frm_clear_startpage" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmstartpage";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'startpage');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>RemoteEdit Confirmation Page</h4>
<input type="checkbox" name="frm_clear_remote_edit_confirmation_page" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmremoteeditconfirmationpage";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'remote_edit_confirmation_page');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>Calendar Invitation Confirmation Page</h4>

<input type="checkbox" name="frm_clear_calendar_confirmation_page" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmcalendarconfirmationpage";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'calendar_confirmation_page');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>User Welcome Mail</h4>

<input type="checkbox" name="frm_clear_welcome_mail" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmwelcomemail";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'welcomemail');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>Product add confirmation</h4>
<input type="checkbox" name="frm_clear_productadd_confirmation" value="1" class="noborder"> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmproductadd_confirmation";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'productadd_confirmation');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>

<h4>Product add confirmation (With prices)</h4>
<input type="checkbox" name="frm_clear_productadd_confirmation_sale" value="1" class="noborder" /> Element entfernen und wieder Vorgabeelement verwenden
<cfscript>
	fckEditor = createObject("component", "/components/tools/cmp_fckeditor");
	fckEditor.instanceName	= "frmproductadd_confirmation_sale";
	fckEditor.value			=  a_cmp_content.GetCompanyCustomElement(companykey = url.companykey, elementname = 'productadd_confirmation_sale');
	fckEditor.width			= 500;
	fckEditor.height		= 250;
	fckEditor.toolbarSet	= 'INBOX_Default';
	fckEditor.create(); // create the editor.
</cfscript>


<br />

<input type="submit" value="Speichern" class="btn btn-primary" />
</form>