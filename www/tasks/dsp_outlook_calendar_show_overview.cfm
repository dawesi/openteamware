
<!--- load tasks ... --->

<cfinvoke component="/components/tasks/cmp_task" method="GetTasks" returnvariable="stReturn">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="createcategorylist" value="false">
  <cfinvokeargument name="loadnotice" value="false">
</cfinvoke>

<cfset a_int_dt_today = DateFormat(GetLocalTime(Now()), 'yyyymmdd')&'0000'>
<cfset a_int_dt_tommorrow = DateFormat(DateAdd('d', 1, GetLocalTime(Now())), 'yyyymmdd')&'0000'>

<cfquery name="q_select_tasks" dbtype="query">
SELECT
	*
FROM
	stReturn.q_select_tasks
WHERE
	int_dt_due IS NOT NULL
	AND
	int_dt_due >= #a_int_dt_today#
	AND
	int_dt_due <= #a_int_dt_tommorrow#
;
</cfquery>

<div class="mischeader" style="padding:2px;">
<font class="contrasttext" style="font-weight:bold;"><img src="/images/high.png" align="absmiddle" vspace="2" hspace="2" border="0">&nbsp;<cfoutput>#GetLangVal("cal_ph_tasks_due")#</cfoutput> (<cfoutput>#q_select_tasks.recordcount#</cfoutput>)</font></div>

<cfoutput query="q_select_tasks" startrow="1" maxrows="5">
&gt;&nbsp;<a title="#htmleditformat(q_select_tasks.notice)#" href="../tasks/index.cfm?action=ShowTask&entrykey=#urlencodedformat(q_select_tasks.entrykey)#">#htmleditformat(shortenstring(q_select_tasks.title, 30))#</a><br>

<cfif isDate(q_select_tasks.dt_due)>
	&nbsp;&nbsp;<font class="addinfotext">(#GetLangVal("cal_wd_due")# #trim(lsdateformat(q_select_tasks.dt_due, "ddd, dd.mm. "))#)</font><br>
</cfif>
</cfoutput>

<cfif q_select_tasks.recordcount gt 5>
<a href="../tasks/">Alle <cfoutput>#q_select_tasks.recordcount#</cfoutput> f&auml;lligen Aufgaben anzeigen</a>
</cfif>