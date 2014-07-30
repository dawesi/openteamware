<cfquery name="q_select_user_info">
SELECT
	firstname,surname,organization
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>