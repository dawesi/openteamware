<!--- //

	Module:		info
	Action:		DoFileBugReport
	Description: 
	

// --->

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="Bug report filed" type="html">
<cfdump var="#form#">
<cfdump var="#cgi#">
<cfdump var="#session#">
</cfmail>

<cflocation addtoken="false" url="default.cfm?action=ThanksForBugReport">
