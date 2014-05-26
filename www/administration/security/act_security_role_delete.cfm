<!--- //

	delete now 
	
	// --->

<cfinvoke component="#application.components.cmp_security#" method="DeleteSecurityRole" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="no" url="../index.cfm?action=security#writeurltags()#">