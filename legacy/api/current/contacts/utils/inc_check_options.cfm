<!--- //

	parse the options
	
	// --->
	
<cfset a_xml_options = XmlParse(arguments.options)>

<!--- check various filters

	... begin with entrykey
	
	--->
<cfset a_bol_maxrows = StructKeyExists(a_xml_options, 'maxrows')>

<cfif a_bol_maxrows>
	<!--- hit, add to list ... --->
	<cfset a_struct_load_contacts_options.maxrows = val(a_xml_options.maxrows.xmltext)>
</cfif>

<cfset a_bol_fields = StructKeyExists(a_xml_options, 'fields')>

<cfif a_bol_fields>
	<!--- hit, add to list ... --->
	<cfset a_struct_load_contacts_options.fields2load = a_xml_options.fields.xmltext>
</cfif>

<cfset a_bol_notifyuser = StructKeyExists(a_xml_options, 'notifyuser')>