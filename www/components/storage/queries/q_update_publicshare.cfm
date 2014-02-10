<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Update the parentdirectory of a file (=Move)


<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the Directory
</description>
</param>
<param name="password" scope="arguments" type="string">
<description>
The New Password
</description>
</param>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The UUID of the active User.
</description>
</param>
</in>
<out>
</out>
</io> 

--->

<cfquery name="q_update_directory" datasource="#request.a_str_db_tools#">

UPDATE

	publicshares

SET

	type = 0,

	password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">

WHERE

	directorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">

	AND

	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">

;

</cfquery>

