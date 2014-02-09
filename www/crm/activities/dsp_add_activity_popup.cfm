<!--- //

	new version of adding a popup ...
	
	// --->

<cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>	

<cfset ShowCoreData.action = 'InsertRecord'>
<cfset ShowCoreData.table_entrykey = a_struct_crmsales_bindings.ACTIVITIES_TABLEKEY>
<cfset ShowCoreData.viewmode = 'single'>
<cfset ShowCoreData.orderby = 'ASC'>
<cfset ShowCoreData.enable_search = 0>
<cfset ShowCoreData.enable_adddata = 0>
<cfset ShowCoreData.enable_showempty = 1>
<cfset ShowCoreData.startrow = 1>
<cfset ShowCoreData.filterfieldname = 'addressbookkey'>

<cfset ShowCoreData.filtervalue = url.entrykey>

<cfset ShowCoreData.DisplaySource = 'addressbook'>
<cfset ShowCoreData.SHOW_FORM = false>
<cfset ShowCoreData.form_name = 'formaddactivity'>
<cfset ShowCoreData.DisplayOperation = 'crm_add_activity'>
	
<cfinvoke
		component = "#variables.a_cmp_database#"   
		method = "GetTableFields"   
		returnVariable = "q_table_fields"   
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		table_entrykey="#ShowCoreData.table_entrykey#"
		 >
</cfinvoke>

<div class="mischeader bb" style="padding:8px;font-weight:bold;"><cfoutput>#GetLangVal('adrb_crm_ph_add_activity')#</cfoutput></div>

<cfset a_str_unique_categories = ''>

<cfloop query="q_table_fields">
	<cfloop list="#q_table_fields.categories#" delimiters="," index="a_str_category">
		<cfif ListFindNoCase(a_str_unique_categories, a_str_category) IS 0>
			<cfset a_str_unique_categories = ListAppend(a_str_unique_categories, a_str_category)>
		</cfif>
	</cfloop>
</cfloop>

<cfif (Len(a_str_unique_categories) GT 0)>

		<!--- we're adding activities ... --->
		
		<div style="padding:6px; ">
		
		<script type="text/javascript">
			var a_arr_field_categories = new Array(1);
			<cfloop list="#a_str_unique_categories#" index="a_str_category">
				a_arr_field_categories[<cfoutput>#(ListFindNoCase(a_str_unique_categories, a_str_category) - 1)#</cfoutput>] = '<cfoutput>#Hash(a_str_category)#</cfoutput>';
			</cfloop>			
		</script>
		
		<cfloop list="#a_str_unique_categories#" index="a_str_category">
			<fieldset class="default_fieldset" style="margin-bottom:10px; ">
				<legend class="addinfotext" style="font-weight:bold; "><cfoutput>#GetLangVal('cm_wd_category')#</cfoutput> <cfoutput>#a_str_category#</cfoutput></legend>
				<div>
					<form enctype="multipart/form-data"  target="id_iframe_<cfoutput>#hash(a_str_category)#</cfoutput>" action="act_add_activity_item.cfm" name="id_form_<cfoutput>#hash(a_str_category)#</cfoutput>" id="id_form_<cfoutput>#hash(a_str_category)#</cfoutput>" method="post" style="margin:0px; ">
					
					<input onClick="DisplayAddActivityItem(this.value, this.checked);" type="checkbox" name="frm_cb_add_item_<cfoutput>#hash(a_str_category)#</cfoutput>" value="<cfoutput>#htmleditformat(a_str_category)#</cfoutput>" class="noborder"> <cfoutput>#GetLangVal('crm_ph_add_entry_in_this_category')#</cfoutput>
										
					<div style="display:none; " id="id_div_form_<cfoutput>#htmleditformat(a_str_category)#</cfoutput>">
					
						<!--- display form elements ... --->
						<cfset ShowCoreData = StructNew()>
						<cfset ShowCoreData.action = 'InsertRecord'>
						<cfset ShowCoreData.table_entrykey = a_struct_crmsales_bindings.ACTIVITIES_TABLEKEY>
						<cfset ShowCoreData.viewmode = 'single'>
						<cfset ShowCoreData.orderby = 'ASC'>
						<cfset ShowCoreData.enable_search = 0>
						<cfset ShowCoreData.enable_adddata = 0>
						<cfset ShowCoreData.enable_showempty = 1>
						<cfset ShowCoreData.startrow = 1>
						<cfset ShowCoreData.filterfieldname = 'addressbookkey'>
						
						<cfset ShowCoreData.filtervalue = url.entrykey>
						
						<cfset ShowCoreData.DisplaySource = 'addressbook'>
						<cfset ShowCoreData.SHOW_FORM = false>
						<cfset ShowCoreData.form_name = 'id_form_#hash(a_str_category)#'>
						<cfset ShowCoreData.DisplayOperation = 'crm_add_activity'>
						<cfset ShowCoreData.DisplayFieldsCategory = a_str_category>
						
						<cfinclude template="../../database/inc_data_display_edit.cfm">
					
					</div>
					
					</form>
					
					<iframe style="display:none; " src="/content/dummy.html" width="1" name="id_iframe_<cfoutput>#hash(a_str_category)#</cfoutput>" id="id_iframe_<cfoutput>#htmleditformat(a_str_category)#</cfoutput>" height="1"></iframe>
					
				</div>
			</fieldset>
			
		</cfloop>
		

		
		</div>
			<div style="text-align:center;padding:5px; " class="mischeader bt bb">
				<input style="font-weight:bold; " id="id_btn_submit" name="id_btn_submit"  type="button" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" onClick="CheckAddForms();">
			</div>		


<cfelse>
	<!--- display default edit form without any modifications ... --->
	
	<cfset ShowCoreData.action = 'InsertRecord'>
	<cfset ShowCoreData.table_entrykey = a_struct_crmsales_bindings.ACTIVITIES_TABLEKEY>
	<cfset ShowCoreData.viewmode = 'single'>
	<cfset ShowCoreData.orderby = 'ASC'>
	<cfset ShowCoreData.enable_search = 0>
	<cfset ShowCoreData.enable_adddata = 0>
	<cfset ShowCoreData.enable_showempty = 1>
	<cfset ShowCoreData.startrow = 1>
	<cfset ShowCoreData.filterfieldname = 'addressbookkey'>
	
	<cfset ShowCoreData.filtervalue = url.entrykey>
	
	<cfset ShowCoreData.DisplaySource = 'addressbook'>
	<cfset ShowCoreData.SHOW_FORM = false>
	<cfset ShowCoreData.form_name = 'formaddactivity'>
	<cfset ShowCoreData.DisplayOperation = 'crm_add_activity'>
	
	
	<form class="form_edit_data" action="act_save_add_activity.cfm" method="post" enctype="multipart/form-data" name="formaddactivity" style="margin:0px;">
	<!---<input type="hidden" name="frmentrykey" value="<cfoutput>#url.entrykey#</cfoutput>">--->
	<cfinclude template="../../database/inc_data_display_edit.cfm">
	<div style="text-align:center;padding:8px;" class="mischeader bt bb">
	<input type="submit" style="font-weight:bold;" class="btn" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" id="id_btn_submit" name="id_btn_submit" >
	</div>
	</form>

	
	
</cfif>

<script type="text/javascript">
	function CheckAddForms()
		{
		var obj1, catname, obj2, obj3;
		
		obj3 = findObj('id_btn_submit');
		obj3.style.display = 'none';
		
		for (var i = 0; i < a_arr_field_categories.length; ++i)
			{
			catname = a_arr_field_categories[i];
			// alert(a_arr_field_categories[i]);
			obj1 = findObj('frm_cb_add_item_' + catname);
			obj2 = findObj('id_form_' + catname);
			
			if (obj1.checked == true)
				{
				
				obj2.submit();
				
				// alert('submitted');
				}
			
			obj2.style.display = 'none';
			}
			
		setTimeout("CloseWindow();", 3000);
		}
		
	function CloseWindow()
		{
		window.close();
		}
		
	function DisplayAddActivityItem(category, c)
		{
		var obj1;
		
		obj1 = findObj('id_div_form_' + category);
		
		if (c == true)
			{
			obj1.style.display = '';
			}
				else
					{
					obj1.style.display = 'none';
					}
		}
</script>