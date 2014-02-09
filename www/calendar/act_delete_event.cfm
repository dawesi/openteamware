

<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="form.frmentrykey" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.return" type="string" default="">

<cfif Len(form.frmentrykey) GT 0>
	<cfset sEntrykey = form.frmentrykey>
<cfelse>
	<cfset sEntrykey = url.entrykey>
</cfif>


<cfif len(sEntrykey) is 0>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>


<!--- delete event ... --->

<cfinvoke component="#application.components.cmp_calendar#" method="DeleteEvent" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#sEntrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>


<cfif FindNoCase('ShowEvent', cgi.HTTP_REFERER) GT 0>
	<cflocation addtoken="no" url="default.cfm">
<cfelse>
	
	<cfif Len(url.return) IS 0>
		<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">
	<cfelse>
		<cflocation addtoken="no" url="#url.return#">
	</cfif>
</cfif>