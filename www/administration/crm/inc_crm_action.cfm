<!--- //

	Module:		Admintool
	Action:		CRM
	Description:Manage various CRM settings
	
// --->

	
<cfparam name="url.subaction" type="string" default="ShowWelcome">

<cfinclude template="../dsp_inc_select_company.cfm">

<cfswitch expression="#url.subaction#">
	<cfcase value="enablecrm_database">
		<cfinclude template="dsp_inc_activate_database.cfm">
	</cfcase>
	<cfcase value="database_properties">
		<cfinclude template="dsp_database_properties.cfm">
	</cfcase>
	<cfcase value="reorganize">
		<cfinclude template="dsp_reorganize_check.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="dsp_welcome.cfm">
	</cfdefaultcase>
</cfswitch>


