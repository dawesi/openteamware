
<cfquery name="q_select_whitelist_item" datasource="#request.a_str_db_mailusers#">
SELECT value
FROM
	userpref
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	AND
	preference = 'whitelist_from'
	AND
	value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>

<cfif q_select_whitelist_item.recordcount IS 0>


<cfquery name="q_insert_whitelist_item" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	userpref
	(
	username,
	preference,
	value
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">,
	'whitelist_from',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
	)
;
</cfquery>

</cfif>