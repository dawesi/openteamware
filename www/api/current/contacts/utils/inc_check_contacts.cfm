<!--- //

	parse contacts
	
	get contact by contact, check CRM fields and so on ...
	
	// --->
	
	
<cfset stReturn.meta = StructNew()>
<cfset stReturn.meta.created = ArrayNew(1)>

<cfset a_arr_contacts = XmlSearch(a_xml_obj, '/contacts/contact')>

<cfset a_int_count = ArrayLen(a_arr_contacts)>

<cfloop from="1" to="#a_int_count#" index="ii">

	<!--- the array holding all xml data of the contact --->
	<cfset a_arr_contact = a_arr_contacts[ii]>
	<cfset a_struct_key_list = structkeylist(a_arr_contact)>
	
	<cfset a_struct_contact = StructNew()>
	
	<cfloop list="#a_struct_key_list#" index="a_str_item">
	
		<cfset a_struct_contact[a_str_item] = a_arr_contact[a_str_item].xmltext>		
		
		<cflog text="#a_str_item#: #a_arr_contact[a_str_item].xmltext#" type="Information" log="Application" file="ib_ws">
		
	</cfloop>
	
	<!--- do we have the ID? --->
	<cfif StructKeyExists(a_struct_contact, 'id')>
		<!--- use the supplied ID --->
		<cfset a_str_id_of_element = a_struct_contact.id>
	<cfelse>
		<!--- otherwise just use the current index --->
		<cfset a_str_id_of_element = ii>
	</cfif>
	
	
	<!--- call insert process ... --->
	
	<cfinvoke component="/components/webservices/cmp_contacts" method="CreateContactAndCRM" returnvariable="stReturn_create">
		<cfinvokeargument name="data" value="#a_struct_contact#">
		<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
		<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">
	</cfinvoke>
	
	
	<!--- how to identify the return ... --->
	<cfset stReturn.meta.created[ii] = StructNew()>
	<cfset stReturn.meta.created[ii].id = a_str_id_of_element>
	<cfset stReturn.meta.created[ii].entrykey = stReturn_create.entrykey>

</cfloop>