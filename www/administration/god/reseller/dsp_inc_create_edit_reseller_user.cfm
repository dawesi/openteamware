
<cfparam name="CreateEditResellerUser.action" type="string" default="create">

<cfparam name="CreateEditResellerUser.query" type="query" default="#QueryNew('resellerkey,userkey,permissions,contacttype')#">

<cfif CreateEditResellerUser.action IS 'create'>
	<cfset tmp = QueryAddRow(CreateEditResellerUser.query, 1)>
	<cfset tmp = QuerySetCell(CreateEditResellerUser.query, 'contacttype', 'technical,sales', 1)>
	<cfset tmp = QuerySetCell(CreateEditResellerUser.query, 'resellerkey', url.resellerkey, 1)>
	<cfset tmp = QuerySetCell(CreateEditResellerUser.query, 'userkey', url.userkey, 1)>
</cfif>

<cfoutput query="CreateEditResellerUser.query">
<table border="0" cellspacing="0" cellpadding="4">

<cfif CreateEditResellerUser.action IS 'create'>
	<form action="act_create_reseller_user.cfm" method="post">
<cfelse>
	<form action="act_edit_reseller_user.cfm" method="post">
</cfif>

<input type="hidden" name="frmresellerkey" value="#CreateEditResellerUser.query.resellerkey#">
<input type="hidden" name="frmuserkey" value="#CreateEditResellerUser.query.userkey#">

  <tr>
    <td align="right" valign="top">
		Kontakt-Type:
	</td>
    <td valign="top">
		<input type="checkbox" name="frmcontacttype" value="technical" <cfif ListFind(CreateEditResellerUser.query.contacttype, 'technical') GT 0>checked</cfif>> technisch
		<br>
		<input type="checkbox" name="frmcontacttype" value="sales" <cfif ListFind(CreateEditResellerUser.query.contacttype, 'sales') GT 0>checked</cfif>> sales
	</td>
  </tr>
  <tr>
    <td align="right">
		Permissions:
	</td>
    <td>
		n/a
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" name="frmsubmit" value="Speichern ...">
	</td>
  </tr>
</form>
</table>
</cfoutput>