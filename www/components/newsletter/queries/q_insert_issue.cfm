<!--- //

	Module:		
	Action:		Save NL issue in database
	Description:	
	

// --->

<cfquery name="q_insert_issue" datasource="#request.a_str_db_crm#">
INSERT INTO
	newsletter_issues 
	(
	entrykey,
	listkey,
	issue_name,
	description,
	body_html,
	body_text,
	dt_send,
	approved,
	subject,
	autogenerate_text_version,
	attachmentkeys,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issue_name#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.body_html#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.body_text#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.dt_send#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.approved#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.auto_generate_text_version#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attachmentkeys#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	)
;
</cfquery>
