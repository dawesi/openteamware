<!--- //

	Module:		Reporting engine
	Description: 
	

// --->
<cfcomponent output='false'>
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- add key/value pair to array of select options ... --->
	<cffunction access="public" name="AddReportPropertiesOptionSelectboxOption" returntype="array" hint="add an option">
		<cfargument name="arr" type="array" required="yes">
		<cfargument name="key" type="string" required="yes">
		<cfargument name="value" type="any" required="yes">
		
		<cfset var a_arr_return = ArrayNew(1)>
		
		<cfset a_arr_return = Duplicate(arguments.arr)>
		
		<cfset a_arr_return[ArrayLen(a_arr_return) + 1] = StructNew()>
		<cfset a_arr_return[ArrayLen(a_arr_return)].key = arguments.key>
		<cfset a_arr_return[ArrayLen(a_arr_return)].value = arguments.value>
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="public" name="GetColdFusionQueryDataTypeFromInBoxccDataType" output="false" returntype="string">
		<cfargument name="input" type="numeric" default="0">
		
		<cfswitch expression="#arguments.input#">
			<cfcase value="0">
				<cfreturn 'VarChar'>
			</cfcase>
			<cfcase value="1">
				<cfreturn 'BigInt'>
			</cfcase>
			<cfcase value="3">
				<cfreturn 'Date'>
			</cfcase>
			<cfdefaultcase>
				<cfreturn 'VarChar'>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<!--- add a virtual field to the virtual fields array ...  these fields are created in the output table! --->	
	<cffunction access="public" name="AddReportPropertiesVirtualField" returntype="array" output="false" hint="add a virtual field ...">
		<cfargument name="ArrayOfFields" type="array" required="yes" hint="array holding the fields ...">
		<cfargument name="fieldname" type="string" required="yes" hint="fieldname to show">
		<cfargument name="internal_fieldname" type="string" required="no" default="" hint="internal fieldname in table (for easier lookup when filling a field)">
		<cfargument name="datatype" type="numeric" default="0" required="yes" hint="datatype (openTeamware.com standard)">
		<cfargument name="entrykey" type="string" required="yes" hint="internal entrykey of virtual field">
		<cfargument name="selected" type="boolean" required="no" default="true" hint="selected by default">
		<cfargument name="fixed" type="boolean" required="no" default="false" hint="cannot be de-selected">
		<cfargument name="visible" type="boolean" required="no" default="true" hint="should this field be visible to the user?">
		
		<cfset var a_struct_add = StructNew()>

		<cfset a_struct_add.fieldname = arguments.fieldname>
		<cfset a_struct_add.datatype = arguments.datatype>
		<cfset a_struct_add.entrykey = arguments.entrykey>
		<cfset a_struct_add.selected = arguments.selected>
		<cfset a_struct_add.fixed = arguments.fixed>
		<cfset a_struct_add.visible = arguments.visible>
		<cfset a_struct_add.internal_fieldname = arguments.internal_fieldname>
		
		<cfset arguments.arrayOfFields[ArrayLen(arrayOfFields) + 1] = a_struct_add>		

		<cfreturn arguments.arrayOfFields>
	</cffunction>
	
	<!--- add an option to the "generate report" interface ... --->
	<cffunction access="public" name="AddReportPropertiesOption" returntype="array" output="false" hint="add an option">
		<cfargument name="ArrayOfOptions" type="array" required="yes" hint="array holding the options ...">
		<cfargument name="name" type="string" required="yes" hint="name of option">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of option">
		<cfargument name="description" type="string" required="no" default="" hint="displayed description">
		<cfargument name="datatype" type="numeric" default="0" required="yes" hint="openTeamware.com datatype">
		<cfargument name="default" type="string" default="" required="no" hint="default value">
		<cfargument name="select_options" type="array" default="#ArrayNew(1)#" hint="array holding options for a select input field">
		<cfargument name="allow_multi_select_options" type="boolean" required="no" default="false" hint="allow multiselect?">
		<cfargument name="include_crm_filter" type="boolean" required="no" default="false" hint="include option as crm filter (merge on query?)">
		<cfargument name="crm_filter_internalfieldname" type="string" default="" required="no" hint="internal fieldname for crm filter">
		<cfargument name="crm_filter_area" type="numeric" default="0" required="no" hint="area of field (0 = meta, 1 = database, 2 = contact)">
		<cfargument name="crm_filter_operator" type="numeric" default="0" required="no" hint="operator for filter">
		<cfargument name="crm_filter_connector" type="numeric" default="0" required="no" hint="connector for filter">
		<cfargument name="visible" type="boolean" required="no" default="true" hint="option visible?">
		
		<cfset var a_struct_add = StructNew()>
		
		<cfset a_struct_add.name = arguments.name>
		<cfset a_struct_add.description = arguments.description>
		<cfset a_struct_add.entrykey = arguments.entrykey>
		<cfset a_struct_add.datatype = arguments.datatype>
		<cfset a_struct_add.default = arguments.default>
		<cfset a_struct_add.options = arguments.select_options>
		<cfset a_struct_add.visible = arguments.visible>
		<cfset a_struct_add.value = ''>
		<cfset a_struct_add.allow_multi_select_options = arguments.allow_multi_select_options>
		
		<!--- crm filter ... ? --->
		<cfset a_struct_add.include_crm_filter = arguments.include_crm_filter>
		<cfset a_struct_add.include_crm_filter_structure = StructNew()>
		<cfset a_struct_add.include_crm_filter_structure.entrykey = arguments.entrykey>
		<cfset a_struct_add.include_crm_filter_structure.internalfieldname = arguments.crm_filter_internalfieldname>
		<cfset a_struct_add.include_crm_filter_structure.displayname = arguments.name>
		<cfset a_struct_add.include_crm_filter_structure.internaldatatype = arguments.datatype>
		<cfset a_struct_add.include_crm_filter_structure.area = arguments.crm_filter_area>
		<cfset a_struct_add.include_crm_filter_structure.operator = arguments.crm_filter_operator>
		<cfset a_struct_add.include_crm_filter_structure.connector = arguments.crm_filter_connector>
		<cfset a_struct_add.include_crm_filter_structure.comparevalue = ''>
		
		<cfset arguments.ArrayOfOptions[ArrayLen(arguments.ArrayOfOptions) + 1] = a_struct_add>
		
		<cfreturn arguments.ArrayOfOptions>
	</cffunction>
	
	<cffunction access="public" name="AddCRMFilterAttribute" returntype="boolean" output="false">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetDefaultReports" output="false" returntype="query" hint="return the list of default reports">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<cfinclude template="queries/reports/q_select_default_reports.cfm">
		
		<cfreturn q_select_default_reports>		
	</cffunction>
	
	<cffunction access="public" name="GetReportList" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<cfinclude template="queries/q_select_reports.cfm">
		
		<cfreturn q_select_reports>		
	</cffunction>
	
	<cffunction access="public" name="SetDefaultReportDefaultSettings" output="false" returntype="query">
		<cfargument name="reportkey" type="string" required="yes">
			
		<cfinclude template="utils/inc_set_properties_default_reports.cfm">
		
		<cfreturn q_select_report>
		
	</cffunction>
	
	<cffunction access="public" name="GetReportSettings" output="false" returntype="struct" hint="get the settings of a report">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfset var stReturn = StructNew() />
			
		<!--- check if this is a default report ... if yes, load settings ... --->
		<cfset q_select_default_reports = GetDefaultReports(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings) />
		
		<cfif ListFind(valuelist(q_select_default_reports.entrykey), arguments.entrykey) GT 0>
			<!--- return the query with the settings of the default report --->
			<cfset stReturn.q_select_report =  SetDefaultReportDefaultSettings(reportkey = arguments.entrykey) />
		<cfelse>
			<!--- custom report --->
			<cfinclude template="queries/q_select_report.cfm">
		
			<cfset stReturn.q_select_report = q_select_report />
		</cfif>
		
		<!--- load further data of report --->
		<cfinclude template="utils/inc_return_report_options.cfm">
		
		<cfreturn stReturn />
	</cffunction>
	
	<!--- create a report --->
	<cffunction access="public" name="CreateReport" returntype="boolean" output="false">
		<cfargument name="reportname" type="string" required="yes">
		<cfargument name="description" type="string" required="yes">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of report">
		<cfargument name="tablekey" type="string" required="yes" hint="tablekey or special words like 'FOLLOWUPS'">
		<cfargument name="crmfilterkey" type="string" required="no" default="" hint="entrykey of crm filter">
		<cfargument name="dt_start" type="date" required="yes" hint="start date">
		<cfargument name="dt_end" type="date" required="yes" hint="end date">
		<cfargument name="date_field" type="string" required="no" default="" hint="name a date field or use dt_created">
		<cfargument name="displayfields" type="string" default="" required="no" hint="list of fields to display ... if empty, display all">
		<cfargument name="specials" type="struct" required="no" default="#StructNew()#" hint="specials operations (make sums ...) ...">
		<cfargument name="interval" type="string" default="week" hint="day,week,month,year">
		<cfargument name="filter" type="struct" default="#StructNew()#" required="no" hint="further simple filters">
		
		<!--- insert into database ... --->
		<cfinclude template="queries/q_insert_crm_report.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="EditReport" returntype="boolean" output="false">
	
	</cffunction>
	
	<!--- // create the standard output // --->
	<!---<cffunction access="public" name="GenerateStandardReportOutput" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="reportkey" type="string" required="yes" hint="entrykey of report">
		<cfargument name="query" 		type="query" 		required="yes" hint="address book query">
		<cfargument name="fieldstodisplay" type="string"	default="" required="no" hint="fields to display (all, if empty)">
		<cfargument name="options" 		type="string" 		default="" required="no" hint="various options">
		<cfargument name="orderby" 		type="string" 		default="" required="no" hint="order by field">
		<cfargument name="desc" 		type="boolean" 		required="no" hint="descending?">
		<cfargument name="format" 		type="string" 		default="html" required="no" hint="html, excel, pdf or xml">
		<cfargument name="fieldnameinformation" type="query" required="no" default="#QueryNew('dummy')#" hint="query holding information about own fields data">
		<cfargument name="fieldtypeinformation" type="struct" required="no" default="#StructNew()#" hint="structure holding the information about the type of the specified field">
		
		<cfset var stReturn = StructNew()>
		<cfset stReturn.content = ''>
		
		<cfinclude template="reports_output/inc_prepare_query.cfm">
		
		<cfswitch expression="#arguments.format#">
			<cfcase value="excel">
			
			</cfcase>
			<cfcase value="xml">
			
			</cfcase>
			<cfcase value="pdf">
			
			</cfcase>			
			<cfdefaultcase>
				<cfinclude template="reports_output/inc_generate_standard_report_output_html.cfm">
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn stReturn>
		
	</cffunction>--->
	
	
	<!--- //
	
		check if the report output database for a certain user exists and if no, create one
		
		// --->
	<!--- <cffunction access="public" name="GetReportDatabaseOfUser" output="false" returntype="string">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		
		<cfset var sEntrykey = ''>
		
		<cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>
		<cfset a_cmp_users = application.components.cmp_user>
		
		<cfset a_str_db_name = 'Reports erstellt von ' & a_cmp_users.getusernamebyentrykey(arguments.securitycontext.myuserkey)>
		
		<cfset a_tmp_database_exists = a_cmp_database.UserDatabaseExists(databasename = a_str_db_name, securitycontext = arguments.securitycontext)>
		
		<cfif a_tmp_database_exists>
			<!--- get entrykey of this database --->			
			<cfreturn a_cmp_database.GetUserDatabaseEntrykeyByDatabasename(databasename = a_str_db_name, securitycontext = arguments.securitycontext)>
		<cfelse>
			<!--- create a new database --->
			<cfset sEntrykey = ReplaceNoCase(CreateUUID(), '-', '', 'ALL')>
			
			<cfinvoke
					component = "#a_cmp_database#"   
					method = "CreateDatabase"   
					returnVariable = "a_struct_info"   
					securitycontext="#arguments.securitycontext#"
					usersettings="#arguments.usersettings#"
					database_name="#a_str_db_name#"
					database_description=""
					entrykey="#sEntrykey#">
			</cfinvoke>
			
			<cfreturn sEntrykey>
		</cfif>
		
	</cffunction> --->
	
	<!--- start generation of a report --->
	<cffunction access="public" name="GenerateReport" output="false" returntype="struct">
		<cfargument name="reportkey" 		type="string" 	required="yes" 	hint="entrykey of report settings">
		<cfargument name="securitycontext" 	type="struct" 	required="yes">
		<cfargument name="usersettings" 	type="struct" 	required="yes">
		<!--- <cfargument name="includefields"	type="string" 	required="no" 	default=""> --->
		<cfargument name="crmfilterkey"		type="string" 	required="no"	default="">
		<cfargument name="options" 			type="struct" 	required="no"	default="#StructNew()#">
		<cfargument name="virtualfields"	type="array"	required="no" 	default="#arrayNew(1)#">
		<!--- <cfargument name="q_select_field_information" type="query" default="#QueryNew('hello')#" hint="query holding information about used fields"> --->
			
		<cfset var stReturn = StructNew() />
		<cfset var sEntrykey = CreateUUID() />
		<cfset var a_tc = GetTickCount() />
		<cfset var a_struct_report_settings = GetReportSettings(entrykey = arguments.reportkey,
											securitycontext = arguments.securitycontext,
											usersettings = arguments.usersettings) />
		
		<!--- entrykey of this unique report --->
		<cfset stReturn.entrykey = sEntrykey />
		
		<cfinclude template="queries/q_insert_crm_report_running.cfm">
		
		<!--- tablekey of the report output (empty if no table is created) --->
		<cfset stReturn.tablekey_of_report_output = ''>
		
		<cfset q_select_report_settings = a_struct_report_settings.q_select_report />
		<cfset a_arr_report_options = a_struct_report_settings.options />
		<cfset stReturn.q_select_report_settings = q_select_report_settings />
		
		<cfinclude template="reports/inc_create_report.cfm">
		
		<!--- save raw data now in the database --->
		<!--- <cfinclude template="utils/inc_save_report_database_wddx.cfm"> --->
		
		<cfinclude template="reports/inc_check_report_finished.cfm">
		
		<cfreturn stReturn>
	</cffunction>
	
	<!--- return the friendly names for the address book fields ... --->
	<cffunction access="public" name="GetFriendlyAddressbookFieldnames" output="false" returntype="struct" hint="return the localized names of various fields">
	
		<cfset var stReturn = StructNew()>
		
		<cfinclude template="utils/inc_return_friendly_addressbook_fieldnames.cfm">
		
		<cfreturn stReturn>
	</cffunction>
	
	<!--- merge report options with crm filters ... --->
	<cffunction access="public" name="MergeCRMFilterWithReportFilter" output="false" returntype="struct">
		<cfargument name="user_options" type="struct" required="yes" hint="submitted by the user (form)">
		<cfargument name="report_options" type="array" required="yes" hint="settings of the report">
		<cfargument name="crm_filter" type="struct" required="yes" hint="the crm filter structure ... ">
		
		<cfset var stReturn = Duplicate(arguments.crm_filter) />
		
		<!--- loop through user submitted options ... --->
		<!--- <cfloop list="#StructKeyList(arguments.user_options)#" index="a_Str_index">
		
			<!--- the value of the option ... --->
			<cfset a_str_option_value = trim(arguments.user_options[a_str_index]) />
		
			<cfloop from="1" to="#ArrayLen(arguments.report_options)#" index="ii">
				
				<!--- check if entrykey is OK and the option to include this filter item as crm filter is set to true --->
				<cfif arguments.report_options[ii].include_crm_filter AND
				 	 (arguments.report_options[ii].include_crm_filter_structure.entrykey IS a_str_index)>
				
					<!--- hit! --->
				
					<!--- check the datatype ... --->
					<cfswitch expression="#arguments.report_options[ii].include_crm_filter_structure.internaldatatype#">
						<cfcase value="0">
							<!--- string --->
							<cfset arguments.report_options[ii].include_crm_filter_structure.comparevalue = a_str_option_value>
						</cfcase>
						<cfcase value="1">
							<!--- integer --->
							<cfset arguments.report_options[ii].include_crm_filter_structure.comparevalue = val(a_str_option_value)>
						</cfcase>
						<cfcase value="3">
							<!--- date --->
							<cfif isDate(a_str_option_value)>
								<cfset arguments.report_options[ii].include_crm_filter_structure.comparevalue = CreateODBCDateTime(LSParseDateTime(a_str_option_value))>
							</cfif>
						</cfcase>				
					</cfswitch>
				
				<cfif Len(arguments.report_options[ii].include_crm_filter_structure.comparevalue) IS 0>
					<!--- use default value if comparevalue is empty ... --->
					<cfset arguments.report_options[ii].include_crm_filter_structure.comparevalue = arguments.report_options[ii].default>
				</cfif>
				
				<!--- now, add virtually to the crm filter structure ... --->
				<cfset stReturn = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stReturn,
												connector = 0,
												operator = 0,
												internalfieldname = arguments.report_options[ii].internalfieldname,
												AddCriteria = arguments.report_options[ii].include_crm_filter_structure) />
			</cfif>
		</cfloop>
	
		</cfloop>	 --->	

		<!--- return the crm filter ... --->
		<cfreturn stReturn />
	</cffunction>
	
	<!--- // return the output table for a report ... // --->
	<!--- <cffunction access="public" name="CreateReportOutputTable" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="reportkey" type="string" required="yes" hint="the entrykey of the report">
		<cfargument name="databasekey" type="string" required="yes" hint="entrykey of database">
		<cfargument name="tablename" type="string" required="yes" hint="name of table">
		<cfargument name="tabledescription" type="string" required="no" default="">
		<cfargument name="q" type="query" required="yes" hint="query holding the data/columns">
		<cfargument name="q_select_fieldnames" required="no" default="#QueryNew('fieldname,showname')#" hint="query holding fieldname/showname (empty by default)">
		<cfargument name="adddata" type="boolean" required="no" default="false" hint="add data to table right now?">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_str_column = ''>
		<cfset var a_str_tablekey = CreateUUID()>
		
		<cfset a_tc_count = GetTickCount()>
		
		<cflog text="starting db output" type="Information" log="Application" file="ib_crm_database">
		
		<cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>
		<cfset request.a_cmp_database = a_cmp_database>
				
		<!--- create table ... --->
		<cfset stReturn.tablekey = a_str_tablekey>
		
		<cfinvoke
				returnvariable="stReturn_create_table"
				component = "#a_cmp_database#"   
				method = "CreateTable"   
				securitycontext="#arguments.securitycontext#"
				usersettings="#arguments.usersettings#"
				table_name="#arguments.tablename#"
				table_description="#arguments.tabledescription#"
				entrykey="#a_str_tablekey#"
				database_entrykey="#arguments.databasekey#"
				reportkey = "#arguments.reportkey#"
				options = "">
		</cfinvoke>		
		
		<cflog text="table created #(GetTickCount() - a_tc_count)#" type="Information" log="Application" file="ib_crm_database">
		
		<!--- select only the columns that are included in the meta table query --->
		<cfset a_str_columns_to_use = ''>
		<cfset a_str_columns_with_meta_information = valueList(q_select_fieldnames.fieldname)>
		
		<cflog text="a_str_columns_with_meta_information: #a_str_columns_with_meta_information#" type="Information" log="Application" file="ib_crm_database">
				
		<cfloop list="#arguments.q.columnlist#" index="a_str_col_name">

			<cfif (ListFindNoCase(a_str_columns_with_meta_information, a_str_col_name) GT 0)
					OR
				  (ListFindNoCase(a_str_columns_with_meta_information, ReplaceNoCase(a_str_col_name, 'db_', '')) GT 0)>
				<cfset a_str_columns_to_use = ListAppend(a_str_columns_to_use, a_str_col_name)>
			<cfelse>
				<cflog text="not found and ignored: #a_str_col_name#" type="Information" log="Application" file="ib_crm_database">
			</cfif>
			
		</cfloop>

		<cfquery name="q_select_table_data" dbtype="query">
		SELECT
			#a_str_columns_to_use#
		FROM
			arguments.q
		;
		</cfquery>
		
		<cflog text="--- a_str_columns_to_use_ #a_str_columns_to_use#" type="Information" log="Application" file="ib_crm_database">
		
		<!--- loop through columns and create them --->		
		<cfloop list="#q_select_table_data.columnlist#" delimiters="," index="a_str_column">
			
			<cflog text="next col: #a_str_column#" type="Information" log="Application" file="ib_crm_database">
		
			<!--- check for friendly column name if meta query exists ... --->

			<!--- default datatype = string --->
			<cfset a_int_fieldtype = 0>			

			<cfif arguments.q_select_fieldnames.recordcount GT 0>

				<cfquery name="q_select_friendly_fieldname" dbtype="query">
				SELECT
					showname,fieldtype
				FROM
					arguments.q_select_fieldnames
				WHERE
					UPPER(fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_column)#">
					OR
					UPPER(fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(ReplaceNoCase(a_str_column, 'db_', ''))#">
					OR
					UPPER(fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(ReplaceNoCase(a_str_column, 'act_', ''))#">					
				;
				</cfquery>
				
				<cflog text="fieldname: #a_str_column#; showname: #q_select_friendly_fieldname.showname#" type="Information" log="Application" file="ib_crm_database">
		
						
				<!--- if a "friendly" fieldname can be found, use this showname --->
				<cfif Len(q_select_friendly_fieldname.showname) GT 0>
					<cfset a_str_column = q_select_friendly_fieldname.showname>
					
					<cfset a_int_fieldtype = q_select_friendly_fieldname.fieldtype>
				</cfif>
			
			<cfelse>
				<!--- check meta data for fieldtype ... --->
				<cfscript>
				// get the field type
				metadata = q_select_table_data.getMetaData();
				metadata.getColumnType(q_select_table_data.findColumn(a_str_column));
				a_str_datatype = q_select_table_data.getColumnTypeName(metadata.getColumnType(q_select_table_data.findColumn(a_str_column)));
				</cfscript>		
				
				
				<cfswitch expression="#a_str_datatype#">
					<cfcase value="varchar">
						<cfset a_int_fieldtype = 0>
					</cfcase>
					<cfcase value="TIMESTAMP">
						<cfset a_int_fieldtype = 5>
					</cfcase>
					<cfcase value="INTEGER">
						<cfset a_int_fieldtype = 1>
					</cfcase>
				</cfswitch>
					
			</cfif>
		
			<!--- add column ... --->
			<cfif ListFindNoCase('entrykey,addressbookkey', a_str_column) IS 0>
				<cfinvoke
						component = "#a_cmp_database#"    
						method = "AddField"   
						returnVariable = "a_bol_addfield"   
						securitycontext="#arguments.securitycontext#"
						usersettings="#arguments.usersettings#"
						table_entrykey="#a_str_tablekey#"
						fieldname="#a_str_column#"
						fieldtype="#a_int_fieldtype#"
						field_entrykey="#CreateUUID()#"
						field_size="255">
					</cfinvoke>	
			</cfif>
			</cfloop>
			
		<cflog text="fields added #(GetTickCount() - a_tc_count)#" type="Information" log="Application" file="ib_crm_database">
		
			
		<!--- add data right now? --->
		<cfif arguments.adddata>
			<cfset stReturn_add_data = AddOutputTableData(securitycontext = arguments.securitycontext, 
												usersettings = arguments.usersettings,
												tablekey = a_str_tablekey,
												q = q_select_table_data,
												q_select_fieldnames = arguments.q_select_fieldnames)>
		</cfif>
		
		<cflog text="data created #(GetTickCount() - a_tc_count)#" type="Information" log="Application" file="ib_crm_database">
		
	
		<cfreturn stReturn>
	</cffunction>
	
	<!--- add the report output to a custom table ... --->
	<cffunction access="public" name="AddOutputTableData" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">	
		<cfargument name="tablekey" type="string" required="yes">
		<cfargument name="q" type="query" required="yes" hint="query holding the data to insert">
		<cfargument name="q_select_fieldnames" required="no" default="#QueryNew('fieldname,showname')#" hint="query holding fieldname/showname (empty by default)">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_arr_add_records = ArrayNew(1)>
		<cfset var a_struct_fieldnames = StructNew()>
		
		<!--- check if the component already has been created --->
		<cfif StructKeyExists(request, 'a_cmp_database')>
			<cfset a_cmp_database = request.a_cmp_database>
		<cfelse>
			<cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>
		</cfif>
		
		<cfinvoke
				component = "#a_cmp_database#"   
				method = "GetTableFields"   
				returnVariable = "q_table_fields"   
				securitycontext="#arguments.securitycontext#"
				usersettings="#arguments.usersettings#"
				table_entrykey="#arguments.tablekey#">
		</cfinvoke>		
		
		<cfloop list="#arguments.q.columnlist#" delimiters="," index="a_str_column">
			<!--- default ... --->
			<cfset a_struct_fieldnames[a_str_column] = a_str_column>
			
			<cfif q_select_fieldnames.recordcount GT 0>
			
				<cfquery name="q_select_friendly_fieldname" dbtype="query">
				SELECT
					showname
				FROM
					arguments.q_select_fieldnames
				WHERE
					UPPER(fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_column)#">
					OR
					UPPER(fieldname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(ReplaceNoCase(a_str_column, 'db_', ''))#">
				;
				</cfquery>	
				
				
				<cfquery name="q_select_fieldname" dbtype="query">
				SELECT
					fieldname
				FROM
					q_table_fields
				WHERE
					<!--- try to select by using the friendly column name ... --->
					UPPER(showname) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(q_select_friendly_fieldname.showname)#">
				;
				</cfquery>						
				
				<cfset a_struct_fieldnames[a_str_column] = q_select_fieldname.fieldname>
				
			</cfif>
		</cfloop>
		
		<cfoutput query="arguments.q">
			<!--- the structure holding the data of the current record ... --->
			<cfset a_arr_add_records[ArrayLen(a_arr_add_records) + 1 ] = StructNew()>
	
			<cfset a_int_current_array_index = ArrayLen(a_arr_add_records)>
	
			<cfloop list="#arguments.q.columnlist#" delimiters="," index="a_str_column">
	
				<cfset a_arr_add_records[a_int_current_array_index][a_struct_fieldnames[a_str_column]] = arguments.q[a_str_column][arguments.q.currentrow]>
		
			</cfloop>

		</cfoutput>
		
		<!--- call add data ... --->
		<cfinvoke
				component = "#a_cmp_database#"   
				method = "AddMultipleRecordsAtOnce"   
				returnVariable = "a_struct_info"   
				securitycontext="#arguments.securitycontext#"
				usersettings="#arguments.usersettings#"
				table_entrykey="#arguments.tablekey#"
				record_data="#a_arr_add_records#">
				
			<cfreturn stReturn>
	</cffunction> --->
		
</cfcomponent>

