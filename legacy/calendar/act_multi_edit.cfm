<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="form.frmcb_item" type="string" default="">


<cfloop list="#form.frmcb_item#" delimiters="," index="sEntrykey">
	
	<cfinvoke component="#application.components.cmp_calendar#" method="DeleteEvent" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#sEntrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>	

</cfloop>


<cflocation addtoken="no" url="#ReturnRedirectURL()#">