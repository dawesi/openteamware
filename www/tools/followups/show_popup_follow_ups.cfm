<cfinclude template="/login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">


<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">
<cfparam name="url.title" type="string" default="">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">




<cfinvoke component="#request.a_str_component_followups#" method="GetFollowUps" returnvariable="q_select_follow_ups">
	<cfinvokeargument name="servicekey" value="#url.servicekey#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="objectkeys" value="#url.objectkey#">				
</cfinvoke>

<html>
<head>
	<cfinclude template="../../style_sheet.cfm">
	<cfinclude template="../../render/inc_html_header.cfm">
	<title><cfoutput>#htmleditformat(url.title)#</cfoutput></title>
</head>

<body>

<div class="mischeader" style="padding:10px;font-weight:bold; ">
	<cfoutput>#GetLangVal('cm_wd_object')#</cfoutput> "<cfoutput>#htmleditformat(url.title)#</cfoutput>"
</div>

<table border="1" cellspacing="0" cellpadding="6" bordercolor="silver" style="border-collapse:collapse; " width="100%">
  <tr class="mischeader">
    <td>
		<cfoutput>#GetLangVal('tsk_wd_done ')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('tsk_wd_due')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_type')#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal('cm_wd_created')#</cfoutput>
	</td>
	<td>
		<cfoutput>#GetLangVal('cm_wd_comment')#</cfoutput>
	</td>
  </tr>
  <cfoutput query="q_select_follow_ups">
  <tr>
    <td align="center">
		#YesNoFormat(q_select_follow_ups.done)#
	</td>
    <td>
		<cfif IsDate(q_select_follow_ups.dt_due)>
			#LsDateFormat(q_select_follow_ups.dt_due, request.stUserSettings.DEFAULT_DATEFORMAT)# #TimeFormat(q_select_follow_ups.dt_due, request.stUserSettings.default_timeformat)#
		</cfif>
	</td>
	<td>
		<cfswitch expression="#q_select_follow_ups.followuptype#">
			<cfcase value="1">
				#GetLangVal('cm_wd_email')#
			</cfcase>
			<cfcase value="2">
				#GetLangVal('crm_wd_follow_up_call')#
			</cfcase>
			<cfdefaultcase>
				#GetLangVal('crm_wd_follow_up')#
			</cfdefaultcase>
		</cfswitch>
	</td>
    <td>
		#LsDateFormat(q_select_follow_ups.dt_created, request.stUserSettings.DEFAULT_DATEFORMAT)#
	</td>
    <td>
		#htmleditformat(q_select_follow_ups.comment)#
	</td>
  </tr>
  </cfoutput>
</table>

<cfset a_str_followup_link = 'show_popup_create.cfm?objectkey='&url.objectkey&'&servicekey='&url.servicekey&'&title='&urlencodedformat(url.title)>

<br>
&nbsp;&nbsp;&raquo; <a href="<cfoutput>#a_str_followup_link#</cfoutput>"><cfoutput>#GetLangVal('crm_ph_create_new_followup_item')#</cfoutput> ...</a>
</body>
</html>
