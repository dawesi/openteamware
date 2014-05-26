<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif NOT StructKeyExists(stReturn, 'q_select_contact')>
	<cfabort>
</cfif>

<cfset q_select_contact = stReturn.q_select_contact>

<html>
<head>
<cfinclude template="../style_sheet.cfm">
<title></title>
</head>

<body class="b_all" style="height:95% ">

<cfoutput query="q_select_contact">

<table width="100%"  border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td colspan="2" class="bb" style="font-size:13px;color:white;background-color:gray;">
		#si_img('user')# #q_select_contact.surname#, #q_select_contact.firstname#
	</td>
  </tr>
  <tr>
  	<td colspan="2">
		<a href="index.cfm?action=ShowItem&entrykey=#urlencodedformat(url.entrykey)#" target="_parent">Kontaktdetails anzeigen ...</a>
	</td>
  </tr>
  <tr>
  	<td></td>
	<td>
		#q_select_contact.email_prim#
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		#q_select_contact.company#<br>
		#q_select_contact.department# #q_select_contact.aposition#
		<br>
		#q_select_contact.b_telephone#
		<br>
		#q_select_contact.b_mobile# [SMS]
		<br>
		#q_select_contact.b_street#
		<br>
		#q_select_contact.b_zipcode# #q_select_contact.b_city# #q_select_contact.b_country#
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		#q_select_contact.p_telephone#
		<br>
		#q_select_contact.p_mobile# [SMS]
		<br>
		#q_select_contact.p_street#
		<br>
		#q_select_contact.p_zipcode# #q_select_contact.p_city# #q_select_contact.p_country#	
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</cfoutput>

</body>
</html>
