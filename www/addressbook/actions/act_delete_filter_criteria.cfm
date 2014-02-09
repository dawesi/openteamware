<!--- //

	Module:		Address Book
	Description:DeleteFilterCriteria
	
				Delete a certain criteria ...
				
// --->

<!--- entrykey of filter and filter criteria ... --->
<cfparam name="url.filterviewkey" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_crmsales#" method="DeleteFilterCriteria" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="viewkey" value="#url.filterviewkey#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="no" url="/addressbook/">