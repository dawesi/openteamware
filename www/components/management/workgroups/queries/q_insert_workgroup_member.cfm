<!--- //

	insert a workgroup member ...
	
	// --->
	
<cfparam name="AddWorkgroupMemberRequest.entrykey" type="string" default="">
<cfparam name="AddWorkgroupMemberRequest.userkey" type="string" default="">
<cfparam name="AddWorkgroupMemberRequest.workgroupkey" type="string" default="">
<cfparam name="AddWorkgroupMemberRequest.roles" type="string" default="">
<cfparam name="AddWorkgroupMemberRequest.createdbyuserkey" type="string" default="">

<cfquery name="q_insert_workgroup_member">
INSERT INTO workgroup_members
(entrykey,userkey,workgroupkey,dt_created,roles,createdbyuserkey)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#AddWorkgroupMemberRequest.entrykey#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#AddWorkgroupMemberRequest.userkey#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#AddWorkgroupMemberRequest.workgroupkey#">,
<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#AddWorkgroupMemberRequest.roles#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#AddWorkgroupMemberRequest.createdbyuserkey#">);
</cfquery>