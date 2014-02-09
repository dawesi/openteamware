<cfquery name="q_select_is_virtual_user" datasource="#request.a_str_db_users#">
SELECT
	userkey
FROM
	virtual_mobilesync_users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>