<cfquery name="q_select_contacts_total_count">
SELECT
	COUNT(entrykey) AS count_id
FROM
	addressbook
WHERE
	id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#sIDList#" list="Yes">)
;
</cfquery>