<!--- //

	Module:		CRM
	Function:	GetContactActitivitesData
	Description:Return history activities ...
	

	
	
	Use a filter to filter out unreached calls
	
// --->



<cfswitch expression="#arguments.area#">
	<cfcase value="emailfaxsms">
		<!--- email only ... --->
		<cfset a_struct_filter.item_type = '3' />
	</cfcase>
	<cfdefaultcase>
		
		<!--- default ... no missed calls ... --->
		<cfset a_struct_filter.not_item_type = '5' />
	</cfdefaultcase>
</cfswitch>

<cfset a_struct_history = GetHistoryItemsOfContact(securitycontext = arguments.securitycontext,
									usersettings = arguments.usersettings,
									servicekey = arguments.servicekey,
									objectkeys = arguments.entrykeys,
									filter = a_struct_filter) />

<cfset q_select_history_items = a_struct_history.q_select_history_items />

<!--- pda? --->
<cfset a_bol_is_pda = (arguments.usersettings.device.type IS 'pda') />

<cfsavecontent variable="a_str_output">
<table class="table_overview">
	<tr class="tbl_overview_header">
	<cfoutput>
		<td>#GetLangVal('cm_ph_timestamp')#</td>
		<td>#GetLangVal('cm_wd_type')#</td>
		<cfif NOT a_bol_is_pda>
		<td>#GetLangVal('cm_wd_user')#</td>
		<td>#GetLangVal('cm_wd_contact')#</td>
		</cfif>
		<td>#GetLangVal('cm_Wd_text')#</td>
		<cfif NOT a_bol_is_pda>
			<td>#GetLangVal('cm_wd_categories')#</td>
			
			<td>#GetLangVal('cm_wd_link')#</td>
			
			<cfif arguments.managemode>
				<td>
					#GetLangVal('cm_wd_action')#
				</td>
			</cfif>
		</cfif>
	</cfoutput>
	</tr>
	<cfoutput query="q_select_history_items">
		<tr>
			<td>
				#FormatDateTimeAccordingToUserSettings(q_select_history_items.dt_created)#
			</td>
			<td>
				<cfswitch expression="#q_select_history_items.item_type#">
					<cfcase value="1">
						<img src="/images/si/telephone.png" class="si_img" />
					</cfcase>
					<cfcase value="3">
						<img src="/images/si/email.png" class="si_img" />
					</cfcase>
					<cfcase value="4">
						<img src="/images/si/page_word.png" class="si_img" />
					</cfcase>
					<cfdefaultcase>
						
						<!--- in case of the default case (=0) try to display an image of a project ... --->
						<cfswitch expression="#q_select_history_items.linked_servicekey#">
							<cfcase value="5137784B-C09F-24D5-396734F6193D879D">
								<img src="/images/si/chart_organisation.png" class="si_img" />
							</cfcase>
							<cfdefaultcase>
								<img src="/images/si/bullet_orange.png" class="si_img" />
							</cfdefaultcase>>
						</cfswitch>

					</cfdefaultcase>>
				</cfswitch>
			</td>
			<cfif NOT a_bol_is_pda>
			<td>
				<a href="/workgroups/?action=ShowUser&entrykey=#q_select_history_items.createdbyuserkey#">#htmleditformat(application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_history_items.createdbyuserkey))#</a>
			</td>
			<td>
				<a href="/addressbook/?action=ShowItem&entrykey=#q_select_history_items.objectkey#">#htmleditformat(application.components.cmp_addressbook.GetContactDisplayNameData(q_select_history_items.objectkey))#</a>
			</td>
			</cfif>
			
			<cfset a_str_td_id = 'id_history_' & Hash(CreateUUID()) & q_select_history_items.currentrow />
			
			<td id="#a_str_td_id#">
				
				<cfset a_int_len_text = Len(q_select_history_items.comment) />
				
				<cfif a_int_len_text LTE 500>
					#FormatTextToHTML(q_select_history_items.comment)#
				<cfelse>
					#FormatTextToHTML(ShortenString(q_select_history_items.comment, 500))#
						
					<cfif a_bol_is_pda>
						<a href="/crm/?action=ShowFullHistoryData&entrykey=">Alle Daten anzeigen ...</a>
					<cfelse>
						<br /> 
						<a href="##" onclick="LoadFullHistoryItem('#JsStringFormat(q_select_history_items.servicekey)#', '#JsStringFormat(q_select_history_items.objectkey)#', '#JsStringFormat(q_select_history_items.entrykey)#', '#a_str_td_id#');"><img src="/images/si/page_white_go.png" class="si_img" /> #GetLangval('crm_ph_load_full_entry')#</a>
					</cfif>
					
				</cfif>
				
			</td>
			
			<cfif NOT a_bol_is_pda>
				<td>
					#htmleditformat(q_select_history_items.categories)#
				</td>
				
				<td>
					<cfif (Len(q_select_history_items.linked_servicekey) GT 0) AND (Len(q_select_history_items.linked_objectkey) GT 0)>
	
						#application.components.cmp_tools.GenerateLinkToItem(usersettings = arguments.usersettings,
								servicekey = q_select_history_items.linked_servicekey,
								objectkey = q_select_history_items.linked_objectkey,
								title = GetLangVal('cm_wd_details'),
								format = 'html')#
					</cfif>
				</td>
				<cfif arguments.managemode>
					<td>
						<a href="/crm/?action=ShowEditHistoryItem&amp;entrykey=#q_select_history_items.entrykey#">#si_img('pencil')#</a>
						<a href="##" onclick="ShowSimpleConfirmationDialog('/crm/?action=DeleteHistoryItem&amp;entrykey=#q_select_history_items.entrykey#');return false;">#si_img('delete')#</a>
					</td>
				</cfif>
			</cfif>	
		</tr>
	</cfoutput>
</table>

</cfsavecontent>

<cfset stReturn.recordcount = q_select_history_items.recordcount />
<cfset stReturn.output = a_str_output />

<!---
	$Log: inc_generate_output_activities.cfm,v $
	Revision 1.8  2007-10-11 18:23:55  hansjp
	added edit/delete links

	Revision 1.7  2007-09-10 13:35:14  hansjp
	- varing all local variables- xml formatting

	Revision 1.6  2007-07-15 12:10:27  hansjp
	special treatment for pda (no link, no user, no contact information)

	Revision 1.5  2007-06-27 14:12:59  hansjp
	display link to linked objectdisplay right imagedisplay only first 500 chars

	--->