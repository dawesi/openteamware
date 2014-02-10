

<cfquery name="q_select_spamguard_settings" datasource="#request.a_str_db_mailusers#">
SELECT
	enabled,action,spamtargetfolder
FROM
	spamassassin
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
;
</cfquery>