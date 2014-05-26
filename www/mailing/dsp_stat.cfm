<cfparam name="url.listkey" type="string" default="">
<cfparam name="url.issuekey" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>
<cfset q_select_profile = a_cmp_nl.GetNewsletterProfile(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, entrykey = url.listkey)>
<cfset q_select_issue = a_cmp_nl.GetIssue(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, entrykey = url.issuekey)>


<cfquery name="q_select_recipients" datasource="#request.a_str_db_crm#">
SELECT
	recipient,status,opened,dt_opened,bounced,contactkey
FROM
	newsletter_recipients
WHERE
	<!---listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.listkey#">
	AND--->
	issuekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.issuekey#">
;
</cfquery>

<cfquery name="q_select_opened" dbtype="query">
SELECT
	COUNT(opened) AS count_opened
FROM
	q_select_recipients
WHERE
	opened = 1
	AND
	bounced = 0
;
</cfquery>

<cfquery name="q_select_not_opened" dbtype="query">
SELECT
	COUNT(opened) AS count_not_opened
FROM
	q_select_recipients
WHERE
	opened = 0
	AND
	bounced = 0
;
</cfquery>


<cfquery name="q_select_bounced" dbtype="query">
SELECT
	COUNT(opened) AS count_bounced
FROM
	q_select_recipients
WHERE
	bounced = 1
;
</cfquery>

<cfquery name="q_select_not_bounced" dbtype="query">
SELECT
	COUNT(opened) AS count_not_bounced
FROM
	q_select_recipients
WHERE
	bounced = 0
;
</cfquery>



<cfset tmp = SetHeaderTopInfoString(GetLangVal('scr_wd_statistics'))>

<br/>

<cfsavecontent variable="a_str_content">
		<cfif q_select_issue.prepare_done IS 0>
			<div class="mischeader">
			<img src="/images/img_bar_status_loading.gif" width="107" height="13" border="0">
			<br>
			<cfoutput>#GetLangVal('nl_ph_status_sending_issue')#</cfoutput>
			</div>
			<br><br>
		</cfif>
	
		<div style="height:300px;overflow:auto; " class="b_all"><cfoutput>#q_select_issue.body_html#</cfoutput></div>

</cfsavecontent>

<cfif IsDate(q_select_issue.dt_send)>
	<cfset a_str_dt_sent = LsDateFormat(q_select_issue.dt_send, request.stUserSettings.default_Dateformat)>
<cfelse>
	<cfset a_str_dt_sent = ''>
</cfif>

<cfsavecontent variable="a_str_buttons">
	<cfoutput>
	<input onClick="location.href = 'index.cfm?action=newissue&listkey=#q_select_issue.listkey#&tempaltekey=#q_select_issue.entrykey#';" type="button" class="btn" value="#GetLangVal('nl_ph_use_as_template')#"/>
	</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(q_select_issue.subject & ' (' & a_str_dt_sent & ')', a_str_buttons, a_str_content)#</cfoutput>

<br>

<!--- recipients ... --->
<cfsavecontent variable="a_str_content">
	
	
	<cfsavecontent variable="a_str_chart">
	<cfchart format="flash" xaxistitle=" " yaxistitle=" "> 

<cfchartseries type="pie"
itemcolumn=" " 
valuecolumn=" ">
<cfchartdata item="#GetLangVal('cm_ph_no_error')#" value="#val(q_select_not_bounced.count_not_bounced)#">
<cfchartdata item="#GetLangVal('cm_wd_error')#" value="#val(q_select_bounced.count_bounced)#">


</cfchartseries>
</cfchart> 
</cfsavecontent>

<cfoutput>#ReplaceNoCase(a_str_chart, 'http://', 'https://', 'ALL')#</cfoutput>


	<cfsavecontent variable="a_str_chart">
	<cfchart format="flash" 
xaxistitle=" " 
yaxistitle=" "> 

<cfchartseries type="pie"
itemcolumn=" " 
valuecolumn=" ">

<cfchartdata item="#GetLangVal('nl_wd_status_opened')#" value="#val(q_select_opened.count_opened)#">
<cfchartdata item="#GetLangVal('nl_wd_status_not_opened')#" value="#val(q_select_not_opened.count_not_opened)#">

</cfchartseries>
</cfchart> 
</cfsavecontent>

<cfoutput>#ReplaceNoCase(a_str_chart, 'http://', 'https://', 'ALL')#</cfoutput>

	
	<table class="table_overview">
	  <tr class="tbl_overview_header">
		<td align="center">#</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_email')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_error')#</cfoutput>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  <cfoutput query="q_select_recipients">
	  <tr>
		<td align="center" <cfif q_select_recipients.opened IS 1>style="background-color:lightgreen;"</cfif><cfif q_select_recipients.bounced IS 1>style="background-color:##FF7171;"</cfif>>
			#q_select_recipients.currentrow#&nbsp;
		</td>
		<td>
			<cfif Len(q_select_recipients.contactkey) GT 0><a href="javascript:OpenContactAddressBook('#jsstringformat(q_select_recipients.contactkey)#');"></cfif>#htmleditformat(q_select_recipients.recipient)#<cfif Len(q_select_recipients.contactkey) GT 0></a></cfif>
		</td>
		<td>
			<cfif q_select_recipients.bounced IS 1>
				#GetLangVal('cm_wd_error')#
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		<td>&nbsp;</td>
	  </tr>
	  </cfoutput>
	</table>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('mail_wd_recipients') & '/' & GetLangVal('nl_ph_delivery_status') & ' (' & q_select_recipients.recordcount & ')' , '', a_str_content)#</cfoutput>



<script type="text/javascript">
	function OpenContactAddressBook(entrykey)
		{
		location.href = '/addressbook/?action=ShowItem&entrykey=' + escape(entrykey);
		}
</script>