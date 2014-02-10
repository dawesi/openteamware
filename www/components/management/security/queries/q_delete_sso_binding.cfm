<!--- //

	Component:	Security
	Function:	DeleteSwitchUserRelation
	Description:Delete a SSO binding
	

// --->

<cfquery name="q_delete_sso_binding" datasource="#request.a_str_db_users#">
DELETE FROM
	switchuserrelations
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	otheruserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.otheruserkey#">
;
</cfquery>


