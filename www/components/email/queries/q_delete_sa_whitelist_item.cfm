
<cfquery name="q_delete_whitelist_item" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	userpref
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	AND
	preference = 'whitelist_from'
	AND
	value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>