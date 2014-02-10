<!--- //

	Component:	Forms
	Function:	UpdateFormDefinitionsFromXML
	Description:Import data from .XML
	

// --->

<cffile action="read" charset="utf-8" file="#sFilename#" variable="a_str_forms">

<cfset q_select_forms = application.components.cmp_datatypeconvert.xmltoquery(xmlObj = XmlParse(a_str_forms))>

<!--- insert now all forms into database ... --->
<cfloop query="q_select_forms">

	<cfquery name="q_insert_form" datasource="#request.a_str_db_tools#">
	INSERT INTO
		forms
		(
		autopickup,
		autopickup_functionname,
		columns,
		create_url,
		description,
		dt_created,
		entrykey,
		form_id,
		form_name,
		method,
		onsubmit,
		query_name,
		servicekey,
		update_url,
		css_style,
		db_datasource,
		db_table,
		db_primary
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.autopickup#">,	
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.autopickup_functionname#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_forms.columns#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.create_url#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.description#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(q_select_forms.dt_created)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.entrykey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.form_id#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.form_name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.method#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.onsubmit#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.query_name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.servicekey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.update_url#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.css_style#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.db_datasource#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.db_table#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_forms.db_primary#">		
		)
	;
	</cfquery>
	
	<!--- load elements now ... --->
	<cfset sFilename_elements = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'forms' & ReturnDirSeparatorOfCurrentOS() & q_select_forms.entrykey & '.xml'>	

	<cfif FileExists(sFilename_elements)>
	
		<cffile action="read" charset="utf-8" file="#sFilename_elements#" variable="a_str_elements">

		<cfset q_select_elements = application.components.cmp_datatypeconvert.xmltoquery(xmlObj = XmlParse(a_str_elements)) />

		<cfloop query="q_select_elements">
			
			<!--- check if new fields exist at all ... in this case ignorebydefault ... --->
			<cfif ListFindNoCase(q_select_elements.columnlist, 'ignorebydefault') GT 0>
				<cfset a_int_ignore_by_default = val(q_select_elements.ignorebydefault) />
			<cfelse>
				<cfset a_int_ignore_by_default = 0 />			
			</cfif>
			
			<cfif ListFindNoCase(q_select_elements.columnlist, 'db_fieldname_selector_displayvalue') GT 0>
				<cfset a_str_db_fieldname_selector_displayvalue = q_select_elements.db_fieldname_selector_displayvalue />
			<cfelse>
				<cfset a_str_db_fieldname_selector_displayvalue =  ''/>			
			</cfif>
			  	 	 	 	 	 	
			<cfquery name="q_insert_element" datasource="#request.a_str_db_tools#">
			INSERT INTO
				form_fields
				(
				entrykey,
				formkey,
				input_name,
				datatype,
				field_name,
				internal_description,
				addvalidation,
				defaultvalue,
				parameters,
				dt_created,
				options,
				visible_description,
				orderno,
				db_fieldname,
				db_fieldname_selector_displayvalue,
				required,
				output_only,
				tr_id,
				onchange,
				CallBackFunctionName,
				CallBackFunctionNameNecessaryArguments,
				default_parameter_scope,
				default_parameter_name,
				colspan,
				css,
				jsselectorfunction,
				useuniversalselectorjsfunction,
				useuniversalselectorjsfunction_type,
				ignorebydefault
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.entrykey#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.formkey#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.input_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.datatype#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.field_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.internal_description#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_elements.addvalidation#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.defaultvalue#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.parameters#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_select_elements.dt_created#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.options#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.visible_description#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_elements.currentrow#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.db_fieldname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_db_fieldname_selector_displayvalue#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_elements.required#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_elements.output_only#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.tr_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.onchange#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.CallBackFunctionName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.CallBackFunctionNameNecessaryArguments#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.default_parameter_scope#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.default_parameter_name#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_elements.colspan#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.css#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.jsselectorfunction#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.useuniversalselectorjsfunction#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_elements.useuniversalselectorjsfunction_type#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_ignore_by_default#">
				)
			;
			</cfquery>
			
		</cfloop>
	
	</cfif>
</cfloop>


