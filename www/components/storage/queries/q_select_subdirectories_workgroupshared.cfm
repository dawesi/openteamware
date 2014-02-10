<!---

<io>
<in>
<param name="Q_SELECT_WORKGROUP_PERMISSIONS" scope="arguments.securitycontext" type="string">
<description>
All Workgroups
</description>
</param>
</in>
<out>
<qzery q_select_subdirectories_workgroupshared />
</out>
</io> 

--->

<cfquery name="q_select_subdirectories_workgroupshared" datasource="#request.a_str_db_tools#">
SELECT 
	'directory' AS filetype,
	entrykey,
	directoryname AS name,
	description,
	categories,
	0 AS filesize,
	'' AS contenttype,
	userkey,
	filescount,
	0 AS specialtype,
	0 as shared,
	dt_lastmodified
FROM
	directories,directories_shareddata
WHERE
	(directories_shareddata.directorykey = directories.entrykey)
	AND 
	directories_shareddata.workgroupkey IN 

		('----novalue----'
		 <cfloop query="arguments.securitycontext.Q_SELECT_WORKGROUP_PERMISSIONS">

			 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#workgroup_key#">

		 </cfloop>
		)
ORDER BY
	filetype,
	name
;
</cfquery>

