<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2007-07-31 14:26:07 $
modul name:      Storage
description: Select all Info about a file


<io>
<in>
<param name="entrykey" scope="SelectFileRequest" type="string">
<description>
The Entrykey of the File
</description>
</param>
</in>
<out>
<query q_select_file />
</out>
</io> 

--->

<cfparam name="SelectFileRequest.entrykey" type="string" default="">

<cfquery name="q_select_file" datasource="#request.a_str_db_tools#">
SELECT
	storagefiles.entrykey,
	storagefiles.filename,
	storagefiles.description,
	storagefiles.createdbyuserkey,
	storagefiles.userkey,
	storagefiles.lasteditedbyuserkey,
	storagefiles.filesize,
	storagefiles.contenttype,
	storagefiles.storagefilename,
	storagefiles.storagepath,
	storagefiles.dt_created,
	storagefiles.dt_lastmodified,
	storagefiles.parentdirectorykey,
	directories.directoryname,
	storagefiles.locked
FROM
	storagefiles left join 
	directories on (directories.entrykey = storagefiles.parentdirectorykey)
WHERE
	storagefiles.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectFileRequest.entrykey#">
;
</cfquery>
