<!--- //

	select all members of a workgroup
	
	// --->
	
<cfparam name="SelectWorkgroupMembersRequest.entrykey" type="string" default="">
	
<cfquery name="q_select_workgroup_members" datasource="#request.a_str_db_users#">
SELECT createdbyuserkey,userkey,workgroupkey,dt_created,roles,entrykey FROM workgroup_members
WHERE workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupMembersRequest.entrykey#">;
</cfquery>