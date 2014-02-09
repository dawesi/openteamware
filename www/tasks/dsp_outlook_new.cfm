<!--- //

	outlook on the startpage ...
	
	// --->
	
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.statusexclude = 0>

<cfinvoke component="/components/tasks/cmp_task" method="GetTasks" returnvariable="stReturn">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
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
	<!---AND
	int_dt_due <= #a_int_dt_tommorrow#--->
	AND
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
	)	
;
</cfquery>

<cfquery name="q_select_overdue_tasks" dbtype="query">
SELECT
	*
FROM
	stReturn.q_select_tasks
WHERE
	int_dt_due IS NOT NULL
	AND NOT
	(int_dt_due = 0)
	AND
	int_dt_due < #a_int_dt_today#
	AND
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
	)
;
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr class="mischeader">
	<td class="b_all" style="letter-spacing:2px;font-size:10px;text-transform:uppercase;">
	&nbsp;<a href="/tasks/" title="zur Aufgabenverwaltung wechseln ..."><b><img src="/images/icon/notizen.gif" width="12" height="12" align="absmiddle" hspace="3" vspace="3" border="0"> Faellige Aufgaben</b></a>
	</td>
  </tr>
  
  <tr>
  	<td>
	
	<cfif (q_select_tasks.recordcount is 0) AND (q_select_overdue_tasks.recordcount is 0)>
		<div class="addinfotext">
		Keine Eintraege gefunden
		</div>
	<cfelse>
	
		<cfset a_int_recordcount = 0>
		
		<cfset a_int_recordcount = q_select_tasks.recordcount>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<cfoutput query="q_select_tasks" startrow="1" maxrows="10">
		  <tr id="idtrtasks#q_select_tasks.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">
			<td <cfif q_select_tasks.currentrow neq 1>class="bdashedtop"</cfif>>
				<img src="/images/tasks/task_status_#q_select_tasks.status#.png" width="9" height="9" vspace="0" hspace="0" border="0" align="absmiddle">
			</td>
			<td <cfif q_select_tasks.currentrow neq 1>class="bdashedtop"</cfif>>
				<a title="#htmleditformat(q_select_tasks.title)#" href="/tasks/default.cfm?action=ShowTask&entrykey=#urlencodedformat(q_select_tasks.entrykey)#">#htmleditformat(shortenstring(checkzerostring(q_select_tasks.title), 30))#</a>
			</td>
		  </tr>
		</cfoutput>
		
		
		
		<cfif q_select_overdue_tasks.recordcount GT 0>
		
			<cfif a_int_recordcount GTE 10>
			<tr>
				<td <cfif q_select_tasks.recordcount GT 0>class="bdashedtop"</cfif>><img src="/images/high.png" width="8" height="17" border="0" vspace="0" hspace="0"></td>
				<td <cfif q_select_tasks.recordcount GT 0>class="bdashedtop"</cfif>>
				<a href="/tasks/default.cfm?&filterstatus=open&filtertimeframe=overdue&filtercategory=&filterpriority=&filterworkgroup="><cfoutput>#q_select_overdue_tasks.recordcount#</cfoutput> &uuml;berf&auml;llige Aufgaben</a>
				</td>
			</tr>
			<cfelse>
				
				<tr>
					<td <cfif q_select_tasks.recordcount GT 0>class="bdashedtop"</cfif>><img src="/images/high.png" width="8" height="17" border="0" vspace="0" hspace="0"></td>
					<td <cfif q_select_tasks.recordcount GT 0>class="bdashedtop"</cfif>>
					<b><a href="/tasks/default.cfm?&filterstatus=open&filtertimeframe=overdue&filtercategory=&filterpriority=&filterworkgroup="><cfoutput>#q_select_overdue_tasks.recordcount#</cfoutput> &uuml;berf&auml;llige Aufgaben</a></b>
					</td>
				</tr>
				  <cfoutput query="q_select_overdue_tasks" startrow="1" maxrows="10">
				  <tr id="idtrtasksoverdue#q_select_tasks.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">
					<td class="bdashedtop">
						<img src="/images/tasks/task_status_#q_select_overdue_tasks.status#.png" width="9" height="9" vspace="0" hspace="0" border="0" align="absmiddle">
					</td>
					<td class="bdashedtop">
						<a title="#htmleditformat(q_select_overdue_tasks.title)#" href="/tasks/default.cfm?action=ShowTask&entrykey=#urlencodedformat(q_select_overdue_tasks.entrykey)#">#htmleditformat(shortenstring(checkzerostring(q_select_overdue_tasks.title), 30))#</a>
					</td>
				  </tr>
				  </cfoutput>
				  
			</cfif>
		</cfif>
		</table>

	</cfif>
	
	</td>
  </tr>
 </table>