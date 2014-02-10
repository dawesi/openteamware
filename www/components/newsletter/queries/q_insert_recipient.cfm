<!--- //

	Module:		insert a new recipient
	Action:		
	Description:perform a duplicate check
	

// --->

<cfquery name="q_select_already_exists" datasource="#request.a_str_db_crm#">
SELECT
	COUNT(id) AS count_id
FROM
	newsletter_recipients
WHERE
	(listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">)
	AND
	(issuekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issuekey#">)
	AND
	(recipient LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#a_str_email_adr#%">)
;
</cfquery>

<cfif q_select_already_exists.count_id IS 0>

	<cfquery name="q_insert_recipient" datasource="#request.a_str_db_crm#">
	INSERT INTO
		newsletter_recipients
		(
		status,
		dt_created,
		subject,
		body_html,
		body_text,
		recipient,
		entrykey,
		listkey,
		issuekey,
		contactkey,
		attachments,
		sender_value,
		replyto,
		test_sending
		)
	VALUES
		(
		-1,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body_html#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.body_text#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.recipient#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issuekey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attachments#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_value#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.replyto#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_int_test_sending)#">
		)
	;
	</cfquery>

</cfif>
