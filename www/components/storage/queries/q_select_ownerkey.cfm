<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2007-09-04 01:14:55 $
modul name:      Storage
description: Get The owner of a file or directory


<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
Entrykey of the Directory or File
</description>
</param>
</in>
<out>
<query q_select_ownerkey />
</out>
</io> 

--->

<cfquery name="q_select_ownerkey" datasource="#request.a_str_db_tools#">

SELECT

	userkey

FROM

	directories

WHERE


	entrykey = <cfqueryparam value="#arguments.entrykey#" cfsqltype="cf_sql_varchar">
UNION

SELECT

	userkey

FROM

	storagefiles

WHERE


	entrykey = <cfqueryparam value="#arguments.entrykey#" cfsqltype="cf_sql_varchar">

;

</cfquery>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="select owner userkey" type="html">
<cfdump var="#arguments#">
<cfdump var="#q_select_ownerkey#">
</cfmail>--->