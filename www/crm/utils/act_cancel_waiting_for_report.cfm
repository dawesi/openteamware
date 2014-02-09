<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfquery name="q_update_notify_email" datasource="#request.a_str_db_tools#">
UPDATE
	crm_running_reports
SET
	alert_user_by_email_when_finished = 1
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<cflocation addtoken="no" url="/crm/">