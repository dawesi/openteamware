

<cfloop list="#StructKeyList(arguments.newvalues)#" index="a_str_key">
	
	<cfset a_str_new_value = arguments.newvalues[a_str_key]>
	
	<cfif ListFindNoCase(arguments.query.columnlist, a_str_key) GT 0>
		<!--- column exists in the original query ... --->
		
		<cfif CompareNoCase(a_str_new_value, arguments.query[a_str_key][1]) NEQ 0>
		
			<cfset a_str_fields_changed = ListAppend(a_str_fields_changed, a_str_key)>
			
			<cfset a_struct_new_data[a_str_key] = a_str_new_value>
			<cfset a_struct_old_data[a_str_key] = arguments.query[a_str_key][1]>
			
			<!---<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="value changed">
			key: #a_str_key#
			
			new: #a_str_new_value#
			
			
			old: #arguments.query[a_str_key][1]#
			</cfmail>--->
		</cfif>
		
	</cfif>
	
</cfloop>