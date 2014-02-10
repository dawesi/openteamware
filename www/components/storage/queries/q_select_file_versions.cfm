<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Select all Version of a File


<io>
<in>
<param name="entrykey" scope="SelectFileVersion" type="string">
<description>
The Entrykey of the File
</description>
</param>
<param name="version" scope="SelectFileVersion" type="string">
<description>
The Version Number
</description>
</param>
</in>
<out>
<query q_select_file_versions />
</out>
</io> 

--->

<cfparam name="SelectFileVersions.entrykey" type="string" default="">



<cfquery name="q_select_file_versions" datasource="#request.a_str_db_tools#">

SELECT

	entrykey,version,dt_created

FROM

	versions

WHERE

	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectFileVersions.entrykey#">

order by version desc

;

</cfquery>