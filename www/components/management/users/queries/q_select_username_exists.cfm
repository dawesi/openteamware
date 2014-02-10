

<cfparam name="SelectUsernameExists.Username" type="string" default="">

<cfquery name="q_select_username_exists" datasource="#request.a_str_db_users#">
SELECT COUNT(userid) AS count_userid FROM users
WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectUsernameExists.Username#">;
</cfquery>