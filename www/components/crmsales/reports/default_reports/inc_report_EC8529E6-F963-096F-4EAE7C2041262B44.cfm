<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_filter = StructNew()>

<cfset a_cmp_database = CreateObject('component', request.a_str_component_database)>
<cfset a_cmp_crmsales = application.components.cmp_crmsales>
<cfset a_cmp_users = application.components.cmp_user>

<!--- always create a temp filter when selecting criterias --->
<cfinvoke component="#a_cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="viewkey" value="#arguments.crmfilterkey#">
</cfinvoke>

<!--- add possible options now to the crm filter structure ... --->
<cfinvoke component="/components/crmsales/crm_reports" method="MergeCRMFilterWithReportFilter" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="user_options" value="#arguments.options#">
	<cfinvokeargument name="report_options" value="#a_arr_report_options#">
	<cfinvokeargument name="crm_filter" value="#a_struct_crm_filter#">
</cfinvoke>

<cfset a_struct_crm_bindings = a_cmp_crmsales.GetCRMSalesBinding(companykey = request.stSecurityContext.mycompanykey)>
<cfset a_str_crm_databasekey = a_struct_crm_bindings.databasekey> 

<!--- use all rows --->
<cfset a_struct_loadoptions.maxrows = 0>

<!--- ignore archive items ... --->
<cfset a_struct_filter.NoArchiveItems = true>

<!--- load contacts ... order by which column??? --->	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
	<!--- load crm data at once without manual reloads --->
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="fieldlist" value="#arguments.includefields#">
</cfinvoke>

<cfset q_select_fieldnames_of_contacts_table = stReturn_contacts.q_select_table_fields>


<!--- create output table ... --->
<cfinvoke component="/components/crmsales/crm_reports" method="CreateReportOutputTable" returnvariable="stReturn_create_output_table">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="reportkey" value="#q_select_report_settings.entrykey#">
	<cfinvokeargument name="databasekey" value="#a_str_databasekey_for_report#">
	<cfinvokeargument name="tablename" value="#GetLangVal('crm_ph_report_output_table_name_begin')# #q_select_report_settings.reportname# (#DateFormat(now(), 'dd.mm.yy')# #TimeFormat(now(), 'hhmm')#)">
	<cfinvokeargument name="tabledescription" value="#GetLangVal('cm_ph_created_by')# #a_cmp_users.getusernamebyentrykey(arguments.securitycontext.myuserkey)#">
	<cfinvokeargument name="q" value="#stReturn_contacts.q_select_contacts#">
	<cfinvokeargument name="q_select_fieldnames" value="#q_select_fieldnames_of_contacts_table#">
	<cfinvokeargument name="adddata" value="true">
</cfinvoke>

<cfset stReturn.tablekey_of_report_output = stReturn_create_output_table.tablekey>