<!--- //

	delete all alerts of a user
	
	// --->
	
<cfparam name="DeleteAllExistingAlerts.accountid" type="numeric" default="0">

<cfquery name="q_delete" datasource="#request.a_str_db_users#">
DELETE FROM newmailalerts WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
AND accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#DeleteAllExistingAlerts.accountid#">;
</cfquery>