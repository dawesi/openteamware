<!--- //

	Module:		
	Action:		Save custom elements
	Description:// --->
<cfparam name="form.frm_clear_mail_header" type="numeric" default="0">
<cfparam name="form.frm_clear_mail_footer" type="numeric" default="0">
<cfparam name="form.frm_clear_remote_edit_confirmation_page" type="numeric" default="0">
<cfparam name="form.frm_clear_startpage" type="numeric" default="0">
<cfparam name="form.frm_clear_welcome_mail" type="numeric" default="0">
<cfparam name="form.frm_clear_calendar_confirmation_page" type="numeric" default="0">
<cfparam name="form.frm_clear_productadd_confirmation" type="numeric" default="0">
<cfparam name="form.frm_clear_productadd_confirmation_sale" type="numeric" default="0">

<cfif form.frm_clear_mail_header IS 1>
	<cfset form.frmmailheader = ''>
</cfif>

<cfif form.frm_clear_mail_footer IS 1>
	<cfset form.frmmailfooter = ''>
</cfif>

<cfif form.frm_clear_remote_edit_confirmation_page IS 1>
	<cfset form.frmremoteeditconfirmationpage = ''>
</cfif>

<cfif form.frm_clear_startpage IS 1>
	<cfset form.frmstartpage = ''>
</cfif>

<cfif form.frm_clear_welcome_mail IS 1>
	<cfset form.frmwelcomemail = ''>
</cfif>

<cfif form.frm_clear_calendar_confirmation_page IS 1>
	<cfset form.frmcalendarconfirmationpage = ''>
</cfif>

<cfif form.frm_clear_productadd_confirmation IS 1>
	<cfset form.frmproductadd_confirmation = '' />
</cfif>

<cfif form.frm_clear_productadd_confirmation_sale IS 1>
	<cfset form.frmproductadd_confirmation_sale = '' />
</cfif>

<cfset a_cmp_content = application.components.cmp_content>

<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'mail_header', elementvalue = form.frmmailheader)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'mail_footer', elementvalue = form.frmmailfooter)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'remote_edit_confirmation_page', elementvalue = form.frmremoteeditconfirmationpage)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'startpage', elementvalue = form.frmstartpage)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'welcomemail', elementvalue = form.frmwelcomemail)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'calendar_confirmation_page', elementvalue = form.frmcalendarconfirmationpage)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'productadd_confirmation', elementvalue = form.frmproductadd_confirmation)>
<cfset a_cmp_content.SetCompanyCustomElement(createdbyuserkey = request.stSecurityContext.myuserkey, companykey = form.frmcompanykey, elementname = 'productadd_confirmation_sale', elementvalue = form.frmproductadd_confirmation_sale) />

<cflocation addtoken="no" url="#ReturnRedirectURL()#">


