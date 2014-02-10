
<cfquery name="q_select_productkey_of_user" datasource="#request.a_str_db_users#">
SELECT
	productkey
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>