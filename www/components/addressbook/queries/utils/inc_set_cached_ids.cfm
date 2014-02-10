<!--- //

	Module:		Address Book
	Description:Build string for caching data ...
	
// --->

<cfsetting requesttimeout="20000">

<!--- loop now through filters ... --->
<cfloop list="#StructKeyList(arguments.filter)#" index="a_str_item">
	<cfset a_str_param_string = AddParamStringItem(a_str_param_string, a_str_item, arguments.filter[a_str_item]) />
</cfloop>

<cfif StructKeyExists(arguments.crmfilter, 'metadata')>
	<cfloop from="1" to="#ArrayLen(arguments.crmfilter.metadata)#" index="ii">
		<cfset a_struct_filter_element = arguments.crmfilter.metadata[ii] />
		<cfset a_str_param_string = AddParamStringItem(a_str_param_string, a_struct_filter_element.internalfieldname, a_struct_filter_element.connector & a_struct_filter_element.operator & a_struct_filter_element.comparevalue) />
	</cfloop>
</cfif>

<cfif StructKeyExists(arguments.crmfilter, 'crm')>
	<cfloop from="1" to="#ArrayLen(arguments.crmfilter.crm)#" index="ii">
		<cfset a_str_param_string = AddParamStringItem(a_str_param_string, arguments.crmfilter.crm[ii].internalfieldname, arguments.crmfilter.crm[ii].operator & arguments.crmfilter.crm[ii].comparevalue) />
	</cfloop>
</cfif>

<cfif StructKeyExists(arguments.crmfilter, 'contact')>
	<cfloop from="1" to="#ArrayLen(arguments.crmfilter.contact)#" index="ii">
		<cfset a_str_param_string = AddParamStringItem(a_str_param_string, arguments.crmfilter.contact[ii].internalfieldname, arguments.crmfilter.contact[ii].operator & arguments.crmfilter.contact[ii].comparevalue) />
	</cfloop>
</cfif>

<!--- set various items here ... --->
<cfset a_str_param_string = AddParamStringItem(a_str_param_string, 'convert_lastcontact_utc', arguments.convert_lastcontact_utc) />
<cfset a_str_param_string = AddParamStringItem(a_str_param_string, 'loaddistinctcategories', arguments.loaddistinctcategories) />
<cfset a_str_param_string = AddParamStringItem(a_str_param_string, 'filterdatatypes', arguments.filterdatatypes) />

<!--- save all loadoptions! --->
<cfloop list="#StructKeyList(arguments.loadoptions)#" index="a_str_item">
	<cfif IsSimpleValue(arguments.loadoptions[a_str_item]) AND (a_str_item NEQ 'startrow')>
		<cfset a_str_param_string = AddParamStringItem(a_str_param_string, a_str_item, arguments.loadoptions[a_str_item]) />
	</cfif>
</cfloop>
