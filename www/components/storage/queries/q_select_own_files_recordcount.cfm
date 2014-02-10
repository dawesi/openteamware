<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Get File per Person Count


<io>
<in>
<param name="userkey" scope="arguments" type="string">
<description>
The Key of the User.
</description>
</in>
<out>
<query q_select_own_files_recordcount />
</out>
</io> 

--->

<cfquery name="q_select_own_files_recordcount" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	storagefiles
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>