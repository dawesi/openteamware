<cfinclude template="../../../../login/check_logged_in.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<cfinclude template="../../../../style_sheet.cfm">
<title>Projektzuweisungen editieren</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfinvoke component="#request.a_str_component_project#" method="GetAllProjects" returnvariable="q_select_projects">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<!--- load connection settings ... --->

<cfdump var="#url#">

<!--- load security context (allow only to set tasks to a project that is available to the user or a workgroup) --->

<cfdump var="#q_select_projects#">

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
  	<td>
	
	</td>
	<td align="right">
		Einstellungen
	</td>
	<td>
		<input type="submit" name="frmsubmit" value="Speichern ...">
	</td>
  </tr>
<form action="savesettings.cfm" method="post">
<input type="hidden" name="frmentrykey" value="">
<input type="hidden" name="frmservicekey" value="">
  <tr class="mischeader">
    <td class="bb">&nbsp;</td>
    <td class="bb">
		<b>Projektname</b>
	</td>
    <td class="bb">&nbsp;</td>
  </tr>

  <cfoutput query="q_select_projects">
  <tr>
    <td>
		<input type="checkbox" name="frmprojectkeys" value="#q_select_projects.entrykey#" class="noborder">
	</td>
    <td>
		<b>#q_select_projects.title#</b>
		<br>
		#q_select_projects.description#
	</td>
    <td>
		<div class="b_all" style="width:100px;"><img src="/images/bar_small.gif" width="#q_select_projects.percentdone#" height="5"></div>
	</td>
  </tr>
  </cfoutput>
</form>
</table>


</body>
</html>
