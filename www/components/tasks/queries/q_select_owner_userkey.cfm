<cfquery name="q_select_owner_userkey" datasource="#request.a_Str_db_tools#">
SELECT
	userkey
FROM
	tasks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>