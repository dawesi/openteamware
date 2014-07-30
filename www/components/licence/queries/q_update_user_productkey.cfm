
<cfquery name="q_update_user_productkey">
UPDATE
	users
SET
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>