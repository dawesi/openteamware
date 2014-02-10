<!--- //

	load rolename
	
	// --->
	
<cfparam name="GetRoleNameByEntrykeyrequest.entrykey" type="string" default="">

<cfquery name="q_select_rolename_by_entrykey" datasource="#request.a_str_db_users#">
SELECT rolename FROM roles
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetRoleNameByEntrykeyrequest.entrykey#">;
</cfquery>