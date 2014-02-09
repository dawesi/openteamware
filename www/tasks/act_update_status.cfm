<!--- //

	update the status of an item
	
	// --->
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.status" type="numeric" default="1">
	
<cfinclude template="../login/check_logged_in.cfm">

<cfset stUpdate = StructNew()>

<cfset stUpdate.entrykey = url.entrykey>
<cfset stUpdate.status = url.status>

<cfif url.status IS 0>
	<cfset stUpdate.percentdone = 100>
</cfif>

<cfinvoke component="/components/tasks/cmp_task" method="UpdateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
</cfinvoke>

<!--- link back ... --->
<cflocation addtoken="no" url="#ReturnRedirectURL()#">