

<cfcomponent displayname="CreateStructureFromXML">

<cffunction access="public" name="createstructurefromxml" output="false" returntype="array">
<cfargument name="str_xml" default="" type="string" required="true">

<cfset a_xml_doc = XmlParse(str_xml)>

<CFSET xnResults = a_xml_doc.XmlRoot>

<cfset a_arr_items = ArrayNew(1)>

<cfloop index="a_int_index_ii" from="1" to="#ArrayLen(xnResults.XmlChildren)#">
	<cfset xnItem = xnResults.XmlChildren[a_int_index_ii]>
	
	<cfset a_struct_new = StructNew()>
	
	<cfloop index="a_int_index_jj" from="1" to="#ArrayLen(xnItem.XMLChildren)#">
		<cfset xnEntry = xnItem.XmlChildren[a_int_index_jj]>
		
		<!---<cfoutput>#xnentry.xmlname#: #xnEntry.xmltext#</cfoutput><hr>--->
		
		<cfset a_struct_new[urldecode(xnentry.xmlname)] = urldecode(xnEntry.xmltext)>
		<!---<cfset a_struct_new.&"#xnentry.xmlname#" = 1>--->
	</cfloop>
	
	<cfset a_arr_items[ArrayLen(a_arr_items)+1] = a_struct_new>
	
</cfloop>


<cfreturn a_arr_items>

</cffunction>
</cfcomponent>