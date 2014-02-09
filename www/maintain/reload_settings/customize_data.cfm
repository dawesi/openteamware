

<cflock scope="server" timeout="30" type="exclusive">
	<!--- clear --->
	<cfset tmp = StructClear(server.A_STRUCT_CUSTOM_STYLES)>

	<!--- reload styles ... --->
	<cfset server.a_struct_custom_styles = application.components.cmp_customize.ReturnAllAvailableStyles()>
</cflock>

<cfoutput>#StructCount(server.a_struct_custom_styles)#</cfoutput> styles reloaded.