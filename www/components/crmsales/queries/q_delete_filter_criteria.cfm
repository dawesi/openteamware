<cfquery name="q_delete_filter_criteria">
DELETE FROM
	crmfiltersearchsettings  
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	AND
	(viewkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.viewkey#">)
	AND
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
;
</cfquery>