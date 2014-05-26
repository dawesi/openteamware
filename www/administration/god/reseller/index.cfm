<!--- // reseller verwaltung // --->
<cfparam name="url.action" type="string" default="ShowWelcome">


<html>
<head>
	<style>
		body,p,td,a{font-family:Verdana;font-size:11px;}
	</style>
	<title>Resellerverwaltung</title>
</head>
<body>

<h1 style="margin-bottom:10px;border-bottom:silver solid 1px;">Resellerverwaltung</h1>


<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td width="200" bgcolor="#EEEEEE" valign="top" style="line-height:20px;">
		<a href="index.cfm?action=showwelcome">Uebersicht</a>
		<br>
		<a href="index.cfm?action=newreseller">Neu ...</a>
	</td>
    <td valign="top">
		<cfswitch expression="#url.action#">
			<cfdefaultcase>
				<cfinclude template="dsp_welcome.cfm">
			</cfdefaultcase>
			<cfcase value="newreseller">
				<cfinclude template="dsp_new_reseller.cfm">
			</cfcase>
			
			<cfcase value="editreseller">
				<cfinclude template="dsp_edit_reseller.cfm">
			</cfcase>
			
			<cfcase value="resellerusers">
				<cfinclude template="dsp_reseller_users.cfm">
			</cfcase>
			
			<cfcase value="newreselleruser">
				<cfinclude template="dsp_new_reseller_user.cfm">
			</cfcase>
			
			<cfcase value="deletereseller">
				<cfinclude template="dsp_delete_reseller.cfm">
			</cfcase>
			
			<cfcase value="editreselleruser">
				<cfinclude template="dsp_edit_reseller_user.cfm">
			</cfcase>
		</cfswitch>
	</td>
  </tr>
</table>
</body>
</html>