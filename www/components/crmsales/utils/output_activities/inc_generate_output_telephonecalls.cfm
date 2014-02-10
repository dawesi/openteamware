<!--- //

	Module:		CRM
	Function:	GetContactActitivitesData
	Description:Return telephone call activities (reached / not reached ...)
	

	
	
	Use a filter to get calls only from history
	
// --->

<cfset a_struct_filter.item_type = '1,5' />

<cfset a_struct_call_history = GetHistoryItemsOfContact(securitycontext = arguments.securitycontext,
									usersettings = arguments.usersettings,
									servicekey = arguments.servicekey,
									objectkeys = arguments.entrykeys,
									filter = a_struct_filter) />

<cfset q_select_history_items = a_struct_call_history.q_select_history_items />

<cfsavecontent variable="a_str_output">
	
<table class="table_overview">
	<tr class="tbl_overview_header">
	<cfoutput>
		<td>#GetLangVal('cm_ph_timestamp')#</td>
		<td>#GetLangVal('crm_wd_reached')#</td>
		<td>#GetLangVal('cm_wd_user')#</td>
		<td>#GetLangVal('cm_wd_contact')#</td>
		<td>#GetLangVal('cm_Wd_text')#</td>
		<td>#GetLangVal('cm_wd_categories')#</td>
	</cfoutput>
	</tr>
	<cfoutput query="q_select_history_items">
		<tr>
			<td>
				#LsDateFormat(q_select_history_items.dt_created, request.stUserSettings.default_dateformat)#
			</td>
			<td>
				<cfif q_select_history_items.item_type IS 1>
					<img src="/images/si/accept.png" class="si_img" />
				<cfelse>
					<img src="/images/si/cancel.png" class="si_img" />
				</cfif>
			</td>
			<td>
				#htmleditformat(application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_history_items.createdbyuserkey))#
			</td>
			<td>
				<a href="/addressbook/?action=ShowItem&entrykey=#q_select_history_items.objectkey#">#htmleditformat(application.components.cmp_addressbook.GetContactDisplayNameData(q_select_history_items.objectkey))#</a>
			</td>
			<td>
				#FormatTextToHTML(q_select_history_items.comment)#
			</td>
			<td>
				#htmleditformat(q_select_history_items.categories)#
			</td>
		</tr>
	</cfoutput>
</table>

</cfsavecontent>

<cfset stReturn.recordcount = q_select_history_items.recordcount />
<cfset stReturn.output = a_str_output />



