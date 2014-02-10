
<cfquery name="q_insert_security_role" datasource="#request.a_str_db_users#">
INSERT INTO	
	securityroles
	(
	companykey,
	entrykey,
	rolename,
	description,
	dt_created,
	createdbyuserkey,
	allow_pda_login,
	allow_wap_login,
	allow_outlooksync,
	allow_ftp_access,
	allow_mailaccessdata_access,
	allow_www_ssl_only,
	protocol_depth
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rolename#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allow_pda_login#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allow_wap_login#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allow_outlooksync#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allow_ftp_access#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allow_maildataacceessdata_access#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allow_www_ssl_only#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.protocol_depth#">
	)
;
</cfquery>