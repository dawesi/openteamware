<!--- //

	load parent contact data and fill arguments ...
	
	// --->


<cfset a_struct_load_parent_contact = GetContact(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings, entrykey = arguments.parentcontactkey)>

<cfif StructKeyExists(a_struct_load_parent_contact, 'q_select_contact')>
	<!--- ok, fill fields now --->
	
	<cfset arguments.company = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'company')>
	<cfset arguments.department = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'department')>
	<cfset arguments.aposition = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'aposition')>
	
	<!--- business data --->
	<cfset arguments.b_street = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_street')>
	<cfset arguments.b_city = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_city')>
	<cfset arguments.b_zipcode = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_zipcode')>
	<cfset arguments.b_country = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_country')>
	<cfset arguments.b_telephone = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_telephone')>
	<cfset arguments.b_fax = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_fax')>
	<cfset arguments.b_mobile = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_mobile')>
	<cfset arguments.b_url = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'b_url')>
	
	<cfset arguments.email_prim = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'email_prim')>
	<cfset arguments.email_adr = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'email_adr')>
	
	<!--- private ... ignore --->

	
	<!--- meta --->
	<cfset arguments.categories = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'categories')>
	<cfset arguments.dt_lastcontact = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'dt_lastcontact')>
	<cfset arguments.notice = CheckParentContactData(arguments, a_struct_load_parent_contact.q_select_contact, 'notice')>
</cfif>