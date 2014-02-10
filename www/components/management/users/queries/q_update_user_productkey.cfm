
<cfquery name="q_update_user_productkey" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>