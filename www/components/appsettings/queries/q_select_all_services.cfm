<!--- //

	Component:	Services
	Description:Load all available services
	

// --->

<cfset q_select_all_services = application.components.cmp_tools.ReturnStoredXMLDatabaseAsQuery('myapp.services')>

