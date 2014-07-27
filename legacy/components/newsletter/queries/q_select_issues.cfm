<!--- //

	Module:		
	Action:		GetIssues
	Description:	
	

// --->

<cfquery name="q_select_issues">
SELECT
	newsletter_issues.entrykey,
	newsletter_issues.listkey,
	newsletter_issues.issue_name,
	newsletter_issues.description,
	newsletter_issues.body_html,
	newsletter_issues.body_text,
	newsletter_issues.dt_send,
	newsletter_issues.approved,
	newsletter_issues.subject,
	newsletter_issues.autogenerate_text_version,
	newsletter_issues.attachmentkeys,
	newsletter_profiles.profile_name,
	newsletter_issues.attachmentkeys,
	newsletter_issues.prepare_done,
	newsletter_issues.dt_approved,
	newsletter_issues.hidden_issue
FROM
	newsletter_issues 
LEFT JOIN
	newsletter_profiles ON (newsletter_profiles.entrykey = newsletter_issues.listkey)
WHERE
	(newsletter_profiles.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)

<cfif Len(arguments.entrykeys) GT 0>
	AND
	(newsletter_issues.entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys#" list="yes">))
</cfif>

<cfif Val(arguments.filter_approved) GT -1>
	AND
	(newsletter_issues.approved = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter_approved#">)
</cfif>

;
</cfquery>

