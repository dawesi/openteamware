<!--- //

	Component:	cmp_content
	Function:	UpdateCompanyLogo
	

// --->

<cfquery name="q_delete_company_logo" datasource="#request.a_str_db_tools#">
DELETE FROM
	companylogos
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>


