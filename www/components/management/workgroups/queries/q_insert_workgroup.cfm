

<cfparam name="CreateWorkgroupRequest.Createdbyuserkey" type="string" default="">

<cfparam name="CreateWorkgroupRequest.companykey" type="string" default="">

<cfparam name="CreateWorkgroupRequest.groupname" type="string" default="">

<cfparam name="CreateWorkgroupRequest.shortgroupname" type="string" default="">

<cfparam name="CreateWorkgroupRequest.description" type="string" default="">

<cfparam name="CreateWorkgroupRequest.parentkey" type="string" default="">

<cfparam name="CreateWorkgroupRequest.entrykey" type="string" default="">

<cfparam name="CreateWorkgroupRequest.colour" type="string" default="white">

<cfquery name="q_insert_workgroup">
INSERT INTO
	workgroups
	(
	createdbyuserkey,
	companykey,
	groupname,
	shortname,
	description,
	parentkey,
	entrykey,
	dt_created,
	colour
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.Createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.groupname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(CreateWorkgroupRequest.shortgroupname, 1, 12)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.parentkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateWorkgroupRequest.colour#">
	)
;
</cfquery>