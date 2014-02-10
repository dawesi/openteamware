
		
<cfquery name="q_select_subscriptions" datasource="#request.a_str_db_crm#">
SELECT
	newsletter_recipients.contactkey,
	newsletter_recipients.dt_created,
	newsletter_recipients.bounced,
	newsletter_recipients.opened,
	newsletter_recipients.issuekey,
	newsletter_recipients.listkey,
	newsletter_profiles.profile_name,
	newsletter_issues.issue_name
FROM
	newsletter_recipients
LEFT JOIN
	newsletter_profiles ON (newsletter_profiles.entrykey = newsletter_recipients.listkey)
LEFT JOIN
	newsletter_issues ON (newsletter_issues.entrykey = newsletter_recipients.issuekey)
WHERE
	newsletter_recipients.contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys#">
ORDER BY
	newsletter_recipients.dt_created DESC
;
</cfquery>

<cfset stReturn.recordcount = q_select_subscriptions.recordcount>

<cfsavecontent variable="a_str_output">
<table border="0" cellspacing="0" cellpadding="2" width="95%" align="center">
  <tr>
	<td width="50%" class="addinfotext">
		<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
	</td>
	<td class="addinfotext" width="25%">
		<cfoutput>#GetLangVal('cm_wd_created')#</cfoutput>
	</td>
	<td class="addinfotext" width="25%">
		<cfoutput>#GetLangVal('nl_wd_status_opened')#/#GetLangVal('cm_Wd_error')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select_subscriptions">
  <tr>
  	<td>
		<a href="/mailing/default.cfm?action=stat&listkey=#q_select_subscriptions.listkey#&issuekey=#q_select_subscriptions.issuekey#">#htmleditformat(q_select_subscriptions.issue_name)# (#htmleditformat(q_select_subscriptions.profile_name)#)</a>
	</td>
	<td>
		#LsDateFormat(q_select_subscriptions.dt_created, arguments.usersettings.default_Dateformat)#
	</td>
	<td>
		<cfif q_select_subscriptions.opened IS 1>
			#GetLangVal('cm_wd_yes')#
		<cfelse>
			#GetLangVal('cm_wd_no')#
		</cfif>
		/
		<cfif q_select_subscriptions.bounced IS 1>
			#GetLangVal('cm_wd_yes')#
		<cfelse>
			#GetLangVal('cm_wd_no')#
		</cfif>
	</td>
  </tr>
  </cfoutput>
</table>
</cfsavecontent>

<cfset stReturn.output = a_str_output>