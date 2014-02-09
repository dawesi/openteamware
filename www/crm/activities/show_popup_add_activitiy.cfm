<!---

	add an activity to a contact
	
	--->
<cfinclude template="/login/check_logged_in.cfm">

<cfset request.a_struct_current_service_action = 'crm'>

<cfinclude template="/common/scripts/script_utils.cfm">
	
<cfparam name="url.entrykey" type="string">

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfif Len(a_struct_crmsales_bindings.ACTIVITIES_TABLEKEY) IS 0>
	<cfexit method="exittemplate">
</cfif>

<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<cfinclude template="/common/js/inc_js.cfm">
	
	<script type="text/javascript" src="/common/js/CalendarPopup.js"></script>
	<cfinclude template="../../render/inc_html_header.cfm">
	<title><cfoutput>#GetLangVal('adrb_crm_ph_add_activity')#</cfoutput></title>
</head>

<body>

<cfif request.stSecurityContext.mycompanykey IS 'D6576B72-AA82-49BC-BDF4F792DD41EF91'>
	<script type="text/javascript">
		window.resizeTo(800,600)
	</script>
</cfif>

<cfinclude template="dsp_add_activity_popup.cfm">

