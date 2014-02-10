<!--- //

	load the data associated with ONE contact
	
	// --->


<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<cfset stReturn.a_struct_crmsales_bindings = a_struct_crmsales_bindings>