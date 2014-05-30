<cfparam name="CreateEditForumRequest.query" type="query" default="#QueryNew('entrykey,forumname,description')#">
<cfparam name="CreateEditForumRequest.request" type="string" default="create">


<cfinclude template="../queries/q_select_workgroups.cfm">

<!--- create or update? --->
<cfif CreateEditForumRequest.request IS 'create'>
	<form action="forum/act_new_forum.cfm" method="post">
	
	<!--- add a dummy row ... --->
	<cfset tmp = queryAddRow(CreateEditForumRequest.query, 1)>
	
<cfelse>
	<form action="forum/act_update_forum.cfm" method="post">
		
		<cfoutput>
		<input type="hidden" name="frmentrykey" value="#CreateEditForumRequest.query.entrykey#">
		</cfoutput>
		
</cfif>

<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
	
<cfoutput query="CreateEditForumRequest.query">
<table class="table_details table_edit_form">
  <tr>
    <td class="field_name">#GetLangVal('cm_wd_name')#:</td>
    <td>
		<input type="text" name="frmname" value="#htmleditformat(CreateEditForumRequest.query.forumname)#">
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('cm_wd_description')#:</td>
    <td>
		<input type="text" name="frmdescription" value="#htmleditformat(CreateEditForumRequest.query.description)#">
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('cm_wd_workgroups')#:</td>
    <td>
	
		<!--- // 2do: on edit: pre-select workgroups for which this forum has been enabled ... // --->
		<select name="frmworkgroupkeys" size="10" multiple>
		<cfloop query="q_select_workgroups">
			<option value="#q_select_workgroups.entrykey#">#htmleditformat(q_select_workgroups.groupname)#</option>
		</cfloop>
		</select>
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('adm_ph_nav_companynews')#:</td>
    <td>
		<input type="checkbox" name="frmcompany_news" value="1" class="noborder">
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('forum_ph_admin_post_only')#:</td>
    <td>
		<input type="checkbox" name="frm_admin_post_only" value="1" class="noborder">
	</td>
  </tr>
  <tr>
    <td class="field_name">&nbsp;</td>
    <td>
		<input type="submit" class="btn btn-primary" value="#GetLangVal('cm_wd_save_button_caption')#" />
	</td>
  </tr>
</table>
</cfoutput>
	
</form>