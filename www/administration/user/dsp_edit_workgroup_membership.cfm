<!--- //

	edit workgroup membership ... 
	
	// --->
	
<cfinclude template="../dsp_inc_select_company.cfm">
<h4><cfoutput>#GetLangVal('adm_ph_edit_workgroup_membership')#</cfoutput></h4>

<cfinclude template="../queries/q_select_workgroups.cfm">

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
<cfinclude template="../queries/q_select_roles.cfm">

<cfset cmp_get_workgroup_memberships = application.components.cmp_user>
<cfset q_select_workgroup_memberships = cmp_get_workgroup_memberships.GetWorkgroupMemberships(url.userkey)>

<cfquery name="q_select_workgroup_membership" dbtype="query">
SELECT
	*
FROM
	q_select_workgroup_memberships
WHERE
	workgroupkey = '#url.workgroupkey#'
;
</cfquery>

<form action="user/act_update_workgroup_membership.cfm" method="post">
<input type="hidden" name="frmuserkey" value="<cfoutput>#htmleditformat(url.userkey)#</cfoutput>">
<input type="hidden" name="frmworkgroupkey" value="<cfoutput>#htmleditformat(url.workgroupkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td align="right"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:</td>
    <td>
		<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
			<cfinvokeargument name="entrykey" value="#url.userkey#">
		</cfinvoke>
		
		<cfoutput>#a_str_username#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right"><cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput>:</td>
    <td>
		<cfoutput>#q_select_workgroup.groupname#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right"><cfoutput>#GetLangVal('adm_wd_role')#</cfoutput>:</td>
    <td>
	
	<!---<select name="frmrolekey">--->
		<cfoutput query="q_select_roles">
		<input type="radio" name="frmrolekey" value="#htmleditformat(q_select_roles.entrykey)#" #writecheckedelement(q_select_workgroup_membership.roles,q_select_roles.entrykey)# >#htmleditformat(q_select_roles.rolename)#<br>
		</cfoutput>		
	<!---</select>--->
	</td>
  </tr>
  <tr>
  	<td></td>
	<td>
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>">
	</td>
  </tr>
</table>
</form>