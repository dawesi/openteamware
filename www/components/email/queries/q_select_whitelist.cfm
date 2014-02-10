
<cfquery name="q_select_whitelist" datasource="#request.a_str_db_mailusers#">
SELECT
	value AS emailaddress
FROM
	userpref
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
	AND
	preference = 'whitelist_from'
;
</cfquery>