<cfquery name="q_update_rename_folder" datasource="#request.a_str_db_email#">
DELETE FROM
	folders
WHERE
	foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sourcefolder#">
	AND
	UPPER(account) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.username)#">
;
</cfquery>