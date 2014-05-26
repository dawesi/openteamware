<!--- //



	user administration interface for the company admin ...

	

	// --->
<!--- filter a special company? --->
<cfparam name="url.companykey" type="string" default="">

<h4><img src="/images/admin/img_people.png" width="32" height="32" hspace="3" vspace="3" border="0" align="absmiddle">Benutzerverwaltung</h4>

<cfloop from="1" to="#ArrayLen(request.a_arr_company_admin)#" step="1" index="ii">
  <li><b><cfoutput>#request.a_arr_company_admin[ii].companyname#</cfoutput></b></li>
</cfloop>

<br>
<br>
<!--- load numer of users ... --->
<cfif len(url.companykey) is 0>
	<!--- display select box ... --->
	<form action="index.cfm" method="get">
	<input type="hidden" name="action" value="useradministration">
	
	<select name="companykey">
		<cfloop from="1" to="#ArrayLen(request.a_arr_company_admin)#" step="1" index="ii">

		<option value="#htmleditformat(request.a_arr_company_admin[ii].entrykey)#">#htmleditformat(request.a_arr_company_admin[ii].companyname)#</option>

		</cfloop>
	</select>
	
	<input type="submit" value="Anzeigen ... ">
	</form>
<cfexit method="exittemplate">
</cfif>

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="queries/q_select_company_users.cfm">
<cfoutput>#q_select_company_users.recordcount#</cfoutput> Konten gefunden<br>
<cfif q_select_company_users.recordcount gt 20>
  <!--- // search form ... // --->
  <table border="0" cellspacing="0" cellpadding="4"><form action="index.cfm" method="get">
    <input type="hidden" name="action" value="useradministration">
    <tr> 
      <td align="right">Benutzername:</td>
      <td><input type="text" name="frmusername" size="30"></td>
    </tr>
    <tr> 
      <td align="right">Vorname:</td>
      <td><input type="text" name="frmfirstname" size="30"></td>
    </tr>
    <tr> 
      <td align="right">Nachname:</td>
      <td><input type="text" name="frmsurname" size="30"></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td><input type="submit" name="frmsubmit" value="Suchen"></td>
    </tr>
  </table></form>
  <cfelse>
  <!--- display the corresponding users ... --->
  <cfset cmp_get_workgroup_memberships = application.components.cmp_user>
  <cfset cmp_get_workgroup_name = CreateObject("component", "/components/management/workgroups/cmp_workgroup")>
  <table border="0" cellspacing="0" cellpadding="4">
    <tr class="lightbg"> 
      <td><img src="/images/space_1_1.gif" width="19" height="2" vspace="2" hspace="2" border="0">Benutzername</td>
      <td>Zu- und Vorname</td>
      <td>Gruppenmitgliedschaften</td>
      <td>Aktion</td>
    </tr>
    <cfoutput query="q_select_company_users"> 
      <tr> 
        <td valign="top"><a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_company_users.entrykey)#"><img src="/images/addressbook/menu_neuer-kontakt.gif" width="19" height="19" hspace="2" vspace="2" border="0" align="absmiddle">#htmleditformat(q_select_company_users.username)#</a></td>
        <td valign="top">#htmleditformat(q_select_company_users.surname)#, #htmleditformat(q_select_company_users.firstname)#</td>
        <td valign="top"> 
          <!--- load group memberships ... --->
          <cfset q_select_workgroups = cmp_get_workgroup_memberships.GetWorkgroupMemberships(q_select_company_users.entrykey)> 
          <cfloop query="q_select_workgroups">
            #cmp_get_workgroup_name.GetWorkgroupNameByEntryKey(q_select_workgroups.workgroupkey)#*<br>
          </cfloop> </td>
        <td nowrap valign="top"> <a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_company_users.entrykey)#"><img src="/images/editicon.gif" width="12" height="12" hspace="2" vspace="2" border="0" align="absmiddle"></a> 
          &nbsp;|&nbsp; <img src="/images/del.gif" width="12" height="12" hspace="2" vspace="2" border="0" align="absmiddle"> 
        </td>
      </tr>
    </cfoutput> 
  </table>
</cfif>
<br>
<br>
<table border="0" cellspacing="0" cellpadding="4">
  <form action="index.cfm" method="get">
    <input type="hidden" name="action" value="newuser">
    <tr> 
      <td align="right">Unternehmen:</td>
      <td> <select name="frmcompanykey">
          <cfloop from="1" to="#ArrayLen(request.a_arr_company_admin)#" step="1" index="ii">
            <cfoutput> 
              <option value="#request.a_arr_company_admin[ii].companykey#">#htmleditformat(request.a_arr_company_admin[ii].companyname)#</option>
            </cfoutput> 
          </cfloop>
        </select> </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td><input type="submit" value="Neuen Benutzer ..."></td>
    </tr>
  </form>
</table>
<br>
* Mitgliedschaft bei anderen Gruppen kann auch vererbt werden 
<!---

<a href="index.cfm?action=newuser&companykey=<cfoutput>#urlencodedformat(url.companykey)#</cfoutput>"><img src="/images/new_event.gif" width="12" height="12" vspace="2" hspace="2" border="0" align="absmiddle"><b>Neuen Benutzer hinzuf&uuml;gen ...</b></a>

--->
