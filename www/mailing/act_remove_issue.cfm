<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.listkey" type="string" default="">
<cfparam name="url.issuekey" type="string" default="">

<cfquery name="q_update_set_hidden_issue" datasource="#request.a_str_db_crm#">
UPDATE
	newsletter_issues
SET
	hidden_issue = 1
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.issuekey#">
	AND
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.listkey#">
;
</cfquery>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">