<!--- //

	Module:		CRMSales
	Function:	ReturnObjectEntrykeysForCriteriaID
	Description: 
	

// --->

<cfquery name="q_select_objectkeys_by_criteria_ids">
SELECT
	objectkey
FROM
	assigned_criteria
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	criteria_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.criteria_ids#" list="true">)
;
</cfquery>

