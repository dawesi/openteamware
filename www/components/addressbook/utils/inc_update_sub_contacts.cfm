<!--- //

	Module:		Address Book
	Function:	UpdateContact
	Description:Update sub contacts ...
	

// --->

<cfloop query="q_select_sub_contacts">

	<!--- get contact ... --->
	<cfset a_struct_get_contact = GetContact(entrykey = q_select_sub_contacts.entrykey,
										securitycontext = arguments.securitycontext,
										usersettings = arguments.usersettings) />
										
	<cfif a_struct_get_contact.result AND a_struct_get_contact.rights.edit>
		
		<cfset stUpdate_sub = StructNew() />
		
		<!--- compare raw data and data returned by cmp ... --->
		
		<cfloop list="#a_str_fields_check_sub_update#" index="a_str_field_name">
			
			<cfset a_str_value_original_parent = q_select_contact_raw[a_str_field_name] />
			<cfset a_str_value_original_sub = a_struct_get_contact.q_select_contact[a_str_field_name] />
		
			<!--- 
				conditions:
				- old value of parent and current value or sub are the same
				- new value provided in update struct
				- new value different from current value --->
				
			<cfset a_bol_value_exists_in_update_struct = (StructKeyExists(arguments.newvalues, a_str_field_name) GT 0) />
			<cfset a_bol_sub_value_is_empty = (Len(a_str_value_original_sub) IS 0) />
			<cfset a_bol_sub_value_was_same = (CompareNoCase(a_str_value_original_parent, a_str_value_original_sub) IS 0) />
			
			<cfif a_bol_value_exists_in_update_struct>
				<cfset a_bol_sub_value_not_same_as_new = (CompareNoCase(arguments.newvalues[a_str_field_name], a_str_value_original_sub) NEQ 0) />
			<cfelse>
				<cfset a_bol_sub_value_not_same_as_new = false />
			</cfif>
				
			<cfif a_bol_value_exists_in_update_struct AND
				  (a_bol_sub_value_was_same OR a_bol_sub_value_is_empty) AND
				  a_bol_sub_value_not_same_as_new>
				  
				  <cfset stUpdate_sub[a_str_field_name] = arguments.newvalues[a_str_field_name] />
	
			</cfif>
		
		</cfloop>
		
		<!--- update sub contact? ... if fields have been found, do it now ... --->
		<cfif StructCount(stUpdate_sub) GT 0>
	
			  <cfinvoke component="#application.components.cmp_addressbook#" method="UpdateContact" returnvariable="stReturn">
				<cfinvokeargument name="entrykey" value="#q_select_sub_contacts.entrykey#">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
				<cfinvokeargument name="newvalues" value="#stUpdate_sub#">
			</cfinvoke>
	
		</cfif>
		
	</cfif>

</cfloop>

