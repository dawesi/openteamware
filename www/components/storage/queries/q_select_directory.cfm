<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Select a Directory and all Info about it


<io>
<in>
<param name="directorykey" scope="SelectDirectoryRequest" type="string">
<description>
The Entrykey of the Directory
</description>
</param>
</in>
<out>
<query q_select_directory>
</out>
</io> 

--->

<cfparam name="SelectDirectoryRequest.directorykey" type="string" default="">



<cfquery name="q_select_directory" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,
	directoryname,
	description,
	directories.createdbyuserkey,
	directories.userkey,
	lasteditedbyuserkey,
	directories.dt_created,
	dt_lastmodified,
	parentdirectorykey,
	filescount,
	displaytype,
	versioning,
	displaytype,
	publicshares.directorykey AS publicshare_directorykey,
	publicshares.password AS publicshare_password,
	directories_shareddata.directorykey AS shared_directorykey,
	directories_shareddata.workgroupkey AS shared_workgroupkey,
	0 AS specialtype 
FROM
	directories
LEFT OUTER JOIN
	publicshares
		ON
		entrykey = publicshares.directorykey 
LEFT OUTER JOIN
	directories_shareddata
		ON
		entrykey=directories_shareddata.directorykey
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectDirectoryRequest.directorykey#">
;
</cfquery>

<!---

Postgresql Spezifischer Code 

LEFT OUTER JOIN ist nicht SQL92 konform. 



alternativ k�nnte die query so geschrieben werden (Oracle kompatibel).



FROM directories,publicshares,directories_shareddata

WHERE

directories.entrykey = publicshares.directorykey (+),

directories.entrykey = directories_shareddata.directorykey (+)

--->