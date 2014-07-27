<!--- //

	Module:		Address Book
	Description:Build table with filter/search information ...
	

	
	
	TODO: Improve the look ...
	
// --->




<!--- 
<cfsavecontent variable="a_str_js">
	a_arr_fields_contacts = new Array();
	a_arr_fields_database = new Array();
	a_arr_fields_meta = new Array();
</cfsavecontent>

<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />
 --->


<cfset a_int_criteria_count = application.components.cmp_crmsales.GetCriteriaCount(companykey = request.stSecurityContext.mycompanykey) />

<table class="table table_details table_edit_form" style="width:auto;">
<tr>
	<td colspan="5">
		<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_ph_filter_default_fields'))#</cfoutput>
	</td>
</tr>
<cfif a_int_criteria_count GT 0>
 
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
		FieldName="criteria"
		DisplayName="#GetLangVal('crm_wd_criteria')#"
		FieldType="criteria"
		FieldSource="meta">
</cfif>
	
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="company"
		DisplayName="#GetLangVal('adrb_wd_company')#"
		FieldType="string"
		FieldSource="contact">	
	
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="surname"
		DisplayName="#GetLangVal('adrb_wd_surname')#"
		FieldType="string"
		FieldSource="contact">
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="firstname"
		DisplayName="#GetLangVal('adrb_wd_firstname')#"
		FieldType="string"
		FieldSource="contact">
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="aposition"
		DisplayName="#GetLangVal('adrb_wd_position')#"
		FieldType="string"
		FieldSource="contact">		
		
  <cfset a_arr_options = ArrayNew(1)>
  <cfset a_arr_options[1] = '0,male'>
  <cfset a_arr_options[2] = '1,female'>
	
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="sex"
		DisplayName="#GetLangVal('adrb_wd_sex')#"
		FieldType="select"
		FieldSource="contact"
		CompareOptions=#a_arr_options#>		

  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="dt_lastcontact"
		DisplayName="#GetLangVal('adrb_ph_last_contact')#"
		FieldType="date"
		FieldSource="contact">
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="email_prim"
		DisplayName="#GetLangVal('adrb_wd_email')#"
		FieldType="string"
		FieldSource="contact">				
		
  <!---<cfmodule template="crm/mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="categories"
		DisplayName="Kategorien"
		FieldType="string"
		FieldSource="contact">		--->		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_city"
		DisplayName="#GetLangVal('adrb_wd_city')#"
		FieldType="string"
		FieldSource="contact">		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_country"
		DisplayName="#GetLangVal('adrb_wd_country')#"
		FieldType="string"
		FieldSource="contact">		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_zipcode"
		DisplayName="#GetLangVal('adrb_wd_zipcode')#"
		FieldType="string"
		FieldSource="contact">							
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="b_telephone"
		DisplayName="#GetLangVal('adrb_wd_telephone')#"
		FieldType="string"
		FieldSource="contact">	
		
<!--- allow to select nace codes ... --->
<cfset q_select_nance_codes = application.components.cmp_Addressbook.ReturnAllNaceCodes(request.stUserSettings.language) />
		
 <cfset a_arr_options = ArrayNew(1)>
<cfloop query="q_select_nance_codes">
  <cfset a_arr_options[q_select_nance_codes.currentrow] = q_select_nance_codes.code & ',' & htmleditformat(q_select_nance_codes.industry_name) />
</cfloop>
	
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="nace_code"
		DisplayName="#GetLangVal('adrb_wd_industry')#"
		FieldType="select"
		FieldSource="contact"
		CompareOptions=#a_arr_options#>		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="notice"
		DisplayName="#GetLangVal('adrb_wd_notices')#"
		FieldType="string"
		FieldSource="contact">		
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="ownfield1"
		DisplayName="Own Field ##1"
		FieldType="string"
		FieldSource="contact">			
		
  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
  		FieldName="ownfield2"
		DisplayName="Own Field ##2"
		FieldType="string"
		FieldSource="contact">							
		
<!--- now, send own datafields through the filter ... ---><!--- 
<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
		
	<cfset variables.a_cmp_database = CreateObject('component', request.a_str_component_database)>
		
		<cfinvoke
			component = "#variables.a_cmp_database#"   
			method = "GetTableFields"   
			returnVariable = "q_table_fields"   
			securitycontext="#request.stSecurityContext#"
			usersettings="#request.stUserSettings#"
			table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#">
		</cfinvoke>
		
	<cfif q_table_fields.recordcount GT 0>
	<tr>
		<td colspan="5">
			<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_ph_filter_own_fields'))#</cfoutput>
		</td>
	</tr>

		
		
		<cfoutput query="q_table_fields">
		
			<cfswitch expression="#q_table_fields.fieldtype#">
				<cfcase value="0">
					<!--- string --->
					  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
						FieldName="#q_table_fields.fieldname#"
						DisplayName="#q_table_fields.showname#"
						FieldType="string"
						FieldSource="database">
				</cfcase>
				<cfcase value="1">
					<!--- number --->
					  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
						FieldName="#q_table_fields.fieldname#"
						DisplayName="#q_table_fields.showname#"
						FieldType="number"
						FieldSource="database">
						
				</cfcase>
				<cfcase value="5">
					<!--- date --->
					  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
						FieldName="#q_table_fields.fieldname#"
						DisplayName="#q_table_fields.showname#"
						FieldType="date"
						FieldSource="database">
				</cfcase>
				<cfcase value="10">
					<!--- true/false --->
					  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
						FieldName="#q_table_fields.fieldname#"
						DisplayName="#q_table_fields.showname#"
						FieldType="boolean"
						FieldSource="database">
				</cfcase>
				<cfcase value="11">
					<!--- select ... --->
					  <cfset a_arr_options = ArrayNew(1)>
					  
					  <cfloop list="#q_table_fields.options#" delimiters="#chr(13)#" index="a_str_item">
  					  	<cfset a_arr_options[ArrayLen(a_arr_options)+1] = '#a_str_item#,#a_str_item#'>
					  </cfloop>
					  
					  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
						FieldName="#q_table_fields.fieldname#"
						DisplayName="#q_table_fields.showname#"
						FieldType="select"
						FieldSource="database"
						CompareOptions=#a_arr_options#>		
				</cfcase>
				<cfcase value="14">
					<!--- select ... --->
					  <cfset a_arr_options = ArrayNew(1)>
					  
					  <cfloop list="#q_table_fields.options#" delimiters="#chr(13)#" index="a_str_item">
  					  	<cfset a_arr_options[ArrayLen(a_arr_options)+1] = '#a_str_item#,#a_str_item#'>
					  </cfloop>
					  
					  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
						FieldName="#q_table_fields.fieldname#"
						DisplayName="#q_table_fields.showname#"
						FieldType="multiselect"
						FieldSource="database"
						CompareOptions=#a_arr_options#>		
				</cfcase>				
			</cfswitch>
			
		</cfoutput>
	</cfif>		
</cfif> --->
	
	<!--- // meta data // --->
	<tr>
		<td colspan="5">
			<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_ph_filter_meta_data'))#</cfoutput>
		</td>
	</tr>
	  <cfset a_arr_options = ArrayNew(1)>
	  
	  <!--- loop users ... --->
		<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>
		
		<cfquery name="q_select_users" dbtype="query">
		SELECT
			*
		FROM
			q_select_users
		ORDER BY
			surname,firstname
		;
		</cfquery>			
		
		<cfloop query="q_select_users">
	 	 <cfset a_arr_options[q_select_users.currentrow] = '#JsStringFormat(application.components.cmp_user.GetFullNameByentrykey(entrykey = q_select_users.entrykey))#' />
	  	</cfloop>
		
	  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
			FieldName="custodian"
			DisplayName="#GetLangVal('crm_wd_custodian')#"
			FieldType="select"
			FieldSource="meta"
			CompareOptions=#a_arr_options#>	
			
	 
	 <!--- workgroups ... --->
	<cfset a_arr_options = ArrayNew(1)> 
		<cfoutput query="request.stSecurityContext.q_select_workgroup_permissions">
			<cfset a_arr_options[request.stSecurityContext.q_select_workgroup_permissions.currentrow] = request.stSecurityContext.q_select_workgroup_permissions.workgroup_key & ',' & request.stSecurityContext.q_select_workgroup_permissions.workgroup_name>
		</cfoutput>

	  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
			FieldName="workgroup"
			DisplayName="#GetLangVal('cm_wd_workgroup')#"
			FieldType="select"
			FieldSource="meta"
			CompareOptions=#a_arr_options#>								
	  
	  <!--- loop categories ... --->
	  <cfset a_str_categories = GetUserPrefPerson('common', 'personalcategories', '', '', false) />
		
	  <cfset a_str_categories = ListAppend(a_str_categories, getlangval("cm_ph_categories_masterlist")) />
						 
		<cfset a_arr_options = ArrayNew(1)> 
			<cfloop list="#a_str_categories#" delimiters="," index="a_str_category">
				<cfset a_arr_options[ArrayLen(a_arr_options) + 1] = a_str_category />
			</cfloop>
		
	  <cfmodule template="mod_dsp_inc_generate_filter_row.cfm"
			FieldName="categories"
			DisplayName="#GetLangVal('cm_wd_category')#"
			FieldType="select"
			FieldSource="contact"
			CompareOptions=#a_arr_options#>		
			
</table>

