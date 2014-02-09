<!--- //

	Module:        Framework/Admin
	Description:   Reload action switches
	

// --->

<cfinvoke component="/components/appsettings/cmp_services" method="LoadAllServicesActionsSwitches" returnvariable="a_struct_switches">
	<cfinvokeargument name="frontend" value="www">
</cfinvoke>

<cflock scope="Application" type="exclusive" timeout="30">
	<cfset application.actionswitches = a_struct_switches>
</cflock>

OK, ACTIONSWITCHES RELOADED
<br /><br />
  
<cfinvoke component="/components/appsettings/cmp_services" method="LoadAvailableSecurityActionsOfServices" returnvariable="a_struct_switches">
	<cfinvokeargument name="frontend" value="www">
</cfinvoke>

OK, AVAILABLE ACTIONS RELOADED

