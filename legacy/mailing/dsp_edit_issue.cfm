<!--- //

	Module:		Mailing
	Action:		Create/Edit an issue
	Description:	
	

// ---><!--- the issuekey ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>

<cfset CreateEditIssue.Query = a_cmp_nl.GetIssue(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, entrykey = url.entrykey)>

<cfset CreateEditIssue.Action = 'edit'>

<cfinclude template="dsp_inc_create_edit_issue.cfm">
