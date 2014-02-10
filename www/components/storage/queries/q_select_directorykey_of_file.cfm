<cfquery name="q_select_directorykey_of_file" datasource="#request.a_str_db_tools#">
SELECT
	parentdirectorykey
FROM
	storagefiles
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filekey#">
;
</cfquery>