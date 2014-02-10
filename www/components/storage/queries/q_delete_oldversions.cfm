<!---
<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the File
</description>
</param>
</in>
<out>
</out>
</io> 
--->

<cfquery name="q_delete_oldversions" datasource="#request.a_str_db_tools#">
DELETE FROM 
	versions	
WHERE 
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

