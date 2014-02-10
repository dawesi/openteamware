<!--- //

	Module:		CRMSales
	Function:	SaveCriteriaForObject
	Description: 
	

// --->

<cfquery name="q_delete_current_criteria_of_object" datasource="#request.a_str_db_crm#">
DELETE FROM
	assigned_criteria
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
;
</cfquery>

