<cfquery name="q_select_old_issue_version">
SELECT
	*
FROM
	newsletter_issues
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

<cfif q_select_old_issue_version.recordcount GT 0>
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="newsletter edit version" type="html"><cfdump var="#q_select_old_issue_version#"><cfdump var="#arguments#"></cfmail>
</cfif>

<cfquery name="q_delete_old_issue_version">
DELETE FROM
	newsletter_issues
WHERE
	listkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.listkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	
	<!---
		check userkey ...
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	--->
;
</cfquery>