<cfquery name="q_select_newsletter_profiles" datasource="#request.a_str_db_crm#">
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
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	
	<cfif Len(arguments.entrykeys) GT 0>
		AND
		(entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys#" list="yes">))
	</cfif>
	
	AND
	(hidden_profile = 0)
	
;
</cfquery>