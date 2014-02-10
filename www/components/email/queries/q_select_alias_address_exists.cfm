
<cfquery name="q_select_alias_address_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(aliasaddress) AS count_account
FROM
	emailaliases
WHERE
	aliasaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>