<!--- //

	Component:	CRM
	Function:	GetHistoryItemsOfContact
	Description:Return the history items according to the given filters
	
	Header:		

// --->

<cfquery name="q_select_history_items">
SELECT
	entrykey,
	createdbyuserkey,
	objectkey,
	servicekey,
	dt_created,
	dt_lastmodified,
	subject,
	comment,
	item_type,
	projectkey,
	dt_created_internally,
	categories,
	linked_servicekey,
	linked_objectkey
FROM
	history
WHERE
	(servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">)
	AND
	(objectkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkeys#" list="true">))
	
	<cfif StructKeyExists(arguments.filter, 'projectkey')>
		AND (projectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.projectkey#">)
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'entrykeys')>
		AND (entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykeys#" list="true">))
	</cfif>
	
	<cfif StructKeyExists(arguments.filter, 'item_type')>
		AND (item_type IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.item_type#" list="true">))
	</cfif>	
	
	<cfif StructKeyExists(arguments.filter, 'not_item_type')>
		AND NOT (item_type IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.not_item_type#" list="true">))
	</cfif>	
ORDER BY
	dt_created DESC,dt_created_internally DESC
;
</cfquery>

