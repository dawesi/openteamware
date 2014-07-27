<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Search for Files without the need for security


<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the File
</description>
</param>
<param name="directorykey" scope="arguments" type="string">
<description>
The Directory to search in
</description>
</param>
<param name="filename" scope="arguments" type="string">
<description>
File Name Pattern
</description>
</param>
</in>
<out>
<query q_select_publicfindfile />
</out>
</io> 

--->

<cfquery name="q_select_publicfindfile" datasource="#request.a_str_db_tools#">

SELECT

	'file' as filetype,entrykey,filename as name,description,

		categories,filesize,contenttype,userkey,

		0 as filescount,0 as specialtype,
		storagepath,storagefilename,parentdirectorykey,dt_lastmodified

FROM

	storagefiles

	

WHERE

	1=1

<cfif len(arguments.filename) gt 0 >

	AND filename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"> 

</cfif>

<cfif len(arguments.directorykey) gt 0 >

	AND parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#"> 

</cfif>

<cfif len(arguments.entrykey) gt 0 >

	AND entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"> 

</cfif>


ORDER BY

	name





;

</cfquery>