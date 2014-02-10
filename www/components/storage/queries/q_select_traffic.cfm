<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Update the Traffic Table


<io>
<in>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The Userkey to Update, typically the owner of a file.
</description>
</param>
</in>
<out>
<query q_update_traffic>
</out>
</io> 

--->

<cfquery name="q_select_traffic" datasource="#request.a_str_db_tools#">
SELECT 
	kbused,kblimit
FROM 
	trafficlimits
WHERE 
	userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">
;
</cfquery>

