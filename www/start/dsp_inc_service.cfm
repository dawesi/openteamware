
<cfparam name="IncludeService.Servicename" type="string" default="">

<!---<cflog text="IncludeService.Servicename: #IncludeService.Servicename# #request.stSecurityContext.myusername#" type="Information" log="Application" file="ib_startpage">--->

<cfif Len(IncludeService.Servicename) IS 0>
	<cfexit method="exittemplate">
</cfif><cfswitch expression="#IncludeService.Servicename#">
	<cfcase value="email">
	<!--- email ... --->
	<cfinclude template="../../../email/dsp_outlook_content.cfm">
	</cfcase>
	<cfcase value="calendar">
	<!--- calendar ... --->
	<cfinclude template="../../../calendar/dsp_outlook_content.cfm">

	</cfcase>
	<cfcase value="tasks">
	<cfinclude template="../../../tasks/dsp_outlook_content.cfm">
	</cfcase>
	<cfcase value="addressbook">
	<cfinclude template="../../../addressbook/dsp_outlook_content.cfm">
	</cfcase>
	<cfcase value="stat">
	<cfinclude template="../../../content/pages/start/dsp_stat_content.cfm">
	</cfcase>
</cfswitch>

<br><br>

<!---
<cfflush>
--->