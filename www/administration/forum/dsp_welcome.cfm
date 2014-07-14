<!--- //

	Module:		Admintool
	Action:		forum
	Description:display all forums

// --->

<cfinvoke component="#application.components.cmp_forum#" method="GetAllForumsOfACompany" returnvariable="q_select_foren">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfsavecontent variable="a_str_content">
<table class="table table-hover">
  <tr class="tbl_overview_header">
    <td><cfoutput>#GetLangVal('cm_wd_name')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput></td>
    <td>&nbsp;</td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
	<cfoutput query="q_select_foren">
  <tr>
    <td>
		<a href="/forum/?action=ShowForum&entrykey=#q_select_foren.entrykey#">#htmleditformat(q_select_foren.forumname)#</a>
	</td>
    <td>
		#htmleditformat(q_select_foren.description)#
	</td>
    <td>&nbsp;</td>
    <td>
		<span class="glyphicon glyphicon-pencil"></span>
		<img src="/images/si/delete.png" class="si_img" />
	</td>
  </tr>
	</cfoutput>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
<cfoutput>
<input class="btn btn-primary" type="button" value="#GetLangVal('adm_ph_create_new_forum')#" onclick="GotoLocHref('index.cfm?action=forum#WriteURLTags()#&subaction=createnewforum');return false;" />
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_foren'), a_str_buttons, a_str_content)#</cfoutput>



