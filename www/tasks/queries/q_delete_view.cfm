

<cfquery name="q_delete_view" datasource="#request.a_str_db_tools#">
DELETE FROM
	savedtaskviews
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>