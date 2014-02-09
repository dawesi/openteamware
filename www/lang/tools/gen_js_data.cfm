<!--- //

	generate data for javascript
	
	just copy/paste this later
	
	// --->


<cfset a_cmp_translation = application.components.cmp_lang />

<!---
	yes
	no
	are you sure?
	please wait
	save
	confirmation
	--->
	
<cfset a_str_items = 'cm_wd_yes,cm_wd_no,cm_ph_are_you_sure,cm_ph_status_please_wait,cm_wd_save_button_caption,cm_wd_confirmation,cm_wd_close_btn_caption,cm_wd_information,cm_wd_selection,cm_ph_more_details,cm_wd_delete,cm_wd_edit'>

<cfsavecontent variable="a_str_js_lang">
var a_arr_lang_data = new Array(5);
<cfloop from="0" to="5" index="ii">

	<cfset a_str_list_values = ''>
	
	<cfloop list="#a_str_items#" index="a_str_item_name">
		<cfset a_str_list_values = ListAppend(a_str_list_values, '"' & jsstringformat(a_cmp_translation.GetLangValExt(langno = ii, entryid = a_str_item_name)) & '"')>
	</cfloop>
	
<cfoutput>a_arr_lang_data[#ii#] = new Array(#a_str_list_values#);
</cfoutput>

</cfloop>
</cfsavecontent>

<cfoutput>#a_str_js_lang#</cfoutput>

<textarea rows="10" cols="70"><cfoutput>#htmleditformat(a_str_js_lang)#</cfoutput></textarea>