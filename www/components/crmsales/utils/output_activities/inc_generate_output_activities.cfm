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

<cfsavecontent variable="a_str_output">
<table class="table table-hover">
	<tr class="tbl_overview_header">
	<cfoutput>
		<td>#GetLangVal('cm_ph_timestamp')#</td>
		<td>#GetLangVal('cm_wd_user')#</td>
<!--- 		<td>#GetLangVal('cm_wd_contact')#</td> --->
		<td>#GetLangVal('cm_Wd_text')#</td>

			<cfif arguments.managemode>
				<td>
					#GetLangVal('cm_wd_action')#
				</td>
		</cfif>
	</cfoutput>
	</tr>
	<cfoutput query="q_select_history_items">
		<tr>
			<td>
				<cfswitch expression="#q_select_history_items.item_type#">
					<cfcase value="1">
						<span class="glyphicon glyphicon-earphone"></span>
					</cfcase>
					<cfcase value="4">
						<span class="glyphicon glyphicon-file"></span>
					</cfcase>
					<cfdefaultcase>

						<span class="glyphicon glyphicon-header"></span>

					</cfdefaultcase>>
				</cfswitch>

				#FormatDateTimeAccordingToUserSettings(q_select_history_items.dt_created)#
			</td>
			<td>
				<a href="/workgroups/?action=ShowUser&entrykey=#q_select_history_items.createdbyuserkey#">#htmleditformat(application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_history_items.createdbyuserkey))#</a>
			</td>
			<!--- <td>
				<a href="/addressbook/?action=ShowItem&entrykey=#q_select_history_items.objectkey#">#htmleditformat(application.components.cmp_addressbook.GetContactDisplayNameData(q_select_history_items.objectkey))#</a>
			</td> --->
			<td>
				#FormatTextToHTML(q_select_history_items.comment)#
			</td>
				<cfif arguments.managemode>
					<td>
						<a href="/crm/?action=ShowEditHistoryItem&amp;entrykey=#q_select_history_items.entrykey#">#si_img('pencil')#</a>
						<a href="##" onclick="ShowSimpleConfirmationDialog('/crm/?action=DeleteHistoryItem&amp;entrykey=#q_select_history_items.entrykey#');return false;"><span class="glyphicon glyphicon-trash�></span></a>
					</td>
			</cfif>
		</tr>
	</cfoutput>
</table>

</cfsavecontent>

<cfset stReturn.recordcount = q_select_history_items.recordcount />
<cfset stReturn.output = a_str_output />
