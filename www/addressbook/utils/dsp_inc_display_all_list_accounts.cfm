<!--- //

	Module:		AddressBook
	Action:		ShowAll
	Description:Display all items, Accounts


// --->


<!--- old display routine ... --->
<table class="table table-hover">
  <tr class="tbl_overview_header">
	<td style="width:35px;">
		<a href="#" onclick="SelectAllDisplayedItems();return false;"><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></a>
	</td>
	<td>
		<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'orderby', 'company,surname')>
		<a href="index.cfm?<cfoutput>#a_str_href#</cfoutput>"><cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput></a>

		<cfif sOrderBy IS 'company,surname'>
			<img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" width="14" height="10" alt="" border="0"/>
		</cfif>
	</td>
	<td>
		<cfset a_str_href = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'orderby', 'b_city')>
		<a href="index.cfm?<cfoutput>#a_str_href#</cfoutput>"><cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput></a>

		<cfif sOrderBy IS 'b_city'>
			<img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" width="14" height="10" alt="" border="0"/>
		</cfif>
	</td>
	<td>
		<cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput>
	</td>
	<td>
		<cfoutput>#GetLangVal('adrb_wd_telephone')#</cfoutput>
	</td>
	<td>
		<cfoutput>#GetLangVal('crm_wd_custodian')#</cfoutput>
	</td>
  </tr>

  <cfoutput query="q_select_contacts">
  <tr>
	<td>
		<input type="checkbox" name="frmcbselect" value="#htmleditformat(q_select_contacts.entrykey)#" class="noborder" />
	</td>
	<td>
		<span class="glyphicon glyphicon-th-large"></span> <a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#" style="font-weight:bold;">#htmleditformat(shortenstring(CheckZeroString(q_select_contacts.company), 25))#</a>
	</td>
	<td>
		#htmleditformat(q_select_contacts.b_city)#
	</td>
	<td>
		<cfset a_int_sub_contact = 0>

		<cfloop from="1" to="#ArrayLen(stReturn.a_struct_accounts[q_select_contacts.entrykey])#" index="a_int_sub_contact">
			<cfset a_struct_sub_contact = stReturn.a_struct_accounts[q_select_contacts.entrykey][a_int_sub_contact]>

			<a href="index.cfm?action=ShowItem&entrykey=#a_struct_sub_contact.entrykey#">#htmleditformat(CheckZeroString(a_struct_sub_contact.surname))#<cfif Len(a_struct_sub_contact.firstname) GT 0>, #htmleditformat(a_struct_sub_contact.firstname)#</cfif></a>

			<cfif Len(a_struct_sub_contact.department & a_struct_sub_contact.aposition) GT 0>
				&nbsp;/&nbsp;#htmleditformat(a_struct_sub_contact.department)# #htmleditformat(a_struct_sub_contact.aposition)#
			</cfif>
			<br />
		</cfloop>
	</td>

	<td>
		<cfif len(q_select_contacts.b_telephone) GT 0>
			#q_select_contacts.b_telephone#
		<cfelseif len(q_select_contacts.b_MOBILE) GT 0>
			<a href="javascript:ComposeSMS2Nr('#urlencodedformat(q_select_contacts.b_MOBILE)#');"><img src="/images/ico_mobil.gif" hspace="2" vspace="2" border="0" align="absmiddle" alt="">#q_select_contacts.b_mobile#</a>
		<cfelseif len(q_select_contacts.p_telephone) GT 0>
			#q_select_contacts.p_telephone#
		<cfelseif len(q_select_contacts.p_mobile) GT 0>
			<a href="javascript:ComposeSMS2Nr('#urlencodedformat(q_select_contacts.p_mobile)#');"><img src="/images/ico_mobil.gif" hspace="2" vspace="2" border="0" align="absmiddle" alt="">#q_select_contacts.p_mobile#</a>
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
  </tr>
  </cfoutput>
</table>


