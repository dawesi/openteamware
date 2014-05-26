<!--- //

	Module:		CRM
	Function	GetItemActivitiesAndData
	Description: 
	

// --->
	
<cfset arguments.contactkey = arguments.contactkeys />
	
<cfinclude template="../queries/activities/q_select_tasks_associated_with_contact.cfm">

<cfset stReturn.recordcount = q_select_tasks_associated_with_contact.recordcount />

<cfif q_select_tasks_associated_with_contact.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- device specific ... on PDA just use / as separator --->
<cfif arguments.usersettings.device.type IS 'pda'>
	<cfset a_str_td_break = ' / '>
	<cfset a_int_shortenstring = 20>
<cfelse>
	<cfset a_str_td_break = '</td><td>'>
	<cfset a_int_shortenstring = 50>
</cfif>

<cfsavecontent variable="as">

<cfquery name="q_select_tasks" datasource="#request.a_str_db_tools#">
SELECT
	actualwork,userkey,categories,dt_created,dt_due,assignedtouserkeys,userkey,
	dt_done,dt_start,entrykey,notice,mileage,percentdone,status,priority,title
FROM
	tasks
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#valuelist(q_select_tasks_associated_with_contact.taskkey)#">)
	
	<cfif StructCount(arguments.filter) GT 0>

	<cfif StructKeyExists(arguments.filter, 'exclude_status')>
		AND NOT (status = 0)
	</cfif>

	</cfif>
ORDER BY
	dt_due DESC
;
</cfquery>

<cfif q_select_tasks.recordcount GT 0>

<cfset a_cmp_users = application.components.cmp_user>

<table class="table_overview" cellspacing="0">
  <tr class="tbl_overview_header">
	<cfif arguments.usersettings.device.type IS 'pda'>
	<td>
		<cfoutput>#GetLangVal('cm_wd_tasks')# (#q_select_tasks.recordcount#)</cfoutput></td>
		/
		<cfoutput>#GetLangVal('task_ph_assignedto')#</cfoutput>
		/
		<cfoutput>#GetLangVal('tsk_ph_due_to')#</cfoutput>
	</td>
	<cfelse>
	<td width="50%">
		<cfoutput>#GetLangVal('cm_wd_tasks')# (#q_select_tasks.recordcount#)</cfoutput></td>
	<td width="25%">
		<cfoutput>#GetLangVal('task_ph_assignedto')#</cfoutput>
	</td>
	<td>
		<cfoutput>#GetLangVal('tsk_ph_due_to')#</cfoutput>
	</td>
	</cfif>
  </tr>
  <cfoutput query="q_select_tasks">
  <tr <cfif q_select_tasks.status GT 0 AND IsDate(q_select_tasks.dt_due) AND q_select_tasks.dt_due LTE Now()>style="background-color:##FCE4BA"</cfif>>
	<td>
		<!---<img src="/images/tasks/task_status_#q_select_tasks.status#.png" align="absmiddle">--->
		<span style="background-color:##3333CC;color:white:padding:3px;font-weight:bold;color:white;">&nbsp;#ucase(GetLangVal('cm_wd_task_one_char'))#&nbsp;</span> <a href="/tasks/?action=ShowTask&entrykey=#q_select_tasks.entrykey#&source=crm" <cfif q_select_tasks.status is 0>class="addinfotext" style="text-decoration:line-through;"</cfif> <cfif arguments.managemode>target="_blank"</cfif>>#htmleditformat(ShortenString(CheckZerostring(q_select_tasks.title), a_int_shortenstring))#</a>
		
		<cfif val(q_select_tasks.percentdone) GT 0>
			(#q_select_tasks.percentdone# %)
		</cfif>
		
	#a_str_td_break#
	
		<!--- % done ... --->
		<!---<span title="#q_select_tasks.percentdone# %" style="width:50px;height:14px;padding:0px;margin:0px;text-align:left;" class="b_all"><div style="height:14px;padding:0px;margin:0px;background-color:<cfif IsDate(q_select_tasks.dt_due) AND (q_select_tasks.dt_due LTE Now())>red<cfelse>silver</cfif>;width:#(q_select_tasks.percentdone/2)#px;"><img src="/images/space_1_1.gif"></span></span>--->
		
		<cfif (Len(q_select_tasks.assignedtouserkeys) IS 0)>
			<cfset tmp = QuerySetCell(q_select_tasks, 'assignedtouserkeys', arguments.securitycontext.myuserkey)>
		</cfif>
		<cfloop list="#q_select_tasks.assignedtouserkeys#" index="a_str_userkey">
			<a href="/workgroups/index.cfm?action=showuser&userkey=#a_str_userkey#">#htmleditformat(a_cmp_users.GetFullNameByentrykey(a_str_userkey))#</a>&nbsp;
		</cfloop>			
		
	#a_str_td_break#
	
		<cfif IsDate(q_select_tasks.dt_due)>
			#LsDateFormat(q_select_tasks.dt_due, 'dd.mm.yy')#
		<cfelse>
			&nbsp;
		</cfif>		
		
		<cfif arguments.managemode>
			<br/>
			
			<cfset sReturn_url = cgi.SCRIPT_NAME&'?'&cgi.QUERY_STRING>
			<a href="/tasks/act_set_new_status.cfm?entrykey=#q_select_tasks.entrykey#&status=0"><img src="/images/set_status_done.gif" align="absmiddle" border="0" width="16" height="16" vspace="2" hspace="2">#GetLangVal('tsk_ph_set_done')#</a>
			<br/>
			<a target="_blank" href="/tasks/?action=edittask&entrykey=#q_select_tasks.entrykey#">#MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a>
			
			<a target="_blank" onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="/tasks/?action=deletetask&entrykey=#q_select_tasks.entrykey#">#MakeFirstCharUCase(GetLangVal('cm_wd_delete'))#</a>
			
		</cfif>
	</td>
  </tr>
   </cfoutput>
 
</table>
</cfif><!--- if rc gt 0 --->
</cfsavecontent>

<cfset sReturn = as />

<cfset stReturn.a_str_content = sReturn />


