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

<cfset a_int_shortenstring = 50>

<cfsavecontent variable="sReturn">
<cfset arguments.filter.display_border = false>

<cfif arguments.filter.display_border>
	<div style="padding:0px;padding-top:8px;padding-bottom:8px;margin-top:10px;margin-bottom:10px;border-top:orange solid 2px;border-bottom:orange solid 2px;">
</cfif>

<table class="table table-hover">
  <tr class="tbl_overview_header">		<td width="50%">
		<cfoutput>#GetLangVal('crm_wd_follow_ups')# (#q_select_follow_ups.recordcount#)</cfoutput></td>
		<td width="25%">
			<cfoutput>#GetLangVal('task_ph_assignedto')#</cfoutput>
			/
			<cfoutput>#GetLangVal('tsk_ph_due_to')#</cfoutput>
		</td>
		<cfif arguments.managemode>
		<td width="25%">

			<cfoutput>#GetLangVal('cm_wd_Action')#</cfoutput>

		</td>
		</cfif>
  </tr>
  <cfoutput query="q_select_follow_ups">
  <tr>
  	<td <cfif q_select_follow_ups.done GT 0>style="text-decoration:line-through;"</cfif>>

		<cfswitch expression="#q_select_follow_ups.followuptype#">
			<cfcase value="0"><span class="glyphicon glyphicon-flag"></span></cfcase>
			<cfcase value="1"><img align="absmiddle" src="/images/si/email.png" alt="" class="si_img" /></cfcase>
			<cfcase value="2"><span class="glyphicon glyphicon-earphone"></span></cfcase>
			<cfdefaultcase><span class="glyphicon glyphicon-flag"></span></cfdefaultcase>
		</cfswitch>

		<cfif Len(q_select_follow_ups.comment) GT 0>
			#ReplaceNoCase(htmleditformat(trim( q_select_follow_ups.comment )), chr(10), ' ... ', 'ALL')#
		</cfif>

	</td>
	<td>

		<a href="/workgroups/?action=ShowUser&entrykey=#q_select_follow_ups.userkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_follow_ups.userkey)#</a>

		/

		#LsDateFormat(q_select_follow_ups.dt_due, arguments.usersettings.default_dateformat)#<cfif Hour(q_select_follow_ups.dt_due) NEQ 0> #TimeFormat(q_select_follow_ups.dt_due, arguments.usersettings.default_timeformat)#</cfif>

		<cfif q_select_follow_ups.done IS 0 AND q_select_follow_ups.dt_due LT Now()>
			<span class="glyphicon glyphicon-exclamation-sign"></span>
		</cfif>

	</td>
	<cfif arguments.managemode>
	<td>

			<cfset sReturn_url = cgi.SCRIPT_NAME&'?'&cgi.QUERY_STRING>
			<button type="button" class="btn btn-success" onclick="SetFollowUpDone('#jsstringformat(q_select_follow_ups.entrykey)#', '#JsStringFormat(q_select_follow_ups.objectkey)#');CloseSimpleModalDialog();location.reload();return false;">
				<span class="glyphicon glyphicon-ok"></span>
				#GetLangVal('tsk_ph_set_done')#
			</button>

			<br />

			<a href="/crm/?action=EditFollowup&entrykey=#q_select_follow_ups.entrykey#&returnurl=#urlencodedformat(sReturn_url)#"><span class="glyphicon glyphicon-pencil"></span> #MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a>

			<a href="##" onClick="ShowSimpleConfirmationDialog('/crm/index.cfm?action=DeleteFollowups&entrykeys=#q_select_follow_ups.entrykey#');"><span class="glyphicon glyphicon-trash"></span> #MakeFirstCharUCase(GetLangVal('cm_wd_delete'))#</a>

	</td>
	</cfif>
  </tr>
  </cfoutput>
 </table>

<cfif arguments.filter.display_border>
	</div>
</cfif>
</cfsavecontent>

<cfset stReturn.a_str_content = sReturn />

