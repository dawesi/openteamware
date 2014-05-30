<!--- //

	Module:		CRM
	function:	SetCRMSalesBinding
	Description: 
	

// --->
<cfquery name="q_insert_crm_sales_binding">
INSERT INTO
	crmsalesmappings
	(
	companykey,
	additionaldata_tablekey,
	dt_created,
	databasekey,
	userkey_data
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.additionaldata_tablekey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.databasekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey_data#">
);
</cfquery>

