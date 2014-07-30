<cfquery name="q_delete_element_link">
DELETE FROM
	element_links
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>