<!--- //

	Module:		Project
	Function:	GetAssignedItemsMetaInformation
	Description: 
	

// --->

<cfquery name="q_select_assigned_items_meta_information">
SELECT
	projectkey,
	servicekey,
	objectkey,
	objecttype,
	dt_created,
	createdbyuserkey,
	comment,
	categories
FROM
	connecteditems
WHERE
	projectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectkey#">
;
</cfquery>


