<!--- //

	Module:		admintool
	Action:		criteria
	Description: 
	
// --->

<cfinclude template="../dsp_inc_select_company.cfm">

<h4><cfoutput>#GetLangVal('crm_wd_criteria')#</cfoutput></h4>

<cfinclude template="queries/q_select_all_criteria.cfm">

<cfparam name="url.subaction" type="string" default="">

<cfswitch expression="#url.subaction#">
	<cfcase value="AddCriteria">
		<!--- add new sub criteria ... --->
		<cfinclude template="dsp_add_criteria.cfm">
	</cfcase>
	<cfcase value="DeleteCriteria">
		<cfinclude template="act_delete_criteria.cfm">
	</cfcase>
	<cfdefaultcase>
		<!--- overview ... --->
		<cfinclude template="dsp_overview.cfm">		
	</cfdefaultcase>
</cfswitch>

