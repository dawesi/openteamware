<!--- //

	Component:	CRMSales
	Function:	BuildCriteriaTree
	Description:Create structure of attributes
				Display only mode
	
	Header:		

// --->

<cfset q_select_all_criteria = GetFullCriteriaQuery(companykey = arguments.companykey) />

<cfquery name="q_select_level_0" dbtype="query">
SELECT
	*
FROM
	q_select_all_criteria
WHERE
	parent_id = 0
;
</cfquery>

<cfsavecontent variable="sReturn">
	<cfmodule template="mod_build_criteria_tree_level_display_only.cfm"
	q_select_all_criteria = #q_select_all_criteria#
	parent_id = 0
	selected_ids = #arguments.selected_ids#>
</cfsavecontent>

<cfset sReturn = trim(sReturn) />

<cfif Len(sReturn) GT 0 AND Right(sReturn, 1) IS '/'>
	<cfset sReturn = Left(sReturn, Len(sReturn) - 1) />
</cfif>

