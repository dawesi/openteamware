<!--- //

	take over the ownership of an object
	
	this could be a method to disallow deleting a contact ...
	
	// --->
	
<cfinclude template="../login/check_logged_in.cfm">
	
<cfparam name="url.entrykey" type="string" default="">


<cfinvoke component="/components/tasks/cmp_task" method="TransferOwnership" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="newuserkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>


<cflocation addtoken="no" url="#ReturnRedirectURL()#">