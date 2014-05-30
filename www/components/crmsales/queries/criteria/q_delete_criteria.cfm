<!--- //

	Module:		CRMSales
	Description:Delete CRM criteria
	
// --->

<cfquery name="q_delete_criteria">
DELETE FROM
	crmcriteria
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
;
</cfquery>