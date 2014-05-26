<cfset TaskRequest.SelectTop = 10>
<cfset TaskRequest.StatusExclude = 0>
<cfset TaskRequest.Sort = "due">
<cfset TaskRequest.DueNotNull = 1>
<cfset TaskRequest.Order = "up">
<cfset TaskRequest.DueDateGreatherThan = "">
<cfinclude template="queries/q_select_tasks.cfm">

<table width="100%" border="0" cellspacing="0" cellpadding="3">
<cfoutput query="q_select_tasks">
<tr>
	<td><img height=9 width=9 align="absmiddle" src="/images/tasks/task_status_#q_select_tasks.status#.png">&nbsp;<a class="simplelink" href="/tasks/index.cfm?action=ShowTask&id=#q_select_tasks.id#">#shortenstring(q_select_tasks.title, 30)#</a></td>
</tr>
</cfoutput>
</table>