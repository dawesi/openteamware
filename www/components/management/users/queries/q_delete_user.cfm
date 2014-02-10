<cfquery name="q_delete_user" datasource="#request.a_str_db_users#">
DELETE FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>