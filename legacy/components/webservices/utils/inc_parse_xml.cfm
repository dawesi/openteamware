<cfset a_xml_doc = XmlParse(arguments.data)>

<cfset a_xml_root = a_xml_doc.xmlroot>

<cfloop from="1" to="#ArrayLen(a_xml_root.xmlchildren)#" index="ii">
	<cfset a_struct_contact_data[a_xml_root.xmlchildren[ii].xmlname] = a_xml_root.xmlchildren[ii].xmltext>
</cfloop>