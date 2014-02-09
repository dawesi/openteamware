<cfquery name="q_update_logo" datasource="#request.a_str_db_users#">
UPDATE users SET
LogoFilename = ''
WHERE (userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">);
</cfquery>