<!--- //

	select companies which are customers
	
	// --->
	
<cfif cgi.REMOTE_ADDR NEQ '62.99.232.51'>
	<cfabort>
</cfif>
	
<cfquery name="q_select_companies" datasource="#request.a_Str_db_users#">
SELECT
	companyname,entrykey,
	0 AS groupware_count,
	0 AS groupware_licence,
	0 AS pro_count,
	0 AS pro_licence
FROM
	companies
WHERE
	status = 0
;
</cfquery>	
	
<cfquery name="q_select_licence" datasource="#request.a_str_db_users#">
SELECT
	companykey,productkey,availableseats,totalseats,inuse,'' AS companyname
FROM
	licencing
WHERE
	(companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_companies.entrykey)#" list="yes">))
	AND
	(
		(availableseats > totalseats)
		OR
		((availableseats + inuse) > totalseats)
	)
;
</cfquery>

<cfloop query="q_select_licence">

	<cfquery name="q_Select_company_name" dbtype="query">
	SELECT
		companyname
	FROM
		q_select_companies
	WHERE
		entrykey = '#q_select_licence.companykey#'
	;
	</cfquery>
	
	<cfset tmp = QuerySetcell(q_select_licence, 'companyname', q_Select_company_name.companyname, q_select_licence.currentrow)>
</cfloop>

<cfdump var="#q_select_licence#">

<cfloop query="q_select_companies">
	<!--- ... --->
	<cfquery name="q_select_groupware_count" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(userid) AS count_userid
	FROM
		users
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
		AND
		productkey = 'AE79D26D-D86D-E073-B9648D735D84F319'
	;
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_select_companies, 'groupware_count', val(q_select_groupware_count.count_userid), q_select_companies.currentrow)>
	
	<cfquery name="q_select_professional_count" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(userid) AS count_userid
	FROM
		users
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
		AND
		productkey = 'AD4262D0-98D5-D611-4763153818C89190'
	;
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_select_companies, 'pro_count', val(q_select_professional_count.count_userid), q_select_companies.currentrow)>
		
		
	<!--- select from licence table ... --->
	<cfquery name="q_select_licence_status_groupware" datasource="#request.a_str_db_users#">
	SELECT
		availableseats,inuse,totalseats
	FROM
		licencing
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
		AND
		productkey = 'AE79D26D-D86D-E073-B9648D735D84F319'
	;		
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_select_companies, 'groupware_licence', val(q_select_licence_status_groupware.totalseats), q_select_companies.currentrow)>

	<!--- select from licence table ... --->
	<cfquery name="q_select_licence_status_pro" datasource="#request.a_str_db_users#">
	SELECT
		availableseats,inuse,totalseats
	FROM
		licencing
	WHERE
		companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companies.entrykey#">
		AND
		productkey = 'AD4262D0-98D5-D611-4763153818C89190'
	;		
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_select_companies, 'pro_licence', val(q_select_licence_status_pro.totalseats), q_select_companies.currentrow)>


</cfloop>

<cfquery name="q_select_companies" dbtype="query">
SELECT
	*
FROM
	q_select_companies
WHERE
	(groupware_count > groupware_licence)
	OR
	(pro_count > pro_licence)
;
</cfquery>

<cfdump var="#q_select_companies#">