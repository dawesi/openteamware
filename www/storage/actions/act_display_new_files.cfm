<!--- //

	Module:		Storage
	Action:		DisplayLatelyAddedFilesList
	Description: 
	

// --->

<cfparam name="url.type" type="string" default="newfiles">

<cfset a_struct_recent = application.components.cmp_storage.GetRecentFileList(securitycontext = request.stSecurityContext,
							usersettings = request.stUserSettings,
							type = url.type) />

<cfset q_select_recent_files = a_struct_recent.q_select_recent_files />

<cfset a_query_displayfiles = q_select_recent_files>
<cfset url.ordertype = 'DESC'>
<cfinclude template="../dsp_display_files.cfm">

