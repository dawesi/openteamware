<!--- //

	Component:	Customers	
	Function:	GetAllCompanyUsers
	Description:Return all users of a given company (basic data only)
	
	Header:		

// --->

<cfquery name="q_select_company_users" datasource="#request.a_str_db_users#">
SELECT
	firstname,surname,username,entrykey,title,
	aposition,department,telephone,mobilenr,
	smallphotoavaliable,login_count,userid,
	identificationcode
FROM
	users
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
ORDER BY
	surname
;
</cfquery>
