<cfquery name="q_select_customer_contacts" datasource="#request.a_str_db_users#">
SELECT
	LEFT(companycontacts.userkey, 36) AS userkey,
	companycontacts.user_level,
	companycontacts.contacttype,
	LEFT(companycontacts.permissions, 255) AS permissions,
	companycontacts.contacttype,
	LEFT(users.username, 100) AS username
FROM
	companycontacts
LEFT JOIN users ON (users.entrykey = companycontacts.userkey)
WHERE
	companycontacts.companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>