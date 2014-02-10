<!---

<io>
<in>
<param name="directorykey" scope="SelectDirectoryRequest" type="string">
<description>
The Entrykey of the  Directory
</description>
</param>
</in>
<out>
<query q_select_parent_directory />
</out>
</io> 

--->

<cfparam name="SelectDirectoryRequest.directorykey" type="string" default="">



<cfquery name="q_select_parent_directory" datasource="#request.a_str_db_tools#">
SELECT
	directories.parentdirectorykey,
	d2.directoryname,
	d2.userkey
FROM
	directories 
LEFT OUTER JOIN
	directories as d2 
ON
	directories.parentdirectorykey = d2.entrykey
WHERE
	directories.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectDirectoryRequest.directorykey#">
;
</cfquery>

