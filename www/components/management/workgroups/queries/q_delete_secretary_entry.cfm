

<cfquery name="q_delete_secretary_entry" datasource="#request.a_str_db_users#">
DELETE FROM
	secretarydefinitions
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>