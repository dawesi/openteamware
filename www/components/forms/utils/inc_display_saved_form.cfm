<!--- //

	Module:		Forms
	Description:Parse existing form stored in database ...
	

// --->

<!--- which URL to use? --->
<cfif arguments.action IS 'CREATE'>
	<cfset a_str_action = q_select_form.create_url />
<cfelse>
	<cfset a_str_action = q_select_form.update_url />
</cfif>

<!--- use custom provided url ... --->
<cfif Len(arguments.custom_action_url) GT 0>
	<cfset a_str_action = arguments.custom_action_url />
</cfif>

<!--- load data from an existing request of this user? 
	might be the reason if the user has not properly filled out all fields ...
	--->
<cfif StructKeyExists(url, 'loaddatafromrequestkey') AND Len(url.loaddatafromrequestkey) GT 0>
	<cfset a_struct_load_existing_data = application.components.cmp_forms.LoadPostedFormWDDXData(url.loaddatafromrequestkey) />
	
	<!--- if the result is OK, proceed ... --->
	<cfif a_struct_load_existing_data.result>

		<cfloop list="#StructKeyList(a_struct_load_existing_data.a_struct_form_data)#" index="a_str_input_name">
		
			<cfquery name="q_select_db_field_name_by_input_name" dbtype="query">
			SELECT
				db_fieldname
			FROM
				q_select_fields
			WHERE
				UPPER(input_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(a_str_input_name)#">
			;
			</cfquery>
			
			<!--- if the fields has a database input name, set the force element value to the stored value in the database ... --->
			<cfif q_select_db_field_name_by_input_name.recordcount IS 1 AND Len(q_select_db_field_name_by_input_name.db_fieldname) GT 0>
				<cfset arguments.force_element_values[q_select_db_field_name_by_input_name.db_fieldname] = a_struct_load_existing_data.a_struct_form_data[a_str_input_name] />
			</cfif>
		
		</cfloop>
			
	</cfif>
	
	<!--- have missing fields been provided? --->
	<cfif StructKeyExists(url, 'missingfields')>
		<cfset a_str_missing_input_names = url.missingfields />
	</cfif>
</cfif>

<!--- start form with action and method ... --->
<cfset StartNewForm(action = a_str_action,
						  action_type = arguments.action,
						  method = q_select_form.method,
						  onSubmit = q_select_form.onsubmit,
						  form_id = q_select_form.form_id,
						  style = q_select_form.css_style,
						  callback_functions_parameters = arguments.callback_functions_parameters,
						  autopickup = q_select_form.autopickup,
						  columns_no = q_select_form.columns,
						  formkey = q_select_form.entrykey,
						  userkey = arguments.securitycontext.myuserkey,
						  servicekey = q_select_form.servicekey,
						  objectkey = arguments.objectkey,
						  missing_required_fields_input_names = a_str_missing_input_names) />

<!--- data provided in the query? create a column list for fast lookups --->
<cfset a_str_column_list_of_query = arguments.query.columnlist />

<!--- add one field by another ... --->
<cfloop query="q_select_fields">

	<!--- field name ... we might have to translate the name ... --->
	<cfset a_str_fieldname = q_select_fields.field_name />
	<cfset a_str_input_value = '' />
	<cfset a_str_db_fieldname = q_select_fields.db_fieldname />
	<cfset a_str_db_fieldname_selector_displayvalue = q_select_fields.db_fieldname_selector_displayvalue />
	<cfset a_str_display_value = '' />
	<cfset a_bol_required = false />
	<cfset a_bol_output_only = false />
	<cfset a_bol_validate = false />
	<cfset a_str_datatype = q_select_fields.datatype />
	<cfset a_str_default_value = q_select_fields.defaultvalue />
	<cfset a_arr_options = ArrayNew(1) />
	<cfset a_int_colspan = q_select_fields.colspan />
	<cfset a_str_parameters = q_select_fields.parameters />
	<cfset a_str_CallBackFunctionName = '' />
	<cfset a_str_CallBackFunctionNameNecessaryArguments = '' />
	<cfset a_str_default_parameter_scope = q_select_fields.default_parameter_scope />
	<cfset a_str_default_parameter_name = q_select_fields.default_parameter_name />	
	<cfset a_str_css = q_select_fields.css />
	<cfset a_str_jsselectorfunction = q_select_fields.jsselectorfunction />
	<cfset a_str_useuniversalselectorjsfunction = q_select_fields.useuniversalselectorjsfunction />
	<cfset a_str_useuniversalselectorjsfunction_type = q_select_fields.useuniversalselectorjsfunction_type />
	<cfset a_str_onChange = q_select_fields.onChange />
	
	
	<cfif FindNoCase('%LANG_', a_str_fieldname) IS 1>
		<!--- translate! --->
		<cfset a_str_fieldname = ReplaceNoCase(a_str_fieldname, '%LANG_', '', 'ONE') />
		<cfset a_str_fieldname = ReplaceNoCase(a_str_fieldname, '%', '', 'ALL') />
		<cfset a_str_fieldname = GetLangVal(a_str_fieldname) />
	</cfif>
	
	<!--- VERY FIRST OPTION ... check if default value is given in databse ... (only when item is created!) --->
	<cfif (arguments.action IS 'Create') AND Len(a_str_default_value) GT 0>
		<cfset a_str_input_value = a_str_default_value />
	</cfif>
	
	<!--- FIRST OPTION ... default parameter is given e.g. from url scope ... only possible during CREATE operation
		value must not be empty ... otherwise all the cfparam tags would create wrong results ... --->
	<cfif (arguments.action IS 'Create') AND
		  (ListFindNoCase('url,form,session,application,client,request', a_str_default_parameter_scope) GT 0) AND
		  (Len(a_str_default_parameter_name) GT 0)>
		<cfset a_struct_scope = Evaluate(a_str_default_parameter_scope) />
		
		<cfif StructKeyExists(a_struct_scope, a_str_default_parameter_name) AND
		      (Len(a_struct_scope[a_str_default_parameter_name]) GT 0)>
			 <cfset a_str_input_value = a_struct_scope[a_str_default_parameter_name] />
		</cfif>
	
	</cfif>

	<!--- SECOND OPTION input value ... check if given in database or arguments ... --->
	<cfif (Len(q_select_fields.db_fieldname) GT 0) AND
		  (ListFindNoCase(a_str_column_list_of_query, q_select_fields.db_fieldname) GT 0)>
		  <cfset a_str_input_value = arguments.query[q_select_fields.db_fieldname][1] />
	</cfif>
	
	<!--- THIRD OPTION force a certain value for a certain field? --->
	<cfif StructKeyExists(arguments.force_element_values, q_select_fields.db_fieldname)>
		<cfset a_str_input_value = arguments.force_element_values[q_select_fields.db_fieldname] />
	</cfif>
	
	<!--- is the input value a known contact? if yes, replace it now ... --->
	<cfif ListFindNoCase('{NOW}', a_str_input_value) GT 0>
		<cfswitch expression="#a_str_input_value#">
			<cfcase value="{NOW}">
				<cfset a_str_input_value = Now() />
			</cfcase>
		</cfswitch>
	</cfif>
	
	<!--- does an own display value field exist (SELECTOR type only!) ...
		fieldname is db_fieldname PLUS _displayvalue
		
		criteria:
		a) database fieldname is given
		b) display value exists
		c) display value field has entered value 
		
		ONLY in this case set the value ... --->
		
	<cfif (Len(q_select_fields.db_fieldname) GT 0) AND
		  (ListFindNoCase(a_str_column_list_of_query, q_select_fields.db_fieldname & '_displayvalue') GT 0) AND
		  (Len(arguments.query[q_select_fields.db_fieldname& '_displayvalue'][1]) GT 0)>
		
		<cfset a_str_display_value = arguments.query[q_select_fields.db_fieldname& '_displayvalue'][1]  />
	<!--- <cfelse>
		<cfset a_str_display_value = a_str_input_value /> --->
	</cfif>
	
	<!--- for selector ... for certain fields do an auto-generate of the _displayvalue, including
	
		contactkey,workgroupkeys,contactkeys,frmprojectleaderuserkey
		
		... what's necessary? - 

		- MUST
			- selector
			- db fieldname
			- input value not empty
		- DB version: _displayvalue exist
		- else
			- use simple input value
		- PLUS
			- displayvalue is still empty (see code above to fill field
		 --->
		
	<cfif (a_str_datatype IS 'selector') AND
		  (Len(q_select_fields.db_fieldname) GT 0) AND
		  (Len(a_str_input_value) GT 0) AND
		  (Len(a_str_display_value) IS 0)>
			  
		<cfif (ListFindNoCase(a_str_column_list_of_query, q_select_fields.db_fieldname & '_displayvalue') GT 0) AND
          		(Len(arguments.query[q_select_fields.db_fieldname][1]) GT 0) AND
		 		(Len(arguments.query[q_select_fields.db_fieldname & '_displayvalue'][1]) IS 0)>
			<cfset a_str_real_db_value_to_check = arguments.query[q_select_fields.db_fieldname][1] />
			
		<cfelse>
			<!--- simple value ... --->
			<cfset a_str_real_db_value_to_check = a_str_input_value />
			
		</cfif>
	
		<cfset a_str_set_display_value_to_data = '' />
		
		<cfswitch expression="#q_select_fields.db_fieldname#">
			<cfcase value="contactkey">
				<!--- get the contact display name ... --->
				<cfset a_str_set_display_value_to_data = application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = a_str_real_db_value_to_check) />
			</cfcase>
			<cfcase value="projectleaderuserkey">
				<!--- get the username ... --->
				<cfset a_str_set_display_value_to_data = application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(entrykey = a_str_real_db_value_to_check) />
			</cfcase>
			<cfdefaultcase>
				<cfset a_str_set_display_value_to_data = a_str_input_value />
			</cfdefaultcase>
		</cfswitch>
		
		<!--- set display value ... --->
		<cfset a_str_display_value = a_str_set_display_value_to_data />
		
		<!--- database given? ... --->
		<cfif (ListFindNoCase(a_str_column_list_of_query, q_select_fields.db_fieldname & '_displayvalue') GT 0)>
			<cfset QuerySetCell(arguments.query, q_select_fields.db_fieldname & '_displayvalue', a_str_set_display_value_to_data, 1) />
		</cfif>

	</cfif>
	
	<!--- take a special display value field for this? ... for SELECTORS only --->
  	<cfif (a_str_datatype IS 'selector') AND
  		(Len(q_select_fields.db_fieldname_selector_displayvalue) GT 0) AND
  		(ListFindNoCase(a_str_column_list_of_query, q_select_fields.db_fieldname_selector_displayvalue) GT 0)>
		
		<cfset a_str_display_value = arguments.query[q_select_fields.db_fieldname_selector_displayvalue][1] />
  	</cfif>
	
	<!--- if options, fill them ... --->
	<cfif a_str_datatype IS 'options'>
	
		<cfif StructKeyExists(arguments.force_options_replace, q_select_fields.db_fieldname)>
			<!--- force the options saved in the given options ... --->
			
			<cfloop from="1" to="#ArrayLen(arguments.force_options_replace[q_select_fields.db_fieldname])#" index="ii">
				<cfset a_arr_options = AddOptionToInputElementOptions(a_arr_options, arguments.force_options_replace[q_select_fields.db_fieldname][ii].name, arguments.force_options_replace[q_select_fields.db_fieldname][ii].value)>
			</cfloop>
		
		<cfelse>
			<!--- use the default options and maybe some additional options ... --->
	
			<cfloop list="#q_select_fields.options#" delimiters="#Chr(10)#" index="a_str_option_item">
			
				<!--- options are given in the following format: value | display --->
				<cfset a_str_option_value = Trim(ListGetAt(a_str_option_item, 1, '|'))>
				
				<cfset a_str_option_display = ''>
				
				<!--- try to load value ... --->
				<cfif ListLen(a_str_option_item, '|') GTE 2>
					<cfset a_str_option_display = Trim(ListGetAt(a_str_option_item, 2, '|'))>
				</cfif>
				
				<cfif FindNoCase('%LANG_', a_str_option_display) IS 1>
					<!--- translate! --->
					<cfset a_str_option_display = ReplaceNoCase(a_str_option_display, '%LANG_', '', 'ONE') />
					<cfset a_str_option_display = ReplaceNoCase(a_str_option_display, '%', '', 'ALL') />
					<cfset a_str_option_display = GetLangVal(a_str_option_display) />
				</cfif>
			
				<cfset a_arr_options = AddOptionToInputElementOptions(a_arr_options, a_str_option_display, a_str_option_value) />
			</cfloop>
			
			<!--- add additional items? --->
			<cfif StructKeyExists(arguments.force_options_add, q_select_fields.db_fieldname)>
				<cfloop from="1" to="#ArrayLen(arguments.force_options_add[q_select_fields.db_fieldname])#" index="ii">
					<cfset a_arr_options = AddOptionToInputElementOptions(a_arr_options, arguments.force_options_add[q_select_fields.db_fieldname][ii].name, arguments.force_options_add[q_select_fields.db_fieldname][ii].value) />
				</cfloop>
			</cfif>
			
		</cfif>
		
	</cfif>
	
	<!--- various properties --->
	<cfset a_bol_output_only = (q_select_fields.output_only IS 1) />
	<cfset a_bol_required = (q_select_fields.required IS 1) />
	<cfset a_bol_validate = (q_select_fields.addvalidation IS 1) />
	
	<!--- callback properties --->
	<cfset a_str_CallBackFunctionName = q_select_fields.CallBackFunctionName />
	<cfset a_str_CallBackFunctionNameNecessaryArguments = q_select_fields.CallBackFunctionNameNecessaryArguments />
	
	<!--- add form element ... --->
	<cfset AddFormElement(securitycontext = arguments.securitycontext,
								usersettings = arguments.usersettings,
								datatype = a_str_datatype,
								field_name = a_str_fieldname,
								db_fieldname = a_str_db_fieldname,
								db_fieldname_selector_displayvalue = a_str_db_fieldname_selector_displayvalue,
								input_value = a_str_input_value,
								display_value = a_str_display_value,
								input_name = q_select_fields.input_name,
								options = a_arr_options,
								parameters = a_str_parameters,
								output_only = a_bol_output_only,
								required = a_bol_required,
								colspan = a_int_colspan,
								add_validation = a_bol_validate,
								CallBackFunctionName = a_str_CallBackFunctionName,
								CallBackFunctionNameNecessaryArguments = a_str_CallBackFunctionNameNecessaryArguments,
								css = a_str_css,
								selectorJSFunction = a_str_jsselectorfunction,
								useuniversalselectorjsfunction = a_str_useuniversalselectorjsfunction,
								useuniversalselectorjsfunction_type = a_str_useuniversalselectorjsfunction_type,
								onChange = a_str_onChange) />
</cfloop>