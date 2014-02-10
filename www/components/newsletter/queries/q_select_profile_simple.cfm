<cfquery name="q_select_profile_simple" datasource="#request.a_str_db_crm#">
SELECT
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
	sender_name,
	sender_address,
	default_header,
	default_footer,
	replyto,
	confirmation_url_unsubscribed,
	confirmation_url_subscribed,
	lang,
	test_email_addresses
FROM
	newsletter_profiles
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	
;
</cfquery>