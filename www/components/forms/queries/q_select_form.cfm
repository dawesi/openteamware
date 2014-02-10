<!--- //

	Component:	Forms
	Description:Select form properties and cache for 20 minutes
	

// --->

<cfquery name="q_select_form" datasource="#request.a_str_db_tools#" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
SELECT
	*
FROM
	forms
WHERE
	entrykey = '#arguments.entrykey#'
;
</cfquery>

