<!--- //

	Component:	cmp_content
	Function:	GetCompanyLogo
	

// --->

<cfquery name="q_select_company_logo" datasource="#request.a_str_db_tools#">
SELECT
	imagedata,
	filetype,
	dt_created,
	entrykey
FROM
	companylogos
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>


