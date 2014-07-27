<!--- //

	Module:		Framework
	Description:Logout of service
	
// --->

<cfparam name="url.confirmed" default="false" type="string">

<!--- is the user logged in?? --->
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<cfset a_str_location = application.components.cmp_customize.GetCustomStyleData(usersettings = request.stUserSettings, entryname = 'locations').onLogout />
<cfset a_struct_logo = application.components.cmp_customize.GetCustomStyleData(usersettings = request.stUserSettings, entryname = 'big_logo')>

<!--- does the user want NO confirmation screen? --->
<cfinclude template="settings/queries/q_select_display_settings.cfm">

<cfif q_select_display_settings.confirmlogout is 0>
	<cfset StructClear(session)>
	<!--- get forwarding target ... --->
	<html>
		<head>
			<meta http-equiv="refresh" content="0;URL=<cfoutput>#a_str_location#</cfoutput>" />
		</head>
	<body>
		<a href="<cfoutput>#a_str_location#</cfoutput>">Click here ...</a>
	</body>
	</html>
</cfif>



<cfif url.confirmed is "false">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>

	<!--- auto logout if no action is taken --->
	<meta http-equiv="refresh" content="7;URL=logout.cfm?confirmed=true" />

	<cfinclude template="style_sheet.cfm">

	<title><cfoutput>#request.a_str_product_name#</cfoutput></title>
</head>
<body>
<br /><br /><br /><br /><br />

<table width="100%" border="0" cellspacing="0" cellpadding="30">
  <tr>
    <td align="center">
	
	<fieldset class="default_fieldset" style="width:600px; ">
		<legend>
				<cfoutput>
				<img src="#a_struct_logo.path#" width="#a_struct_logo.width#" height="#a_struct_logo.height#" hspace="10" vspace="10" border="0" align="absmiddle">
				</cfoutput>
		
				<!---<cfoutput>#htmleditformat(request.a_str_product_name)#</cfoutput>--->
		</legend>
		<div>
		
		<table border="0" cellspacing="0" cellpadding="4" align="center">
			<tr style="background-color:white;">
				<!---<td class="bb">
					<!--- logo --->
					
				</td>--->
				<td align="center" class="bb" colspan="2">
				<cfoutput>#GetLangVal('logout_currently_logged_in_user')#</cfoutput> <b><cfoutput>#htmleditformat(request.a_struct_personal_properties.myfirstname)# #htmleditformat(request.a_struct_personal_properties.mysurname)#</cfoutput> (<cfoutput>#request.stSecurityContext.myusername#</cfoutput>)</b>&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<br>
		
				<br>
		
				<b><cfoutput>#GetLangVal('logout_ph_areyousure')#</cfoutput>
		
				<br>
		
				<br>
		
				<br>
		
				[ <a href="logout.cfm?confirmed=true"><b><cfoutput>#GetLangVal('logout_ph_logout_now')#</cfoutput></b></a> ] &nbsp;&nbsp;&nbsp;&nbsp;[ <a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('logout_ph_donot_logout')#</cfoutput></a> ]
		
				</b>
		
				<br><br>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="addinfotext" align="center">
				<cfoutput>#GetLangVal('logout_ph_autologout')#</cfoutput>
				</td>
			</tr>
		</table>
		
		</div>
	</fieldset>
	
	
	
	</td>
  </tr>	
</table>
</body>
</html>
<cfelse>

<!--- delete session entrykey ... --->

<cfif StructKeyExists(cookie, 'ib_session_key')>
	<cfinvoke component="#request.a_str_component_session#" method="DeleteSessionKey" returnvariable="a_bol_return">
		<cfinvokeargument name="sessionkey" value="#cookie.ib_session_key#">
		<cfinvokeargument name="applicationname" value="#application.applicationname#">
	</cfinvoke>
</cfif>

<!--- call session end manually ... --->
<cftry>
<cfscript>
   ap = CreateObject("component","Application");
   ap.onSessionEnd(session, application);
</cfscript>

<cfcatch type="any"></cfcatch>
</cftry>

<cfset StructClear(session)>

<!--- // clear session and relocate to the main screen // --->
<html>
	<head>
		<title>Logout</title>
		<cfinclude template="/style_sheet.cfm">
		<meta http-equiv="refresh" content="0;URL=<cfoutput>#a_str_location#</cfoutput>">
	</head>
	<body style="text-align:center;padding:40px; ">
		<a href="<cfoutput>#a_str_location#</cfoutput>">Logout done ... proceed</a>
	</body>
</html>

</cfif>