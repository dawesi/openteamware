<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2007/05/02 16:55:31 $
modul name:      Storage
description: Get the Quota of a User. 


<io>
<in>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The User Key
</description>
</param>
</in>
<out>
<query q_select_user_quota />
</out>
</io> 

--->

<cfquery name="q_select_user_quota" datasource="#request.a_str_db_tools#">

SELECT

	maxsize

FROM

	quota

WHERE

	userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">

;

</cfquery>

<cfif q_select_user_quota.recordcount lte 0>
	<cfset q_select_user_quota = StructNew ()>
	<cfset q_Select_user_quota.recordcount=1>
	<cfset q_select_user_quota.maxsize = a_int_storage_max_quota>
</cfif>

