<cfquery name="q_delete_view_filter">
DELETE FROM
	crmfilterviews
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.viewkey#">
;
</cfquery>