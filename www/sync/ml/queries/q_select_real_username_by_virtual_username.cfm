<cfquery name="q_select_real_username_by_virtual_username" datasource="#request.a_str_db_users#">
SELECT
	users.username
FROM
	virtual_mobilesync_users
LEFT JOIN
	users
		ON
			(virtual_mobilesync_users.userkey = users.entrykey)
WHERE
	(virtual_mobilesync_users.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">)
;
</cfquery>

