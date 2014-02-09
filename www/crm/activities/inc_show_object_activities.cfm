<!--- //

	Module:		Address Book
	Action:		IncShowItemActivities
	Description:Display open item activities
	

// --->

<cfparam name="url.editmode" type="boolean" default="false">

<!--- contactkeys --->
<cfparam name="url.entrykeys" type="string" default="">
<cfparam name="url.rights" type="string" default="read">

<!--- entrykey of salesproject (if empty, show all data) --->
<cfparam name="url.projectkey" type="string" default="">

<cfset url.entrykey = url.entrykeys />

<!--- invalid request? --->
<cfif Len(url.entrykeys) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_filter_calendar = StructNew() />
<cfset a_struct_filter_calendar.date_start = DateAdd('d', -7, Now()) />
<cfset a_struct_filter_calendar.date_end = DateAdd('yyyy', 3, Now()) />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetItemActivitiesAndData" returnvariable="a_struct_output_appointments">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykey#">
	<cfinvokeargument name="filter" value="#a_struct_filter_calendar#">
	<cfinvokeargument name="managemode" value="#url.editmode#">
	<cfinvokeargument name="type" value="appointments">
	<cfinvokeargument name="projectkey" value="#url.projectkey#">
</cfinvoke>

<cfif a_struct_output_appointments.recordcount GT 0>
	<cfoutput>#a_struct_output_appointments.a_str_content#</cfoutput>
</cfif>

<!--- projects (sales, common) ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="GetItemActivitiesAndData" returnvariable="a_struct_output_projects">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykey#">
	<cfinvokeargument name="managemode" value="#url.editmode#">
	<cfinvokeargument name="rights" value="#url.rights#">
	<cfinvokeargument name="type" value="projects">
</cfinvoke>

<cfif a_struct_output_projects.recordcount GT 0>
	<cfoutput>#a_struct_output_projects.a_str_content#</cfoutput>
</cfif>

<cfset a_struct_filter_followups = StructNew() />
<cfset a_struct_filter_followups.statusonly = 0 />

<cfinvoke component="#application.components.cmp_crmsales#" method="GetItemActivitiesAndData" returnvariable="a_struct_output_followups">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykey#">
	<cfinvokeargument name="filter" value="#a_struct_filter_followups#">
	<cfinvokeargument name="managemode" value="#url.editmode#">
	<cfinvokeargument name="rights" value="#url.rights#">
	<cfinvokeargument name="projectkey" value="#url.projectkey#">
	<cfinvokeargument name="type" value="followups">
</cfinvoke>

<cfif a_struct_output_followups.recordcount GT 0>
	<cfoutput>#a_struct_output_followups.a_str_content#</cfoutput>
</cfif>

<cfset a_struct_filter_tasks = StructNew() />
<cfset a_struct_filter_tasks.exclude_status = 0 />
	
<cfinvoke component="#application.components.cmp_crmsales#" method="GetItemActivitiesAndData" returnvariable="a_struct_output_tasks">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykey#">
	<cfinvokeargument name="filter" value="#a_struct_filter_tasks#">
	<cfinvokeargument name="managemode" value="#url.editmode#">
	<cfinvokeargument name="rights" value="#url.rights#">	
	<cfinvokeargument name="projectkey" value="#url.projectkey#">
	<cfinvokeargument name="type" value="tasks">
</cfinvoke>

<cfoutput>#a_struct_output_tasks.a_str_content#</cfoutput>

