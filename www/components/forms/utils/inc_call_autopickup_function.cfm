<!--- //

	Component:     Forms
	Function:	   CallServicePickupMethod
	Description:   Call the given autopickup method
	

// --->

<cfset a_cmp_service = application.components.cmp_tools.ReturnComponentByServicekey(servicekey = arguments.servicekey) />

<cfinvoke component="#a_cmp_service#" method="#arguments.function_name#" returnvariable="stReturn_pickup_function">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="action_type" value="#arguments.action_type#">
	<cfinvokeargument name="database_values" value="#arguments.database_values#">
	<cfinvokeargument name="all_values" value="#arguments.all_values#">	
</cfinvoke>

