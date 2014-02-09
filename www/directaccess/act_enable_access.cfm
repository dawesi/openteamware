
<cfset a_str_clientkey = CreateUUID() />

<cfquery name="q_update_client_key_status" datasource="#request.a_str_db_users#">
UPDATE
	webservices_enabled_applications
SET
	status = 1,
	enabled = 1,
	clientkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_clientkey#">
WHERE
	applicationkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.applicationkey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<h4>GRANTED. Please reload the client app. / use the GetClientKey Button</h4>


<form name="formaccessgranted">
	<input type="hidden" name="success" value="1">
	<input type="hidden" name="clientkey" value="<cfoutput>#a_str_clientkey#</cfoutput>">
</form>