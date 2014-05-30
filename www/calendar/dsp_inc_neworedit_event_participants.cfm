<!--- //
	Module:		Calendar
	Action:		Create/edit event
	Description:Check participants/resources added to event
	

	
// --->

<cfprocessingdirective pageencoding="utf-8">

<!--- <div class="bb" style="padding:4px; "><cfoutput>#GetLangVal('cal_ph_newedit_participants_invite')#</cfoutput></div>

<div class="addinfotext" style="padding:4px;line-height:17px;">
<cfoutput>#GetLangVal('cal_ph_newedit_participants_invite_description')#</cfoutput>
</div> --->

<div style="padding:8px;">
<!--- 

TODO hp: implement this feature in future release

<input type="checkbox" value="1" name="frmoptions" id="frmoptions" value="publicparticipantslist" /> <cfoutput>#GetLangVal('cal_ph_list_of_participants_is_public')#</cfoutput>
<br /><br />  --->
 
<div id="id_div_show_assigned_members_resources">
</div>
<br /> 
<cfset tmp = AddJSToExecuteAfterPageLoad('loadAssignedResources("#Variables.NewOrEditEvent.query.entrykey#")', '') />

<cfoutput>#GetLangVal('cm_wd_new')#</cfoutput>:
<cfoutput>
<cfif request.stSecurityContext.q_select_workgroup_permissions.recordcount GT 0>
<input class="btn" type="button" onClick="AddAttendeeToEvent('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#', 0, '#GetLangVal('cm_wd_employee')#');" value="#GetLangVal('cm_wd_employee')#" />
</cfif>

<input class="btn" type="button" onclick="AddAttendeeToEvent('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#', 1, '#GetLangVal('cm_wd_contact')# (#GetLangVal('cm_wd_addressbook')#)');" value="#GetLangVal('cm_wd_contact')# (#GetLangVal('cm_wd_addressbook')#)" />
<input class="btn" type="button" onclick="AddAttendeeToEvent('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#', 2, '#GetLangVal('adrb_wd_email_address')#');" value="#GetLangVal('adrb_wd_email_address')#" />
<input class="btn" type="button" onclick="AddAttendeeToEvent('#jsstringformat(Variables.NewOrEditEvent.Query.entrykey)#', 4, '#GetLangVal('cm_wd_resource')#');" value="#GetLangVal('cm_wd_resource')#" />
</cfoutput>
</div>

