<!--- //

	Module:		AddressBook
	Action:		ShowAll
	Description:Display all items, default view
	

// --->


<table class="table table-hover">
  <tr class="tbl_overview_header">
	<td style="width:35px;">
		<a href="#" onclick="SelectAllDisplayedItems();return false;"><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></a>
	</td>
	<td>
		<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'orderby', 'surname')>
		<a href="index.cfm?<cfoutput>#a_str_href#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></a>
			
		<cfif CompareNoCase(sOrderBy, 'surname') IS 0>
			<img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" width="14" height="10" alt="" border="0"/>
		</cfif>					
	</td>
	<td>
		<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'orderby', 'company,surname')>
		<a href="index.cfm?<cfoutput>#a_str_href#</cfoutput>"><cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput></a>
			
		<cfif ListFindNoCase(sOrderBy, 'company') GT 0>
			<img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" width="14" height="10" alt="" border="0"/>
		</cfif>		
	</td>
	<td>
		<cfoutput>#GetLangVal('adrb_ph_contact_data')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
	</td>
  </tr>
  
  <cfoutput query="q_select_contacts">
  <tr>
	<td>
		<input type="checkbox" name="frmcbselect" value="#htmleditformat(q_select_contacts.entrykey)#" class="noborder">
	</td>
	<td>
		<img src="/images/si/vcard.png" alt="" class="si_img" /> <a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#" style="font-weight:bold;">#htmleditformat(checkzerostring(trim(q_select_contacts.surname)))#<cfif Len(q_select_contacts.firstname) GT 0>, #htmleditformat(q_select_contacts.firstname)#</cfif></a>
	</td>
	<td>
		<cfif Len(q_select_contacts.parentcontactkey) GT 0>
			<a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.parentcontactkey)#">#htmleditformat(shortenstring(q_select_contacts.company, 25))#</a>
		<cfelse>
			#htmleditformat(shortenstring(q_select_contacts.company, 25))#
		</cfif>				
	</td>
	<td>
		<a onClick="OpenEmailPopup('#jsstringformat(q_select_contacts.entrykey)#', '#jsstringformat(q_select_contacts.email_prim)#');return false;" href="##">#shortenstring(q_select_contacts.email_prim, 20)#</a>
		
		<cfif len(q_select_contacts.b_telephone) GT 0>
			/ #htmleditformat(q_select_contacts.b_telephone)#
		<cfelseif len(q_select_contacts.b_MOBILE) GT 0>
			/ #htmleditformat(q_select_contacts.b_mobile)#
		<cfelseif len(q_select_contacts.p_telephone) GT 0>
			/ #htmleditformat(q_select_contacts.p_telephone)#
		<cfelse>
			&nbsp;
		</cfif>		
	</td>
    <td style="white-space:nowrap;">
		<cfset a_str_id = 'id_a_file_' & Hash(q_select_contacts.entrykey) & RandRange(1, 9999)>
		<a href="##" id="#a_str_id#" onClick="SetCurrentlySelectedContacts('#jsstringformat(q_select_contacts.entrykey)#');ShowHTMLActionPopup('#a_str_id#', a_act_popm);return false;">#GetLangVal('cm_wd_action')#</a>			
	</td>
  </tr>
  </cfoutput>
</table>


