<!--- //

	Component:	Webservices/Contacts
	Function:	CreateContactAndCRM
	Description:Call create contact method
	
	Header:	

// --->

<cfif NOT StructKeyExists(variables, 'CheckEntryExistsAndReturnValue')>
	<cfinclude template="inc_script.cfm">
</cfif>

<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">	
	<cfinvokeargument name="entrykey" value="#sEntrykey#">
	
	<cfinvokeargument name="firstname" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'firstname')#">
	<cfinvokeargument name="surname" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'surname')#">
	<cfinvokeargument name="company" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'company')#">
	<cfinvokeargument name="department" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'department')#">
	<cfinvokeargument name="position" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'position')#">
	<cfinvokeargument name="title" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'title')#">
	<cfinvokeargument name="sex" value="#val(CheckEntryExistsAndReturnValue(a_struct_contact_data, 'sex'))#">
	<cfinvokeargument name="email_prim" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'email_prim')#">
	<cfinvokeargument name="email_adr" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'email_adr')#">
	<cfinvokeargument name="birthday" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'birthday')#">
	<cfinvokeargument name="categories" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'categories')#">
	<cfinvokeargument name="b_street" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_street')#">
	<cfinvokeargument name="b_city" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_city')#">
	<cfinvokeargument name="b_zipcode" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_zipcode')#">
	<cfinvokeargument name="b_country" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_country')#">
	<cfinvokeargument name="b_telephone" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_telephone')#">
	<cfinvokeargument name="b_telephone_2" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_telephone_2')#">	
	<cfinvokeargument name="b_fax" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_fax')#">
	<cfinvokeargument name="b_mobile" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_mobile')#">
	<cfinvokeargument name="b_url" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'b_url')#">
	<cfinvokeargument name="p_street" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_street')#">
	<cfinvokeargument name="p_city" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_city')#">
	<cfinvokeargument name="p_zipcode" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_zipcode')#">
	<cfinvokeargument name="p_country" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_country')#">
	<cfinvokeargument name="p_telephone" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_telephone')#">		
	<cfinvokeargument name="p_fax" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_fax')#">
	<cfinvokeargument name="p_mobile" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_mobile')#">
	<cfinvokeargument name="p_url" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'p_url')#">
	<cfinvokeargument name="notice" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'notice')#">
	<cfinvokeargument name="archiveentry" value="#val(CheckEntryExistsAndReturnValue(a_struct_contact_data, 'archiveentry'))#">			
	<cfinvokeargument name="contacttype" value="#val(CheckEntryExistsAndReturnValue(a_struct_contact_data, 'contacttype'))#">				
	<cfinvokeargument name="parentcontactkey" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'parentcontactkey')#">				
	<cfinvokeargument name="criteria" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'criteria')#">
	<cfinvokeargument name="nace_code" value="#CheckEntryExistsAndReturnValue(a_struct_contact_data, 'nace_code')#">
	<cfinvokeargument name="sender" value="ws_import">				
</cfinvoke>

<cfset stReturn.a_bol_return_addressbook = a_bol_return />

