

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="attributes.q_select_all_criteria" type="query">
<cfparam name="attributes.parent_id" type="numeric">
<cfparam name="attributes.options" type="string" default="">
<cfparam name="attributes.url_tags_to_add" type="string" default="">
<cfparam name="attributes.selected_ids" type="string" default="">
<cfparam name="attributes.level" type="numeric" default="0">
<cfparam name="attributes.form_input_name" type="string" default="frm_criteria_id">

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
	
	<cfif (ListFindNoCase(attributes.options, 'display_selected') GT 0) AND (ListFindNoCase(attributes.selected_ids, q_select_current_level.id) IS 0)>
		<cfset a_bol_display = false />
	</cfif>
	
	<cfif a_bol_display>
	
		<cfset request.a_str_criteria_elements_count_total = request.a_str_criteria_elements_count_total + 1>
		
		<cfif attributes.level IS 0>
			#request.a_str_tag_li_begin_first#
		<cfelse>
			#request.a_str_tag_li_begin#
		</cfif>
		
			<!--- ? checkbox --->
			<cfif ListFindNoCase(attributes.options, 'allowedit') GT 0>
				<input id="frm_input_criteria_#q_select_current_level.id#" <cfif ListFindNoCase(attributes.selected_ids, q_select_current_level.id) GT 0>checked</cfif>  type="checkbox" name="#attributes.form_input_name#" value="#q_select_current_level.id#" class="noborder" style="width:auto" align="absmiddle" />
				<input type="hidden" name="frm_attr_name_#q_select_current_level.id#" id="frm_attr_name_#q_select_current_level.id#" value="#htmleditformat(q_select_current_level.criterianame)#" />
			</cfif>
			
			<!--- <label for="frm_input_criteria_#q_select_current_level.id#"> --->#htmleditformat(q_select_current_level.criterianame)#<!--- </label> --->
			
			<cfif ListFindNoCase(attributes.options, 'allow_add_admin_tool') GT 0>
				&nbsp;&nbsp;
				<a href="default.cfm?action=criteria&subaction=AddCriteria#attributes.url_tags_to_add#&parentid=#q_select_current_level.id#"><img src="/images/si/add.png" class="si_img" /></a>
				&nbsp;
				<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="default.cfm?action=criteria&subaction=DeleteCriteria#attributes.url_tags_to_add#&id=#q_select_current_level.id#"><img src="/images/si/delete.png" class="si_img" /></a>
			</cfif>
		
		<cfif q_select_sub_level_items.recordcount IS 0>
		#request.a_str_tag_li_end#
		</cfif>
			
	</cfif>
	
	
	<cfif q_select_sub_level_items.recordcount GT 0>
		
		#request.a_str_tag_ul_start#
		
		<cfmodule template="mod_build_criteria_tree_level.cfm"
			q_select_all_criteria = #attributes.q_select_all_criteria#
			parent_id = #q_select_current_level.id#
			options = #attributes.options#
			url_tags_to_add = #attributes.url_tags_to_add#
			selected_ids = #attributes.selected_ids#
			level = #(attributes.level + 1)#
			form_input_name = #attributes.form_input_name#>
			
		#request.a_str_tag_ul_end#
		
		<cfif q_select_sub_level_items.recordcount GT 0>
		#request.a_str_tag_li_end#
		</cfif>
		
	</cfif>
	
	<cfif a_bol_display AND attributes.level IS 0 AND ListFindNoCase(attributes.options, 'display_selected') GT 0 AND q_select_current_level.currentrow NEQ q_select_current_level.recordcount>
		#chr(10)##chr(13)#
	</cfif>	
	
</cfoutput>