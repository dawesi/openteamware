
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
	<cfif a_str_productkey NEQ 'DAB4E803-C645-EFA3-BE8E6FCF906F5BD6'>
	<cfinclude template="../../../calendar/dsp_outlook_content.cfm">
	</cfif>
	</cfcase>
	<cfcase value="tasks">
	<cfif a_str_productkey NEQ 'DAB4E803-C645-EFA3-BE8E6FCF906F5BD6'>
	<cfinclude template="../../../tasks/dsp_outlook_content.cfm">
	</cfif>
	</cfcase>
	<cfcase value="storage">
	<!--- to do --->
	</cfcase>
	<cfcase value="im">
	<cfinclude template="../../../im/dsp_outlook_content.cfm">
	</cfcase>
	<cfcase value="forum">
	
	<!--- to do --->
	</cfcase>
	<cfcase value="bookmarks">
	<cfif a_str_productkey NEQ 'DAB4E803-C645-EFA3-BE8E6FCF906F5BD6'>
	<cfinclude template="../../../bookmark/dsp_outlook_content.cfm">
	</cfif>
	</cfcase>
	<cfcase value="addressbook">
	<cfinclude template="../../../addressbook/dsp_outlook_content.cfm">
	</cfcase>
	<!--- <cfcase value="news">
	<cfinclude template="../../../content/pages/newsticker/dsp_outlook_content.cfm">
	</cfcase> --->
	<cfcase value="stat">
	<cfinclude template="../../../content/pages/start/dsp_stat_content.cfm">
	</cfcase>
</cfswitch>

<br><br>

<!---
<cfflush>
--->