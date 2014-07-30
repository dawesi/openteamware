<cfquery name="q_select_secretarykey_of_event">
SELECT
	createdbysecretarykey
FROM
	calendar
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>