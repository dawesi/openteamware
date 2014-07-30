<cfquery name="q_update_empty_view_filter_items">
UPDATE
	crmfiltersearchsettings
SET
	viewkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	AND
	(viewkey = '')
;

</cfquery>