<!--- //

	Module:		Admintool
	Action:		Newworkgroup
	Description:create a new workgroup ... 
	
// --->
	
<cfinclude template="dsp_inc_select_company.cfm">

<cfparam name="url.companykey" type="string" default="">
<cfparam name="url.error" type="string" default="">

<cfinclude template="queries/q_select_workgroups.cfm">

<h4><cfoutput>#GetLangVal('adm_ph_create_new_group')#</cfoutput></h4>

<cfif len(url.error) gt 0>
	<!--- display the error message ... --->
	<h1><cfoutput>#url.error#</cfoutput></h1>
</cfif>


<cfquery name="q_select_other_groups" dbtype="query">
SELECT
	groupname,entrykey
FROM
	q_select_workgroups
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<fieldset class="default_fieldset">
	<legend><cfoutput>#GetLangVal('adm_ph_create_new_group')#</cfoutput></legend>


<table class="table_details table_edit_form">
<form action="act_new_workgroup.cfm" method="post">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:</td>
    <td>
	<input type="text" name="frmname" size="30">
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('adm_ph_workgroup_short_name')#</cfoutput>:</td>
	<td>
	<input type="text" name="frmshortname" size="10" maxlength="12"> (<cfoutput>#GetLangVal('adm_ph_workgroup_short_name_max_12_chars')#</cfoutput>)
	</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:</td>
    <td>
	<input type="text" name="frmdescription" size="30">
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('adm_ph_superior_group')#</cfoutput>:</td>
	<td>
	<select name="frmparentgroupkey">
		<option value="" selected>(<cfoutput>#GetLangVal('cm_wd_none')#</cfoutput>)</option>
	<cfoutput query="q_select_other_groups">
		<option value="#htmleditformat(q_select_other_groups.entrykey)#">#htmleditformat(q_select_other_groups.groupname)#</option>
	</cfoutput>
	</select>
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('cm_ph_assigned_color')#</cfoutput>:</td>
	<td>
		<input type="text" name="frmcolour" size="8" value="white">
	</td>
  </tr>
  <tr>
    <td class="field_name">&nbsp;</td>
    <td><input type="submit" class="btn" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_create_new_group')#</cfoutput>"></td>
  </tr>
</form>
</table>

</fieldset>

