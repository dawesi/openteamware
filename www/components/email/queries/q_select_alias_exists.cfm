
<cfquery name="q_select_alias_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	emailaliases
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	aliasaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">
;
</cfquery>