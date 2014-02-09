<!--- //

	Module:		Address Book
	Action:		Create / Edit a contact, account, lead or datapool item
	Description:Show available remote edit information
	
				Display changed fields and so on ...
				
	

// --->

<cfinvoke component="#application.components.cmp_addressbook#" method="GetRemoteEditData" returnvariable="q_select_re_data">
	<cfinvokeargument name="entrykey" value="#EditOrCreateContact.query.entrykey#">
</cfinvoke>

<cfset a_struct_original_values = QueryToArrayOfStructures(EditOrCreateContact.query)>

<!--- update select query --->
<cfset a_str_columnlist = EditOrCreateContact.query.columnlist>

<cfloop list="#q_select_re_data.columnlist#" index="a_str_column_name" delimiters=",">
	
	<cfif ListFindNoCase(a_str_columnlist, a_str_column_name) GT 0>
	
		<cfif Compare(EditOrCreateContact.query[a_str_column_name][1], q_select_re_data[a_str_column_name][1]) NEQ 0>
			<cfset a_str_edited_fields = ListPrepend(a_str_edited_fields, a_str_column_name)>
		</cfif>
		
		<!--- if addtext: is present, use the existing text PLUS the new text --->
		<cfif FindNoCase('ADDTEXT:', q_select_re_data[a_str_column_name][1]) IS 1>
			<cfset a_str_set_value = ReplaceNoCase(q_select_re_data[a_str_column_name][1], 'ADDTEXT:', '')>
			<cfset a_str_set_value = EditOrCreateContact.query[a_str_column_name][1] & chr(13) & chr(10) & trim(a_str_set_value)>
		<cfelse>
			<cfset a_str_set_value = q_select_re_data[a_str_column_name][1]>
		</cfif>
		
		<cfset tmp = QuerySetCell(EditOrCreateContact.query, a_str_column_name, a_str_set_value, 1)>
	</cfif>			

</cfloop>

<!--- TODO hansjoergp Update design ... --->
<table width="100%" border="0" cellspacing="0" cellpadding="4" class="b_all" style="margin:10px;">
  <tr>
	<td>
	<img src="/images/extras/img_flash_64x64.png" width="64" height="64" vspace="4" hspace="4">
	</td>
	<td class="bl mischeader">
	<b><cfoutput>#GetLangVal('adrb_ph_remoteedit_contact_has_updated_data1')#</cfoutput></b>
	<br />
	<cfoutput>#GetLangVal('adrb_ph_remoteedit_contact_has_updated_data2')#</cfoutput>
	</td>
  </tr>
</table>

