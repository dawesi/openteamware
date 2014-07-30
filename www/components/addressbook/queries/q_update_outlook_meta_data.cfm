
<cfquery name="q_update_outlook_meta_data">
UPDATE
	addressbook_outlook_data
SET
	lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">
WHERE
	addressbookkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>