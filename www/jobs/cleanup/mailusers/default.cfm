

<cfquery name="q_select_users" datasource="#request.a_str_db_mailusers#">
SELECT
	id
FROM
	users
;
</cfquery>




<cfquery name="q_select_non_existing_users" datasource="#request.a_str_db_mailusers#">
SELECT
	id
FROM
	quota
WHERE
	id NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_users.id)#" list="yes">)
;
</cfquery>

<cfquery name="q_select_non_existing_users" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	quota
WHERE
	id IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_non_existing_users.id)#" list="yes">)
;
</cfquery>