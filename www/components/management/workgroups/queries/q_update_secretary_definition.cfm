<cfquery name="q_update_secretary_definition">
UPDATE
	secretarydefinitions
SET
	permission = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permission#">
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
;
</cfquery>