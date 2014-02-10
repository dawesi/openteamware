<!--- //

	Module:		CRMReports
	Description:Countries
	

// --->
<cfset a_cmp_users = application.components.cmp_user>

<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="viewkey" value="">
</cfinvoke>

<!--- use all rows --->
<cfset a_struct_loadoptions.maxrows = 0 />
<!--- <cfset a_struct_loadoptions.fieldstoselect = 'b_country'>--->

<!--- ignore archive items ... --->
<cfset a_struct_filter.NoArchiveItems = true />

<!--- load contacts ... order by which column??? --->	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
	<!---
	<cfinvokeargument name="loadfulldata" value="true">
	--->
</cfinvoke>

<cfset q_select_contacts = stReturn_contacts.q_select_contacts />

<cfset stReturn.rc = q_select_contacts.recordcount />

<cfset a_one_percent = q_select_contacts.recordcount / 100 />
<cfif a_one_percent IS 0>
	<cfset a_one_percent = 1 />
</cfif>

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="q_select_contacts" type="html">
<cfdump var="#q_select_contacts#">
-
</cfmail>

<cfquery name="q_select_distinct_countries" dbtype="query">
SELECT
	DISTINCT(UPPER(b_country)),
	0 AS count_country,
	0 AS percent_country
FROM
	q_select_contacts
;
</cfquery>

<!--- create table with information about fields ... --->
<cfset q_select_fieldnames = QueryNew('showname,fieldname,fieldtype,fielddescription')>
<cfset tmp = QueryAddRow(q_select_fieldnames, 1)>
<cfset QuerySetCell(q_select_fieldnames, 'showname', '%', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fieldname', 'percent_country', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fieldtype', '1', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fielddescription', '', q_select_fieldnames.recordcount)>	

<cfset tmp = QueryAddRow(q_select_fieldnames, 1)>
<cfset QuerySetCell(q_select_fieldnames, 'showname', 'Anzahl', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fieldname', 'count_country', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fieldtype', '1', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fielddescription', '', q_select_fieldnames.recordcount)>	

<cfset tmp = QueryAddRow(q_select_fieldnames, 1)>
<cfset QuerySetCell(q_select_fieldnames, 'showname', 'Land', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fieldname', 'b_country', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fieldtype', '0', q_select_fieldnames.recordcount)>
<cfset QuerySetCell(q_select_fieldnames, 'fielddescription', '', q_select_fieldnames.recordcount)>	

<cfloop query="q_select_distinct_countries">
	<cfquery name="q_select_distinct_country_count" dbtype="query">
	SELECT
		COUNT(b_country) AS count_country
	FROM
		q_select_contacts
	WHERE
		UPPER(b_country) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(q_select_distinct_countries.b_country)#">
	;
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_select_distinct_countries, 'count_country', val(q_select_distinct_country_count.count_country), q_select_distinct_countries.currentrow)>
	<cfset tmp = QuerySetCell(q_select_distinct_countries, 'percent_country', DecimalFormat(q_select_distinct_country_count.count_country / a_one_percent), q_select_distinct_countries.currentrow)>

	<cfif Len(q_select_distinct_countries.b_country) IS 0>
		<cfset tmp = QuerySetCell(q_select_distinct_countries, 'b_country', 'leer/unbekannt', q_select_distinct_countries.currentrow)>	
	</cfif>
</cfloop>

<cfinvoke component="/components/crmsales/crm_reports" method="CreateReportOutputTable" returnvariable="stReturn_create_output_table">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="reportkey" value="#q_select_report_settings.entrykey#">
	<cfinvokeargument name="databasekey" value="#a_str_databasekey_for_report#">
	<cfinvokeargument name="tablename" value="#GetLangVal('crm_ph_report_output_table_name_begin')# #q_select_report_settings.reportname# (#DateFormat(now(), 'dd.mm.yy')# #TimeFormat(now(), 'HH:mm')#)">
	<cfinvokeargument name="tabledescription" value="#GetLangVal('cm_ph_created_by')# #a_cmp_users.getusernamebyentrykey(arguments.securitycontext.myuserkey)#">
	<cfinvokeargument name="q" value="#q_select_distinct_countries#">
	<cfinvokeargument name="q_select_fieldnames" value="#q_select_fieldnames#">
	<cfinvokeargument name="adddata" value="true">
</cfinvoke>

<cfset stReturn.tablekey_of_report_output = stReturn_create_output_table.tablekey>


