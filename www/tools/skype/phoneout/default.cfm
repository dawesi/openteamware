
<!--- check session ... we got it via CFID/CFTOKEN! --->

<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	not allowed
	<cfabort>
</cfif>


<html>
<head>
<cfinclude template="/style_sheet.cfm">
<title>openTeamWare</title>
</head>

<body>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.addressbookkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadcrm" value="true">
</cfinvoke>

<cfif NOT StructKeyExists(stReturn, 'q_select_contact')>
	Error 404
	<cfabort>
</cfif>

<cfset q_select_contact = stReturn.q_select_contact>


<cfoutput query="q_select_contact">
<table width="100%"  border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td colspan="2" class="mischeader bb" style="font-weight:bold; ">
		#q_select_contact.surname#, #q_select_contact.firstname#
	</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="right">
		Organisation/Abteilung/Position:
	</td>
    <td>
		#q_select_contact.company# / #q_select_contact.department# / #q_select_contact.aposition#
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		#q_select_contact.b_zipcode# #q_select_contact.b_city#
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>
</body>
</html>
