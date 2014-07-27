<!---//

	output of activities
	
	// --->
	
<!--- which types of activities should we include?

	if this string is empty, all
	--->

<!--- <cfif Len(arguments.options.meta_type) IS 0>
	<cfset arguments.options.meta_type = 'events,appointments,followups,tasks'>
</cfif> 

<cflog text="types to include: #arguments.options.meta_type#" type="Information" log="Application" file="ib_crm_reports">--->


<cfset a_cmp_crmsales = application.components.cmp_crmsales>
<cfset a_cmp_users = application.components.cmp_user>
<cfset a_cmp_translation = application.components.cmp_lang>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_userdata">
	<cfinvokeargument name="entrykey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<cfset q_select_user = a_struct_userdata.query>
<cfset iLangNo = a_struct_userdata.query.defaultlanguage>

<!--- string holding the items to load --->
<cfset sEntrykeys_of_contacts_2_load = 'thisitemdoesnotexit'>

<!--- always create a temp filter when selecting criterias --->
<cfinvoke component="#a_cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="viewkey" value="#arguments.crmfilterkey#">
</cfinvoke>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_struct_crm_filter" type="html">
<cfdump var="#a_struct_crm_filter#">
</cfmail>--->

<!--- add possible options now to the crm filter structure ... --->
<cfinvoke component="/components/crmsales/crm_reports" method="MergeCRMFilterWithReportFilter" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="user_options" value="#arguments.options#">
	<cfinvokeargument name="report_options" value="#a_arr_report_options#">
	<cfinvokeargument name="crm_filter" value="#a_struct_crm_filter#">
</cfinvoke>

<cfset a_struct_crm_bindings = a_cmp_crmsales.GetCRMSalesBinding(companykey = request.stSecurityContext.mycompanykey)>
<cfset a_str_crm_databasekey = a_struct_crm_bindings.databasekey> 

<!--- check the options ... --->
<cfset a_str_option_date_start = arguments.options.dt_start>
<cfset a_str_option_date_end = arguments.options.dt_end>

<cflog text="arguments.options.dt_start: #arguments.options.dt_start#" type="Information" log="Application" file="ib_crm_reports">
<cflog text="a_str_option_date_end: #a_str_option_date_end#" type="Information" log="Application" file="ib_crm_reports">


<!--- check start and end date --->
<cfif IsDate(a_str_option_date_start)>
	<cfset a_dt_option_start_date = LSParseDateTime(a_str_option_date_start)>
<cfelse>
	<cfset a_dt_option_start_date = DateAdd('h', -90, Now())>
</cfif>

<cfif IsDate(a_str_option_date_end)>
	<cfset a_dt_option_start_end = LSParseDateTime(a_str_option_date_end)>
<cfelse>
	<cfset a_dt_option_start_end = Now()>
</cfif>

<!--- start/end date (timeframe) --->

<cflog text="timeframe begin: #a_dt_option_start_date#" type="Information" log="Application" file="ib_crm_reports">
<cflog text="timeframe end: #a_dt_option_start_end#" type="Information" log="Application" file="ib_crm_reports">

<!--- fixed option ... --->
<cfset a_str_option_createdbyuserkey = arguments.options.db_userentrykey_created>

<cfset a_struct_options_query = StructNew()>


<!--- create the output query ...

	fields:
	
	a) the selected fields by the user
	b) various fields for certain datatypes, e.g. dt_due for tasks

	--->

<cfset a_str_types = ''>

<cfloop list="#arguments.includefields#" delimiters="," index="a_Str_fieldname">
	<cfset a_str_types = ListAppend(a_str_types, 'Varchar')>
</cfloop>

<!--- create output table ... only with varchar type for easier access --->
<cfset q_select_data = QueryNew(arguments.includefields, a_str_types)>

<!--- // include now the various datatypes ... --->
<cfinclude template="AC329E6-F963-096F-4EAE7C2041262777/inc_activities_events.cfm">

<cfinclude template="AC329E6-F963-096F-4EAE7C2041262777/inc_activities_appointments.cfm">

<cfinclude template="AC329E6-F963-096F-4EAE7C2041262777/inc_activities_tasks.cfm">

<cfinclude template="AC329E6-F963-096F-4EAE7C2041262777/inc_activities_followups.cfm">



<!--- make sure that *no* contact is loaded if no exists --->
<cfif Len(sEntrykeys_of_contacts_2_load) IS 0>
	<cfset sEntrykeys_of_contacts_2_load = 'dummyloadnocontactatall'>
</cfif>

<!--- use all rows --->
<cfset a_struct_loadoptions = StructNew()>
<cfset a_struct_loadoptions.maxrows = 0>

<cfset a_struct_filter = StructNew()>
<!---<cfset a_struct_filter.NoArchiveItems = true>--->

<!--- set the entrykeys of the contacts which should be loaded --->
<cfset a_struct_filter.entrykeys = sEntrykeys_of_contacts_2_load>

<cflog text="number of contacts to load: #ListLen(sEntrykeys_of_contacts_2_load)#" type="Information" log="Application" file="ib_crm_reports">

<cflog text="loading contacts: #(GetTickCount() - a_tc)#" type="Information" log="Application" file="ib_crm_reports">

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="fieldlist" value="#arguments.includefields#">
</cfinvoke>

<cflog text="contacts loaded: #(GetTickCount() - a_tc)#; #stReturn_contacts.q_select_contacts.recordcount# records" type="Information" log="Application" file="ib_crm_reports">

<cfset q_select_contacts = stReturn_contacts.q_select_contacts>
<!--- <cfset q_select_fieldnames_of_contacts_table = stReturn_contacts.q_select_table_fields> --->

<!--- get unique users to create structure holding their names --->
<cfquery name="q_select_unique_users_who_have_created_items" dbtype="query">
SELECT
	DISTINCT(virt_createdbyuserkey) AS distinct_userkey
FROM
	q_select_data
;
</cfquery>

<cfset a_struct_unique_userkeys = StructNew()>

<cfloop query="q_select_unique_users_who_have_created_items">
	<cfset a_struct_unique_userkeys[q_select_unique_users_who_have_created_items.distinct_userkey] = a_cmp_users.GetFullNameByentrykey(q_select_unique_users_who_have_created_items.distinct_userkey)>
</cfloop>


<!--- fill output data now --->
<cfloop query="q_select_data">
	
	<!--- set data fields based on address book table --->
	<cfset a_str_addressbook_key = q_select_data.addressbookkey>
	
	<cfquery name="q_select_current_contact" dbtype="query">
	SELECT
		*
	FROM
		q_select_contacts
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_addressbook_key#">
	;
	</cfquery>
	
	<cfif q_select_current_contact.recordcount IS 1>
		<!--- set data --->
		<cfloop list="#q_select_data.columnlist#" index="a_str_col_name">
		
			<cfif ListFindNoCase(q_select_current_contact.columnlist, a_str_col_name) GT 0>
				<cfset QuerySetCell(q_select_data, a_str_col_name, q_select_current_contact[a_str_col_name][1], q_select_data.currentrow)>
			</cfif>
		
		</cfloop>	
	</cfif>
	
	<!--- update userkey to username --->
	<cfset QuerySetCell(q_select_data, 'virt_createdbyuserkey', a_struct_unique_userkeys[q_select_data.virt_createdbyuserkey], q_select_data.currentrow)>

</cfloop>

<cflog text="looped over contact data: #(GetTickCount() - a_tc)#" type="Information" log="Application" file="ib_crm_reports">

<!--- <cfset q_select_fields_information_2_display = arguments.q_select_field_information> --->

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="report done" type="html">
	<cfdump var="#q_select_data#">
	<cfdump var="#q_select_fields_information_2_display#">
</cfmail>--->

<cfinvoke component="/components/crmsales/crm_reports" method="CreateReportOutputTable" returnvariable="stReturn_create_output_table">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="reportkey" value="#q_select_report_settings.entrykey#">
	<cfinvokeargument name="databasekey" value="#a_str_databasekey_for_report#">
	<cfinvokeargument name="tablename" value="#GetLangVal('crm_ph_report_output_table_name_begin')# #q_select_report_settings.reportname# (#DateFormat(now(), arguments.usersettings.default_Dateformat)# #TimeFormat(now(), 'HH:mm')#)">
	<cfinvokeargument name="tabledescription" value="#GetLangVal('cm_ph_created_by')# #a_cmp_users.getusernamebyentrykey(arguments.securitycontext.myuserkey)#">
	<cfinvokeargument name="q" value="#q_select_data#">
	<cfinvokeargument name="q_select_fieldnames" value="#variables.q_select_fields_information_2_display#">
	<cfinvokeargument name="adddata" value="true">
</cfinvoke>

<cflog text="report output created (new database created): #(GetTickCount() - a_tc)#" type="Information" log="Application" file="ib_crm_reports">

<cfset stReturn.tablekey_of_report_output = stReturn_create_output_table.tablekey>