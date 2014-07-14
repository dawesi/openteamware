<!--- //

	parse contacts
	
	get contact by contact, check CRM fields and so on ...
	
	// --->
	
	
<!---<cfset stReturn.meta = StructNew()>
<cfset stReturn.meta.updated = ArrayNew(1)>--->

<cfset a_xml_obj = XmlParse(arguments.data)>

<cfset a_arr_contact = XmlSearch(a_xml_obj, '/contact')>

<cfset a_arr_contact = a_arr_contact[1].xmlchildren>

<cfset a_struct_contact = StructNew()>
	
<cfloop from="1" to="#ArrayLen(a_arr_contact)#" index="ii">

	<cfset a_str_item_name = a_arr_contact[ii].xmlname>
	
	<cfset a_struct_contact[a_str_item_name] = a_arr_contact[ii].xmltext>
	
</cfloop>

<cfif StructKeyExists(a_struct_contact, 'userkey')>
	<cfset tmp = StructDelete(a_struct_contact, 'userkey')>
</cfif>

<!--- call update! --->
<cfinvoke component="/components/webservices/cmp_contacts" method="UpdateContactAndCRM" returnvariable="stReturn_update">
	<cfinvokeargument name="data" value="#a_struct_contact#">
	<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
	<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">
	<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
</cfinvoke>