<!--- //

	Module:		Settings
	Action:		DoSaveCustomize
	Description:Save customized display settings (stylesheets)
	
// --->

<cfparam name="form.frmcustomstylesheet" type="string" default="">

<cfdump var="#form#">

<cfset a_struct_newvalues = StructNew()>
<cfset a_struct_newvalues.style = form.frmcustomstylesheet>

<cfinvoke component="#application.components.cmp_user#" method="UpdateUserData" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="newvalues" value="#a_struct_newvalues#">
</cfinvoke>