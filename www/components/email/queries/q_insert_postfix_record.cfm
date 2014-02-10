<!--- //

	Component:	cmp_accounts
	Description:Insert postfix record
	

// --->

<cfset a_int_mail_gid = ReadPropertiesFileProperty('Mail', 'gid', '8')>
<cfset a_int_mail_uid = ReadPropertiesFileProperty('Mail', 'uid', '104')>

<cfquery name="q_insert_postfix_record" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	users
	(
	id,
	address,
	clear,
	uid,
	gid,
	home,
	domain,
	maildir,
	entrykey,
	userkey,
	dt_created  	
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.emailaddress)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.emailaddress)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_mail_uid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_mail_gid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_mountpoint#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(a_str_domain)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(a_str_maildir)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(now())#">
	)
;
</cfquery>

