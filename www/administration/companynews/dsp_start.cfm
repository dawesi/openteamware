<!--- //

	Module:		Admintool
	Action:		Companynews
	Description:Display current company news
	
// --->

 
 
<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="#application.components.cmp_content#" method="GetCompanyNews" returnvariable="q_select_news">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>
 
<h4><cfoutput>#GetLangVal('adm_ph_company_news')#</cfoutput></h4>

<!---<cfdump var="#q_select_news#">--->

<cfsavecontent variable="a_str_content">
<table class="table_overview">
  <tr class="tbl_overview_header">
    <td>#</td>
    <td><cfoutput>#GetLangVal('cm_wd_subject')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('adm_ph_company_news_valid_until')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_link')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_news">
  <tr>
    <td>&nbsp;</td>
    <td>
		#htmleditformat(q_select_news.title)#
	</td>
    <td>
		<cfif IsDate(q_select_news.dt_valid_until)>
		#LSdateformat(q_select_news.dt_valid_until, 'ddd, dd.mm.yy')#
		</cfif>
	</td>
    <td>
		#q_select_news.href#
	</td>
    <td>
		<a href="default.cfm?action=companynews.edit#writeurltags()#&entrykey=#q_select_news.entrykey#">#si_img('pencil')#</a> | <a href="javascript:deletenews('#jsstringformat(q_select_news.entrykey)#');">#si_img('delete')# #GetLangVal('cm_wd_delete')#</a>
	</td>
  </tr>
  </cfoutput>
</table>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<cfoutput >
<input value="#GetLangVal('adm_ph_company_news_new_item')#" type="button" onclick="GotoLocHref('default.cfm?action=companynews.new#WriteURLTags()#');" class="btn" />
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('adm_ph_company_news'), a_str_buttons, a_str_content)#</cfoutput>


<script type="text/javascript">
	function deletenews(id)
		{
		if (confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>') == true)
			{
			location.href = 'companynews/act_delete_news.cfm?<cfoutput>#WriteURLTags()#</cfoutput>&entrykey='+escape(id);
			}
		}
</script>

