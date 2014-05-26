<!--- //

	Service:	Address Book
	Action:		SaveCRMFilter
	Description:
	
	Header:		

// --->

<!--- select all criterias without a viewkey ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="GetViewFilters" returnvariable="q_select_filter">
	<cfinvokeargument name="viewkey" value="">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>


<!--- save this data now as new filter ... --->
<cfset form.frmname = CheckZeroString(form.frmname) />

<cfinvoke component="#application.components.cmp_crmsales#" method="CreateViewFilter" returnvariable="stReturn">
	<cfinvokeargument name="name" value="#form.frmname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cflocation addtoken="no" url="../index.cfm?action=Advancedsearch&entrykey=#stReturn.entrykey#">

