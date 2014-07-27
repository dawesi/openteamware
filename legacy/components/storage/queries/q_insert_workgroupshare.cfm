<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2006/10/04 14:38:43 $
modul name:      Storage
description: Create a new Workgroup Share


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
<param name="workgroupkey" scope="arguments" type="string">
<description>
</description>
</param>
</in>
<out>
</out>
</io> 

--->

<cfquery name="q_insert_directory" datasource="#request.a_str_db_tools#">

INSERT INTO

	directories_shareddata

(

	directorykey,

	createdbyuserkey,

	workgroupkey,

	dt_created

)

VALUES

	(

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">,

	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">

	)

;

</cfquery>

