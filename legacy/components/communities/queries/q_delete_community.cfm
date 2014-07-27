<cfquery name="q_delete_community" datasource="#request.a_str_db_tools#">
DELETE FROM
	communities
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>