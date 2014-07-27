<cfquery name="q_select_last_posting_userkey" datasource="#request.a_str_db_tools#">
SELECT
	userkey
FROM
	postings
WHERE
	parentpostingkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.threadkey#">
ORDER BY
	dt_created DESC
LIMIT
	1
;
</cfquery>

<cfquery name="q_update_lastposting" datasource="#request.a_str_db_tools#">
UPDATE
	foren
SET
	dt_lastposting = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(Now()))#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forumkey#">
;
</cfquery>

<cfquery name="q_update_lastposting_thread" datasource="#request.a_str_db_tools#">
UPDATE
	postings
SET
	dt_threadlastmodified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(Now()))#">,
	lastpostinguserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_last_posting_userkey.userkey#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.threadkey#">
;
</cfquery>