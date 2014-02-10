<cfquery name="q_select_folder_size" datasource="#request.a_str_db_tools#">
SELECT
	SUM(filesize) AS SUM_filesize
FROM
	storagefiles
WHERE
	parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#">
;
</cfquery>

<cfquery name="q_select_objects_in_directory" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_elements
FROM
	storagefiles
WHERE
	parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#">
;
</cfquery>