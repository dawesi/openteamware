<cfquery name="q_select_admin_rights">
SELECT
	contacttype,user_level,permissions 
FROM
	companycontacts
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>