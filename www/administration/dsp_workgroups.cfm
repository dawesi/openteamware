<!--- //

	Module:		Admintool
	Action:		workgroups
	Description:workgroup administration 
	
// --->
	
<cfinclude template="dsp_inc_select_company.cfm">
	
<h4><cfoutput>#GetLangVal('adm_ph_nav_group_administration')#</cfoutput></h4>

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="queries/q_select_company_users.cfm">

<cfif q_select_company_users.recordcount IS 1>
	<fieldset>
		<legend><cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput></legend>
		<div style="padding:6px; ">
			<a style="font-weight:bold; " href="default.cfm?action=newuser&<cfoutput>#writeurltags()#</cfoutput>&productkey=AE79D26D-D86D-E073-B9648D735D84F319"><img src="/images/img_attention.png" border="0" align="absmiddle"> <cfoutput>#GetLangVal('adm_ph_group_admin_no_more_users')#</cfoutput></a>
		</div>
	</fieldset>
	<br>
</cfif>



<cfinclude template="queries/q_select_workgroups.cfm">
<cfset request.q_select_workgroups = q_select_workgroups>

<cfsavecontent variable="a_str_content">
	
	<div style="padding:6px; ">
	<cfif q_select_workgroups.recordcount is 0>
		<b><cfoutput>#GetLangVal('adm_ph_group_admin_no_teams_defined')#</cfoutput></b>
	<cfelse>
	
	<table class="table_overview">
	  <tr class="tbl_overview_header">
		<td><b><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></b></td>
		<td><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_members')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_created')#</cfoutput></td>
		<td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
	  </tr>
	  <cfmodule template="workgroups/mod_dsp_workgroups_row.cfm" parentkey='' level=0>
	</table>
	
	
	</cfif>
	
	<br /><br />   

	</div>

</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
	<form action="default.cfm" method="get" style="margin:0px; ">
	<input type="hidden" name="action" value="newworkgroup">
	<input type="hidden" name="resellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
	<input type="hidden" name="companykey" value="<cfoutput>#url.companykey#</cfoutput>">
		<input type="submit" class="btn" value="<cfoutput>#GetLangVal('adm_ph_create_new_group')#</cfoutput> ..." />
	</form>
</cfsavecontent>

<cfoutput>
#WriteNewContentBox(GetLangVal('adm_ph_nav_group_administration'), a_str_buttons, a_str_content)#
</cfoutput>

<br /> 

<cfsavecontent variable="a_str_content">
<cfoutput>#GetLangVal('adm_ph_secretary_description')#</cfoutput><br>
<br>

<cfinvoke component="/components/management/workgroups/cmp_secretary" method="GetAllSecretariesOfACompany" returnvariable="q_select_secretaries">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>


<cfquery name="q_select_distinct_secretaries" dbtype="query">
SELECT
	DISTINCT(secretarykey)
FROM
	q_select_secretaries
ORDER BY
	secretarykey
;
</cfquery>

<cfset a_cmp_user = application.components.cmp_user>

<table class="table_overview">
  <tr class="tbl_overview_header">
    <td><cfoutput>#GetLangVal('adm_wd_secretary_assistant')#</cfoutput></td>  
    <td><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput></td>
	<td><cfoutput>#GetLangVal('cm_wd_permissions')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_ph_created_by')#</cfoutput></td>
	<td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_distinct_secretaries">
  
  <cfquery name="q_select_records" dbtype="query">
  SELECT
  	*
  FROM
  	q_select_secretaries
  WHERE
  	secretarykey = '#q_select_distinct_secretaries.secretarykey#'
  ;	
  </cfquery>
  
  <cfloop query="q_select_records">
  <tr>
    <td valign="top">
	<cfif q_select_records.currentrow IS 1>
		#a_cmp_user.GetUsernamebyentrykey(q_select_records.secretarykey)#
	</cfif>
	</td>
    <td valign="top">
		#a_cmp_user.GetUsernamebyentrykey(q_select_records.userkey)#
	</td>
	<td valign="top">
		<cfswitch expression="#q_select_records.permission#">
			<cfcase value="create">
				#GetLangVal('adm_ph_sec_permissions_create')#
			</cfcase>
			<cfcase value="changecreatedbysecretary">
				#GetLangVal('adm_ph_sec_permissions_create')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#
			</cfcase>
			<cfcase value="changeall">
				#GetLangVal('adm_ph_sec_permissions_create')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_all')#
			</cfcase>
			<cfcase value="deletecreatedbysecretary">
				#GetLangVal('adm_ph_sec_permissions_create')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_all')#<br>
				#GetLangVal('adm_ph_sec_permissions_delete_created_by_secretary')#
			</cfcase>			
			<cfcase value="deleteall">
				#GetLangVal('adm_ph_sec_permissions_create')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#<br>
				#GetLangVal('adm_ph_sec_permissions_change_all')#<br>
				#GetLangVal('adm_ph_sec_permissions_delete_created_by_secretary')#<br>
				#GetLangVal('adm_ph_sec_permissions_delete_all')#
			</cfcase>			
			<cfdefaultcase>
				#q_select_secretaries.permission#
			</cfdefaultcase>
		</cfswitch>
	</td>
    <td valign="top">
		#a_cmp_user.GetUsernamebyentrykey(q_select_records.createdbyuserkey)#
	</td>
	<td valign="top">
		<a href="default.cfm?action=secretary.edit&entrykey=#q_select_records.entrykey##WriteURLTags()#"><img src="/images/editicon.gif" align="absmiddle" border="0" vspace="4" hspace="4"> #GetLangVal('cm_wd_edit')#</a>
		<a href="javascript:deletesecretary('#jsstringformat(q_select_records.entrykey)#');"><img src="/images/del.gif" align="absmiddle" border="0" width="12" height="12"> #GetLangVal('cm_wd_delete')#</a>
	</td>
  </tr>
  </cfloop>
  
  </cfoutput>
</table>
<br>



</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<input onclick="GotoLocHref('default.cfm?action=secretary.new<cfoutput>#writeurltags()#</cfoutput>');" type="button" value="<cfoutput>#GetLangVal('cm_ph_create_new_entry')#</cfoutput>" class="btn" />
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('adm_ph_nav_group_administration_secretary'), a_str_buttons, a_str_content)#</cfoutput>

<script type="text/javascript">
	function deletesecretary(entrykey)
		{
		if (confirm('S<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>') == true)
			{
			location.href = 'secretary/act_delete_entry.cfm?<cfoutput>#writeurltags()#</cfoutput>&entrykey='+escape(entrykey);
			}
		}
</script>

