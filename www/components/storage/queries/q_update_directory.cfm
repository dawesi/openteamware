<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Modify a Directory


<io>
<in>
<param name="entrykey" scope="arguments" type="string">
<description>
The Entrykey of the Directory
</description>
</param>
<param name="myuserkey" scope="arguments.securitycontext" type="string">
<description>
The UUID of the active User.
</description>
</param>
<param name="directoryname" scope="arguments" type="string">
<description>
</description>
</param>
<param name="description" scope="arguments" type="string">
<description>
The Descriptoin of the Directory
</description>
</param>
<param name="displaytype" scope="arguments" type="int">
<description>
The DisplayType of the Directory ( 0= Normal, 1= Thumbnails)
</description>
</param>
<param name="categories" scope="arguments" type="string">
<description>

</description>
</param>
<param name="versioning" scope="arguments" type="string">
<description>
Enables Versioning for the Directory
</description>
</param>
</in>
<out>
</out>
</io> 

--->


<cfquery name="q_update_directory" datasource="#request.a_str_db_tools#">

UPDATE

	directories

SET

	directoryname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directoryname#">,

	description=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,

	lasteditedbyuserkey=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	dt_lastmodified =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,

	displaytype=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.displaytype#">,

	categories=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#">,

	versioning =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.versioning#">

WHERE

	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">

;

</cfquery>

