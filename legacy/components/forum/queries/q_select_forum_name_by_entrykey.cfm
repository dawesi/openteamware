<cfquery name="q_select_forum_name_by_entrykey" datasource="#request.a_str_db_tools#">
SELECT
	forumname
FROM
	foren
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>