<cftry>

<cfquery name="q_insert_ignore_addressbook_item">
INSERT INTO
	newsletter_ignored_items
	(
	listkey,
	contactkey,
	contacttype,
	dt_created,
	emailadr
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_recipient.contactkey#">,
	<!--- 0 = crm contact --->
	0,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#ExtractEmailAdr(q_select_recipient.recipient)#">
	)
;
</cfquery>

<cfcatch type="any">
</cfcatch>
</cftry>