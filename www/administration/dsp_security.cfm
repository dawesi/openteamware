<!--- //

	Module:		Administration Tool
	Action:		Security
	Description: 
		Header:		

	
	
	TODO: FINISH
	
// --->



<cfinclude template="dsp_inc_select_company.cfm">

<cfinvoke component="#application.components.cmp_security#" method="GetAllSecurityRolesOfCompany" returnvariable="q_select_roles">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<h4><cfoutput>#GetLangVal('adm_ph_edit_administrator_security')#</cfoutput></h4>


<table class="table_details">
	<tr class="mischeader">
		<td>Feature</td>
		<td align="center">
			Alle
		</td>
		<td align="center">
			Bestimmte Gruppen
		</td>
		<td align="center">
			Nur Administratoren
		</td>
	</tr>
	<tr>
		<td class="field_name">
			Outlook Abgleich
		</td>
		<td align="center">
			<input type="radio" name="frm_outlook" checked="true" />
		</td>
		<td align="center">
			<input type="radio" name="frm_outlook" />
			
			<select multiple="true">
				<option value="123">Team 1</option>
			</select>
		</td>
		<td align="center">
			<input type="radio" name="frm_outlook"  />
		</td>
	</tr>

</table>



<cfexit method="exittemplate">

<h4><img src="/images/img_security_key.png" width="32" height="32" border="0" align="absmiddle">&nbsp;Sicherheitseinstellungen</h4>

<b>Definierte Sicherheitsrollen</b><br>
<br>
<table border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td class="bb">&nbsp;</td>
    <td class="bb">Name</td>
    <td class="bb">Beschreibung</td>
	<td class="bb">anwenden auf</td>
	<td class="bb">erstellt</td>
    <td class="bb">Aktion</td>
  </tr>
  <cfoutput query="q_select_roles">
  <tr>
    <td align="right" valign="top">
		###q_select_roles.currentrow#
	</td>
    <td valign="top">
		<a href="index.cfm?action=securityrole.display&entrykey=#urlencodedformat(q_select_roles.entrykey)##WriteURLTags()#">#htmleditformat(q_select_roles.rolename)#</a>
	</td>
    <td valign="top">
		#q_select_roles.description#
	</td>
	<td valign="top">
	<cfinvoke component="/components/management/security/cmp_security" method="GetUsersUsingRole" returnvariable="q_select_users">
		<cfinvokeargument name="entrykey" value="#q_select_roles.entrykey#">
		<cfinvokeargument name="companykey" value="#url.companykey#">
	</cfinvoke>
	
	#q_select_users.recordcount# Benutzer<br>
	
	<cfloop query="q_select_users">
	<a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_users.entrykey)##WriteURLTags()#">#q_select_users.surname#, #q_select_users.firstname# (#q_select_users.username#)</a><br>
	</cfloop>

	</td>
    <td valign="top">
		#DateFormat(q_select_roles.dt_created, 'dd.mm.yy')#
	</td>
	<td align="center" valign="top">
		<a href="index.cfm?action=securityrole.edit&entrykey=#urlencodedformat(q_select_roles.entrykey)##WriteURLTags()#">editieren</a>
		&nbsp;|&nbsp;
		<a href="javascript:DeleteItem('#jsstringformat(q_select_roles.entrykey)#');"><img src="/images/del.gif" align="absmiddle" border="0"></a>
	</td>
  </tr>
  </cfoutput>
</table>
<br><br>
<a href="index.cfm?action=securityrole.new<cfoutput>#WriteURLTags()#</cfoutput>">Neue Rolle erstellen ...</a>

<script type="text/javascript">
	function DeleteItem(entrykey)
		{
		if (confirm('Sind Sie sicher?') == true)
			{
			location.href = 'security/act_security_role_delete.cfm?<cfoutput>#WriteURLTags()#</cfoutput>&entrykey='+escape(entrykey);
			}
		}
</script>