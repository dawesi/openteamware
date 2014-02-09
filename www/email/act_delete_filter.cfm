<!--- 

	filter l�schen
	
	--->
<cfparam name="url.id" type="numeric" default="0">


<!--- delete db record --->
<cfset DeleteFilterRequest.id = url.id>
<cfinclude template="queries/q_delete_filter.cfm">

<!--- create config ... --->
<cfinvoke component="/components/email/cmp_filter" method="CreateProcmailconfig" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>

<!--- redirect --->
<cflocation addtoken="no" url="default.cfm?action=filter">