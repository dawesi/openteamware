<!--- //

	Component:	CRMSales
	Function:	BuildCriteriaTree
	Description:Create structure of attributes
	

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

<cfset request.a_str_criteria_elements_count_total = 0 />

<cfset request.a_str_tag_ul_start = '<ul class="ul_nopoints">' />
<cfset request.a_str_tag_ul_start_first = '<ul id="' & arguments.tree_id & '" class="ul_nopoints">' />
<cfset request.a_str_tag_ul_end = '</ul>' />	
<cfset request.a_str_tag_li_begin = '<li>' />	
<cfset request.a_str_tag_li_end = '</li>' />

<cfset request.a_str_tag_li_begin_first = '<li>' />

<!--- display selected items in box? --->
<cfif ListFindNoCase(arguments.options, 'display_selected') GT 0>
	<cfset request.a_str_tag_ul_start = '/' />
	<cfset request.a_str_tag_ul_end = '' />	
	<cfset request.a_str_tag_li_begin = '|' />	
	<cfset request.a_str_tag_li_begin_first = '' />
	<cfset request.a_str_tag_li_end = '' />	
</cfif>

<cfsavecontent variable="sReturn">

<cfoutput>#request.a_str_tag_ul_start_first#</cfoutput>

<cfmodule template="mod_build_criteria_tree_level.cfm"
	q_select_all_criteria = #q_select_all_criteria#
	parent_id = 0
	options = #arguments.options#
	url_tags_to_add = #arguments.url_tags_to_add#
	selected_ids = #arguments.selected_ids#
	form_input_name = #arguments.form_input_name#>
	
<cfoutput>#request.a_str_tag_ul_end#</cfoutput>

</cfsavecontent>

<cfif request.a_str_criteria_elements_count_total IS 0>
	<cfset sReturn = '' />
</cfif>

<!--- if in display only - mode ... --->
<cfif Len(sReturn) GT 0 AND ListFindNoCase(arguments.options, 'display_selected') GT 0>
	<!--- modify output ... --->
	<cfset a_str_new_return = '' /><!--- <ul style="margin:0px;list-style-type:none;">' /> --->
	
	<cfset sReturn = ReplaceNoCase(sReturn, '/ /', '/', 'ALL')>
	<cfset sReturn = ReplaceNoCase(sReturn, '/ |', '/', 'ALL')>
	<cfset sReturn = ReplaceNoCase(sReturn, '//', '/', 'ALL')>
	
	
	<cfloop list="#sReturn#" delimiters="#chr(10)#" index="a_str_line">
		<cfset a_str_line = trim(a_str_line)>
		
		<cfif a_str_line IS '<br>'>
			<cfset a_str_line = ''>
		</cfif>
		
		
					
		<!--- replace if / ist first or last char --->
		<cfif Len(a_str_line) GT 0 AND Left(a_Str_line, 1) IS '/'>
			<cfset a_str_line = Mid(a_str_line, 2, Len(a_str_line))>
		</cfif>
		
		<cfif Len(a_str_line) GT 0 AND Right(a_str_line, 1) IS '/'>
			<cfset a_str_line = Mid(a_str_line, 1, Len(a_str_line) - 1 )>
		</cfif>
		
		<cfset a_str_line = trim(a_str_line)>
		
		
			
		<cfif Len(a_str_line) GT 0>			
		
			<!--- make last item bold --->
			<cfif ListLen(a_str_line, '/') GT 0>
			
				<cfset a_str_last_item = ListGetAt(a_str_line, ListLen(a_str_line, '/'), '/')>
				<cfset a_str_new_last_item = ''>
				
				<!--- if serveral items in this leven, make brakets around the strings --->
				<cfif ListLen(a_str_last_item, '|') GT 1>
					<cfset a_str_last_item_start = '['>
					<cfset a_str_last_item_end = '] '>
				<cfelse>
					<cfset a_str_last_item_start = ''>
					<cfset a_str_last_item_end = ' '>				
				</cfif>
				
				<cfloop list="#a_str_last_item#" delimiters="|" index="a_str_last_item_item">
					<cfset a_str_last_item_item = a_str_last_item_start & trim(a_str_last_item_item) & a_str_last_item_end>
					
					<cfset a_str_new_last_item = a_str_new_last_item & a_str_last_item_item>
				</cfloop>
				
				<cfset a_str_line = ListDeleteAt(a_str_line, ListLen(a_str_line, '/'), '/') & '/ <b> ' & a_str_new_last_item & '</b>'>
				
				<!--- in special cases, a slash will be put at the beginning of an single item string ... remove --->
				<cfif Len(a_str_line) GT 0 AND Left(a_Str_line, 1) IS '/'>
					<cfset a_str_line = Mid(a_str_line, 2, Len(a_str_line))>
				</cfif>
				
			</cfif>
			
			
			<!--- build the new return string ... --->
			<cfset a_str_new_return = a_str_new_return & '<li>' & a_str_line & '</li>'>
			
		
		</cfif>
	</cfloop>
	
	<!--- remove the last <br> --->
	<cfif Len(a_str_new_return) GT 10 AND Right(a_str_new_return, 4) IS '<br>'>
		<cfset a_str_new_return = Mid(a_str_new_return, 1, Len(a_str_new_return) - 4)>
	</cfif>
	
	<cfset a_str_new_return = ReplaceNoCase(a_str_new_return, ' / ', ' <img src="/images/arrows/img_indent_small.png" align="absmiddle" border="0"/> ', 'ALL')>
	
	<!--- <cfset a_str_new_return = a_str_new_return & '</ul>'>	 --->
	<cfset sReturn = a_str_new_return>
</cfif>

