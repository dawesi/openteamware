
<cfquery name="q_update_customer_contact">
UPDATE
	companycontacts
SET
	permissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permissions#">,
	contacttype = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	user_level = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.level#">
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>