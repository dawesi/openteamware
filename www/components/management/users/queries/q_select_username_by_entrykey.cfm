<cfparam name="SelectUsernameByuserkeyRequest.entrykey" type="string" default="">

<cfquery name="q_select_username_by_entrykey">
SELECT
	username
FROM
	users
WHERE
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectUsernameByuserkeyRequest.entrykey#">)
;
</cfquery>