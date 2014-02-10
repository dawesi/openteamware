<!--- //

	Component:	CRM
	Function:	CheckIfHistoryItemsExistForLinkedObject
	Description:See function
	
	Header:	

// --->

<cfquery name="q_select_history_linked_item_exists" datasource="#request.a_str_db_crm#">
SELECT
	COUNT(id) AS count_id
FROM
	history
WHERE
	hash_unique = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hashid#">
;
</cfquery>

