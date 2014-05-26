<cf_disp_navigation mytextleft="#GetLangVal('cm_wd_workgroups')#">
<br>
<cfset q_select_workgroups = request.stSecurityContext.q_select_workgroup_permissions>

<cfinvoke component="/components/management/customers/cmp_customer" method="IsUserCompanyAdmin" returnvariable="a_bol_return_is_admin">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfif a_bol_return_is_admin>
	<!--- this user is a company admin ... --->
	<div class="b_all mischeader" style="width:600px;padding:6px;">
	<a href="/administration/" target="_blank"><b><img src="/images/admin/img_admin_link_key.png" hspace="2" vspace="2" border="0" align="absmiddle"> <cfoutput>#GetLangVal('prf_ph_launch_admintool')#</cfoutput></b></a>
	</div>
	<br><br>
</cfif>

<cfoutput>#GetLangVal('wrkgr_ph_you_are_member_of_the_following_groups')#</cfoutput>
<table class="table_overview">
  <tr class="tbl_overview_header">
    <td colspan="2"><b><cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput></b></td>
    <td><cfoutput>#GetLangVal('wrkgr_ph_your_rights')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
    <td>&nbsp;</td>
  </tr>
  <cfif a_bol_return_is_admin>
  	<tr>
		<td colspan="5" style="padding:10px;font-weight:bold; " align="center">
			<a href="javascript:OpenComposePopupTo('ibworkgroup@all');"><img src="/images/icon/letter_yellow.gif" align="absmiddle" border="0"> <cfoutput>#GetLangVal('wrkgr_ph_compose_mail_to_all_employees')#</cfoutput></a>
		</td>
	</tr>
  </cfif>
  <cfoutput query="q_select_workgroups">
  <tr>
  	<td width="4" <cfif Len(q_select_workgroups.colour) GT 0>style="background-color:#q_select_workgroups.colour#;"</cfif>>
		<img src="/images/space_1_1.gif">
	</td>
    <td style="padding-left:#(q_select_workgroups.workgrouplevel*20)#px;">
		<img src="/images/si/group.png" class="si_img" /> <a href="index.cfm?action=ShowWorkgroup&entrykey=#urlencodedformat(q_select_workgroups.workgroup_key)#" style="font-weight:bold;">#q_select_workgroups.workgroup_name#</a>
		
		<cfif Len(q_select_workgroups.description) GT 0>
			<br>
			#htmleditformat(q_select_workgroups.description)#
		</cfif>
	</td>
    <td>
	<ul style="margin-bottom:0px;margin-top:0px; ">
	<cfloop list="#q_select_workgroups.permissions#" delimiters="," index="a_str_permission">
		<li>#GetLangVal('cm_wd_right_' & a_str_permission)#</li>
	</cfloop>
	</ul>
	</td>
    <td>
		<a href="index.cfm?action=showworkgroup&entrykey=#q_select_workgroups.workgroup_key#"><img src="/images/menu/img_members_19x15.gif" align="absmiddle" border="0"> #GetLangVal('wrkgr_ph_show_members')#</a>
		
		<cfif ListFind(q_select_workgroups.permissions, 'write') GT 0>
			<br>
			<a href="javascript:OpenComposePopupTo('ibworkgroup@#q_select_workgroups.workgroup_key#');"><img src="/images/icon/letter_yellow.gif" align="absmiddle" border="0"> #GetLangVal('wrkgr_ph_mail_to_all_members')#</a>
		</cfif>
	</td>
  </tr>
  <tr>
  	<td class="addinfotext" colspan="4" style="padding-left:25px;">
		
	</td>
  </tr>
  <tr>
  	<td colspan="4" class="bb" height="2"><img src="/images/space_1_1.gif" height="1"></td>
  </tr>
  </cfoutput>

</table>