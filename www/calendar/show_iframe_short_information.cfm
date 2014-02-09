
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	You need to login.
	<cfabort>
</cfif>

<html>
<head>
<cfinclude template="../style_sheet.cfm">
<title></title>

<script type="text/javascript">
	function Adopt()
		{
		window.height='200px';
		}
</script>
</head>

<body onLoad="Adopt();">

<cfinvoke component="#application.components.cmp_calendar#" method="GetEvent" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT StructKeyExists(stReturn, 'q_select_event')>
	<cfexit method="exittemplate">
</cfif>

<cfset q_select_event = stReturn.q_select_event>


<cfoutput query="q_select_event">
<div class="mischeader bb" style="padding:4px;" align="center"><b><img src="/images/icon/kalender_klein.gif" width="12" height="12" align="absmiddle" border="0"> #htmleditformat(q_select_event.title)#</b></div>
<table border="0" cellspacing="0" cellpadding="3" width="100%">
  <cfif Len(q_select_event.description) GT 0>
  <tr>
  	<td valign="top" align="right">#GetLangVal('cm_wd_description')#:</td>
	<td valign="top">
	#htmleditformat(q_select_event.description)#
	</td>
  </tr>
  </cfif>
  <tr>
    <td align="right" valign="top">#GetLangVal('cal_wd_location')#:</td>
    <td valign="top">#htmleditformat(q_select_event.location)#</td>
  </tr>
  <cfif len(q_select_event.categories) GT 0>
  <tr>
    <td align="right" valign="top">#GetLangVal('cm_wd_categories')#:</td>
    <td valign="top">#q_select_event.categories#</td>
  </tr>
  </cfif>
  <tr>
  	<td valign="top" align="right">#GetLangVal('cal_wd_start')#:</td>
	<td valign="top">
	#lsdateformat(q_select_event.date_start, 'ddd, dd.mm.yy')# #Timeformat(q_select_event.date_start, 'HH:mm')#
	</td>
  </tr>
  <tr>
  	<td align="right" valign="top">#GetLangVal('cal_wd_duration')#:</td>
	<td valign="top">
	<cfset a_int_diff_hours = DateDiff('h', q_select_event.date_start, q_select_event.date_end)>
	<cfset a_int_diff_minutes = DateDiff('n', q_select_event.date_start, q_select_event.date_end)>	

	<cfif a_int_diff_hours GT 0>
		<cfoutput>#a_int_diff_hours#</cfoutput> Stunden
	<cfelseif a_int_diff_minutes GT 0>
		<cfoutput>#a_int_diff_minutes#</cfoutput> Minuten
	</cfif>
	</td>
  </tr>
</table>
</cfoutput>

</body>
</html>
