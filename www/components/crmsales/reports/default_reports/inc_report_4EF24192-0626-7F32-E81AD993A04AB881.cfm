<!--- //

	Module:		CRM/reports
	Description:growth of customers (Kundenzuwachs)
	

// --->
	
<cflog text="starting generation: #(GetTickCount() - a_tc)#" type="Information" log="Application" file="ib_crm_reports">

<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_filter = StructNew() />
<cfset a_cmp_crmsales = application.components.cmp_crmsales />
<cfset a_cmp_users = application.components.cmp_user />
<cfset a_cmp_translation = application.components.cmp_lang />

<cfset q_select_user = application.components.cmp_user.GetUserData(arguments.securitycontext.myuserkey) />
<cfset iLangNo = q_select_user.defaultlanguage />

<!--- check the options ... --->

<!--- user who has created the item --->
<cfset a_str_option_createdbyuserkey = arguments.options.db_userentrykey_created />

<!--- start/end --->
<cfset a_str_option_date_start = arguments.options.dt_start />
<cfset a_str_option_date_end = arguments.options.dt_end />

<cfif IsDate(a_str_option_date_start)>
	<cfset a_dt_option_start_date = LsParseDateTime(a_str_option_date_start) />
<cfelse>
	<cfset a_dt_option_start_date = DateAdd('h', -90, Now()) />
</cfif>

<cfif IsDate(a_str_option_date_end)>
	<cfset a_dt_option_start_end = LsParseDateTime(a_str_option_date_end) />
<cfelse>
	<cfset a_dt_option_start_end = Now() />
</cfif>

<!---<cfset a_str_interval = arguments.options.meta_interval>--->

<cflog text="a_dt_option_start_date: #a_dt_option_start_date#" type="Information" log="Application" file="ib_crm_reports">
<cflog text="a_str_option_date_end: #a_str_option_date_end#" type="Information" log="Application" file="ib_crm_reports">


<cflog text="building crm filter structure: #(GetTickCount() - a_tc)#" type="Information" log="Application" file="ib_crm_reports">


<!--- always create a temp filter when selecting criterias --->
<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="viewkey" value="#arguments.crmfilterkey#">
</cfinvoke>

<!--- dt_created ... greather than --->
<cfset a_struct_crm_filter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = a_struct_crm_filter,
									operator = 3,
									internalfieldname = 'dt_created',
									comparevalue = a_dt_option_start_date) />
									
<!--- smaller than ... --->
<cfset a_struct_crm_filter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = a_struct_crm_filter,
									operator = 4,
									internalfieldname = 'dt_created',
									comparevalue = a_dt_option_start_end) />
									
<!--- created by userkey ... --->
<cfif Len(a_str_option_createdbyuserkey) GT 0>
	<cfset a_struct_crm_filter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = a_struct_crm_filter,
										operator = 0,
										internalfieldname = 'createdbyuserkey',
										comparevalue = a_str_option_createdbyuserkey) />
</cfif>

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_struct_crm_filter" type="html">
<cfdump var="#a_struct_crm_filter#" label="a_struct_crm_filter">
<cfdump var="#arguments#">
</cfmail>

<!--- use all rows --->
<cfset a_struct_loadoptions.maxrows = 5000 />

<!--- load contacts ... order by which column??? --->	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
	<cfinvokeargument name="loadowndatafields" value="true">
	<cfinvokeargument name="loadfulldata" value="true">
	<cfinvokeargument name="fieldlist" value="#arguments.includefields#">
</cfinvoke>

<cfquery name="stReturn_contacts.q_select_contacts" dbtype="query">
SELECT
	*
FROM
	stReturn_contacts.q_select_contacts
ORDER BY
	dt_created
;
</cfquery>

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_struct_crm_filter" type="html">
<cfdump var="#a_struct_crm_filter#" label="a_struct_crm_filter">
<cfdump var="#a_struct_filter#" label="a_struct_filter">
<cfdump var="#stReturn_contacts#">
</cfmail>

<!--- <cfset q_select_fieldnames = stReturn_contacts.q_select_table_fields>

<cfinvoke component="/components/crmsales/crm_reports" method="CreateReportOutputTable" returnvariable="stReturn_create_output_table">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="reportkey" value="#q_select_report_settings.entrykey#">
	<cfinvokeargument name="databasekey" value="#a_str_databasekey_for_report#">
	<cfinvokeargument name="tablename" value="#GetLangVal('crm_ph_report_output_table_name_begin')# #q_select_report_settings.reportname# (#DateFormat(now(), 'dd.mm.yy')# #TimeFormat(now(), 'HH:mm')#)">
	<cfinvokeargument name="tabledescription" value="#GetLangVal('cm_ph_created_by')# #a_cmp_users.getusernamebyentrykey(arguments.securitycontext.myuserkey)#">
	<cfinvokeargument name="q" value="#stReturn_contacts.q_select_contacts#">
	<cfinvokeargument name="q_select_fieldnames" value="#q_select_fieldnames#">
	<cfinvokeargument name="adddata" value="true">
</cfinvoke>

<cflog text="output table created: #(GetTickCount() - a_tc)#" type="Information" log="Application" file="ib_crm_reports">

<cfset stReturn.tablekey_of_report_output = stReturn_create_output_table.tablekey> --->

