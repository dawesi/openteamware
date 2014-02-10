<cfquery name="q_select_answers_count"  datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	postings
WHERE
	parentpostingkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfquery name="q_update_answer_count"  datasource="#request.a_str_db_tools#">
UPDATE
	postings
SET
	subpostingscount = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_answers_count.count_id#">,
	dt_threadlastmodified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(Now()))#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

