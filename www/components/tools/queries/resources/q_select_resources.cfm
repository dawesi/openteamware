<cfquery name="q_select_resources" datasource="#request.a_str_db_tools#">
SELECT
	entrykey,
	createdbyuserkey,
	title,
	description,
	dt_created,
	companykey,
	workgroupkeys,
	exclusive
FROM
	resources
WHERE
	<cfif StructKeyExists(arguments, 'entrykeys') AND Len(arguments.entrykeys) GT 0>
		<!--- multiple keys --->
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys#" list="yes">)
	<cfelse>
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
		
		<cfif Len(arguments.workgroupkeys) GT 0>
		AND
		workgroupkeys IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkeys#" list="yes">)
		</cfif>
	</cfif>
ORDER BY
	title
;
</cfquery>