<!--- //

	Module:		CRMReports
	Action:		StartGenerateReport
	Description: 
	

// --->
<cfparam name="form.frm_show_fields" type="string" default="addressbookkey,VIRT_ITEMTYPE,VIRT_SUBJECT,VIRT_createdbyuserkey,virt_itemcreated,virt_description">

<!--- query holding information about fields, shownames & field types --->
<!--- <cfparam name="form.frm_field_information" type="string" default="">

<cfwddx action="wddx2cfml" input="#form.frm_field_information#" output="q_select_fields_information"> --->

<cfset a_struct_options = StructNew()>

<!--- check if options are provided ... --->

<cfinvoke component="#application.components.cmp_crm_reports#" method="GetReportSettings" returnvariable="a_struct_report">
	<cfinvokeargument name="entrykey" value="#form.frmreportkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<!--- loop through the options and set values ... --->
<cfset a_arr_options = a_struct_report.options>

<cfloop from="1" to="#ArrayLen(a_struct_report.options)#" index="ii">
	
	<cfset sEntrykey_option = a_struct_report.options[ii].entrykey>
	
	<cfif StructKeyExists(form, 'frm_option_' & sEntrykey_option)>
		<!--- set option ... --->
		<cfset a_struct_options[sEntrykey_option] = form['frm_option_' & sEntrykey_option]>
	</cfif>
	
</cfloop>


<!--- loop through the virtual fields ... --->
<cfset a_arr_virtual_fields = ArrayNew(1)>

<cfloop from="1" to="#arrayLen(a_struct_report.virtualfields)#" index="ii">

	<cfset sEntrykey_virtual_field = a_struct_report.virtualfields[ii].entrykey>
	
	<cfif ListFindNoCase(form.frm_show_fields, sEntrykey_virtual_field) GT 0>
		<!--- hit, field has been selected! --->
		<cfset a_arr_virtual_fields[ArrayLen(a_arr_virtual_fields) + 1] = a_struct_report.virtualfields[ii]>
	</cfif>
	
</cfloop>

<cfinvoke component="#application.components.cmp_crm_reports#" method="GenerateReport" returnvariable="a_struct_report">
	<cfinvokeargument name="reportkey" value="#form.frmreportkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="includefields" value="#form.frm_show_fields#">
	<cfinvokeargument name="crmfilterkey" value="#form.frmcrmfilterkey#">
	<cfinvokeargument name="options" value="#a_struct_options#">
	<cfinvokeargument name="virtualfields" value="#a_arr_virtual_fields#">
	<!--- <cfinvokeargument name="q_select_field_information" value="#q_select_fields_information#"> --->
</cfinvoke>

<!--- forward to output page to handle "page has to be reloaded" problem --->
<cflocation addtoken="no" url="default.cfm?action=ShowReportOutput&entrykey=#a_struct_report.entrykey#">


