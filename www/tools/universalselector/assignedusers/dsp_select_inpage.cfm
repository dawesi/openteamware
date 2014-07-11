<!--- //

	Module:		UniversalSelector
	Description:Select assigned users ...
	

// --->

<!--- userkey maybe to add ... --->
<cfparam name="url.frmadduserkey" type="string" default="">

<cfinvoke component="#application.components.cmp_assigned_items#" method="GetAssignments" returnvariable="q_select_assignments">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
	<cfinvokeargument name="objectkeys" value="#url.objectkey#">
</cfinvoke>

<cfset a_str_existing_assignments = ValueList(q_select_assignments.userkey) />

<!--- add right now selected users plus existing users from input value ... --->
<cfif Len(url.frmadduserkey) GT 0>
	<cfset a_str_existing_assignments = ListAppend(a_str_existing_assignments, url.frmadduserkey) />
</cfif>

<cfif Len(url.inputvalue) GT 0>
	<cfset a_str_existing_assignments = ListAppend(a_str_existing_assignments, url.inputvalue) />
</cfif>


<form name="frmassignusers" id="frmassignusers" class="frm_inpage" action="#" onsubmit="UniversalSelectorSetReturnValues(CollectCheckedSelectBoxesValues('frmassignusers'), UniversalSelectorGetDisplayValuesOfCheckedElements('frmassignusers', 'frm_username_'));return false;">

<div class="div_form_btn_area">
	<input type="submit" value="<cfoutput>#GetLangVal('cm_ph_btn_action_apply')#</cfoutput>" class="btn btn-primary" />
</div>

<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('cm_ph_assign_objects'))#</cfoutput>

<table class="table table-hover">
		
	<cfloop list="#a_str_existing_assignments#" index="a_str_userkey">
	<cfoutput>
		<tr>
			<td>
				<input type="checkbox" name="frm_userkeys" value="#a_str_userkey#" checked="true" class="noborder" />
				<input type="hidden" name="frm_username_#a_str_userkey#" id="frm_username_#a_str_userkey#" value="#htmleditformat(application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(entrykey = a_str_userkey))#" />
			</td>
			<td>
				<img src="/tools/img/show_small_userphoto.cfm?entrykey=#a_str_userkey#" />
			</td>
			<td>
				#htmleditformat(application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(entrykey = a_str_userkey))#
			</td>
		</tr>
	</cfoutput>
	</cfloop>
	
	<cfif ListLen(a_str_existing_assignments) IS 0>
		<tr>
			<td colspan="3">
				<cfoutput>#GetLangVal('crm_ph_no_assignment_found')#</cfoutput>
			</td>
		</tr>
	</cfif>
</table>
</form>

<br /> 

<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="workgroup_memberships" value="#ValueList(request.stSecurityContext.q_select_workgroup_permissions.workgroup_key)#">
</cfinvoke>

<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_ph_create_new_assignment'))#</cfoutput>

<cfoutput>
<form class="frm_inpage" action="#cgi.SCRIPT_NAME#" name="form1" id="form1" method="get" onsubmit="DoHandleAjaxForm(this.id);return false;">
#CreateHiddenFieldsOfURLParameters('frmadduserkey')#
</cfoutput>
<table class="table table_details table_edit_form">
	<tr>
		<td>
			<select name="frmadduserkey" size="5">
					<option value=""><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
				<cfoutput query="q_select_users">
					<option value="#q_select_users.entrykey#">#htmleditformat(q_select_users.surname)#, #htmleditformat(q_select_users.firstname)# (#htmleditformat(q_select_users.username)#) #htmleditformat(q_select_users.aposition)#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput>" class="btn btn-primary" />
		</td>
	</tr>
</table>
</form>

