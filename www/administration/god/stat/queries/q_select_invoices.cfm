<cfquery name="q_select_invoices" datasource="#request.a_str_db_users#">
SELECT
	invoicetotalsum,companykey,'' AS resellerkey,'' AS distributorkey,paid
FROM
	invoices
WHERE
	customerdisabled = 0
	AND
	invoicetotalsum > 0
;
</cfquery>

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	disabled = 0
	AND
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_invoices.companykey)#" list="yes">)
	
	<cfif IsDefined('attributes.resellerkey') AND Len(attributes.resellerkey) GT 0>
	AND
		(
			(resellerkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.resellerkey#" list="yes">)
			OR
			(distributorkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.resellerkey#" list="yes">)
		)
	</cfif>
;
</cfquery>

<cfquery name="q_select_invoices" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_companies.entrykey)#" list="yes">)
;
</cfquery>

<cfloop query="q_select_invoices">
	
	<!--- ... --->
	<cfquery name="q_select_company_data"  datasource="#request.a_str_db_users#">
	SELECT
		resellerkey,distributorkey
	FROM
		companies
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_invoices.companykey#">
	;
	</cfquery>
	
	<cfset QuerySetCell(q_select_invoices, 'resellerkey', q_select_company_data.resellerkey, q_select_invoices.currentrow)>
	<cfset QuerySetCell(q_select_invoices, 'distributorkey', q_select_company_data.distributorkey, q_select_invoices.currentrow)>

</cfloop>