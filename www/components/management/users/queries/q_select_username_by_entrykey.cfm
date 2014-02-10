<cfparam name="SelectUsernameByuserkeyRequest.entrykey" type="string" default="">

<cfquery name="q_select_username_by_entrykey" datasource="#request.a_str_db_users#">
SELECT
	username
FROM
	users
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectUsernameByuserkeyRequest.entrykey#">)
;
</cfquery>