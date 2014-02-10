<!--- //

	Module:		Storage
	Description: 
	

// --->


<cfquery name="q_select_subdirectories_files" datasource="#request.a_str_db_tools#">
SELECT
	'file' AS filetype,
	entrykey,
	filename AS name,
	description,
	categories,
	filesize,
	contenttype,
	0 AS filescount,
	0 AS specialtype,
	locked
FROM
	storagefiles
WHERE
	userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">
ORDER BY
	name
;
</cfquery>

