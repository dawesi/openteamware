<cfquery name="q_select_filter_view_list">
SELECT
	viewname,description,dt_created,entrykey
FROM
	crmfilterviews
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>