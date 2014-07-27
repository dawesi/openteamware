

<cfquery name="q_select_owner_userkey" datasource="#request.a_str_db_tools#">
SELECT
	userkey
FROM
	calendar
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>