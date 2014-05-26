<!--- //

	Module:		CRM
	Function:	GetItemActivitiesAndData
	Description:Display assigned follow up items
	

// --->

<!--- display border if neccessary ... --->
<cfparam name="arguments.filter.display_border" type="boolean" default="true">

<cfinvoke component="#application.components.cmp_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="objectkeys" value="#arguments.contactkeys#">				
</cfinvoke>		

<cfif StructKeyExists(arguments.filter, 'statusonly')>
	<cfquery name="q_select_follow_ups" dbtype="query">
	SELECT
		*
	FROM
		q_select_follow_ups
	WHERE
		done = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.filter.statusonly)#">
	;
	</cfquery>
</cfif>

<cfset stReturn.recordcount = q_select_follow_ups.recordcount />

<cfif q_select_follow_ups.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- device specific ... on PDA just use / as separator --->
<cfif arguments.usersettings.device.type IS 'pda'>
	<cfset a_str_td_break = ' / '>
	<cfset a_int_shortenstring = 20>
<cfelse>
	<cfset a_str_td_break = '</td><td valign="top">'>
	<cfset a_int_shortenstring = 50>
</cfif>

<cfsavecontent variable="sReturn">
<cfset arguments.filter.display_border = false>

<cfif arguments.filter.display_border>
	<div style="padding:0px;padding-top:8px;padding-bottom:8px;margin-top:10px;margin-bottom:10px;border-top:orange solid 2px;border-bottom:orange solid 2px;">
</cfif>

<table class="table_overview">
  <tr class="tbl_overview_header">
	<cfif arguments.usersettings.device.type IS 'pda'>

		<td>
			<cfoutput>#GetLangVal('crm_wd_follow_ups')# (#q_select_follow_ups.recordcount#)</cfoutput>
			/
			<cfoutput>#GetLangVal('task_ph_assignedto')#</cfoutput>
			/
			<cfoutput>#GetLangVal('tsk_ph_due_to')#</cfoutput>
			<cfif arguments.managemode>
				/
				<cfoutput>#GetLangVal('cm_wd_Action')#</cfoutput>
			</cfif>
		</td>
		
	<cfelse>
		<td width="50%">
			<cfoutput>#GetLangVal('crm_wd_follow_ups')# (#q_select_follow_ups.recordcount#)</cfoutput></td>
		<td width="25%">
			<cfoutput>#GetLangVal('task_ph_assignedto')#</cfoutput>
		</td>
		<td width="25%">
			<cfoutput>#GetLangVal('tsk_ph_due_to')#</cfoutput>
			<cfif arguments.managemode>
				/
				<cfoutput>#GetLangVal('cm_wd_Action')#</cfoutput>
			</cfif>
		</td>
	</cfif>
  </tr>
  <cfoutput query="q_select_follow_ups">
  <tr>
  	<td <cfif q_select_follow_ups.done GT 0>style="text-decoration:line-through;"</cfif>>
		
		<a href="/crm/?action=ShowFollowUp&entrykey=#q_select_follow_ups.entrykey#">
		<cfswitch expression="#q_select_follow_ups.followuptype#">
			<cfcase value="0"><img align="absmiddle" src="/images/si/flag_red.png" alt="" class="si_img" />#GetLangVal('crm_wd_follow_up')#</cfcase>
			<cfcase value="1"><img align="absmiddle" src="/images/si/email.png" alt="" class="si_img" />#GetLangVal('cm_wd_email')#</cfcase>
			<cfcase value="2"><img align="absmiddle" src="/images/si/telephone.png" alt="" class="si_img" />#GetLangVal('crm_wd_follow_up_call')#</cfcase>
			<cfdefaultcase><img align="absmiddle" src="/images/si/flag_red.png" alt="" class="si_img" />#GetLangVal('crm_wd_follow_up')#</cfdefaultcase>
		</cfswitch>
		
		<cfif Len(q_select_follow_ups.comment) GT 0>
			- #ReplaceNoCase(htmleditformat(trim(shortenstring(q_select_follow_ups.comment, 100))), chr(10), ' ... ', 'ALL')#
		</cfif>
		</a>
	
	#a_str_td_break#
	
		<a href="/workgroups/?action=ShowUser&entrykey=#q_select_follow_ups.userkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_follow_ups.userkey)#</a>
	
	#a_str_td_break#
	
		#LsDateFormat(q_select_follow_ups.dt_due, arguments.usersettings.default_dateformat)#<cfif Hour(q_select_follow_ups.dt_due) NEQ 0> #TimeFormat(q_select_follow_ups.dt_due, arguments.usersettings.default_timeformat)#</cfif>					
		
		<cfif q_select_follow_ups.done IS 0 AND q_select_follow_ups.dt_due LT Now()>
			<img src="/images/si/exclamation.png" class="si_img" />
		</cfif>
		
		<cfif arguments.managemode>
			
			<br/>
			<cfset sReturn_url = cgi.SCRIPT_NAME&'?'&cgi.QUERY_STRING>
			<a onclick="SetFollowUpDone('#jsstringformat(q_select_follow_ups.entrykey)#', '#JsStringFormat(q_select_follow_ups.objectkey)#');CloseSimpleModalDialog();location.reload();return false;" href="##"><img src="/images/si/accept.png" class="si_img" />#GetLangVal('tsk_ph_set_done')#</a>
			<br/>
			<a href="/crm/?action=EditFollowup&entrykey=#q_select_follow_ups.entrykey#&returnurl=#urlencodedformat(sReturn_url)#"><img src="/images/si/pencil.png" class="si_img" /> #MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a>
			
			<a href="##" onClick="ShowSimpleConfirmationDialog('/crm/index.cfm?action=DeleteFollowups&entrykeys=#q_select_follow_ups.entrykey#');"><img src="/images/si/delete.png" class="si_img" /> #MakeFirstCharUCase(GetLangVal('cm_wd_delete'))#</a>
		</cfif>
	</td>
  </tr>  
  </cfoutput>
 </table>

<cfif arguments.filter.display_border>
	</div>
</cfif>
</cfsavecontent>

<cfif q_select_follow_ups.recordcount GT 0>
	<cfset a_str_info_cal = '<img src="/images/si/flag_red.png" class="si_img" /> #GetLangValJS('crm_wd_follow_ups')# (#q_select_follow_ups.recordcount#)' />
	
	<cfset tmp = AddJSToExecuteAfterPageLoad('AddCRMTopInfoString(''' & a_str_info_cal & ''')', '') />
</cfif>

<cfset stReturn.a_str_content = sReturn />

