<!--- //

	Module:		Admintool
	Action:		addusertoworkgroup
	Description:add a user to a workgroup 
	
// --->


<cfinclude template="dsp_inc_select_company.cfm">

<cfparam name="url.workgroupkey" type="string" default="">

<cfinclude template="queries/q_select_workgroups.cfm">

<cfquery name="q_select_workgroup" dbtype="query">
SELECT
	*
FROM
	q_select_workgroups
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.workgroupkey#">
;
</cfquery>

<!--- load roles for this workgroup ... --->
<cfset SelectWorkgroupRoles.workgroupkey = url.workgroupkey>
<cfinclude template="queries/q_select_roles.cfm">

<!--- load workgroup members ... --->
<cfset SelectWorkgroupMembersRequest.entrykey = url.workgroupkey>
<cfinclude template="queries/q_select_workgroup_members.cfm">

<!--- load all members of this company ... --->
<cfset SelectCompanyUsersRequest.companykey = q_select_workgroup.companykey>
<cfinclude template="queries/q_select_company_users.cfm">

<cfif q_select_company_users.recordcount IS 0>
	<h4><cfoutput>#GetLangVal('adm_ph_activitiy_no_accounts_yet')#</cfoutput></h4>
	<a href="default.cfm?action=useradministration<cfoutput>&#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_add_user_now')#</cfoutput></a>
	<cfabort>
</cfif>

<!--- select all not - yet - members ... --->
<cfquery name="q_select_avaliable_persons" dbtype="query">
SELECT
	*
FROM
	q_select_company_users
WHERE 
	(NOT entrykey = '')

	<cfloop query="q_select_workgroup_members">
	AND NOT entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_workgroup_members.userkey#">
	</cfloop>
;
</cfquery>

<h4><cfoutput>#GetLangVal('adm_ph_workgroups_add_members')#</cfoutput></h4>


<form action="act_add_workgroup_member.cfm" method="post" style="margin:0px;">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="hidden" name="frmworkgroupkey" value="<cfoutput>#htmleditformat(url.workgroupkey)#</cfoutput>">

<table class="table_details table_edit_form">
  <tr
  	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput>:
	</td>
	<td style="font-weight:bold; ">
		<cfoutput>#htmleditformat(q_select_workgroup.groupname)#</cfoutput>
	</td>
  </tr>
  <tr>

    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>/<cfoutput>#GetLangVal('cm_wd_source')#</cfoutput>:</td>

    <td>
	
		<label for="frminternaluser"><input checked onClick="ChangeUserSource('internal');"  type="radio" name="frmusersource" value="internal" id="frminternaluser" class="noborder"> Benutzer des aktuellen Unternehmens</label>
		
		<br>
		
		<label for="frmexternalcontact"><input onClick="ChangeUserSource('external');" type="radio" name="frmusersource" value="external" id="frmexternalcontact" class="noborder"> Externer Kontakt</label>
	

	<div style="padding:10px; " id="id_div_source_company">
	<select name="frmuserkey" size="5">

		<option value=""><cfoutput>#GetLangVal('cm_ph_please_select')#</cfoutput> ...</option>
		
		<cfoutput query="q_select_avaliable_persons">
		<option value="#q_select_avaliable_persons.entrykey#">#q_select_avaliable_persons.username# (#q_select_avaliable_persons.firstname# #q_select_avaliable_persons.surname#)</option>
		</cfoutput>

	</select>
	</div>
	
	<div style="padding:10px;display:none; " id="id_div_source_external">
		<!--- external --->
		<b>Geben Sie bitte die Daten des externen Kontaktes an.</b>
		<br><br>
		<a href="?action=newuser<cfoutput>#writeurltags()#</cfoutput>">Wenn Sie erweiterte Optionen w&uuml;nschen erstellen Sie bitte &uuml;ber den gewohnten Weg einen Benutzer.</a>
		<br><br>
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td>
				E-Mail:
			</td>
			<td>
				<input type="text" name="frmemail" size="20">
			</td>
		  </tr>
		  <tr>
		  	<td></td>
			<td>
				<a href="/addressbook/" target="_blank">zum Adressbuch ...</a>
			</td>
		  </tr>
		  <tr>
			<td>
				Vorname:
			</td>
			<td>
				<input type="text" name="frmfirstname" size="20">
			</td>
		  </tr>
		  <tr>
			<td>
				Nachname:
			</td>
			<td>
				<input type="text" name="frmsurname" size="20">
			</td>
		  </tr>
		  <tr>
			<td>
				Geschlecht:
			</td>
			<td>
				<select name="frmsex">
					<option value="0">maennlich</option>
					<option value="1">weiblich</option>
				</select>
			</td>
		  </tr>
		  <tr>
		  	<td>Kommentar im E-Mail</td>
			<td>
				<textarea name="frmcommentemail" cols="40" rows="5"></textarea>
			</td>
		  </tr>
		</table>
	
	</div>

	</td>

  </tr>
  

  <tr>

    <td class="field_name"><cfoutput>#GetLangVal('adm_ph_role_permission_level')#</cfoutput>:</td>

    <td>

	<cfoutput query="q_select_roles">

		<input class="noborder" type="radio" id="#htmleditformat(q_select_roles.entrykey)#" name="frmrole" #writecheckedelement('mainuser', q_select_roles.rolename)# value="#htmleditformat(q_select_roles.entrykey)#"> <label for="#htmleditformat(q_select_roles.entrykey)#">#htmleditformat(q_select_roles.rolename)# (#shortenstring(htmleditformat(q_select_roles.description), 35)#)</label><br>

	</cfoutput>

	</td>

  </tr>

  <tr>

    <td class="field_name"></td>

    <td><input class="btn" type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_add')#</cfoutput> ..."></td>

  </tr>
<tr>
	<td></td>
	<td>

		<br><br>
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td colspan="2" class="bb lightbg"><cfoutput>#GetLangVal('adm_ph_roles_standard_permission_levels')#</cfoutput></td>
		  </tr>
		  <tr>
			<td valign="top">
				mainuser
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_role_name_friendly_mainuser')#</cfoutput>.<br>
				<cfoutput>#GetLangVal('adm_ph_role_mainuser_rights')#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td valign="top">
				user
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_role_name_friendly_user')#</cfoutput>.<br>
				<cfoutput>#GetLangVal('adm_ph_role_user_rights')#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td valign="top">
				guest
			</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_role_name_friendly_guest')#</cfoutput>.<br>
				<cfoutput>#GetLangVal('adm_ph_role_guest_rights')#</cfoutput>
			</td>
		  </tr>
		</table>

	</td>
</tr>
</form>

</table>

<script type="text/javascript">
	function ChangeUserSource(t)
		{
		var obj1,obj2;
		obj1 = findObj('id_div_source_company');
		obj2 = findObj('id_div_source_external');		
		obj1.style.display = 'none';
		obj2.style.display = 'none';
		
		if (t == 'internal')
			{
			obj1.style.display = '';
			} else
				{
				obj2.style.display = '';
				}
		}
</script>


