
<cfquery name="q_update_outlook_meta_data">
UPDATE
	tasks_outlook_data
SET
	lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>