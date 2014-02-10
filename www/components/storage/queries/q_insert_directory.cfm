<!---
modul name:      Storage
description: Create a Directory
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


<cfquery name="q_insert_directory" datasource="#request.a_str_db_tools#">

INSERT INTO

	directories

(

	entrykey,

	directoryname,

	description,

	createdbyuserkey,

	userkey,

	lasteditedbyuserkey,

	dt_created,

	parentdirectorykey,

	dt_lastmodified,

	filescount,

	displaytype,

	categories,

	versioning

)

VALUES

	(

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directoryname#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentdirectorykey#">,

	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,

	0,

	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.displaytype#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.versioning#">

	)

;

</cfquery>

