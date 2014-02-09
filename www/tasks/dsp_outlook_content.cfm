<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.statusexclude = 0>
<cfset a_struct_filter.excludenoduedateitems = true>

<cfinvoke component="#application.components.cmp_tasks#" method="GetTasks" returnvariable="stReturn">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
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
	int_dt_due >= #a_int_dt_today#
	<!---AND
	int_dt_due <= #a_int_dt_tommorrow#--->
	AND
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
	)	
ORDER BY
	int_dt_due
;
</cfquery>

<cfquery name="q_select_overdue_tasks" dbtype="query">
SELECT
	*
FROM
	stReturn.q_select_tasks
WHERE
	(int_dt_due < #a_int_dt_today#)
	AND NOT
	(int_dt_due = 0)
	AND
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
	)
ORDER BY
	int_dt_due
;
</cfquery>

<cfset a_str_overdue_status = ''>

<cfif q_select_overdue_tasks.recordcount GT 0>
	<cfset a_str_overdue_status = ' (<b style="color:red;"><cfoutput>#GetLangVal('tsk_ph_overdue_tasks')#</cfoutput>: <cfoutput>#q_select_overdue_tasks.recordcount#</cfoutput></b>)'>
</cfif>

<fieldset class="bg_fieldset">
	<legend>
		<a href="/tasks/"><img src="/images/menu/img_box_task_ok_32x32.gif" width="32" height="32" hspace="2" vspace="2" border="0" align="absmiddle"> <cfoutput>#GetLangVal('tsk_wd_tasks')#</cfoutput></a> <cfoutput>#a_str_overdue_status#</cfoutput>
	</legend>

	
	<div class="div_startpage_contentbox_content">
	
	<cfif q_select_tasks.recordcount IS 0 AND q_select_overdue_tasks.recordcount IS 0>
		<font class="addinfotext"><cfoutput>#GetLangVal('tsk_ph_no_due_overdue_tasks')#</cfoutput></font>
	</cfif>
	
	<table border="0" cellspacing="0" cellpadding="3" width="100%">
	  <cfoutput query="q_select_tasks">
	  <tr>
		<td width="35" align="center">
			<img src="/images/tasks/task_status_#q_select_tasks.status#.png" height="9" width="9" border="0" vspace="2" hspace="2">
		</td>
		<td>
			<a href="/tasks/?action=ShowTask&entrykey=#q_select_tasks.entrykey#">#shortenstring(q_select_tasks.title, 30)#</a>
		</td>
		<td>
			 #DateFormat(q_select_tasks.dt_due, 'dd.mm')#
		</td>
	  </tr>
	  </cfoutput>
	  	  
	  <cfoutput query="q_select_overdue_tasks" startrow="1" maxrows="10">
	  <tr>
		<td width="35" align="center">
			<img src="/images/tasks/task_status_#q_select_overdue_tasks.status#.png" height="9" width="9" border="0" align="absmiddle" vspace="2" hspace="2">
		</td>
		<td>
			 <a style="color:red;" href="/tasks/?action=ShowTask&entrykey=#q_select_overdue_tasks.entrykey#">#shortenstring(q_select_overdue_tasks.title, 30)#</a>
		</td>
		<td>
			 
			 
			 <cfif Year(q_select_overdue_tasks.dt_due) NEQ Year(now())>
				 #LSDateFormat(q_select_overdue_tasks.dt_due, 'mmm yy')#
			 <cfelse>
			 	#DateFormat(q_select_overdue_tasks.dt_due, 'dd.mm.')#
			 </cfif>
		</td>
	  </tr>
	  </cfoutput>
	</table>
	
	
	</div>
</fieldset>