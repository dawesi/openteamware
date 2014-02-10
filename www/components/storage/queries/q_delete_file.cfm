<!--- //

	Module:		Storage
	Function:	DeleteFile
	Description:Remove a file
	

// --->


<cfquery name="q_delete_file" datasource="#request.a_str_db_tools#">
DELETE FROM 
	storagefiles	
WHERE 
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>


