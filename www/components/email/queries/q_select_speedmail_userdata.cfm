<cfquery name="q_select_speedmail_userdata" datasource="#request.a_str_db_mailusers#">
SELECT
	maildir
FROM
	users
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>