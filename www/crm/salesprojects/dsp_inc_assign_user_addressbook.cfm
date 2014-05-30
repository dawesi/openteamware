<!--- //

	add someone from the address book
	
	// --->
	
	
<cfset a_cmp_tools = CreateObject('component', request.a_str_component_tools)>
<cfset a_cmp_contacts = CreateObject('component', request.a_str_component_addressbook)>

<form action="salesprojects/act_add_assigned_contact_to_sales_project.cfm" method="post">

<!--- no internal user --->
<input type="hidden" name="frminternaluser" value="0"/>

<input type="hidden" name="frmsalesprojectkey" value="<cfoutput>#q_select_sales_project.entrykey#</cfoutput>">

<cfoutput>
<table class="table_details table_edit_form">
#a_cmp_tools.GenerateEditingTableRow(field_name = GetLangVal('crm_ph_sales_project'), input_value = q_select_sales_project.title, output_only = true)#

<cfset a_arr_options = ArrayNew(1)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_type_0'), 0)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_type_1'), 1)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_type_2'), 2)>
	
#a_cmp_tools.GenerateEditingTableRow(datatype = 'options', field_name = GetLangVal('cm_wd_type'), input_name = 'frmtype', input_value = 0, options = a_arr_options, parameters = 'bigsize')#

<cfset a_arr_options = ArrayNew(1)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_0'), 0)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_1'), 1)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_2'), 2)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_3'), 3)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_4'), 4)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_5'), 5)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_6'), 6)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('crm_ph_assigned_contact_role_7'), 7)>
	
#a_cmp_tools.GenerateEditingTableRow(datatype = 'options', field_name = GetLangVal('crm_wd_role'), input_name = 'frmrole', input_value = 0, options = a_arr_options)#

<!--- //

	list contacts
	
	a) sub contacts
	b) other items of account
	c) linked contacts
	d) search
	
	// --->
	


<!--- select other employees of contact/account --->
<cfinvoke component="#a_cmp_contacts#" method="GetContact" returnvariable="a_struct_contact">
	<cfinvokeargument name="entrykey" value="#q_select_sales_project.contactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif a_struct_contact.q_select_sub_items.recordcount GT 0>
	<!--- has sub contacts ... --->
	<cfset a_arr_options = ArrayNew(1)>
	<cfloop query="a_struct_contact.q_select_sub_items">
		<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, htmleditformat(a_struct_contact.q_select_sub_items.surname & ', ' & a_struct_contact.q_select_sub_items.firstname), a_struct_contact.q_select_sub_items.entrykey)>
	</cfloop>
	
	#a_cmp_tools.GenerateEditingTableRow(datatype = 'radio', field_name = GetLangVal('crm_ph_sub_contacts'), input_name = 'frmentrykey', input_value = '', options = a_arr_options)#
	
</cfif>

<cfif a_struct_contact.q_select_parent_contact.recordcount GT 0>

	<!--- has parent contact --->
	<cfinvoke component="#a_cmp_contacts#" method="GetContact" returnvariable="a_struct_parent_contact">
		<cfinvokeargument name="entrykey" value="#a_struct_contact.q_select_contact.parentcontactkey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>
	
	<cfset q_select_further_contacts = a_struct_parent_contact.q_select_sub_items>
	
	<!--- check if other users than the currenct one is available ... --->
	<cfquery name="q_select_further_contacts" dbtype="query">
	SELECT
		*
	FROM
		q_select_further_contacts
	WHERE
		NOT entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_sales_project.contactkey#">
	;
	</cfquery>
	
	<cfif q_select_further_contacts.recordcount GT 0>
		<cfset a_arr_options = ArrayNew(1)>
		<cfloop query="q_select_further_contacts">
			<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, htmleditformat(q_select_further_contacts.surname & ', ' & q_select_further_contacts.firstname), q_select_further_contacts.entrykey)>
		</cfloop>
		
		#a_cmp_tools.GenerateEditingTableRow(datatype = 'radio', field_name = GetLangVal('crm_ph_further_contacts_of_account'), input_name = 'frmentrykey', input_value = '', options = a_arr_options)#
	</cfif>
</cfif>


<!--- select linked contacts --->
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.DEST_SERVICEKEY = '52227624-9DAA-05E9-0892A27198268072'>
<cfset a_struct_filter.SOURCE_SERVICEKEY = '52227624-9DAA-05E9-0892A27198268072'>

<cfinvoke component="#request.a_str_component_tools#" method="GetElementLinksFromTo" returnvariable="q_select_links">
	<cfinvokeargument name="entrykey" value="#q_select_sales_project.contactkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<!--- filter correct ones out!!!!!!!!! --->

	<cfif q_select_links.recordcount GT 0>
		
		<cfset a_arr_options = ArrayNew(1)>
		<cfloop query="q_select_links">
			<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, q_select_links.dest_name, q_select_links.dest_entrykey)>
			<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, q_select_links.source_name, q_select_links.source_entrykey)>
		</cfloop>
	
		#a_cmp_tools.GenerateEditingTableRow(datatype = 'radio', field_name = GetLangVal('crm_wd_contact_links'), input_name = 'frmentrykey', input_value = '', options = a_arr_options)#
	</cfif>
	
  	<!--- comment ... --->
  	#a_cmp_tools.GenerateEditingTableRow(datatype = 'memo', field_name = GetLangVal('cm_wd_comment'), input_name = 'frmcomment', input_value = '')#

  
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" class="btn btn-primary" value="add">
	</td>
  </tr>
</table>
</cfoutput>
</form>