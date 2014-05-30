
<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfif Len(url.entrykey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfinclude template="../queries/q_select_workgroups.cfm">

<h4><cfoutput>#GetLangVal('adm_ph_edit_workgroup')#</cfoutput></h4>

<cfquery name="q_select_workgroup" dbtype="query">
SELECT
	*
FROM
	q_select_workgroups
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfif q_select_workgroup.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_other_groups" dbtype="query">
SELECT
	groupname,entrykey
FROM
	q_select_workgroups
WHERE
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">)
	AND NOT
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">)
;
</cfquery>


<form action="workgroups/act_edit_workgroup.cfm" method="post">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<input type="hidden" name="frmworkgroupkey" value="<cfoutput>#htmleditformat(url.entrykey)#</cfoutput>">
<table class="table_details table_edit_form">
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:</td>
    <td>
	<input type="text" name="frmname" size="30" value="<cfoutput>#htmleditformat(q_select_workgroup.groupname)#</cfoutput>">
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('adm_ph_workgroup_short_name')#</cfoutput>:</td>
	<td>
	<input type="text" name="frmshortname" size="10" maxlength="12" value="<cfoutput>#htmleditformat(q_select_workgroup.groupname)#</cfoutput>"> (<cfoutput>#GetLangVal('adm_ph_workgroup_short_name_max_12_chars')#</cfoutput>)
	</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:</td>
    <td>
	<input type="text" name="frmdescription" size="30" value="<cfoutput>#htmleditformat(q_select_workgroup.description)#</cfoutput>">
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('adm_ph_superior_group')#</cfoutput>:</td>
	<td>
	<select name="frmparentgroupkey">
		<option value="" selected>(<cfoutput>#GetLangVal('cm_wd_none')#</cfoutput>)</option>
	<cfoutput query="q_select_other_groups">
		<option value="#htmleditformat(q_select_other_groups.entrykey)#" #writeselectedelement(q_select_workgroup.parentkey, q_select_other_groups.entrykey)#>#htmleditformat(q_select_other_groups.groupname)#</option>
	</cfoutput>
	</select>
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('cm_ph_assigned_color')#</cfoutput>:</td>
	<td>
		<input type="text" name="frmcolour" size="8" value="<cfoutput>#htmleditformat(q_select_workgroup.colour)#</cfoutput>">
	</td>
  </tr>
  <tr>
    <td class="field_name">&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput> ..." class="btn btn-primary" /></td>
  </tr>
</form>
</table>