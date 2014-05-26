<!--- //

	Module:		
	Action:		Store CRM preferences
	Description:	
	

// --->
	
<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="form.frm_cal_view_web" type="string" default="short">
<cfparam name="form.frm_cal_view_print" type="string" default="full">
<cfparam name="form.frmcb_display_email_addressbook" type="numeric" default="0">
<cfparam name="form.frmdb_hide_empty_areas" type="numeric" default="0">
<cfparam name="form.frmdb_hide_private_data" type="numeric" default="0">
<cfparam name="form.frm_show_products_history_always" type="numeric" default="0">
<cfparam name="form.frm_autoupdate_lastcontact_on_product_add" type="numeric" default="0">
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "calendar.contactdata.viewmode.web"
	entryvalue1 = #form.frm_cal_view_web#>
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "addressbook.displayemailaddress"
	entryvalue1 = #val(form.frmcb_display_email_addressbook)#>
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "common.hide_empty_areas"
	entryvalue1 = #val(form.frmdb_hide_empty_areas)#>	
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "common.hide_private_address_if_business_data_available"
	entryvalue1 = #val(form.frmdb_hide_private_data)#>	
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "products.history.show.always"
	entryvalue1 = #val(form.frm_show_products_history_always)#>	
	
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "products.autoupdate_lastupdate_on_add"
	entryvalue1 = #val(form.frm_autoupdate_lastcontact_on_product_add)#>		
	
<!---<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "extensions.crm"
	entryname = "calendar.contactdata.viewmode.print"
	entryvalue1 = #form.frm_cal_view_print#>--->

<cflocation addtoken="no" url="../index.cfm?action=extensions.crm&saved=1">

