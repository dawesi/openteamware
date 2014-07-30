<!--- //

	select from/to links for a certain contact
	
	// --->

<cfquery name="q_select_element_links">
SELECT
	dt_created,dest_name,source_name,entrykey,connection_type,dest_entrykey,source_entrykey,comment,
	source_servicekey,dest_servicekey
FROM
	element_links
WHERE
	(
		(source_entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
		OR
		(dest_entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">)
	)
<cfif StructKeyExists(arguments.filter, 'DEST_SERVICEKEY')>
	AND
		(DEST_SERVICEKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.DEST_SERVICEKEY#">)
</cfif>

<cfif StructKeyExists(arguments.filter, 'SOURCE_SERVICEKEY')>
	AND
		(SOURCE_SERVICEKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.SOURCE_SERVICEKEY#">)
</cfif>

ORDER BY
	'#arguments.entrykey#' DESC
;
</cfquery>