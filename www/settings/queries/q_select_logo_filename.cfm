<!--- // select the filename with the logo

	scope: session
	
	// --->
	
<cfquery name="q_select_logo_filename" datasource="inboxccusers">
SELECT LogoFilename FROM users
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>