<!--- //

	Module:		AddressBook
	Action:		ShowAll
	Description:Display all items, Leads
	

// --->


<table class="table_overview">
  <tr class="tbl_overview_header">
	<td style="width:35px;">
		<input type="checkbox" name="frmcbselectall" class="noborder" onClick="SelectAllDisplayedItems();">
	</td>
	<td>
		<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'orderby', 'surname')>
		<a href="index.cfm?<cfoutput>#a_str_href#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></a>
			
		<cfif CompareNoCase(sOrderBy, 'surname') IS 0>
			<img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" width="14" height="10" alt="" border="0"/>
		</cfif>					
	</td>
	<td>
		<cfoutput>#htmleditformat(GetLangVal('adrb_wd_position'))#</cfoutput>
	</td>
	<td>
		<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'orderby', 'company,surname')>
		<a href="index.cfm?<cfoutput>#a_str_href#</cfoutput>"><cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput></a>
			
		<cfif ListFindNoCase(sOrderBy, 'company') GT 0>
			<img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" width="14" height="10" alt="" border="0"/>
		</cfif>		
	</td>	
	<td>
		<cfoutput>#GetLangVal('adrb_wd_activities')#</cfoutput>
	</td>
	<td>
		<cfoutput>#GetLangVal('adrb_ph_contact_data')#</cfoutput>
	</td>
	<td>
		<cfoutput>#GetLangVal('crm_wd_custodian')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_action')#</cfoutput>
	</td>
  </tr>
  
  <cfoutput query="q_select_contacts">
  <tr onMouseOver="hilite(this.id);" onMouseOut="restore(this.id);" ID="id_tr_#q_select_contacts.currentrow#">
	<td>
		<input type="checkbox" name="frmcbselect" value="#htmleditformat(q_select_contacts.entrykey)#" class="noborder">
	</td>
	<td>
		<img src="/images/si/vcard.png" alt="" border="0" width="16" height="16" align="absmiddle" /> <a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#"><cfif Len(q_select_contacts.surname) GT 0><b>#htmleditformat(checkzerostring(q_select_contacts.surname))#</b><cfif Len(q_select_contacts.firstname) GT 0>, </cfif></cfif>#htmleditformat(q_select_contacts.firstname)#</a>
	</td>
    <td>
		#htmleditformat(q_select_contacts.aposition)#
	</td>
	<td>
		<cfif Len(q_select_contacts.parentcontactkey) GT 0>
			<a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#">#htmleditformat(shortenstring(q_select_contacts.company, 25))#</a>
		<cfelse>
			#htmleditformat(shortenstring(q_select_contacts.company, 25))#
		</cfif>				
	</td>
	<td>
		<!--- display activites ... --->
		<cfif q_select_contacts.activity_count_followups GT 0>
			<img src="/images/si/flag_red.png" alt="" class="si_img" />
		<cfelse>
			<img src="/images/space_1_1.gif" class="si_img" alt="" />
		</cfif>
		
		<cfif q_select_contacts.activity_count_appointments GT 0>
			<img src="/images/si/calendar.png" class="si_img" />
		<cfelse>
			<img src="/images/space_1_1.gif" class="si_img" alt="" />
		</cfif>
		
		<cfif q_select_contacts.activity_count_salesprojects GT 0>
			<img src="/images/si/coins_add.png" class="si_img" alt="sales projects" />
		<cfelse>
			<img src="/images/space_1_1.gif" class="si_img" alt="" />
		</cfif>
	</td>
	<td>
		<a onClick="OpenEmailPopup('#jsstringformat(q_select_contacts.entrykey)#', '#jsstringformat(q_select_contacts.email_prim)#');return false;" href="##">#shortenstring(q_select_contacts.email_prim, 20)#</a>
		
		<cfif len(q_select_contacts.b_telephone) GT 0>
			/ <a href="javascript:OpenCallPopup('#q_select_contacts.entrykey#', '#jsstringformat(q_select_contacts.b_telephone)#');">#htmleditformat(q_select_contacts.b_telephone)#</a>
		<cfelseif len(q_select_contacts.b_MOBILE) GT 0>
			/ <a href="javascript:OpenCallPopup('#urlencodedformat(q_select_contacts.b_MOBILE)#', 'mobile');">#htmleditformat(q_select_contacts.b_mobile)#</a>
		<cfelseif len(q_select_contacts.p_telephone) GT 0>
			/ <a href="javascript:OpenCallPopup('#urlencodedformat(q_select_contacts.p_telephone)#', 'mobile');">#htmleditformat(q_select_contacts.p_telephone)#</a>
		<cfelse>
			&nbsp;
		</cfif>		
	</td>
	<td>
		<cfif ListFind(a_str_objectkeys_with_assignments, q_select_contacts.entrykey) GT 0>
			<cfquery name="q_select_assignments_for_object" dbtype="query">
			SELECT
				*
			FROM
				q_select_assignments
			WHERE
				objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_contacts.entrykey#">
			;
			</cfquery>
			
			<cfloop query="q_select_assignments_for_object">
				#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_assignments_for_object.userkey)#
			</cfloop>
		</cfif>
	</td>
    <td style="white-space:nowrap;">
		<cfset a_str_id = 'id_a_file_' & Hash(q_select_contacts.entrykey) & RandRange(1, 9999)>
		<a href="##" id="#a_str_id#" onClick="SetCurrentlySelectedContacts('#jsstringformat(q_select_contacts.entrykey)#');ShowHTMLActionPopup('#a_str_id#', a_act_popm);return false;">#GetLangVal('cm_wd_action')#</a>			
	</td>
  </tr>
  </cfoutput>
</table>


