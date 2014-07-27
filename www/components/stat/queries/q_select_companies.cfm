<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	companies.entrykey,
	companies.dt_created,
	companies.entrykey,
	companies.customertype,
	companies.disabled,
	companies.openinvoices,
	companies.signupsource,
	LOWER(companies.countryisocode) AS countryisocode,
	companies.zipcode,
	0 AS dt_created_int,
	companies.id,
	companies.createdbyuserkey,
	companies.generaltermsandconditions_accepted,
	companies.status,
	companies.httpreferer
FROM
	companies
RIGHT JOIN users ON (users.companykey = companies.entrykey)
WHERE
	(1 = 1)
	
	AND
	
	(companies.generaltermsandconditions_accepted = 1)
	
	<!--- check filter ... --->
	<cfif StructKeyExists(arguments.filter, 'resellerkeys') AND Len(arguments.filter.resellerkeys) GT 0>
	AND
		(
			(companies.resellerkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.resellerkeys#" list="yes">))
			OR
			(companies.distributorkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.resellerkeys#" list="yes">))
		)
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'paidonly')>
	AND
		(companies.status = 0)
		AND
		(companies.disabled = 0)
		AND
		(companies.openinvoices = 0)
		AND
		(companies.generaltermsandconditions_accepted = 1)
	</cfif>
	
	
	<cfif StructKeyExists(arguments.filter, 'countryisocode')>
	AND
		(LOWER(companies.countryisocode) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.filter.countryisocode)#">)
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'companykey')>
	AND
		(companies.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.companykey#">)
	</cfif>

;
</cfquery>

<cfif StructKeyExists(arguments.filter, 'paidonly')>
	<cfexit method="exittemplate">
</cfif>

<!--- add old companies? --->
<cfquery name="q_select_old_companies" datasource="#request.a_str_db_users#">
SELECT
	entrykey,dt_created,entrykey,customertype,disabled,openinvoices,signupsource,LOWER(countryisocode) AS countryisocode,zipcode,
	0 AS dt_created_int,id,createdbyuserkey,generaltermsandconditions_accepted,status,httpreferer
FROM
	oldcompanies
WHERE
	(1 = 1)
	<cfif StructKeyExists(arguments.filter, 'resellerkeys') AND Len(arguments.filter.resellerkeys) GT 0>
	AND
		(
			(resellerkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.resellerkeys#" list="yes">))
			OR
			(distributorkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.resellerkeys#" list="yes">))
		)
	</cfif>	
	
	<cfif StructKeyExists(arguments.filter, 'countryisocode')>
	AND
		(LOWER(countryisocode) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.filter.countryisocode)#">)
	</cfif>	
	
	<cfif StructKeyExists(arguments.filter, 'companykey')>
	AND
		(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.companykey#">)
	</cfif>	
;
</cfquery>
	
<cfloop query="q_select_old_companies">
	<cfset QueryAddRow(q_select_companies, 1)>
	
	<cfloop list="#q_select_companies.columnlist#" index="a_str_column" delimiters=",">
		<cfset QuerySetCell(q_select_companies, a_str_column, q_select_old_companies[a_str_column][q_select_old_companies.currentrow], q_select_companies.recordcount)>
		<cfset QuerySetCell(q_select_companies, 'disabled', 1, q_select_companies.recordcount)>
	</cfloop>
</cfloop>

<cfloop query="q_select_companies">
	<cfset QuerySetCell(q_select_companies, 'dt_created_int', DateFormat(q_select_companies.dt_created, 'yyyymmdd'), q_select_companies.currentrow)>
</cfloop>