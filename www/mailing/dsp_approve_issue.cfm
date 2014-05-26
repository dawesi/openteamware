<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>

<cfset a_tmp_done = a_cmp_nl.ApproveIssue(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, issuekey = url.entrykey)>

<cflocation addtoken="no" url="index.cfm?approvedkey=#url.entrykey#">