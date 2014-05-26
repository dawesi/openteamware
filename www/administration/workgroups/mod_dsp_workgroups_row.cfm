<cfparam name="attributes.parentkey" type="string" default="">

<cfparam name="attributes.level" type="numeric" default="0">

<cfinclude template="/common/scripts/script_utils.cfm">


<!---<cfdump var="#attributes#" label="attribute">--->

<cfquery name="q_select_current_workgroups" dbtype="query">
SELECT
	*
FROM
	request.q_select_workgroups
WHERE
	parentkey = '#attributes.parentkey#'
ORDER BY
	groupname
;
</cfquery>

<!---<cfdump var="#q_select_current_workgroups#">--->

<cfoutput query="q_select_current_workgroups">
<cfset sEntrykey = q_select_current_workgroups.entrykey>
<tr>
<td>
	<cfloop from="1" to="#attributes.level#" index="ii">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>
	<a href="index.cfm?action=workgroupproperties&entrykey=#urlencodedformat(q_select_current_workgroups.entrykey)##WriteURLTags()#"><img src="/images/si/group.png" class="si_img" /> <b>#q_select_current_workgroups.groupname#</b></a>
</td>
<td>
	#htmleditformat(q_select_current_workgroups.description)#
</td>
<td>
	<!--- load members ... --->
	<cfset SelectWorkgroupMembersRequest.entrykey = q_select_current_workgroups.entrykey>
	<cfinclude template="../queries/q_select_workgroup_members.cfm">
	
	#q_select_workgroup_members.recordcount#&nbsp;	
</td>
<td>
	#dateformat(q_select_current_workgroups.dt_created, "dd.mm.yy")#
</td>
<td>
	<a href="index.cfm?action=workgroup.edit&entrykey=#urlencodedformat(q_select_current_workgroups.entrykey)##WriteURLTags()#"><img src="/images/si/pencil.png" class="si_img" /> #GetLangVal('cm_wd_edit')#</a>
	&nbsp;|&nbsp;
	<a href="index.cfm?action=workgroup.delete&entrykey=#urlencodedformat(q_select_current_workgroups.entrykey)##WriteURLTags()#"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('cm_wd_delete')#</a>
</td>
</tr>

<cfquery name="q_select_sub_groups" dbtype="query">
SELECT
	*
FROM
	request.q_select_workgroups	
WHERE
	parentkey = '#q_select_current_workgroups.entrykey#'
;
</cfquery>

<!---<cfdump var="#q_select_sub_groups#" label="subgroups">--->

<cfloop query="q_select_sub_groups" startrow="1" endrow="1">
	<cfmodule template="mod_dsp_workgroups_row.cfm" parentkey=#sEntrykey# level=#(attributes.level+1)#>
</cfloop>

</cfoutput>