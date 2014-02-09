<cfquery name="q_update_tnt_subscription" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	subscribetippsntricks = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stSecurityContext.myuserkey#">
;
</cfquery>