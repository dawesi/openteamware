
<script type="text/javascript" src="/administration/js/CalendarPopup.js"></script>

<cfparam name="CreateOrEditNews.action" type="string" default="create">
<cfparam name="CreateOrEditNews.query" type="query" default="#QueryNew('title,entrykey,href,dt_valid_until,topnews,deliver_to_customers_too,furthertext,topnews')#">


<cfif CreateOrEditNews.action IS 'create'>
<form action="companynews/act_insert_news.cfm" method="post">
<cfelse>
<form action="companynews/act_edit_news.cfm" method="post">
<input type="hidden" name="frmentrykey" value="<cfoutput>#CreateOrEditNews.query.entrykey#</cfoutput>">
</cfif>
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">

<table class="table_details table_edit_form">
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>:</td>
    <td>
	<input type="text" name="frmtitle" size="30" value="<cfoutput>#htmleditformat(CreateOrEditNews.query.title)#</cfoutput>">
	</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_link')#</cfoutput>:</td>
    <td>
	<input type="text" name="frmhref" size="30" value="<cfoutput>#htmleditformat(CreateOrEditNews.query.href)#</cfoutput>">
	</td>
  </tr>
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('adm_ph_company_news_valid_until')#</cfoutput>:</td>
    <td>
	<SCRIPT type="text/javascript" ID="js1">
	var cal1 = new CalendarPopup();
	</SCRIPT>

	<script type="text/javascript">writeSource("js1");</SCRIPT>
	<INPUT TYPE="text" NAME="date1" VALUE="<cfoutput>#htmleditformat(CreateOrEditNews.query.dt_valid_until)#</cfoutput>" SIZE=14>
	<A HREF="#" onClick="cal1.select(document.forms[0].date1,'anchor1','MM/dd/yyyy'); return false;" TITLE="cal1.select(document.forms[0].date1,'anchor1','MM/dd/yyyy'); return false;" NAME="anchor1" ID="anchor1"><cfoutput>#GetLangVal('cm_ph_please_select')#</cfoutput></A>


	<!---<input type="text" name="frmdt_valid_until" size="8" value="">--->
	</td>
  </tr>
  <tr style="display:none; ">
  	<td class="field_name">
		<input type="checkbox" name="frmcbtopnews" value="1" class="noborder" <cfoutput>#WriteCheckedElement(CreateOrEditNews.query.topnews, 1)#</cfoutput>>
	</td>
	<td>
		<cfoutput>#GetLangVal('adm_ph_company_news_top_news')#</cfoutput>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_text')#</cfoutput>:
	</td>
	<td>
		<textarea name="frmtext" cols="20" rows="2"><cfoutput>#htmleditformat(CreateOrEditNews.query.furthertext)#</cfoutput></textarea>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<input type="checkbox" name="frmcb_for_customers_too" value="1" class="noborder" <cfoutput>#WriteCheckedElement(CreateOrEditNews.query.deliver_to_customers_too, 1)#</cfoutput>>
	</td>
	<td>
		<cfoutput>#GetLangVal('adm_ph_company_news_display_customers_too')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
	<input type="submit" class="btn btn-primary" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" />
	</td>
  </tr>
</form>
</table>

<br><br>
<a href="index.cfm?action=companynews<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput></a>