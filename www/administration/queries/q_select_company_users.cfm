<!--- //



	select all users of a the selected companies ... 

	

	// --->

<cfparam name="SelectCompanyUsersRequest.companykey" type="string" default="">

<cfquery name="q_select_company_users">
SELECT
	firstname,surname,username,entrykey,companykey,allow_login,
	smallphotoavaliable,aposition,userid
FROM
	users
WHERE

	<!--- check if we've got a admin or a reseller ... --->
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCompanyUsersRequest.companykey#">
ORDER BY
	surname
;
</cfquery>