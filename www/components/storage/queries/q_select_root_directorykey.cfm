<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Get the Root Directory of a User. (Root = '/')


<io>
<in>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The Version Number
</description>
</param>
</in>
<out>
<query q_select_root_directorykey />
</out>
</io> 

--->

<cfquery name="q_select_root_directorykey" datasource="#request.a_str_db_tools#">
SELECT
	entrykey
FROM
	directories
WHERE
	directoryname = '/'
	AND
	parentdirectorykey = ''
	AND 
	userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">
;
</cfquery>