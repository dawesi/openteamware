<!---

modul name:      Storage
description: Select all used Userkeys


<io>
<in>
</in>
<out>
<query q_select_all_users />
</out>
</io> 

--->

<cfquery name="q_select_all_users" datasource="#request.a_str_db_tools#">
SELECT DISTINCT
	userkey
FROM
	storagefiles
ORDER BY
	userkey
;
</cfquery>