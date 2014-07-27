<!---
<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the Directory
</description>
</param>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The UUID of the active User.
</description>
</param>
</in>
<out>
</out>
</io> 

--->

<cfquery name="q_delete_directory" datasource="#request.a_str_db_tools#">
DELETE FROM 
	directories_shareddata
WHERE
	directorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"> 
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>