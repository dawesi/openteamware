<!--- //

	Module:		AddressBook
	Action:		ShowAll
	Description:Display all items, contacts


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
  <tr>
	<td>
		<input type="checkbox" name="frmcbselect" value="#htmleditformat(q_select_contacts.entrykey)#" class="noborder">
	</td>
	<td>
		<span class="glyphicon glyphicon-user"></span> <a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#" style="font-weight:bold;">#htmleditformat(checkzerostring(trim(q_select_contacts.surname)))#<cfif Len(q_select_contacts.firstname) GT 0>, #htmleditformat(q_select_contacts.firstname)#</cfif></a>
	</td>
    <td title="#htmleditformat( q_select_contacts.aposition )#">
		#htmleditformat(shortenstring ( q_select_contacts.aposition, 25 ))#
	</td>
	<td>
		<cfif Len(q_select_contacts.parentcontactkey) GT 0>
			<a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.parentcontactkey)#">#htmleditformat(shortenstring(q_select_contacts.company, 25))#</a>
		<cfelse>
			#htmleditformat(shortenstring(q_select_contacts.company, 25))#
		</cfif>
	</td>
	<td>
		<!--- display activites ... --->
		<cfif q_select_contacts.activity_count_followups>
			<span class="glyphicon glyphicon-flag"></span>
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
		<cfsavecontent variable="a_str_contact_data">
		<cfif Len(q_select_contacts.email_prim) GT 0>
		<a onClick="OpenEmailPopup('#jsstringformat(q_select_contacts.entrykey)#', '#jsstringformat(q_select_contacts.email_prim)#');return false;" href="##" title="#htmleditformat( q_select_contacts.email_prim )#"><!--- #shortenstring(q_select_contacts.email_prim, 20)# --->@</a>
		</cfif>

		<cfif len(q_select_contacts.b_telephone) GT 0>
			/ <a href="javascript:OpenCallPopup('#q_select_contacts.entrykey#', '#jsstringformat(q_select_contacts.b_telephone)#');">#htmleditformat(q_select_contacts.b_telephone)#</a>
		<cfelseif len(q_select_contacts.b_MOBILE) GT 0>
			/ <a href="javascript:OpenCallPopup('#urlencodedformat(q_select_contacts.b_MOBILE)#', 'mobile');">#htmleditformat(q_select_contacts.b_mobile)#</a>
		<cfelseif len(q_select_contacts.p_telephone) GT 0>
			/ <a href="javascript:OpenCallPopup('#urlencodedformat(q_select_contacts.p_telephone)#', 'mobile');">#htmleditformat(q_select_contacts.p_telephone)#</a>
		</cfif>

		</cfsavecontent>

		<cfset a_str_contact_data = ReReplace(Trim(a_str_contact_data), '^/', '', 'one') />

		<cfif Len(a_str_contact_data) GT 0>#a_str_contact_data#<br /></cfif>

		#htmleditformat(q_select_contacts.b_zipcode)# #htmleditformat(q_select_contacts.b_city)#
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
	<!--- <cfif variables.a_bol_crm_extensions_enabled>
		<td>

			<cfif ListFind(a_str_objectkeys_with_followups, q_select_contacts.entrykey) GT 0><img src="/images/flag.gif" alt="Nachverfolgung" width="16" height="16" hspace="0" vspace="0" border="0" align="absmiddle"></cfif>
			&nbsp;
		</td>
		<cfset a_bol_crm_data_available = false>
		<td>

			<cfif Len(q_select_contacts.b_zipcode) GT 0 OR Len(q_select_contacts.b_city) GT 0>
				<cfset a_bol_crm_data_available = true>
				#q_select_contacts.b_zipcode# #q_select_contacts.b_city#<br />
			</cfif>
			<cfif Len(q_select_contacts.b_telephone) GT 0>
				<cfset a_bol_crm_data_available = true>
				T: #q_select_contacts.b_telephone#<br />
			</cfif>
			<cfif Len(q_select_contacts.b_MOBILE) GT 0>
				<cfset a_bol_crm_data_available = true>
				M: #q_select_contacts.b_MOBILE#<br />
			</cfif>
			<!--- bearbeiter --->


				<cfset a_bol_crm_data_available = true>

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
					<cfif Compare(q_select_assignments_for_object.userkey, request.stSecurityContext.myuserkey) IS 0>
					<font class="addinfotext">
					</cfif>

					<font color="##CC0000">B:</font> #variables.a_cmp_show_username.GetUsernamebyentrykey(q_select_assignments_for_object.userkey)#

					<cfif Len(q_select_assignments_for_object.comment) GT 0>
						(#shortenstring(q_select_assignments_for_object.comment, 15)#)
					</cfif>
					<cfif Compare(q_select_assignments_for_object.userkey, request.stSecurityContext.myuserkey) IS 0>
						</font>
					</cfif>
					<br />
				</cfloop>

			</cfif>
			<!--- termine ausgemacht? --->

			<cfif NOT a_bol_crm_data_available>&nbsp;</cfif>
		</td>
	</cfif> --->
    <td>
		<span class="glyphicon glyphicon-pencil"></span>
	</td>
  </tr>
  </cfoutput>
</table>


