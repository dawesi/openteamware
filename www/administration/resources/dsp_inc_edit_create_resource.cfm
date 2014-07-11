<!--- //

	Module:		Admintool
	Description:Form for creating / editing resource
	
// --->


<cfparam name="CreateOrEditResource.action" type="string" default="create">
<cfparam name="CreateOrEditResource.query" type="query" default="#QueryNew('title,description,workgroupkeys,exclusive,entrykey')#">

<cfif CreateOrEditResource.action is 'create'>
<form action="resources/act_create_resource.cfm" method="post">
<cfelse>
<form action="resources/act_update_resource.cfm" method="post">
<input type="hidden" name="entrykey" value="<cfoutput>#CreateOrEditResource.entrykey#</cfoutput>">
</cfif>


<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">

<cfinclude template="../queries/q_select_workgroups.cfm">

<table class="table table_details table_edit_form">
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>:</td>
    <td>
		<input type="text" name="frmtitle" size="30" value="<cfoutput>#htmleditformat(CreateOrEditResource.query.title)#</cfoutput>">
	</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:</td>
    <td>
		<input type="text" name="frmdescription" size="30" value="<cfoutput>#htmleditformat(CreateOrEditResource.query.description)#</cfoutput>">
	</td>
  </tr>
  <tr>
  	<td class="field_name"><cfoutput>#GetLangVal('adm_ph_ressources_exclusive_only')#</cfoutput>:</td>
	<td>
	<input type="checkbox" name="frmexclusive" value="1" checked readonly="1" disabled>
	</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('adm_ph_ressources_access_allowd_for_groups')#</cfoutput>:</td>
    <td valign="top">
	
	<!--- load workgroups of company ... --->
	<cfoutput query="q_select_workgroups">
		<input class="noborder" <cfif ListFindNoCase(CreateOrEditResource.query.workgroupkeys, q_select_workgroups.entrykey) GT 0>checked</cfif> type="checkbox" name="frmworkgroupkeys" value="#htmleditformat(q_select_workgroups.entrykey)#"> #htmleditformat(q_select_workgroups.groupname)#<br>
	</cfoutput>
	
	</td>
  </tr>
  <tr>
  	<td class="field_name"></td>
	<td>
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" class="btn btn-primary" />
	</td>
  </tr>
</form>
</table>

