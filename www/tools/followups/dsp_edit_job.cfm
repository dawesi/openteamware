<cfparam name="url.returnurl" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfabort>
</cfif>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.entrykey = url.entrykey>
<cfset a_struct_filter.userkey = request.stSecurityContext.myuserkey>

<cfinvoke component="#request.a_str_component_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="">
	<cfinvokeargument name="objectkeys" value="">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cf_disp_navigation mytextleft="Editieren">
<br>

<cfset CreateEditFollowupJob.action = 'edit'>
<cfset CreateEditFollowupJob.query = q_select_follow_ups>
<cfset CreateEditFollowupJob.returnurl = url.returnurl>

<cfinclude template="dsp_inc_edit_create_job.cfm">