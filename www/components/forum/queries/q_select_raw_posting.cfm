<cfquery name="q_select_raw_posting" datasource="#request.a_Str_db_forum#">
SELECT
	*
FROM
	postings
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	forumkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forumkey#">
;
</cfquery>