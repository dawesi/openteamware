<!--- //

	Module:		Address Book
	Action:		ShowTopPanelSavedFilterList
	Description:Display list of saved filters


// --->

<cfsilent>
﻿<cfinvoke component="#application.components.cmp_crmsales#" method="GetListOfViewFilters" returnvariable="q_select_all_filters">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

</cfsilent>
<br />
<cfoutput>#GetLangVal('crm_ph_filter_click_to_load')#</cfoutput>

<table class="table table-hover" style="margin-top:10px;">
	<tr class="tbl_overview_header">
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
		<td>
			&nbsp;
		</td>
	</tr>
	<cfoutput query="q_select_all_filters">
	<tr>
		<td>
			<a href="index.cfm?action=ShowContacts&filterviewkey=#q_select_all_filters.entrykey#" style="font-weight:bold;"><img src="/images/si/database_add.png" class="si_img" /> #htmleditformat(q_select_all_filters.viewname)#</a>
		</td>
		<td>
			#htmleditformat(q_select_all_filters.description)#
		</td>
		<td>
			<input onClick="GotoLocHref('index.cfm?action=ShowContacts&filterviewkey=#q_select_all_filters.entrykey#')" class="btn" type="button" value="#GetLangVal('cm_ph_btn_action_apply')# ..." />
		</td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="3">
			<cfoutput>
				<a href="index.cfm?action=AdvancedSearch&filterdatatype=#url.filterdatatype#"><span class="glyphicon glyphicon-pencil"></span> #GetLangVal('crm_ph_edit_filter_criteria')#</a>
			</cfoutput>
		</td>
	</tr>
</table>

