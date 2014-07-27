<!--- //

	Module:		Calendar
	Description:Send a reminder to a person assigned to an appointment
	

	
// --->


<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_securitycontext">
	<cfinvokeargument name="userkey" value="#arguments.userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stUserSettings">
	<cfinvokeargument name="userkey" value="#arguments.userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_calendar#" method="SendInvitation" returnvariable="a_bol_return">
	<cfinvokeargument name="eventkey" value="#arguments.eventkey#">
	<cfinvokeargument name="type" value="#arguments.type#">
	<cfinvokeargument name="parameter" value="#arguments.parameter#">
	<cfinvokeargument name="securitycontext" value="#stReturn_securitycontext#">
	<cfinvokeargument name="usersettings" value="#stUserSettings#">
	<cfinvokeargument name="isreminder" value="true">
</cfinvoke>


