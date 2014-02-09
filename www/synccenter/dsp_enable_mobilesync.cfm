<!--- //

	enable support on phone
	
	// --->
<cfprocessingdirective pageencoding="iso-8859-1">	
	
<cfparam name="url.deviceid" type="string" default="">

<cfif Len(url.deviceid) IS 0>
	<cflocation addtoken="no" url="default.cfm">
</cfif>

<cfinvoke component="#request.a_str_component_mobilesync#" method="GetDevicesOfUser" returnvariable="q_select_devices">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfquery name="q_select_device" dbtype="query">
SELECT
	*
FROM
	q_select_devices
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.deviceid#">
;
</cfquery>

<cf_disp_navigation mytextleft="#GetLangVal('sync_ph_operating_hints')#">
<br><br>
<b>F�hren Sie vor der Einrichtung auf jeden Fall ein Backup Ihrer Daten auf dem mobilen Endger�t durch!

Konsultieren Sie dazu bitte die jeweilige Betriebsanleitung.
</b>
<br><br>
Bitte geben Sie folgende Einstellungen in Ihrem Handy ein:

<br><br>

<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:
		</td>
		<td>
			<cfoutput>#request.appsettings.description#</cfoutput> MobileSync
		</td>
	</tr>
  <tr>
    <td>
		<cfoutput>#GetLangVal('cm_wd_url')#</cfoutput>:
	</td>
    <td>
		http://ms.openTeamWare.com/sync
	</td>
  </tr>
  <tr>
  	<td>
		Port:
	</td>
	<td>
		80
	</td>
  </tr>
  <tr>
  	<td>
		<cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>:
	</td>
	<td>
		<!--- virtual username ... --->
		<cfoutput query="q_select_device">#q_select_device.virtual_username#</cfoutput>
	</td>
  </tr>
  <td>
  	<cfoutput>#GetLangVal('cm_wd_password')#</cfoutput>:
  </td>
  <td>
  	&lt;<cfoutput>#GetLangVal('sync_ph_device_settings_password_your_pwd')#</cfoutput>&gt;
  </td>
  <tr>
    <td>
		<cfoutput>#GetLangVal('sync_ph_device_settings_database_calendar')#</cfoutput>:
	</td>
    <td>
		ca
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('sync_ph_device_settings_database_contacts')#</cfoutput>:
	</td>
    <td>
		co
		<br>
		BlackBerry: scard
	</td>
  </tr>
</table>
<br><br>


<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="synccenter">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="device_settings_hints">
</cfinvoke>

<cfinclude template="#a_str_page_include#">

<cfinvoke component="#application.components.cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_html_filename_contactbox">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="contact_box_website">
	<cfinvokeargument name="style" value="#request.stUserSettings.style#">
</cfinvoke>

<cfinclude template="#a_str_html_filename_contactbox#">