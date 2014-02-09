<!--- //

	load all external email accounts from database
	
	// --->
	
<cfquery name="q_select_external_emailaccounts" datasource="#request.a_str_db_mailusers#">
SELECT accountid,emailaddresstocheck,nextfetch,minterval,id FROM emailaccount
WHERE (userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">);
</cfquery>