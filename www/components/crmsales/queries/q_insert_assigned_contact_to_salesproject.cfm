<cfquery name="q_insert_assigned_contact_to_salesproject">
INSERT INTO
	salesprojects_assigned_contacts
	(
	contactkey,
	dt_created,
	comment,
	role_type,
	contact_type,
	internal_user,
	salesprojectentrykey,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contact_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.role#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.internal_user#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salesprojectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	)
;
</cfquery>