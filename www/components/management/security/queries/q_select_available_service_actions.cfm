<!--- //

	Module:		Security
	Function:	GetAvailableActionsOfService
	Description: 
	

// --->

<cfquery name="q_select_available_service_actions" datasource="#request.a_str_db_users#" cachedwithin="#createtimespan(0,12,0,0)#">
SELECT
	actionname
FROM
	avaliableactions
WHERE
	servicekey = '#arguments.servicekey#'
;
</cfquery>

