<!--- auflisten --->
<cfinclude template="queries/q_select_due_today.cfm">

<cfif q_select_due_today.recordcount gt 0><cfset ATasksAvalialbe = true></cfif>


<!--- heute f�llige aufgaben anzeigen --->
<cfif ATasksAvalialbe is true>
<table  width="100%" border="0" cellspacing="0" cellpadding="2" class="bl">
<tr>
	<td colspan="2" style="background-color:#EEEEEE;border-top:dashed silver 1px;border-bottom:dashed silver 1px;"><b><font style="color:darkred;"><img src="/images/high.png" hspace="2" vspace="2" border="0" align="absmiddle" alt="">&nbsp;<cfoutput>#GetLangVal("cal_ph_due_today_tasks")#</cfoutput></font></b></td>
</tr>


<cfoutput query="q_select_due_today">
<tr>
	<td>-</td>
	<td><a class="simplelink" href="/tasks/index.cfm?action=ShowTask&id=#q_select_due_today.id#">#shortenstring(q_select_due_today.title, 30)#</a></td>
</tr>
</cfoutput>
</table>
</cfif>



<!--- keine erledigten anzeigen --->
<cfset TaskRequest.StatusExclude = 0>
<cfset TaskRequest.SelectTop = 20>
<cfset TaskRequest.Sort = "due">
<cfset TaskRequest.DueNotNull = 1>
<cfset TaskRequest.Order = "up">
<cfset TaskRequest.DueDateGreatherThan = "">

<cfinclude template="qry_get_all_notices.cfm">

<table  class="bl" width="100%" border="0" cellspacing="0" cellpadding="2">
<form action="/tasks/act_quick_add.cfm" method="post">
<tr>
	<td class="MiscHeader MiscHeaderFont">
	<b><cfoutput>#GetLangVal("tasks_ph_new_task_notice")#</cfoutput></b>
	</td>
</tr>
<tr>
	<td><input type="text" name="frmtitle" size="10" style="width:100%;"></td>
</tr>
<tr>
	<td align="center"><input type="submit" name="frmSubmit" value="&nbsp;<cfoutput>#GetLangVal("cm_wd_add")#</cfoutput>&nbsp;"></td>
</tr>
</form>
<tr>
	<td class="MiscHeader"><font class="MiscHeaderFont"><img src="/images/icon/notizen.gif" hspace="2" vspace="2" align="absmiddle" border="0"><b><cfoutput>#GetLangVal("tasks_cal_overview")#</cfoutput></b></font></td>
</tr>
<cfoutput query="q_select_all">
<tr>
	<td><a class="simplelink" href="/tasks/index.cfm?action=ShowTask&id=#q_select_all.id#">#Shortenstring(q_select_all.title, 25)#</a></td>
</tr>
</cfoutput>
</table><br>
<a href="/tasks/"><img src="/images/editicon.gif" vspace="2" hspace="2" align="absmiddle" border="0"><b><cfoutput>#GetLangVal("tasks_ph_cal_administrate_tasks")#</cfoutput></b></a>
