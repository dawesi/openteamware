<!--- //

	Module:		CRM
	Function:	GetCRMSalesBinding
	Description: 
	

// --->

<cfquery name="q_select_crm_sales_binding">
SELECT
	additionaldata_tablekey,
	databasekey,
	userkey_data
FROM
	crmsalesmappings
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

