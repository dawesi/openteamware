<!--- //

	select the contract end of a company
	
	// --->
	
<cfparam name="SelectCompanyContractEndRequest.entrykey" type="string" default="">

<cfquery name="q_select_customer_contract_end">
SELECT DATE_FORMAT(dt_contractend, '%Y-%m-%d %T') AS dt_contractend FROM companies
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCompanyContractEndRequest.entrykey#">;
</cfquery>