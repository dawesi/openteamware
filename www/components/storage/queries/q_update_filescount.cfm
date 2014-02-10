<!--- //

	Module:		Storage
	Function:	UpdateFilesCount
	Description:Updates filescount property of a directory
	

// --->

<cfquery name="q_update_filescount" datasource="#request.a_str_db_tools#">
SELECT 
	count(id) as dircount
FROM 
	directories 
WHERE 
	parentdirectorykey =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfset a_int_filecount = a_int_filecount + q_update_filescount.dircount />

<cfquery name="q_update_filescount" datasource="#request.a_str_db_tools#">
SELECT 
	count(id) as filecount
FROM 
	storagefiles
WHERE 
	parentdirectorykey =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfset a_int_filecount = a_int_filecount + q_update_filescount.filecount />

<cfquery name="q_update_filescount" datasource="#request.a_str_db_tools#">
UPDATE
	directories
SET
	filescount =<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_int_filecount#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>


