<!--- //

	select the name of the company
	
	// --->
	
<cfparam name="SelectCompanyNameByKey.Entrykey" type="string" default="">

<cfquery name="q_select_company_by_key">
SELECT companyname FROM companies WHERE
entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCompanyNameByKey.Entrykey#">;
</cfquery>