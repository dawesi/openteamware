<cfquery name="q_select_contact_quick_display_data">
SELECT
	firstname,surname,title,company,department
FROM
	addressbook
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>