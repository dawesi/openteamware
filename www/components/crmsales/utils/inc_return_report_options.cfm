<!---
			datatype
			0 = string
			1 = integer
			3 = date
			4 = ?
			--->

<cfset a_cmp_translation = application.components.cmp_lang />
<cfset iLangNo = arguments.usersettings.language />


<!--- optionen für diesen report --->
<cfset stReturn.options = ArrayNew(1)>
<!--- virtual fields for this report --->
<cfset stReturn.virtualfields = ArrayNew(1)>

<!--- allow select an interval? --->
<cfset stReturn.AllowSelectInterval = true>

<!--- create a chart by default? --->
<cfset stReturn.DefaultCreateChart = false>

<cfset stReturn.ChartOutputProperties = StructNew()>

<cfswitch expression="#arguments.entrykey#">
	<cfcase value="4EF24192-0626-7F32-E81AD993A04AB881">
	
		<!--- growth of contacts ... --->
		<!--- edited: field values are now included as CRM filter
			so that only contacts form the desired range are included --->
			
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_start', langno = iLangNo),
									entrykey = 'dt_start',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_report_restrict_date', langno = iLangNo),
									datatype = 3,
									default = DateAdd('d', -30, Now()),
									include_crm_filter = true,
									crm_filter_internalfieldname = 'dt_created',
									crm_filter_area = 2,
									crm_filter_operator = 2,
									crm_filter_connector = 0)>	
		
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_end', langno = iLangNo),
									entrykey = 'dt_end',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_report_restrict_date', langno = iLangNo),
									datatype = 3,
									default = DateAdd('d', 1, Now()),
									include_crm_filter = true,
									crm_filter_internalfieldname = 'dt_created',
									crm_filter_area = 2,
									crm_filter_operator = 3,
									crm_filter_connector = 0)>	
		
		<!--- who has created the data? --->
		<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>		
		
			<cfquery name="q_select_users" dbtype="query">
			SELECT
				*
			FROM
				q_select_users
			<cfif arguments.securitycontext.iscompanyadmin NEQ 1>
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
			</cfif>	
			ORDER BY
				surname,firstname
			;		
			</cfquery>		
			
			<cfset a_arr_users = ArrayNew(1)>
			
			<cfif arguments.securitycontext.iscompanyadmin IS 1>
				<cfset a_arr_users[1] = StructNew()>
				<cfset a_arr_users[1].key = ''>
				<cfset a_arr_users[1].value = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_all', langno = iLangNo)>		
			</cfif>
			
			<!--- add users ... --->			
			<cfoutput query="q_select_users">			
				<cfset a_arr_users[(ArrayLen(a_arr_users) + 1)] = StructNew()>
				<cfset a_arr_users[ArrayLen(a_arr_users)].key = q_select_users.entrykey>
				<cfset a_arr_users[ArrayLen(a_arr_users)].value = q_select_users.surname & ', ' & q_select_users.firstname & ' (' & q_select_users.username & ')'>
			</cfoutput>				
			
			
		<!--- add fix option with real name of database field ... --->
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_user', langno = iLangNo),
									entrykey = 'db_userentrykey_created',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_reports_user_who_has_created_an_item', langno = iLangNo),
									datatype = 0,
									select_options = a_arr_users,
									allow_multi_select_options = false,
									include_crm_filter = true,
									crm_filter_internalfieldname = 'createdbyuserkey',
									crm_filter_area = 2,
									crm_filter_operator = 0,
									crm_filter_connector = 0)>
									
		<!--- what's the create date? --->				
		<cfset a_arr_options[1] = StructNew()>
		<cfset a_arr_options[1].key = 'dt_created'>
		<cfset a_arr_options[1].value = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_reports_create_date', langno = iLangNo)>	
							
		<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>
		
		
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_reports_create_date', langno = iLangNo),
									entrykey = 'meta_create_date_field',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_reports_create_date_description', langno = iLangNo),
									datatype = 1,
									allow_multi_select_options = false,
									select_options = a_arr_options,
									include_crm_filter = false)>				
									
		<!---
		<cfset a_arr_options = ArrayNew(1)>
		<cfset a_arr_options[1] = StructNew()>
		<cfset a_arr_options[1].key = 'week'>
		<cfset a_arr_options[1].value = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_week', langno = iLangNo)>
		
		<cfset a_arr_options[ArrayLen(a_arr_options) + 1 ] = StructNew()>
		<cfset a_arr_options[ArrayLen(a_arr_options)].key = 'month'>
		<cfset a_arr_options[ArrayLen(a_arr_options)].value = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_month', langno = iLangNo)>
		
		<cfset a_arr_options[ArrayLen(a_arr_options) + 1 ] = StructNew()>
		<cfset a_arr_options[ArrayLen(a_arr_options)].key = 'day'>
		<cfset a_arr_options[ArrayLen(a_arr_options)].value = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_day', langno = iLangNo)>
		
		<!--- add the select field with prefix "db_" so that the response page knows what to do with this option --->
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_interval', langno = iLangNo),
									entrykey = 'meta_interval',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_reports_interval_description', langno = iLangNo),
									datatype = 1,
									allow_multi_select_options = false,
									select_options = a_arr_options,
									include_crm_filter = false)>											
									
		<cfset stReturn.AllowSelectInterval = false>			--->	
		
		<!---
		<cfset stReturn.DefaultCreateChart = true>

		<cfset stReturn.ChartOutputProperties.type = 'bar'>
		<cfset stReturn.ChartOutputProperties.height = 400>
		<cfset stReturn.ChartOutputProperties.width = 800>
		<cfset stReturn.ChartOutputProperties.showlegend = false>
		
		<cfset stReturn.ChartOutputProperties.chartseries = ArrayNew(1)>
		
		<cfset stReturn.ChartOutputProperties.chartseries[1] = StructNew()>
		<cfset stReturn.ChartOutputProperties.chartseries[1].itemcolumn = 'Zeitpunkt'>
		<cfset stReturn.ChartOutputProperties.chartseries[1].valuecolumn = '%'>									
		--->
	</cfcase>
	<cfcase value="AC329E6-F963-096F-4EAE7C2041262777">
		<!--- overview of acitivties --->
		
		<!--- load fields of activities table ... --->
		
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_start', langno = iLangNo),
									entrykey = 'dt_start',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_report_restrict_date', langno = iLangNo),
									datatype = 3,
									default = DateAdd('d', -90, Now()),
									include_crm_filter = false)>
		
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_end', langno = iLangNo),
									entrykey = 'dt_end',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_report_restrict_date', langno = iLangNo),
									datatype = 3,
									default = DateAdd('d', 1, Now()),
									include_crm_filter = false)>
																		
		<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>		
		
			<cfquery name="q_select_users" dbtype="query">
			SELECT
				*
			FROM
				q_select_users
			<cfif arguments.securitycontext.iscompanyadmin NEQ 1>
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
			</cfif>
							
			ORDER BY
				surname,firstname
			;		
			</cfquery>		
			
			<cfset a_arr_users = ArrayNew(1)>
			
			<cfif arguments.securitycontext.iscompanyadmin IS 1>
				<cfset a_arr_users[1] = StructNew()>
				<cfset a_arr_users[1].key = ''>
				<cfset a_arr_users[1].value = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_all', langno = iLangNo)>		
			</cfif>
			
			<!--- add users ... --->			
			<cfoutput query="q_select_users">			
				<cfset a_arr_users[(ArrayLen(a_arr_users) + 1)] = StructNew()>
				<cfset a_arr_users[ArrayLen(a_arr_users)].key = q_select_users.entrykey>
				<cfset a_arr_users[ArrayLen(a_arr_users)].value = q_select_users.surname & ', ' & q_select_users.firstname & ' (' & q_select_users.username & ')'>
			</cfoutput>		
			
		<!--- add fix option with real name of database field ... --->
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_user', langno = iLangNo),
									entrykey = 'db_userentrykey_created',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_reports_user_who_has_created_an_item', langno = iLangNo),
									datatype = 0,
									select_options = a_arr_users,
									allow_multi_select_options = true,
									include_crm_filter = false)>
									
		<!--- load fields of activities table ... --->
		<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>
		
		<!--- <cfif Len(a_struct_crmsales_bindings.activities_tablekey) GT 0>
			
			<cfinvoke
					component = "#request.a_str_component_database#"   
					method = "GetTableFields"   
					returnVariable = "q_table_fields"   
					securitycontext="#arguments.securitycontext#"
					usersettings="#arguments.usersettings#"
					table_entrykey="#a_struct_crmsales_bindings.activities_tablekey#"></cfinvoke>
					
				
				
			<!--- loop through fields --->
			<cfloop query="q_table_fields">
			
				<cfset a_bol_visible = ListFindNoCase('entrykey,addressbookkey', q_table_fields.showname) IS 0>
			
				<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
											fieldname = q_table_fields.showname,
											datatype = q_table_fields.fieldtype,
											entrykey = 'virt_' & q_table_fields.fieldname,
											selected = true,
											internal_fieldname = q_table_fields.fieldname,
											fixed = false,
											visible = a_bol_visible)>
											
			
			</cfloop>
			
			<cfset a_arr_options[1] = StructNew()>
			
			
			<cfset a_arr_options[1].key = ''>
			<cfset a_arr_options[1].value = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_all', langno = iLangNo)>		
			
			<cfset a_arr_options[(ArrayLen(a_arr_options) + 1)] = StructNew()>
			<cfset a_arr_options[ArrayLen(a_arr_options)].key = 'appointments'>
			<cfset a_arr_options[ArrayLen(a_arr_options)].value = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_events', langno = iLangNo)>
			
			<cfset a_arr_options[(ArrayLen(a_arr_options) + 1)] = StructNew()>
			<cfset a_arr_options[ArrayLen(a_arr_options)].key = 'tasks'>
			<cfset a_arr_options[ArrayLen(a_arr_options)].value = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_tasks', langno = iLangNo)>
			
			<cfset a_arr_options[(ArrayLen(a_arr_options) + 1)] = StructNew()>
			<cfset a_arr_options[ArrayLen(a_arr_options)].key = 'events'>
			<cfset a_arr_options[ArrayLen(a_arr_options)].value = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_events', langno = iLangNo)>	
			
			<cfset a_arr_options[(ArrayLen(a_arr_options) + 1)] = StructNew()>
			<cfset a_arr_options[ArrayLen(a_arr_options)].key = 'followups'>
			<cfset a_arr_options[ArrayLen(a_arr_options)].value = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_follow_ups', langno = iLangNo)>
						
			<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
										name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_type', langno = iLangNo),
										entrykey = 'meta_type',
										description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_report_select_which_Types_to_include', langno = iLangNo),
										datatype = 0,
										allow_multi_select_options = true,
										select_options = a_arr_options,
										include_crm_filter = false)>	

			<!--- when has the item be created? --->
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_created', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_itemcreated',
										selected = true,
										internal_fieldname = 'ITEM_DT_CREATED',
										fixed = true,
										visible = true)>				
			
			<!--- item_type --->
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_type', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_itemtype',
										selected = true,
										internal_fieldname = 'ITEM_TYPE',
										fixed = true,
										visible = true)>		
										
			<!--- calendar fields --->
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_start', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_date_start',
										selected = true,
										internal_fieldname = 'DATE_START',
										fixed = true,
										visible = true)>
										
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_end', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_date_end',
										selected = true,
										internal_fieldname = 'DATE_END',
										fixed = true,
										visible = true)>						
										
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cal_wd_location', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_location',
										selected = true,
										internal_fieldname = 'LOCATION',
										fixed = true,
										visible = true)>			
										
			<!--- tasks --->
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_status', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_task_status',
										selected = true,
										internal_fieldname = 'task_status',
										fixed = true,
										visible = true)>					

			<!--- common: subject + description --->
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_subject', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_subject',
										selected = true,
										internal_fieldname = 'SUBJECT',
										fixed = true,
										visible = true)>			
										
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_description', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_description',
										selected = true,
										internal_fieldname = 'DESCRIPTION',
										fixed = true,
										visible = true)>															
																
										
			<!--- add userkey field  manually ... --->
			<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
										fieldname = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_creator', langno = iLangNo),
										datatype = 0,
										entrykey = 'virt_createdbyuserkey',
										selected = true,
										internal_fieldname = 'USERENTRYKEY_CREATED',
										fixed = true,
										visible = true)>			
		
		</cfif> --->
	</cfcase>
	<cfcase value="35B59D8F-F002-C2F9-E9B1F98AF2B1F293">
		<!--- overdue followups ... --->
		<cfset stReturn.AllowSelectInterval = false>
		
		<!--- virtual fields (filled by report) --->
		<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
									fieldname = a_cmp_translation.GetLangValExt(entryid = 'tsk_wd_due', langno = iLangNo),
									datatype = 3,
									entrykey = 'virt_39B1C935F817C5D031496304AC88348F',
									internal_fieldname = 'dt_due',
									selected = true,
									fixed = true)>
									
		<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
									fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_days', langno = iLangNo),
									datatype = 1,
									entrykey = 'virt_55B1kklk17C5D031496304AC88werwer',
									selected = false,
									fixed = false)>
		
		<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
									fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_type', langno = iLangNo),
									datatype = 0,
									entrykey = 'virt_39B385130C384092805A28109057DA86',
									internal_fieldname = 'followuptype',
									selected = true,
									fixed = false)>
																				
		<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
									fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_user', langno = iLangNo),
									datatype = 0,
									entrykey = 'virt_9vuwh513_0C384092805A28109057DA86',
									internal_fieldname = 'userkey',
									selected = true,
									fixed = true)>
																				
		<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
									fieldname = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_comment', langno = iLangNo),
									datatype = 0,
									entrykey = 'virt_kfi485130C384092805A28109057DA86',
									internal_fieldname = 'comment',
									selected = true,
									fixed = false)>			
																																					
		<cfset stReturn.virtualfields = AddReportPropertiesVirtualField(ArrayOfFields = stReturn.virtualfields,
									fieldname = a_cmp_translation.GetLangValExt(entryid = 'crm_wd_creator', langno = iLangNo),
									datatype = 0,
									entrykey = 'virt_d90dfgh20C384092805A28109057DA86',
									internal_fieldname = 'createdbyuserkey',
									selected = true,
									fixed = false)>		
		
		<!--- options ... --->
		
		
		<!--- a) user for which the follow up item has been created ... --->
		
		<cfset a_arr_users = ArrayNew(1)>
		
			<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
				<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
			</cfinvoke>		
		
			<cfquery name="q_select_users" dbtype="query">
			SELECT
				*
			FROM
				q_select_users
			<cfif arguments.securitycontext.iscompanyadmin NEQ 1>
			WHERE
				entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
			</cfif>				
			ORDER BY
				surname,firstname
			;		
			</cfquery>	
			
			<cfset a_arr_users = ArrayNew(1)>
			
			<cfif arguments.securitycontext.iscompanyadmin IS 1>
				<cfset a_arr_users[1] = StructNew()>
				<cfset a_arr_users[1].key = ''>
				<cfset a_arr_users[1].value = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_all', langno = iLangNo)>		
			</cfif>
			
			<!--- add users ... --->			
			<cfoutput query="q_select_users">			
				<cfset a_arr_users[(ArrayLen(a_arr_users) + 1)] = StructNew()>
				<cfset a_arr_users[ArrayLen(a_arr_users)].key = q_select_users.entrykey>
				<cfset a_arr_users[ArrayLen(a_arr_users)].value = q_select_users.surname & ', ' & q_select_users.firstname & ' (' & q_select_users.username & ')'>
			</cfoutput>			
			
			
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_user', langno = iLangNo),
									entrykey = 'followup_userkey',
									description = '',
									datatype = 0,
									select_options = a_arr_users,
									include_crm_filter = true,
									crm_filter_internalfieldname = 'followup_userkey',
									crm_filter_area = 0,
									crm_filter_operator = 0,
									crm_filter_connector = 0)>
									
		<cfset a_arr_types = ArrayNew(1)>
		
		<cfset a_arr_types = AddReportPropertiesOptionSelectboxOption(a_arr_types, '', 'Alle')>
		<cfset a_arr_types = AddReportPropertiesOptionSelectboxOption(a_arr_types, 'email', 'E-Mail')>
		<cfset a_arr_types = AddReportPropertiesOptionSelectboxOption(a_arr_types, 'call', 'Anruf')>
									
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_type', langno = iLangNo),
									entrykey = 'followup_type',
									description = '',
									datatype = 0,
									select_options = a_arr_types,
									include_crm_filter = true,
									crm_filter_internalfieldname = 'followup_type',
									crm_filter_area = 0,
									crm_filter_operator = 0,
									crm_filter_connector = 0,
									allow_multi_select_options = false)>
									
		<!--- dt_due ... do not display this as option ... --->
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = 'dt_due',
									entrykey = 'followup_dt_due',
									description = 'dt_due of followup job',
									datatype = 3,
									default = Now(),
									include_crm_filter = true,
									crm_filter_internalfieldname = 'followup_dt_due',
									crm_filter_area = 0,
									crm_filter_operator = 0,
									crm_filter_connector = 3,
									visible = false)>			
									
		<!--- status? NOT null --->
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_wd_status', langno = iLangNo),
									entrykey = 'followup_status',
									description = 'status of followup job',
									datatype = 1,
									default = 0,
									include_crm_filter = true,
									crm_filter_internalfieldname = 'followup_status',
									crm_filter_area = 0,
									crm_filter_operator = 0,
									crm_filter_connector = 0,
									visible = false)>								
		
	</cfcase>
	<cfcase value="EC8529E6-F963-096F-4EAE7C2041262B44">
		<!--- options for the inactive report type ... the only setting is which date should be used ... --->
		
		<cfset stReturn.options = AddReportPropertiesOption(ArrayOfOptions = stReturn.options,
									name = a_cmp_translation.GetLangValExt(entryid = 'cm_ph_timestamp', langno = iLangNo),
									entrykey = '348D121A-CEF8-7B16-4EF057E40D992427',
									description = a_cmp_translation.GetLangValExt(entryid = 'crm_ph_report_lastcontact_timestamp_description', langno = iLangNo),
									datatype = 3,
									default = DateAdd('d', -60, Now()),
									include_crm_filter = true,
									crm_filter_internalfieldname = 'dt_lastcontact',
									crm_filter_area = 2,
									crm_filter_operator = 3,
									crm_filter_connector = 0)>		
				
	</cfcase>
	
	<cfcase value="ECC429C2-E237-F73F-E6233C1656C80378">
		<!--- no options ... share by country --->
		<cfset stReturn.AllowSelectInterval = false>				
		
		<cfset stReturn.DefaultCreateChart = true>

		<cfset stReturn.ChartOutputProperties.type = 'pie'>
		<cfset stReturn.ChartOutputProperties.height = 400>
		<cfset stReturn.ChartOutputProperties.width = 600>
		<cfset stReturn.ChartOutputProperties.showlegend = true>
		
		<cfset stReturn.ChartOutputProperties.chartseries = ArrayNew(1)>
		
		<cfset stReturn.ChartOutputProperties.chartseries[1] = StructNew()>
		<cfset stReturn.ChartOutputProperties.chartseries[1].itemcolumn = a_cmp_translation.GetLangValExt(entryid = 'adrb_wd_country', langno = iLangNo)>
		<cfset stReturn.ChartOutputProperties.chartseries[1].valuecolumn = '%'>
		
	</cfcase>
	
	<cfdefaultcase>
		<!--- any custom report --->
		
		<cfif Len(stReturn.q_Select_report.date_field) GT 0>
		
			<!--- //
			
				if a date field is given, allow to select start/end date
				
				// --->
				
			<cfset stReturn.options[1] = StructNew()>
			<cfset stReturn.options[1].name = 'Start'>
			<cfset stReturn.options[1].entrykey = '543D121A-CEF8-7B44-4EF057E40D992427'>			
			<cfset stReturn.options[1].description = ''>
			<cfset stReturn.options[1].datatype = 3>
			<cfset stReturn.options[1].default = DateAdd('d', -360, Now())>
			<cfset stReturn.options[1].options = ''>
			<cfset stReturn.options[1].value = ''>
			<cfset stReturn.options[1].include_crm_filter = false>
		
			<cfset stReturn.options[2] = StructNew()>
			<cfset stReturn.options[2].name = 'Ende'>
			<cfset stReturn.options[2].entrykey = '768D121A-CEF8-7B16-4EF057E40D992427'>
			<cfset stReturn.options[2].description = ''>
			<cfset stReturn.options[2].datatype = 3>
			<cfset stReturn.options[2].default = Now()>
			<cfset stReturn.options[1].options = ''>
			<cfset stReturn.options[2].value = ''>
			<cfset stReturn.options[1].include_crm_filter = false>
		</cfif>
		
	</cfdefaultcase>

</cfswitch>