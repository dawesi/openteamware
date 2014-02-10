<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Get the Space Usage


<io>
<in>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The Version Number
</description>
</param>
</in>
<out>
<query q_select_usage />
</out>
</io> 

--->

<cfquery name="q_select_usage" datasource="#request.a_str_db_tools#">

SELECT

	SUM(filesize) as bused

FROM

	storagefiles

WHERE

	userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">

;

</cfquery>

