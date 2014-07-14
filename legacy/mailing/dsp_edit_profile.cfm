<!--- //

	Module:		Mailings
	Action:		EditProfile
	Description: 
	

// --->



<cfparam name="url.entrykey" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>

<cfset q_select_profile = a_cmp_nl.GetNewsletterProfile(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, entrykey = url.entrykey)>

<cfset CreateEditNLProfile = StructNew() />
<cfset CreateEditNLProfile.action = 'edit' />
<cfset CreateEditNLProfile.Query = q_select_profile />

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_edit')) />

<cfinclude template="dsp_inc_edit_create_profile.cfm">

