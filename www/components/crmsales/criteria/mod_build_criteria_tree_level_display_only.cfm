<!--- //

	Component:	CRMSales
	Function:	BuildCriteriaTree
	Description:Create structure of attributes
				Display only mode
	
	Header:		

// --->


<cfparam name="attributes.q_select_all_criteria" type="query">
<cfparam name="attributes.parent_id" type="numeric">
<cfparam name="attributes.selected_ids" type="string" default="">
<cfparam name="attributes.level" type="numeric" default="0">

<cfquery name="q_select_current_level" dbtype="query">
SELECT
	*
FROM
	attributes.q_select_all_criteria
WHERE
	parent_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#">
ORDER BY
	criterianame
;
</cfquery>

<cfoutput query="q_select_current_level">

	<!--- select sub items ... --->
	<cfquery name="q_select_sub_level_items" dbtype="query">
	SELECT
		*
	FROM
		attributes.q_select_all_criteria
	WHERE
		parent_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(q_select_current_level.id)#">
	ORDER BY
		criterianame		
	;
	</cfquery>

	<cfset a_bol_display = true />
	
	<cfif (ListFindNoCase(attributes.selected_ids, q_select_current_level.id) IS 0)>
		<cfset a_bol_display = false />
	</cfif>
	
	<cfif a_bol_display>
		
		#htmleditformat(q_select_current_level.criterianame)#
			
		<cfif q_select_sub_level_items.recordcount IS 0>
			<br />
		</cfif>
			
	</cfif>
	
	<cfif q_select_sub_level_items.recordcount GT 0>
		
		/
		
		<cfmodule template="mod_build_criteria_tree_level_display_only.cfm"
			q_select_all_criteria = #attributes.q_select_all_criteria#
			parent_id = #q_select_current_level.id#
			selected_ids = #attributes.selected_ids#
			level = #(attributes.level + 1)#>
		
	</cfif>
	
</cfoutput>


