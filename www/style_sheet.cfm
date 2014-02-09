<!--- //

	Module:		Framework
	Description:Include the needed stylesheet files
				Maybe the customer/user is using a custom stylesheet as well
				
				Additionally we offer optimizing cascading stylesheets for mac, linux and firefox 
				
				start ALWAYS with the STANDARD stylesheet ...
			// --->

<cfoutput>#application.components.cmp_render.CallStyleSheetInclude()#</cfoutput>