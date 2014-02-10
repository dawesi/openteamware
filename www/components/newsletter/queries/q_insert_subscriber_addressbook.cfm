<cftry>

<cfquery name="q_insert_subscriber_addressbook" datasource="#request.a_str_db_crm#">
INSERT INTO
	newsletter_subscribers
	(
	entrykey,
	listkey,
	contactkey,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	)
;
</cfquery>

<cfcatch type="any">

</cfcatch>
</cftry>