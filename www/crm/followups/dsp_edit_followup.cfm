<!--- //

	Service:	CRM
	Action:		EditFollowup
	Description:Edit a follow up item
	
	Header:		

// --->

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_followups#" method="GetFollowup" returnvariable="a_struct_fup">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_struct_fup.result>
	Object not found.
	<cfexit method="exittemplate">
</cfif>

<cfset CreateEditFollowupJob = StructNew() />
<cfset CreateEditFollowupJob.returnurl = ReturnRedirectURL() />
<cfset CreateEditFollowupJob.action = 'edit' />
<cfset CreateEditFollowupJob.query = a_struct_fup.q_select_follow_up />

<cfinclude template="dsp_inc_create_edit_followup.cfm">

