<cfset a_xml_filter = XmlParse(arguments.filter)>

<!--- check various filters

	... begin with entrykey
	
	--->
<cfset a_bol_entrykeys = StructKeyExists(a_xml_filter, 'entrykeys')>

<cfif a_bol_entrykeys>
	<!--- hit, add to list ... --->
	<cfset sEntrykeys_filter = a_xml_filter.entrykeys.xmltext>
	
	<cfset a_struct_load_contacts_filter.entrykeys = sEntrykeys_filter>
</cfif>