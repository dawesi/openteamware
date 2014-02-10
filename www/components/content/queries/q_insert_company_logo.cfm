<!--- //

	Component:	cmp_content
	Function:	UpdateCompanyLogo
	

// --->

<cfquery name="q_insert_company_logo" datasource="#request.a_str_db_tools#">
INSERT INTO
	companylogos
	(
	entrykey,
	companykey,
	imagedata,
	filetype,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ToBase64(arguments.imagedata)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenttype#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	)
;
</cfquery>


