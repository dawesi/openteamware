<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Select all Public Directory of a User.

<io>
<in>
<param name="userkey" scope="arguments" type="string">
<description>
The Entrykey of the File
</description>
</param>
</in>
<out>
<query q_select_all_publicfolders />
</out>
</io> 

--->

<cfquery name="q_select_all_publicfolders" datasource="#request.a_str_db_tools#">
SELECT 
	'directory' AS filetype,
	entrykey,
	directoryname AS name,
	description,
	categories,
	0 AS filesize,
	'' AS contenttype,
	directories.userkey,
	filescount,
	0 AS specialtype,
	dt_created,
	publicshares.directorykey AS publicshare_directorykey,
	publicshares.password AS publicshare_password,
	0 AS specialtype,
	0 AS shared,
	parentdirectorykey,
	dt_lastmodified
FROM
	directories
INNER JOIN 
	publicshares ON entrykey = publicshares.directorykey 
WHERE
	directories.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>