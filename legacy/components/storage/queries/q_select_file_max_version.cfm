<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Get the Max Value of Versions of one file.


<io>
<in>
<param name="entrykey" scope="SelectFileVersions" type="string">
<description>
The Entrykey of the File
</description>
</param>
</in>
<out>
<query q_select_file_max_versions />

</out>
</io> 

--->

<cfparam name="SelectFileVersions.entrykey" type="string" default="">



<cfquery name="q_select_file_max_version" datasource="#request.a_str_db_tools#">

SELECT

	max(version) as maxversion

FROM

	versions

WHERE

	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectFileVersions.entrykey#">

;

</cfquery>

