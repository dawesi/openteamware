<!--- //

	Module:        Universal selector
	Description:   Select workgroup shares ...
	
	Parameters

// --->

<cfparam name="url.inputvalue" type="string" default="">
<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">

<!--- load all workgroups where this user has write access ... --->
<cfinvoke component="#application.components.cmp_security#" method="LoadPossibleWorkgroupsForAction" returnvariable="q_select_workgroups">
	<cfinvokeargument name="desiredactions" value="write">
	<cfinvokeargument name="q_workgroup_permissions" value="#request.stSecurityContext.q_select_workgroup_permissions#">
</cfinvoke>

<!--- load the existing permissions ... --->
<cfinvoke component="#application.components.cmp_security#" method="GetWorkgroupSharesForObject" returnvariable="q_select_shares">
	<cfinvokeargument name="entrykey" value="#url.objectkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
</cfinvoke>

<form class="frm_inpage" id="form_save_wg_shares_inpage" name="form_save_wg_shares_inpage">
<div class="div_form_btn_area">
<input onClick="UniversalSelectorSetReturnValues(CollectCheckedSelectBoxesValues('form_save_wg_shares_inpage'), UniversalSelectorGetDisplayValuesOfCheckedElements('form_save_wg_shares_inpage', 'frm_wg_name_'));" class="btn btn-primary" type="button" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_ph_btn_action_apply')#</cfoutput>">

</div>

<table class="table table_details">
<cfoutput query="q_select_workgroups">
<tr>
	<td>
	<cfloop from="1" to="#q_select_workgroups.workgrouplevel#" index="ii">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>

	<!--- output list of subscribed workgroups ... add display name of workgroups as well ... --->
	<cfif ListFindNoCase(q_select_workgroups.permissions, 'write') GT 0>
		<!--- check if managepermissions is true ... --->
		<input type="hidden" id="frm_wg_name_#q_select_workgroups.workgroup_key#" name="frm_wg_name_#q_select_workgroups.workgroup_key#" value="#htmleditformat(q_select_workgroups.workgroup_name)#" />
		<input id="frmcb#q_select_workgroups.currentrow#" type="checkbox" <cfif ListFindNoCase(url.inputvalue, q_select_workgroups.workgroup_key) GT 0>checked</cfif>  name="frmcbworkgroups" value="#htmleditformat(q_select_workgroups.workgroup_key)#" class="noborder"> <label style="cursor:hand;" for="frmcb#q_select_workgroups.currentrow#">#htmleditformat(q_select_workgroups.workgroup_name)#</label>
	</cfif>
	</td>
</tr>
</cfoutput>
<tr>
	<td>
	<cfoutput>#GetLangVal('cm_ph_workgroups_share_select_groups_description')#</cfoutput>
	</td>
</tr>
</table>
</form>


