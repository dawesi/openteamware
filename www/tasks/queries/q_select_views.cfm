
<cfquery name="q_select_views">
SELECT
	entrykey,href,dt_created,viewname
FROM
	savedtaskviews 
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
ORDER BY
	viewname
;
</cfquery>
