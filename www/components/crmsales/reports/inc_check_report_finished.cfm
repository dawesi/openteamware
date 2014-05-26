<!--- //

	report has been finished ...
	
	check if we should notify the user about that by email
	
	// --->
	
<cfquery name="q_select_report_job" datasource="#request.a_str_db_tools#">
SELECT
	alert_user_by_email_when_finished
FROM
	crm_running_reports
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
;
</cfquery>

<cfif q_select_report_job.alert_user_by_email_when_finished IS 1>


<cfmail from="#arguments.securitycontext.myusername#" to="#arguments.securitycontext.myusername#" subject="Report #q_select_report_settings.reportname# is available">
Your requested report #q_select_report_settings.reportname# is available - please click here to display the output:

https://www.openTeamWare.com/crm/index.cfm?action=reports
</cfmail>
</cfif>

<!--- delete from running reports --->
<cfquery name="q_delete_report_job" datasource="#request.a_str_db_tools#">
DELETE FROM
	crm_running_reports 
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
;
</cfquery>