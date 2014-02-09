<!--- //

	check now
	
	// --->

<!--- account id --->
<cfparam name="UpdateCheckNowRequest.id" type="numeric" default="0">

<cfquery name="q_update_check_now" datasource="#request.a_str_db_mailusers#">
UPDATE emailaccount
SET nextfetch = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
WHERE accountid = <cfqueryparam cfsqltype="cf_sql_integer" value="#UpdateCheckNowRequest.id#">
AND userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>