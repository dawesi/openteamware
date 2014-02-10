<cfquery name="q_update_customer_reseller" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.newresellerkey#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>