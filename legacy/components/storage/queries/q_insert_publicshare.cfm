<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Create a new Public Share


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
<param name="description" scope="q_query_file" type="string">
<description>
</description>
</param>
<param name="password" scope="arguments" type="string">
<description>
A Integer defining the Version number
</description>
</param>
</in>
<out>
</out>
</io> 

--->

<cfquery name="q_insert_directory" datasource="#request.a_str_db_tools#">

INSERT INTO

	publicshares

(

	directorykey,

	userkey,

	type,

	password,

	dt_valid_until

)

VALUES

	(

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	0,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">,

	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">

	)

;

</cfquery>

