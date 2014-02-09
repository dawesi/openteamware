<!--- //

	Module:		Project
	Description:Edit a project
	

// --->

<cfparam name="url.entrykey" type="string">

<cfinvoke component="#application.components.cmp_projects#" method="GetProject" returnvariable="a_struct_project">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_struct_project.result>
	Not found.
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_project = a_struct_project.q_select_project />

<cfset CreateEditItem = StructNew() />
<cfset CreateEditItem.action = 'edit' />
<cfset CreateEditItem.query = q_select_project />

<cfinclude template="dsp_inc_edit_create_project.cfm">

