<cfquery name="q_select_virtual_usernames_of_user" datasource="#request.a_str_db_users#">
SELECT
	username
FROM
	virtual_mobilesync_users
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>