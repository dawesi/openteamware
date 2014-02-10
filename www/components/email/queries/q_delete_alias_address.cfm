
<cfquery name="q_delete_alias_address" datasource="#request.a_str_db_users#">
DELETE FROM
	emailaliases
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	aliasaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>