<!--- //

	Module:		Session
	Function:	UpdateLastLoginAndLoginCount
	Description: 
	

// --->

<cfif StructKeyExists(client, 'urltoken')>
	<cfset a_str_url_token = client.URLToken />
<cfelse>
	<cfset a_str_url_token = '' />
</cfif>

<cfquery name="q_insert_log" datasource="#request.a_str_db_log#">
INSERT INTO
	loginstat
	(
	userkey,
	ip,
	dt_created,
	loginsection,
	urltoken
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.remote_ip#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_url_token#">
	)
;	
</cfquery>


