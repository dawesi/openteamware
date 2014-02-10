<cfquery name="q_delete_element_link" datasource="#request.a_str_db_tools#">
DELETE FROM
	element_links
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>