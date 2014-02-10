<cfquery name="q_insert_newsletter_profile" datasource="#request.a_str_db_crm#">
INSERT INTO
	newsletter_profiles
	(
	entrykey,
	userkey,
	dt_created,
	profile_name,
	description,
	manage_subscriptions,
	default_format,
	open_tracking,
	listtype,
	crm_filter_key,
	sender_address,
	sender_name,
	replyto,
	confirmation_url_subscribed,
	confirmation_url_unsubscribed,
	default_header,
	default_footer,
	lang,
	test_email_addresses
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.manage_subscriptions#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_format#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.open_tracking#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.crm_filter_keys#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_address#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_name#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.replyto#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.confirmation_url_subscribed#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.confirmation_url_unsubscribed#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_header#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_footer#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.langno#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.test_addresses#">
	)
;
</cfquery>