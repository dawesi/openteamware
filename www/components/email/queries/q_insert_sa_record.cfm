

<cfquery name="q_insert_sa_record" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	spamassassin
	(
	id,
	enabled,
	action,
	spamtargetfolder
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_enabled#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.spamtargetfolder#">
	)
;
</cfquery>