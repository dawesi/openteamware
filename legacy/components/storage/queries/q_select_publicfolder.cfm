<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Search for Folders without needing userkeys


<io>
<in>
<param name="directoryname" scope="arguments" type="string">
<description>
The Name of the Directory
</description>
</param>
<param name="parentdirectorykey" scope="arguments" type="string">
<description>
The Directory to search in
</description>
</param>
</in>
<out>
<query q_select_publicfolder />
</out>
</io> 

--->
<cfif len(arguments.parentdirectorykey ) gt 0>
<cfquery name="q_select_publicfolder" datasource="#request.a_str_db_tools#">
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
	0 as specialtype ,
	parentdirectorykey,
	dt_lastmodified

FROM
	directories
WHERE 
	directoryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directoryname#">
	AND
	parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentdirectorykey#">
;
</cfquery>

<cfelse>
<cfquery name="q_select_publicfolder" datasource="#request.a_str_db_tools#">
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
	publicshares.directorykey as publicshare_directorykey,
	publicshares.password as publicshare_password,
	0 as specialtype 

FROM

	directories

	INNER JOIN publicshares ON entrykey = publicshares.directorykey 
WHERE 
	directoryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directoryname#">
;
</cfquery>
</cfif>
 