<!--- //

	// --->
	
<cfquery name="q_delete_reminders">
DELETE FROM
	cal_remind
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
;
</cfquery>