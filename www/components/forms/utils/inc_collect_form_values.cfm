<!--- //

	Module:		Forms
	Action:		CollectFormValues
	Description:Collect all form variables based on .xml form definitions
	

// --->

<!--- save posted content as wddx to database ... --->
<cfwddx action="cfml2wddx" input="#arguments.form_scope#" output="a_str_wddx_form">

<cfset a_bol_update = SavePostedFormWDDXData(requestkey = arguments.RequestKey,
								wddx_formdata = a_str_wddx_form,
								formkey = q_select_request_properties.formkey) />

<cfset a_str_device_type = arguments.usersettings.device.type />

<!--- get the names of the displayed fields ... --->
<cfif StructKeyExists(arguments.form_scope, 'FRM_DISPLAY_FIELDS')>
	
	<cfset stReturn.a_str_displayed_fields = arguments.form_scope.FRM_DISPLAY_FIELDS>
	
	<!--- handle *only* the fields which have been displayed ... --->
	<cfquery name="q_select_fields" dbtype="query">
	SELECT
		*
	FROM
		q_select_fields
	WHERE
		input_name IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#stReturn.a_str_displayed_fields#" list="true">)
	;
	</cfquery>
	
</cfif>

<!---

	loop through fields now ...
	
	set database field value if name has been entered 
	
	--->


<cfloop query="q_select_fields">

	<!--- get all form elements where a input_name is given --->
	<cfif Len(q_select_fields.input_name) GT 0>
	
		
		<!--- special treatment for date/time fields of PDA ... --->
		<cfif (a_str_device_type IS 'pda') AND (ListFindNoCase('date,datetime', q_select_fields.datatype) GT 0)>
			
			<!--- does the day input field exist? compose full data out of these data ... --->
			<cfif StructKeyExists(arguments.form_scope, q_select_fields.input_name & '_date_day')>
				
				<!--- create the correct date ... time will be added later automatically ... --->
				<cfset arguments.form_scope[q_select_fields.input_name] = CreateDate(arguments.form_scope[q_select_fields.input_name & '_date_year'],
																						arguments.form_scope[q_select_fields.input_name & '_date_month'],
																						arguments.form_scope[q_select_fields.input_name & '_date_day']) />
			
			</cfif>
			
		</cfif>
		
		<!--- the form element exists! --->
		<cfif StructKeyExists(arguments.form_scope, q_select_fields.input_name)>
		
			<cfset a_str_form_field_value = arguments.form_scope[q_select_fields.input_name] />
			
			<!--- a required field is missing ... add it to the list ... --->
			<cfif q_select_fields.required IS 1 AND Len(a_str_form_field_value) IS 0>
				<cfset stReturn.missing_fields = ListAppend(stReturn.missing_fields, q_select_fields.input_name) />
			</cfif>
			
			<cfif q_select_fields.datatype IS 'datetime'>
				
				<!--- still a need to convert? ... --->
				<cfif FindNoCase('{ts ', arguments.form_scope[q_select_fields.input_name]) IS 0>
					
					<cfif Len( ListLast( arguments.form_scope[q_select_fields.input_name], '.' )) IS 2>
						<cfset arguments.form_scope[q_select_fields.input_name ] = Insert( '20', arguments.form_scope[q_select_fields.input_name ], Len( arguments.form_scope[q_select_fields.input_name] ) - 2) />
					</cfif>
					
					<!--- <cfset SetLocale ("German (Austrian)")> --->
					
					<cfset a_str_form_field_value = LSParseDateTime(arguments.form_scope[q_select_fields.input_name]) />
				</cfif>
				
				<cfset a_str_form_field_value = DateAdd('h', arguments.form_scope[q_select_fields.input_name & '_time_hour'], a_str_form_field_value) />
				<cfset a_str_form_field_value = DateAdd('n', arguments.form_scope[q_select_fields.input_name & '_time_minute'], a_str_form_field_value) />
			</cfif>
			
		<cfelse>
			<!--- especially for boolean values ... set value to false by default ... --->
			<cfset a_str_form_field_value = q_select_fields.defaultvalue />
		</cfif>
			
		<cfset stReturn.a_struct_all_form_fields[q_select_fields.input_name] = a_str_form_field_value />
		
		<!--- does also the database field exist? --->
		<cfif Len(q_select_fields.db_fieldname) GT 0>
			
			<cfset stReturn.a_struct_database_fields[q_select_fields.db_fieldname] = a_str_form_field_value />
		
		</cfif>
		
		<!--- does an own property for a display value exist? ... --->
		<cfset a_str_input_name_display_field = '' />
		
		<cfif (Len(q_select_fields.db_fieldname_selector_displayvalue) GT 0)>
			
			<!--- the input name of the display field ... same name with _DISPLAY on end --->
			<cfset a_str_input_name_display_field = q_select_fields.input_name & '_display' />
			
			<!--- does the field exist? ... --->
			<cfif StructKeyExists(arguments.form_scope, a_str_input_name_display_field)>
				
				<cfset stReturn.a_struct_database_fields[q_select_fields.db_fieldname_selector_displayvalue] = arguments.form_scope[a_str_input_name_display_field] />	
		
				<cfset stReturn.a_struct_all_form_fields[q_select_fields.input_name] = arguments.form_scope[a_str_input_name_display_field] />
				
			</cfif>
			
		</cfif>
			
	
	</cfif>

</cfloop>


