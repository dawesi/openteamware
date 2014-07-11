

<cfset cmp_get_workgroup_memberships = application.components.cmp_user>
<cfset q_select_workgroups = cmp_get_workgroup_memberships.GetWorkgroupMemberships(q_userdata.entrykey)>

<cfset cmp_get_workgroup_name = CreateObject("component", "/components/management/workgroups/cmp_workgroup")>
<b><cfoutput>#GetLangVal('adm_ph_edit_workgroup_memberships')#</cfoutput></b>
<br><br>

<cfoutput>#q_select_workgroups.recordcount#</cfoutput> Mitgliedschaften<br><br>

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="lightbg">
    <td>&nbsp;</td>
    <td><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('adm_wd_role')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_workgroups">
  <tr>
    <td align="right">###q_select_workgroups.currentrow#</td>
    <td>
	#htmleditformat(checkzerostring(cmp_get_workgroup_name.GetWorkgroupNameByEntryKey(q_select_workgroups.workgroupkey)))#
	</td>
    <td>
				 <cfloop index="a_str_role_key" list="#q_select_workgroups.roles#" delimiters=",">
                  <cfset a_str_rolename = cmp_get_workgroup_name.getrolenamebyentrykey(a_str_role_key)>
                  #a_str_rolename# </cfloop>
	</td>
    <td>
	<!---<img src="/images/editicon.gif" align="absmiddle">
	&nbsp;&nbsp;&nbsp;--->
	<a href="index.cfm?action=workgroups.removeuser&workgroupkey=#urlencodedformat(q_select_workgroups.workgroupkey)#&entrykey=#urlencodedformat(url.entrykey)##WriteURLTags()#"><span class="glyphicon glyphicon-trashÓ></span></a>

	</td>
  </tr>
  </cfoutput>
</table>