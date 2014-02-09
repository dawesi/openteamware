<!--- users of a reseller --->

<cfquery name="q_select_reseller_users" datasource="#request.a_str_db_users#">
SELECT
	resellerusers.userkey,users.username,users.firstname,users.surname,resellerusers.permissions,resellerusers.contacttype,
	users.department,users.aposition
FROM
	resellerusers
LEFT JOIN users
	ON (users.entrykey = resellerusers.userkey)
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
;
</cfquery>

<cfquery name="q_select_companykey" datasource="#request.a_str_db_users#">
SELECT
	companykey
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
;
</cfquery>


<cfquery name="q_select_users" datasource="#request.a_str_db_users#">
SELECT
	username,firstname,surname,email,aposition,department,entrykey
FROM
	users
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companykey.companykey#">
;
</cfquery>


<!--- load users of reseller --->
<table border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td>Benutzername</td>
    <td>Voller Name</td>
	<td>Beschreibung</td>
    <td>Type</td>
    <td>Berechtigungen</td>
	<td>Aktionen</td>
  </tr>
  <tr bgcolor="#EEEEEE">
  	<td colspan="6">
		<b>Bestehende Benutzer</b>
	</td>
  </tr>
  <cfoutput query="q_select_reseller_users">
  <tr>
    <td>
		#q_select_reseller_users.username#
	</td>
    <td>
		#q_select_reseller_users.surname#, #q_select_reseller_users.firstname#
	</td>
	<td>
		#q_select_reseller_users.department#, #q_select_reseller_users.aposition#
	</td>
    <td>
		#q_select_reseller_users.contacttype#
	</td>
    <td>
		<a href="default.cfm?action=editreselleruser&resellerkey=#urlencodedformat(url.resellerkey)#&userkey=#urlencodedformat(q_select_reseller_users.userkey)#">edit</a> | <a href="act_delete_reseller_user.cfm?resellerkey=#urlencodedformat(url.resellerkey)#&userkey=#urlencodedformat(q_select_reseller_users.userkey)#" onClick="return confirm('Sind Sie sicher?');">delete</a>
	</td>
	<td></td>
  </tr>
  </cfoutput>
  <tr bgcolor="#EEEEEE">
  	<td colspan="6">
		<b>Neuen Reseller-Benutzer anlegen</b>
	</td>
  </tr>
  <cfoutput query="q_select_users">
  
	  <cfif ListFind(valuelist(q_select_reseller_users.userkey), q_select_users.entrykey) IS 0>
	  <form action="default.cfm" method="get">
	  <input type="hidden" name="action" value="newreselleruser">
	  <input type="hidden" name="userkey" value="#q_select_users.entrykey#">
	  <input type="hidden" name="resellerkey" value="#url.resellerkey#">
	  <tr>
		<td nowrap>
			<input align="absmiddle" type="submit" value="Erstellen ..."> <b>#q_select_users.username#</b>
		</td>
		<td>
			#q_select_users.surname#, #q_select_users.firstname#
		</td>
		<td>
			#q_select_users.department#, #q_select_users.aposition#
		</td>
		<td>
			
		</td>
		<td>&nbsp;</td>
		<td></td>
	  </tr>
	  </form>
	  </cfif>
  </cfoutput>
</table>