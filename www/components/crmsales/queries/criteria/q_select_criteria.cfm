

<cfquery name="q_select_criteria" datasource="#request.a_str_db_crm#">
SELECT
	*
FROM
	crmcriteria 
WHERE
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">)
	
	<cfif Len(arguments.filter_ids) GT 0>
		AND
		(id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter_ids#" list="true">))
	</cfif>
	
ORDER BY
	criterianame
;
</cfquery>
