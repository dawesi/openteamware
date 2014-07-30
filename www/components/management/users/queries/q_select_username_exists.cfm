

<cfparam name="SelectUsernameExists.Username" type="string" default="">

<cfquery name="q_select_username_exists">
SELECT COUNT(userid) AS count_userid FROM users
WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectUsernameExists.Username#">;
</cfquery>