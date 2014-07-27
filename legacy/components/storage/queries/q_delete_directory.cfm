<!---
<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the Directory
</description>
</param>
</in>
<out>
</out>
</io> 
--->


<cfquery name="q_delete_directory" datasource="#request.a_str_db_tools#">
DELETE FROM 
	directories	
WHERE 
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

