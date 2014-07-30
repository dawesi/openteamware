<cfquery name="q_insert_shorturl">
INSERT INTO
	shorturls
	(
	userkey,
	source,
	entrykey,
	href,
	dt_created,
	validuntil
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	'',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.href#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_validuntil)#">
	)
;
</cfquery>