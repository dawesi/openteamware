<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Select a specific Version of a File


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
<query q_select_file />
</out>
</io> 

--->

<cfparam name="SelectFileVersion.entrykey" type="string" default="">

<cfparam name="SelectFileVersion.version" type="numeric" default="">



<cfquery name="q_select_file" datasource="#request.a_str_db_tools#">

SELECT

	storagefiles.entrykey,

	versions.filename,

	versions.description,

	storagefiles.createdbyuserkey,

	storagefiles.userkey,

	storagefiles.lasteditedbyuserkey,

	versions.filesize,

	versions.contenttype,

	storagefiles.storagefilename||'.'||<cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectFileVersion.version#"> as storagefilename,

	storagepath,

	versions.dt_created,

	storagefiles.dt_lastmodified,

	storagefiles.parentdirectorykey

FROM

	storagefiles,versions

WHERE

	versions.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectFileVersion.entrykey#"> 

AND

	storagefiles.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectFileVersion.entrykey#"> 

AND

	version = <cfqueryparam cfsqltype="cf_sql_integer" value="#SelectFileVersion.version#">

	

;

</cfquery>