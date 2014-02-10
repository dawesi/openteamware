

<cfquery name="q_delete_quota_entry" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	quota
WHERE
	(id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">)
;
</cfquery>