<!--- //

	Module:        Forms
	Description:   this component offers two ways of generating forms
		
					a) saved forms from the database
					b) manually created forms (where the elements are added on runtime
					
	

// --->

<cfcomponent output='no'>
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfset request.a_arr_form_elements = ArrayNew(1)>
	<cfset request.a_struct_form_properties = StructNew()>
	<cfset request.a_struct_callback_functions_parameters = StructNew()>
	
	<cffunction access="public" name="StartNewForm" output="false" returntype="boolean"
			hint="Start a new form by setting the main properties ...">
		<cfargument name="action" type="string" default="" hint="url of the action page" required="no">
		<cfargument name="action_type" type="string" default="create"
			hint="CREATE or UPDATE or other action type">		
		<cfargument name="method" type="string" required="no" default="GET"
			hint="CGI method to use">
		<cfargument name="style" type="string" required="no" default="">
		<cfargument name="onSubmit" type="string" required="no" default="">
		<cfargument name="write_table" type="boolean" required="no" default="true" hint="write table as well">
		<cfargument name="form_id" type="string" required="no" default="" hint="form id or name">
		<cfargument name="callback_functions_parameters" type="struct" required="no" default="#StructNew()#">
		<cfargument name="columns_no" type="numeric" default="1" hint="number of columns in the form">
		<cfargument name="autopickup" type="numeric" default="0" hint="autopickup form?">
		<cfargument name="formkey" type="string" default="" hint="entrykey of called form, not required" required="false">
		<cfargument name="userkey" type="string" default="" hint="entrykey of user calling the form, not req" required="false">
		<cfargument name="servicekey" type="string" required="false" default="" hint="entrykey of service where this form belongs to">
		<cfargument name="objectkey" type="string" required="false" default="" hint="entrykey of object manipulated using this form">
		<cfargument name="missing_required_fields_input_names" type="string" required="false" default=""
			hint="list of input fields which are required, but have not been entered by the user (for re-submit forms)">
		
		<cfset request.a_struct_form_properties = StructNew() />
		
		<!--- define an entrykey for this form request ... --->
		<cfset request.a_struct_form_properties.request_entrykey = CreateUUID() />
		
		<cfset request.a_struct_form_properties.servicekey = arguments.servicekey />
		<cfset request.a_struct_form_properties.objectkey = arguments.objectkey />
		
		<cfset request.a_struct_form_properties.action = arguments.action />
		<cfset request.a_struct_form_properties.action_type = arguments.action_type />
		<cfset request.a_struct_form_properties.method = arguments.method />
		<cfset request.a_struct_form_properties.write_table = arguments.write_table />
		<cfset request.a_struct_form_properties.form_id = arguments.form_id />
		<cfset request.a_struct_form_properties.onSubmit = arguments.onSubmit />
		<cfset request.a_struct_form_properties.columns_no = arguments.columns_no />
		<cfset request.a_struct_form_properties.missing_required_fields_input_names = arguments.missing_required_fields_input_names />
		<!--- the current column index ...--->
		<cfset request.a_struct_form_properties.current_col_index = 1 />
		<cfset request.a_struct_form_properties.autopickup = arguments.autopickup />
		
		<cfif Len(request.a_struct_form_properties.form_id) IS 0>
			<cfset request.a_struct_form_properties.form_id = 'form_' & ReplaceNoCase(CreateUUID(), '-', '', 'ALL') />
		</cfif>
		
		<!--- parameters for callback functions ... --->
		<cfset request.a_struct_callback_functions_parameters = arguments.callback_functions_parameters />
		
		<!--- array holding fields --->
		<cfset request.a_arr_form_elements = ArrayNew(1) />
		
		<!--- variable holding fields which are required ... needed for validation ... --->
		<cfset request.a_struct_form_properties.required_fields_in_use = '' />
		
		<!--- insert every form request into the database ... --->
		<cfinclude template="queries/q_insert_form_request.cfm">
				
		<cfreturn true />
	</cffunction>
	
	<!--- //
	
		write start of edit form
		
		// --->
	<cffunction access="public" name="WriteFormStart" output="false" returntype="string"
			hint="write start of form">
				
		<cfset var sReturn = '' />
		<cfset var a_str_form_action = '' />
		<cfset var a_str_form_onsubmit = 'ShowLoadingStatus();' />

		<!--- autopickup form? if true, use autopickup action, otherwise given action --->
		<cfif request.a_struct_form_properties.autopickup IS 1>
			<cfset a_str_form_action = '/tools/autopickup.cfm?' />
		<cfelse>
			<cfset a_str_form_action = request.a_struct_form_properties.action />
		</cfif>
		
		<cfif Len(request.a_struct_form_properties.onSubmit) GT 0>
			<cfset a_str_form_onsubmit = a_str_form_onsubmit & request.a_struct_form_properties.onSubmit>
		</cfif>
		
		<cfset sReturn = '<form onSubmit="' & a_str_form_onsubmit & '" name="' & request.a_struct_form_properties.form_id & '" id="' & request.a_struct_form_properties.form_id & '" style="margin:0px;" action="' & a_str_form_action & '" method="' & request.a_struct_form_properties.method & '">'>
		
		<!--- write entrykey ... --->
		<cfset sReturn = sReturn & '<input type="hidden" name="frmRequestEntrykey" value="'& request.a_struct_form_properties.request_entrykey & '"/>'>
		
		<!--- referer ... --->
		<cfset sReturn = sReturn & '<input type="hidden" name="frmhttpreferer" value="'& htmleditformat(ReturnRedirectURL()) & '"/>' />
		
		<cfif request.a_struct_form_properties.write_table>
			<cfset sReturn = sReturn & '<table class="table_details table_edit_form">'>
			
			<!--- not a very simple table, make sure that column widths are equal --->
			<cfif request.a_struct_form_properties.columns_no GT 1>
				<cfset sReturn = sReturn & '<tr><td colspan="2" width="50%"></td><td colspan="2" width="50%"></td></tr>' />
			</cfif>
		</cfif>
		
		<cfif Len(request.a_struct_form_properties.missing_required_fields_input_names) GT 0>
			<cfset sReturn = sReturn & '<tr><td class="field_name"><span class="glyphicon glyphicon-exclamation-sign"></span></td><td style="font-weight:bold;">' & 'Please enter all required fields!' &  '<img src="/images/space_1_1.gif" class="si_img" /></td></tr>' />
		</cfif>
		
		<cfreturn sReturn />
	</cffunction>
	
	<!--- //
	
		write form elements ...
		
		// --->
	<cffunction access="public" name="WriteFormElements" output="false" returntype="string"
			hint="write output (fields)">
		<cfset var sReturn = ''>
		<cfset var ii = 0>
		<cfset var a_struct_form_element = StructNew() />
		
		<cfloop from="1" to="#ArrayLen(request.a_arr_form_elements)#" index="ii">
			<cfset a_struct_form_element = request.a_arr_form_elements[ii] />
			
			<cfinclude template="utils/inc_generate_edit_table_row.cfm">
			
			<cfset sReturn = sReturn & a_str_edit_table_row />
		</cfloop>
		
		<cfreturn sReturn>
	</cffunction>
	
	<!--- // write end of edit form // --->
	<cffunction access="public" name="WriteFormEnd" output="false" returntype="string"
			hint="write end of form">
			
		<cfset var sReturn = '' />
		<cfset var a_str_displayed_form_elements = '' />
		
		<cfset var ii = 0 />
		<cfset var a_str_js = '' />
		
		<cfif request.a_struct_form_properties.write_table>
			<cfset sReturn = '</table>' />
		</cfif>
		
		<!--- write information about displayed fields ... --->
		<cfloop from="1" to="#ArrayLen(request.a_arr_form_elements)#" index="ii">
			<cfif Len(request.a_arr_form_elements[ii].input_name) GT 0>
				<cfset a_str_displayed_form_elements = ListAppend(a_str_displayed_form_elements, request.a_arr_form_elements[ii].input_name) />
			</cfif>
		</cfloop>
		
		<cfset sReturn = sReturn & '<input type="hidden" name="frm_display_fields" value="' & a_str_displayed_form_elements & '"/>' />
		
		<cfset sReturn = sReturn & '</form>' />
		
		<!--- add validation? ... --->
		<!--- <cfif Len(request.a_struct_form_properties.required_fields_in_use) GT 0>
			<cfsavecontent variable="a_str_js">
			$(document).ready(function() {
				 cleanValidator.init({
				  formId: '<cfoutput>#request.a_struct_form_properties.form_id#</cfoutput>',
				  isRequired: ['<cfoutput>#ReplaceNoCase(request.a_struct_form_properties.required_fields_in_use, ',', ''',''', 'ALL')#</cfoutput>'],
				 });
			});
			</cfsavecontent>
			
			<cfset AddJSToExecuteAfterPageLoad('', a_str_js) />
		</cfif> --->
				
		<cfreturn sReturn />
	</cffunction>
	
	<cffunction access="public" name="GetFormPropertiesAndFields" output="false" returntype="struct">
		<cfset var stReturn = StructNew() />

		<cfset stReturn.a_struct_form_properties = request.a_struct_form_properties />
		<cfset stReturn.a_arr_form_elements = request.a_arr_form_elements />

		<cfreturn stReturn />
	</cffunction>
	
	<!--- // add a form element ... // --->
	<cffunction access="public" name="AddFormElement" output="false" returntype="boolean" hint="add an element">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">	
		<cfargument name="datatype" type="string" default="string" hint="boolean,string,integer,float,date,memo,options,submit,span">
		<cfargument name="tr_id" type="string" default="" hint="if needed, id for the created tr">
		<cfargument name="field_name" type="string" default="" hint="name of field">
		<cfargument name="input_name" type="string" default="" hint="name of input field">
		<cfargument name="input_value" type="string" default="" hint="value of input field">
		<cfargument name="display_value" type="string" default=""
			hint="value to display, only possible for selector input elements">
		<cfargument name="db_fieldname" type="string" required="false" default=""
			hint="name of corresponding database fieldname">
		<cfargument name="db_fieldname_selector_displayvalue" type="string" required="false" default=""
			hint="name of corresponding database fieldname in case of selector and different name">
		<cfargument name="output_only" type="boolean" default="false" hint="if true, only output, no input field">
		<cfargument name="add_validation" type="boolean" required="no" default="false" hint="add validation routine">
		<cfargument name="options" type="array" required="no" default="#ArrayNew(1)#" hint="array with structures (these are the available options)">
		<cfargument name="required" type="boolean" required="no" default="false">
		<cfargument name="platform" type="string" required="no" default="www" hint="www, pda, wap">
		<cfargument name="parameters" type="string" required="no" default="" hint="various parameters ...">
		<cfargument name="CallBackFunctionName" type="string" required="no" default="">
		<cfargument name="CallBackFunctionNameNecessaryArguments" type="string" required="no" default="">
		<cfargument name="colspan" type="numeric" required="no" default="1" hint="span over multiple columns?">
		<cfargument name="css" type="string" required="false" default="" hint="style information">
		<cfargument name="selectorJSFunction" type="string" required="false" default="" hint="JS selector function name">
		<cfargument name="useuniversalselectorjsfunction" type="string" required="false" default="" hint="JS selector function name">
		<cfargument name="useuniversalselectorjsfunction_type" type="string" required="false" default="" hint="JS selector function name">
		<cfargument name="onChange" type="string" required="false" default=""
			hint="JS function which will be fired onChange event">
		
		<cfset var ii = (ArrayLen(request.a_arr_form_elements) + 1)>
		<cfset var a_result_callback = false>
		
		<cfset request.a_arr_form_elements[ii] = StructNew() />
		<cfset request.a_arr_form_elements[ii].datatype = arguments.datatype />
		<cfset request.a_arr_form_elements[ii].tr_id = arguments.tr_id />
		<cfset request.a_arr_form_elements[ii].field_name = arguments.field_name />
		<cfset request.a_arr_form_elements[ii].input_name = arguments.input_name />
		<cfset request.a_arr_form_elements[ii].input_value = arguments.input_value />
		<cfset request.a_arr_form_elements[ii].db_fieldname = arguments.db_fieldname />
		<cfset request.a_arr_form_elements[ii].db_fieldname_selector_displayvalue = arguments.db_fieldname_selector_displayvalue />
		<cfset request.a_arr_form_elements[ii].display_value = arguments.display_value />		
		<cfset request.a_arr_form_elements[ii].output_only = arguments.output_only />
		<cfset request.a_arr_form_elements[ii].add_validation = arguments.add_validation />
		<cfset request.a_arr_form_elements[ii].options = arguments.options />
		<cfset request.a_arr_form_elements[ii].required = arguments.required />
		<cfset request.a_arr_form_elements[ii].platform = arguments.platform />
		<cfset request.a_arr_form_elements[ii].parameters = arguments.parameters />
		<cfset request.a_arr_form_elements[ii].usersettings = arguments.usersettings />
		<cfset request.a_arr_form_elements[ii].colspan = arguments.colspan />
		<cfset request.a_arr_form_elements[ii].css = arguments.css />
		<cfset request.a_arr_form_elements[ii].selectorJSFunction = arguments.selectorJSFunction />
		<cfset request.a_arr_form_elements[ii].useuniversalselectorjsfunction = arguments.useuniversalselectorjsfunction />
		<cfset request.a_arr_form_elements[ii].useuniversalselectorjsfunction_type = arguments.useuniversalselectorjsfunction_type />
		<cfset request.a_arr_form_elements[ii].onChange = arguments.onChange />
		
		<!--- check if function is given and all needed parameters exist ... --->		
		<cfif (Len(arguments.CallBackFunctionName) GT 0) AND
			CallBackFunctionNecessaryParametersAllExist(arguments.CallBackFunctionNameNecessaryArguments)>
			<!--- we've callback functions! --->
			<cfset a_result_callback = CheckCallBackFunctionForGettingOptions(securitycontext = arguments.securitycontext,
															usersettings = arguments.usersettings,
															function_name = arguments.CallBackFunctionName,
															necessary_arguments = arguments.CallBackFunctionNameNecessaryArguments) />
			<cfif a_result_callback.result>
				
				<!--- true, set options (in case of options) or input_value (in case of other fields) --->
				<cfif arguments.datatype IS 'options'>
					<cfset request.a_arr_form_elements[ii].options = a_result_callback.options />
				<cfelse>
					<cfset request.a_arr_form_elements[ii].input_value = a_result_callback.input_value />
				</cfif>
			</cfif>
		</cfif>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="GetFormFields" output="false" returntype="query"
			hint="return form fields">
		<cfargument name="formkey" type="string" required="yes">
		
		<cfset var q_select_form_fields = 0 />
		
		<cfinclude template="queries/q_select_form_fields.cfm">
		
		<cfreturn q_select_form_fields>
	</cffunction>
	
	<cffunction access="public" name="DisplaySavedForm" output="false" returntype="string"
			hint="display a saved form">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes"
			hint="entrykey of form">
		<cfargument name="objectkey" type="string" required="false" default=""
			hint="entrykey of object manipulated using this form">
		<cfargument name="action" type="string" required="yes"
			hint="CREATE or UPDATE">
		<cfargument name="query" type="query" default="#QueryNew('abc')#"
			hint="query holding data ...">
		<cfargument name="entrykeys_fields_to_ignore" type="string" required="false" default=""
			hint="entrykeys of fields to ignore (do not display them at all)">
		<cfargument name="dbfieldnames_to_ignore" type="string" required="false" default=""
			hint="database fieldnames to ignore (do not display/include them at all)">
		<cfargument name="entrykeys_fields_to_hide" type="string" required="false" default=""
			hint="entrykeys of fields to hide (set the type to hidden, so that they are not displayed)">
		<!--- TODO: implement this features ... --->
		<cfargument name="entrykeys_fields_force_to_show" type="string" default="" required="false"
			hint="entrykeys of fields force to show">
		<cfargument name="force_element_values" type="struct" required="no"
			default="#StructNew()#" hint="force input values for certain fields (addressed by db_name)">
		<cfargument name="force_options_replace" type="struct" required="no"
			default="#StructNew()#" hint="force input element options">
		<cfargument name="force_options_add" type="struct" required="no"
			default="#StructNew()#" hint="force additional input element options">
		<cfargument name="callback_functions_parameters" type="struct" required="no"
			default="#StructNew()#" hint="parameters for callback functions ... unique names (simple structure)">
		<cfargument name="custom_action_url" type="string" default="" required="false"
			hint="use a custom action href url instead of url stored in xml definition">
			
		<cfset var sReturn = '' />
		<cfset var q_select_form = 0 />
		<cfset var q_select_fields = 0 />
		<cfset var a_str_missing_input_names = '' />
		<cfset var q_select_fields_to_remove = 0 />
		
		<!--- load form properties and fields --->
		<cfinclude template="queries/q_select_form.cfm">
		
		<cfif q_select_form.recordcount IS 0>
			<cfthrow message="This form does not exist." />
		</cfif>
		
		<!--- load all available fields ... --->
		<cfset q_select_fields = GetFormFields(arguments.entrykey) />
		
		<!--- check which fields to ignore ... --->
		<cfinclude template="utils/inc_check_ignore_hide_fields.cfm">
		
		<!--- calll display routine now ... --->
		<cfinclude template="utils/inc_display_saved_form.cfm">
		
		<!--- generate output ... --->
		<cfsavecontent variable="sReturn">
		<cfoutput>
		#WriteFormStart()#
		#WriteFormElements()#
		#WriteFormEnd()#
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn sReturn />
	
	</cffunction>
	
	
	<cffunction access="public" name="AddOptionsElementFromQuery" output="false" returntype="array"
		hint="add values from a query to an option array using the column name for name/value">
		<cfargument name="array_holding_data" type="array" required="yes">
		<cfargument name="query_holding_data" type="query" required="yes">
		<cfargument name="column_name" type="string" required="yes">
		<cfargument name="column_value" type="string" required="yes">
		
		<cfset var a_arr_return = arguments.array_holding_data>
		<cfset var ii = 0>
		<cfset var a_int_row = 0>
		
		<cfloop from="1" index="a_int_row" to="#arguments.query_holding_data.recordcount#">
			<cfset ii = ArrayLen(a_arr_return) + 1>
			<cfset a_arr_return[ii] = StructNew()>
			<cfset a_arr_return[ii].name = arguments.query_holding_data[arguments.column_name][a_int_row]>
			<cfset a_arr_return[ii].value = arguments.query_holding_data[arguments.column_value][a_int_row]>
		</cfloop>
		
		<cfreturn a_arr_return>
	
	</cffunction>	
	
	<cffunction access="private" name="CheckCallBackFunctionForGettingOptions" output="false" returntype="struct"
		hint="check if the given callback function exists and return the option-elements for the SELECT element">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="function_name" type="string" required="yes" hint="name of the function"/>
		<cfargument name="necessary_arguments" type="string" required="no" default="" hint="list of arguments that must exist in order to call function">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_struct_filter_projects = StructNew() />
		<cfset var q_select_projects = 0 />
		<cfset var a_struct_folders = 0 />
		<cfset stReturn.result = false>
		<cfset stReturn.input_value = ''>
		<cfset stReturn.options = ArrayNew(1)>
		
		<cfinclude template="utils/inc_check_callback_functions.cfm">
		
		<cfreturn stReturn>	
	</cffunction>
	
	<cffunction access="private" name="CallBackFunctionNecessaryParametersAllExist" returntype="boolean" output="false"
		hint="check if all needed parameters are provided">
		<cfargument name="parameters" type="string" required="yes" hint="list of parameters">
		
		<cfset var a_bol_result = false />
		<cfset var a_str_parameter = '' />
		
		<cfloop list="#arguments.parameters#" index="a_str_parameter">
			<cfif NOT StructKeyExists(request.a_struct_callback_functions_parameters, a_str_parameter)>
				<cfreturn a_bol_result />
			</cfif>
		</cfloop>
		
		<cfset a_bol_result = true />
		
		<cfreturn a_bol_result />
	</cffunction>
	
	<cffunction access="private" name="GetCallBackFunctionParameterByName" returntype="any" output="false"
		hint="Return a parameter by name">
		<cfargument name="parameter" type="string" required="yes">		
		
		<cfreturn request.a_struct_callback_functions_parameters[arguments.parameter] />		
	</cffunction>	
	
	<!--- arguments.options above ... add an element to the array holding the elements --->
	<cffunction access="public" name="AddOptionToInputElementOptions" returntype="array">
		<cfargument name="array_holding_data" type="array" required="yes">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="value" type="string" required="yes">

		<cfset var a_arr_return = arguments.array_holding_data>
		<cfset var ii = ArrayLen(a_arr_return) + 1>
		
		<cfset a_arr_return[ii] = StructNew()>
		<cfset a_arr_return[ii].name = arguments.name>
		<cfset a_arr_return[ii].value = arguments.value>
		
		<!--- return now --->
		<cfreturn a_arr_return>
	</cffunction>	
	
	<!--- same as above, just a different name! --->
	<cffunction name="AddItemToArrayOfOptions" access="public" returntype="array">
		<cfargument name="array_holding_data" type="array" required="yes">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="value" type="string" required="yes">

		<cfset var a_arr_return = arguments.array_holding_data />
		<cfset var ii = ArrayLen(a_arr_return) + 1 />
		
		<cfset a_arr_return[ii] = StructNew() />
		<cfset a_arr_return[ii].name = arguments.name />
		<cfset a_arr_return[ii].value = arguments.value />
		
		<!--- return now --->
		<cfreturn a_arr_return />
	</cffunction>
	
	<cffunction access="public" name="GetFormRequestPropertiesbyRequestKey" output="false" returntype="query"
			hint="return the known data about the form request by using the given request key">
		<cfargument name="requestkey" type="string" required="true" hint="the entrykey of the request">
		
		<cfset var q_select_form_request_by_requestkey = 0 />
		
		<cfinclude template="queries/q_select_form_request_by_requestkey.cfm">
		
		<cfreturn q_select_form_request_by_requestkey />
	</cffunction>
	
	<cffunction access="public" name="GetSavedFormProperties" output="false" returntype="query"
			hint="return the properties of a saved form">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var q_select_form = 0 />
		
		<cfinclude template="queries/q_select_form.cfm">
	
		<cfreturn q_select_form />
	</cffunction>
	
	<cffunction access="public" name="CollectFormValues" output="false" returntype="struct"
			hint="Collect all form variables ... create structure with database fieldnames as well(information is taken from forms definition) Does NOT call auto pickup method">
		<cfargument name="requestkey" type="string" required="true"
			hint="entrykey of form request">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">	
		<cfargument name="form_scope" type="struct" required="true"
			hint="form scope with all form elements ...">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_request_properties = 0 />
		<cfset var q_select_fields = 0 />
		<cfset var a_str_form_field_value = '' />
		<cfset var a_str_form_field_value_display_field = '' />
		<cfset var a_str_input_name_display_field = '' />
		<cfset var a_str_device_type = arguments.usersettings.device.type />
		<cfset var a_str_wddx_form = '' />
		<cfset var a_bol_update = false />
		
		<!--- the structure holding the values for the database fields ... --->
		<cfset stReturn.a_struct_database_fields = StructNew() />
		
		<!--- all raw data ... --->
		<cfset stReturn.a_struct_all_form_fields = StructNew() />
		
		<!--- list with displayed fields ... --->
		<cfset stReturn.a_str_displayed_fields = '' />
		
		<!--- list of fields missing (required is true, but has been left empty) ... --->
		<cfset stReturn.missing_fields = '' />
		
		<cfif Len(arguments.requestkey) IS 0>
			<cfreturn SetReturnStructErrorCode(stReturn, 5200) />
		</cfif>
		
		<!--- get the stored request ... --->
		<cfset q_select_request_properties = GetFormRequestPropertiesbyRequestKey(requestkey = arguments.requestkey) />
		
		<!--- no matching request ... --->
		<cfif (q_select_request_properties.recordcount IS 0)>
			<cfreturn SetReturnStructErrorCode(stReturn, 5200) />
		</cfif>
		
		<!--- do not allow multiple submits ... --->
		<cfif (q_select_request_properties.data_used IS 1)>
			<cfreturn SetReturnStructErrorCode(stReturn, 5201) />
		</cfif>
		
		<!--- select fields of form ... --->
		<cfset q_select_fields = GetFormFields(formkey = q_select_request_properties.formkey) />
		
		<cfinclude template="utils/inc_collect_form_values.cfm">
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="DoAutoPickupData" output="false" returntype="struct"
			hint="Do all the autopickup things from form scope">
		<cfargument name="requestkey" type="string" required="true"
			hint="entrykey of form request">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">	
		<cfargument name="form_scope" type="struct" required="true"
			hint="form scope with all form elements ...">
			
		<cfset var stReturn = GenerateReturnStruct() />
		
		<!--- structure for *all* form elements --->
		<cfset var a_struct_all_form_fields = StructNew() />
		
		<cfset var stReturn_call_service_method = StructNew() />

		<!--- structure for database form elements *only* --->
		<cfset var a_struct_database_form_fields = StructNew() />
				
		<!--- vars used in include --->
		<cfset var q_select_request_properties = 0 />
		<cfset var a_struct_collect_form_data = StructNew() />
		<cfset var a_str_sql_action = '' />
		
		<!--- by default, all req fields have been provided ... --->
		<cfset stReturn.missing_fields = '' />
		
		<!--- check all autopickup data ... --->
		<cfinclude template="utils/inc_check_autopickup_data.cfm">
		
		<cfif stReturn.errormessage NEQ ''>
			<cfthrow message="#stReturn.errormessage#">
		</cfif>
		
		<!--- req fields are missing, return ... --->
		<cfif Len(stReturn.missing_fields) GT 0>
			<cfreturn stReturn />
		</cfif>
		
		<!---Check if an automatically database operation should take place ... --->
		<cfif (Len(stReturn.q_select_form_properties.db_datasource) GT 0) AND
			  (Len(stReturn.q_select_form_properties.db_table) GT 0) AND
			  (Len(stReturn.q_select_form_properties.db_primary) GT 0)>
				
			<cfinclude template="utils/inc_do_autoexec_sql.cfm">
			
			<!--- if an error occured, return ... --->
			<cfif NOT stReturn.stReturn_autoexec_sql.result>
				<cfreturn stReturn.stReturn_autoexec_sql />
			</cfif>
		</cfif>
		
		<!--- check if autopickup_functionname is NOT empty --->
		<cfif Len(stReturn.q_select_form_properties.autopickup_functionname) GT 0>
			
			<!--- check which application is responsible for this data ... --->
			<cfset stReturn_call_service_method = CallServicePickupMethod(securitycontext = arguments.securitycontext,
									usersettings = arguments.usersettings,
									servicekey = stReturn.q_select_form_properties.servicekey,
									action_type = stReturn.q_select_request_properties.action_type,
									function_name = stReturn.q_select_form_properties.autopickup_functionname,
									database_values = stReturn.a_struct_database_fields,
									all_values = stReturn.a_struct_all_form_fields,
									displayed_fields = stReturn.a_str_displayed_fields) />
									
			<cfset stReturn.stReturn_call_service_method = stReturn_call_service_method />
			
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="CallServicePickupMethod" output="false" returntype="struct"
			hint="call the given method of the component which is responsible for handling the posted data">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">	
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of service">
		<cfargument name="action_type" type="string" required="true"
			hint="create, edit or other">
		<cfargument name="function_name" type="string" required="true"
			hint="name of function to call">
		<cfargument name="database_values" type="struct" required="true"
			hint="structure with values for database">
		<cfargument name="all_values" type="struct" required="true"
			hint="all values posted by the user">
		<cfargument name="displayed_fields" type="string" required="true"
			hint="list of the displayed fields">
		
		<cfset var stReturn_pickup_function = GenerateReturnStruct() />
		<cfset var a_cmp_service = 0 />
		
		<!--- call the desired function --->
		<cfinclude template="utils/inc_call_autopickup_function.cfm">
	
		<!--- return the result of the pickup method ... --->
		<cfreturn stReturn_pickup_function />
	</cffunction>
	
	<cffunction access="public" name="SavePostedFormWDDXData" output="false" returntype="boolean"
			hint="Save posted form content as wddx to database">
		<cfargument name="requestkey" type="string" required="true"
			hint="entrykey of request">
		<cfargument name="wddx_formdata" type="string" required="true"
			hint="form data in wddx format">
		<cfargument name="formkey" type="string" required="true"
			hint="entrykey of form">
			
		<cfinclude template="queries/q_update_set_wddx_posted_form_content.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="LoadPostedFormWDDXData" output="false" returntype="struct"
			hint="Return the posted content as structure">
		<cfargument name="requestkey" type="string" required="true"
			hint="entrykey of request">	

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_posted_form_data = 0 />
		<cfset var a_struct_form_data = StructNew() />
		
		<cfinclude template="queries/q_select_posted_form_data.cfm">
		
		<!--- request found? ... --->
		<cfif q_select_posted_form_data.recordcount NEQ 1>
			<cfreturn SetReturnStructErrorCode(stReturn, -1) />
		</cfif>
		
		<!--- convert back to basic CFML structure and return ... --->
		<cfwddx action="wddx2cfml" input="#q_select_posted_form_data.wddx_formdata#" output="a_struct_form_data">
		
		<cfset stReturn.a_struct_form_data = a_struct_form_data />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="UpdateFormDefinitionsFromXML" output="false" returntype="boolean"
			hint="read and import form and form field definitions from .xml to database">

		<cfset var sFilename = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'forms' & ReturnDirSeparatorOfCurrentOS() & 'forms.xml' />	

		<cfif Not FileExists(sFilename)>
			<cfreturn false />
		</cfif>
		
		<cfinclude template="queries/q_delete_empty_current_form_definitions.cfm">
		
		<cfinclude template="utils/inc_import_xml.cfm">
		
		<cfreturn true />
	</cffunction>
	
</cfcomponent>

