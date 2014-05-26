<!--- //

	display tasks in calendar ...
	
	// --->

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.statusexclude = 0>
<cfset a_struct_filter.excludenoduedateitems = true>

<cfinvoke component="/components/tasks/cmp_task" method="GetTasks" returnvariable="stReturn">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfif StructKeyExists(request, 'a_dt_utc_current_date')>
	<cfset a_struct_filter_follow_ups = StructNew()>
	<cfset a_struct_filter_follow_ups.dt_due = request.a_dt_utc_current_date>
	<cfset a_struct_filter_follow_ups.userkey = request.stSecurityContext.myuserkey>
	
			<cfinvoke component="#request.a_str_component_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
				<cfinvokeargument name="servicekey" value="">
				<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
				<cfinvokeargument name="objectkeys" value="">				
				<cfinvokeargument name="filter" value="#a_struct_filter_follow_ups#">
			</cfinvoke>
			
	<cfif q_select_follow_ups.recordcount GT 0>
		<br />
		<table class="table_overview">
		  <tr>
			<td colspan="2"  class="mischeader bb bt">
			<a href="/tools/followups/"><img src="/images/flag.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#GetLangVal('crm_wd_follow_ups')#</cfoutput></a>
			</td>
		  </tr>
		  <cfoutput query="q_select_follow_ups">
		  <tr>
		  	<td class="bdashedbottom">
			<cfswitch expression="#q_select_follow_ups.servicekey#">
				<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<a href="/addressbook/?action=ShowItem&entrykey=#q_select_follow_ups.objectkey#"><img src="/images/menu/img_tree_addressbook_19x16.gif" align="absmiddle" border="0"></cfcase>
			</cfswitch>
			 
			#htmleditformat(checkzerostring(shortenstring(q_select_follow_ups.objecttitle, 20)))#</a>
			
			/
			
			<cfswitch expression="#q_select_follow_ups.followuptype#">
				<cfcase value="0">#GetLangVal('crm_wd_follow_up')#</cfcase>
				<cfcase value="1">#GetLangVal('cm_wd_email')#</cfcase>
				
				<cfcase value="2">#GetLangVal('crm_wd_follow_up_call')#</cfcase>
				<cfcase value="3">#GetLangVal('crm_wd_follow_up_write_letter')#</cfcase>
			</cfswitch>
			
			<cfif Len(q_select_follow_ups.comment) GT 0>
				<br>#shortenstring(q_select_follow_ups.comment, 30)#
			</cfif>			
			</td>
		  </tr>
		  </cfoutput>
		 </table>
		
	</cfif>
			
</cfif>	

<!---<cfif request.stSecurityContext.myuserid is 2>
	<cfdump var="#stReturn#">
</cfif>--->

<!--- //

	select due today tasks
	
	// --->
	
<cfquery name="q_select_due_today" dbtype="query">
SELECT
	title,entrykey
FROM
	stReturn.q_select_tasks
WHERE
	<cfset a_int_dt_today = DateFormat(GetLocalTime(Now()), 'yyyymmdd')&'0000'>
	
	<cfset a_int_dt_tommorrow = DateFormat(DateAdd('d', 1, GetLocalTime(Now())), 'yyyymmdd')&'0000'>
	
	int_dt_due IS NOT NULL
	AND
	(int_dt_due >= #a_int_dt_today#)
	AND
	(int_dt_due <= #a_int_dt_tommorrow#)
	AND NOT
	(status = 0)
	AND
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
	)
;
</cfquery>
	<!---(dt_due_simple IS NOT NULL)
	AND
	(dt_due_simple  IN ('#DateFormat(now(), "yyyy/mm/dd")#','#DateFormat(a_dt_tommorrow, "yyyy/mm/dd")#'))--->



<cfquery name="q_select_overdue" dbtype="query">
SELECT
	title,entrykey,dt_due
FROM
	stReturn.q_select_tasks
WHERE
	int_dt_due IS NOT NULL
	AND
	(int_dt_due < #a_int_dt_today#)
	AND NOT
	(status = 0)
	AND
	(
		(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
		OR
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
	)		
ORDER BY
	dt_due DESC
;
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="2" class="table_overview">
  <tr>
  	<td colspan="2" style="font-weight:bold;" class="addinfotext">
	<a href="../tasks/" class="addinfotext"><cfoutput>#GetLangVal('cm_wd_tasks')#</cfoutput></a>
	</td>
  </tr>
  <cfif q_select_due_today.recordcount GT 0>
  <tr>
    <td colspan="2" style="padding:4px;" class="bb bt"><cfoutput>#GetLangVal('cal_ph_due_today_tasks')#</cfoutput> (<cfoutput>#q_select_due_today.recordcount#</cfoutput>)</td>
  </tr>
  <cfoutput query="q_select_due_today">
  <tr>
  	<td colspan="2">
	&nbsp;<a title="#htmleditformat(q_select_due_today.title)#" href="../tasks/?action=ShowTask&entrykey=#urlencodedformat(q_select_due_today.entrykey)#">#shortenstring(q_select_due_today.title, 15)#</a>
	</td>
  </tr>
  </cfoutput>
  </cfif>
  <cfif q_select_overdue.recordcount GT 0>
  <tr>
    <td class="bb bt" style="padding:4px;"><b><cfoutput>#GetLangVal('tsk_wd_view_overdue')#</cfoutput> (<cfoutput># q_select_overdue.recordcount#</cfoutput>)</b></td>
	<td class="bb bt" style="padding:4px;">d</td>
  </tr>
  
  <!---<script type="text/javascript">
  	a_arr_tasks_overdue = new Array(0);
	var aoutput = '';
  
  
  <cfoutput query="q_select_overdue" startrow="1" maxrows="15">
  	a_arr_tasks_overdue[#(q_select_overdue.currentrow - 1)#] = new Array('#jsstringformat(shortenstring(q_select_overdue.title, 20))#', '#q_select_overdue.entrykey#', '#DateDiff("d", q_select_overdue.dt_due, now())#');
  </cfoutput>
  
  for (ii=0; ii<=a_arr_tasks_overdue.length-1; ii=ii+1)
  	{
	aoutput = aoutput + '<tr id="idtrtasks_overdue_' + ii +'" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">';
	aoutput = aoutput + '<td>';
	aoutput = aoutput + '&nbsp;<a href="../tasks/?action=ShowTask&entrykey=' + escape(a_arr_tasks_overdue[ii][1]) + '">' + a_arr_tasks_overdue[ii][0] + '</a>';
	aoutput = aoutput + '</td>';
	aoutput = aoutput + '<td>';
	aoutput = aoutput + a_arr_tasks_overdue[ii][2] + '&nbsp;';
	aoutput = aoutput + '</td>';
  	aoutput = aoutput + '</tr>';
	//alert(a_arr_tasks_overdue[ii][1]);
	}
  
  </script>--->
  
  <cfoutput query="q_select_overdue" startrow="1" maxrows="15">
  <tr id="idtrtasks#q_select_overdue.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);">
  	<td>
	&nbsp;<a href="../tasks/?action=ShowTask&entrykey=#urlencodedformat(q_select_overdue.entrykey)#">#shortenstring(q_select_overdue.title, 20)#</a>
	</td>
	<td>
	<cfif isDate(q_select_overdue.dt_due) IS TRUE>
	#DateDiff("d", q_select_overdue.dt_due, now())#&nbsp;
	</cfif>
	</td>
  </tr>
  </cfoutput>
  
  <!---<cfif q_select_overdue.recordcount GT 15>
  	<tr>
		<td>
		&nbsp;<a href="../tasks/"><b><cfoutput>#(q_select_overdue.recordcount - 20)#</cfoutput> <cfoutput>#GetLangVal('weitere')#</cfoutput> ...</b></a>
		</td>
	</tr>
  </cfif>--->
  </cfif>
  <!---<tr>
    <td class="bb bt" colspan="2">
	&nbsp;<a href="../tasks/index.cfm?action=NewTask&returnurl=<cfoutput>#urlencodedformat(cgi.SCRIPT_NAME&"?"&cgi.QUERY_STRING)#</cfoutput>"><img src="/images/icon/notizen.gif" width="12" height="12" vspace="2" hspace="2" align="absmiddle" border="0"> <cfoutput>#GetLangVal('scr_ph_top_new')#</cfoutput> ...</a>
	</td>
  </tr>--->
</table>
