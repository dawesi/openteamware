<cfquery name="q_delete_mailspeed_folder_entry" datasource="#request.a_str_db_email#">
DELETE FROM
	folders
WHERE
	foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">
	AND
	UPPER(account) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(arguments.username)#">
;
</cfquery>