<!--- //

	create / edit a sales project
	
	if entrykey is empty, it's a new sales project!
	
	// --->

<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.contactkey" type="string" default="">

<cfif Len(url.contactkey) IS 0 AND Len(url.entrykey) IS 0>
	invalid request
	<cfexit method="exittemplate">
</cfif>

<!--- what to do? create or edit? --->
<cfset a_str_operation = 'create'>

<!--- edit request --->
<cfif Len(url.entrykey) GT 0>

	<cfset a_str_operation = 'edit'>
	
	<cfinvoke component="#application.components.cmp_crmsales#" method="GetSalesProject" returnvariable="a_struct_sales_project">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="entrykey" value="#url.entrykey#">
	</cfinvoke>
	
	<cfset q_select_sales_project = a_struct_sales_project.q_select_sales_project>
	<cfset q_select_contacts_assigned_to_sales_project = a_struct_sales_project.q_select_contacts_assigned_to_sales_project>
	<cfset q_select_sales_project_stage_trends = a_struct_sales_project.q_select_sales_project_stage_trends>
	
	<cfif q_select_sales_project.recordcount IS 0>
		No data found.
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset a_str_contactkey = q_select_sales_project.contactkey>

<cfelse>
	
	<!--- brand new opportunity --->
	
	<cfset a_str_contactkey = url.contactkey>
	
	<cfset q_select_sales_project = QueryNew('lead_source,lead_source_id,probability,comment,stage,project_type,responsibleuserkey,currency,entrykey,title,sales,contactkey')>
	
	<cfset QueryAddRow(q_select_sales_project, 1)>
	<cfset QuerySetCell(q_select_sales_project, 'entrykey', CreateUUID(), 1)>
	<cfset QuerySetCell(q_select_sales_project, 'contactkey', url.contactkey, 1)>
	<cfset QuerySetCell(q_select_sales_project, 'currency', 'EUR', 1)>
	<cfset QuerySetCell(q_select_sales_project, 'probability', '10', 1)>
</cfif>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_contact">
	<cfinvokeargument name="entrykey" value="#a_str_contactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadmetainformations" value="true">
</cfinvoke>

<!--- default values ... --->
<cfset a_struct_force_element_values = StructNew()>
<cfset a_struct_force_element_values.currency = 'EUR'>
<cfset a_struct_force_element_values.display_contact_name = application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_sales_project.contactkey)>

<!--- force options ... --->
<cfset a_struct_force_options_replace = StructNew()>
<cfset a_struct_force_options_replace.responsibleuserkey = ArrayNew(1)>

<cfset a_struct_force_options_replace.responsibleuserkey[1] = StructNew()>
<cfset a_struct_force_options_replace.responsibleuserkey[1].name = application.components.cmp_user.GetFullNameByentrykey(request.stSecurityContext.myuserkey)>
<cfset a_struct_force_options_replace.responsibleuserkey[1].value = request.stSecurityContext.myuserkey>

<cfloop query="a_struct_contact.q_select_assigned_employees">
	<cfset a_int_new_index = ArrayLen(a_struct_force_options_replace.responsibleuserkey) + 1>
	
	<cfset a_struct_force_options_replace.responsibleuserkey[a_int_new_index] = StructNew()>
	<cfset a_struct_force_options_replace.responsibleuserkey[a_int_new_index].name = application.components.cmp_user.GetFullNameByentrykey(a_struct_contact.q_select_assigned_employees.userkey)>
	<cfset a_struct_force_options_replace.responsibleuserkey[a_int_new_index].value = a_struct_contact.q_select_assigned_employees.userkey>
	
</cfloop>

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(force_element_values = a_struct_force_element_values,
						action = a_str_operation,
						query = q_select_sales_project,
						securitycontext = request.stSecurityContext,
						usersettings = request.stUserSettings,
						entrykey = '3177C2F6-E0F2-06FE-A904CB04E3D19D52',
						force_options_replace = a_struct_force_options_replace)>

<cfoutput>#a_str_form#</cfoutput>