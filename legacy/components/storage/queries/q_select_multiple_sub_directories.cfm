<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Select a list of Directories


<io>
<in>
<param name="a_arr_directorykeys" scope="select_directories" type="string">
<description>
The Entrykeys of all Directories
</description>
</param>
</in>
<out>
<query q_select_multiple_sub_directories />
</out>
</io> 

--->

<cfset a_str_list_2_query = ArraytoList(select_directories.a_arr_directorykeys)>

<cfif Len(a_str_list_2_query) IS 0>
	<cfset a_str_list_2_query = 'dummyentry'>
</cfif>

<cfquery name="q_select_multiple_sub_directories" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,directoryname,description,createdbyuserkey,userkey,lasteditedbyuserkey,
	dt_created,
	dt_lastmodified,
	parentdirectorykey,filescount,displaytype,description
FROM
	directories
WHERE
	parentdirectorykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_list_2_query#" list="yes">)
ORDER BY
	directoryname
;
</cfquery>