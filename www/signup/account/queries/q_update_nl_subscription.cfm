<cfquery name="q_update_nl_subscription" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	subscrnewsletter = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stSecurityContext.myuserkey#">
;
</cfquery>