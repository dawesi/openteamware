<cfquery name="q_delete_posting" datasource="#request.a_str_db_tools#">
DELETE FROM
	postings
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	forumkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forumkey#">
;
</cfquery>