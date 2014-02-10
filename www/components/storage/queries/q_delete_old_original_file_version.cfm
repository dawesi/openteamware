<!--- //

	Module:		Storage
	Function:	AddFile
	Description:Remove an original file version from storagefiles
				New will be added (overwrite)
	

// --->


<cfquery name="q_delete_file" datasource="#request.a_str_db_tools#">
DELETE FROM 
	storagefiles	
WHERE 
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_filekey_of_existing_file#">
;
</cfquery>


