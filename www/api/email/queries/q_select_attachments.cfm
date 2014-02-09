<cfquery name="q_select_attachments" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,filename,contenttype
FROM
	webservices_file_uploads
WHERE
	clientkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientkey#">
	AND
	appkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">
	AND
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileuploadkeys#" list="yes">)
;
</cfquery>