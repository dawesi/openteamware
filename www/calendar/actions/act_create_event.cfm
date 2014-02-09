<!--- //
	Module:            calendar
	Action:            createEvent
	Description:       Creates new event
// --->


<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="default.cfm?action=ShowNewEvent">
</cfif>

<cfparam name="form.frmtitle" type="string" default="">
<cfset form.frmtitle = CheckZeroString(Trim(form.frmtitle))>

<cfparam name="form.frmuserkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfif Len(form.frmuserkey) IS 0>
	<cfset form.frmuserkey = request.stSecurityContext.myuserkey>	
</cfif>

<cfif CompareNoCase(request.stSecurityContext.myuserkey, form.frmuserkey) IS 0>
	<cfset a_str_secretarykey = ''>
<cfelse>
	<cfset a_str_secretarykey = request.stSecurityContext.myuserkey>
</cfif>

<cfparam name="form.frmshowaspopup" type="numeric" default="0">
<cfparam name="form.frmdescription" type="string" default="">
<cfparam name="form.frmcategories" type="string" default="">
<cfparam name="form.frmshowas" type="numeric" default="0">
<cfparam name="form.frmcolor" type="string" default="">
<cfparam name="form.frmprivateevent" type="numeric" default="0">
<cfparam name="form.frmdurationtype" type="string" default="simple">
<cfparam name="form.frmdurationsimple" type="numeric" default="45">
<cfparam name="form.frmwholedayevent" type="numeric" default="0">

<!--- sms remind ... --->
<cfparam name="form.frmcbremindersms" type="numeric" default="0">
<cfparam name="form.frmsmsremindminutes" type="numeric" default="15">

<!--- email remind ... --->
<cfparam name="form.frmcbreminderemail" type="numeric" default="0">
<cfparam name="form.frmreminderemailaddress" type="string" default="">
<cfparam name="form.frmemailremindminutes" type="numeric" default="30">

<cfif Len(form.frmreminderemailaddress) IS 0>
	<cfset form.frmreminderemailaddress = request.stSecurityContext.myusername />
</cfif>

<cfparam name="form.frmcbreminderreminder" type="numeric" default="0">
<cfparam name="form.frmvirtualcalendarkey" type="string" default="">

<!--- recurring ... --->
<cfparam name="form.frmrepeat_type" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day1" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day2" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day3" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day4" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day5" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day6" type="numeric" default="0">
<cfparam name="form.frmcal_repeat_daily_day7" type="numeric" default="0">

<cfparam name="form.frmrepeat_use_end" type="numeric" default="0">

<cfparam name="form.frm_dt_start_hour" type="numeric" default="0">
<cfparam name="form.frm_dt_start_minute" type="numeric" default="0">
<cfparam name="form.frm_dt_end_hour" type="numeric" default="0">
<cfparam name="form.frm_dt_end_minute" type="numeric" default="0">

<!--- create start date/time and convert to UTC --->
<cfset a_dt_start_date = LsParseDateTime(form.frm_dt_start)>
<cfset a_dt_start = CreateDateTime(Year(a_dt_start_date), Month(a_dt_start_date), Day(a_dt_start_date), form.frm_dt_start_hour, form.frm_dt_start_minute, 0)>
<cfset a_dt_start_tmp = a_dt_start>
<cfset a_dt_start = GetUTCTime(a_dt_start)>

<cfif form.frmdurationtype IS 'simple'>
	<!--- add x minutes to the start time ... --->
	<cfset a_dt_end = DateAdd('n', form.frmdurationsimple, a_dt_start)>
	<cfset a_dt_end_tmp = DateAdd('n', form.frmdurationsimple, a_dt_start_tmp)>
<cfelseif IsDefined('form.frm_dt_end')>
	<!--- create the full end date ... --->
	<cfset a_dt_end_date = LsParseDateTime(form.frm_dt_end)>
	<cfset a_dt_end = CreateDateTime(Year(a_dt_end_date), Month(a_dt_end_date), Day(a_dt_end_date), form.frm_dt_end_hour, form.frm_dt_end_minute, 0)>
	
	<cfset a_dt_end_tmp = a_dt_end>
	
	<cfset a_dt_end = GetUTCTime(a_dt_end)>
	
<cfelse>
	<!--- form element might be lost - create standard end ... --->
	<cfset a_dt_end = DateAdd('n', 60, a_dt_start)>
</cfif>

<cfif a_dt_end LTE a_dt_start>
	<!--- could just be an error --->
	<cfset a_dt_end = DateAdd('h', 1, a_dt_start)>
</cfif>

<cfif form.frmwholedayevent IS 1>
	<!--- whole day event ... --->
	<cfset a_dt_start = CreateDateTime(Year(a_dt_start_date), Month(a_dt_start_date), Day(a_dt_start_date), 0, 0, 0)>
	<cfset a_dt_start = GetUTCTime(a_dt_start)>
	<cfset a_dt_end = DateAdd('d', 1, a_dt_start)>
</cfif>

<cfif CompareNoCase(request.stSecurityContext.myuserkey, form.frmuserkey) NEQ 0>
<!--- load username ...--->
<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
	<cfinvokeargument name="entrykey" value="#form.frmuserkey#">
</cfinvoke>

<!---//
    send mail notification ... 
    //--->
<cfmail from="#request.stSecurityContext.myusername#" to="#a_str_username#" subject="#GetLangVal('cal_ph_subject_new_event_entered')#">
#GetLangVal('cal_ph_notification_mail_new_event_entered')#

#GetLangVal('cal_wd_start')#: #DateFormat(a_dt_start_tmp, 'dd.mm.yy')# #TimeFormat(a_dt_start_tmp, 'HH:mm')#
#GetLangVal('cal_wd_end')#: #DateFormat(a_dt_end_tmp, 'dd.mm.yy')# #TimeFormat(a_dt_end_tmp, 'HH:mm')#
#GetLangVal('cal_wd_location')#: #form.frmlocation#
#GetLangVal('cal_wd_description')#: #form.frmdescription#

#GetLangVal('cal_ph_more_details')#:
https://www.openTeamWare.com/rd/c/e/?#urlencodedformat(form.frmentrykey)#
</cfmail>
</cfif>

<!---//
	create event ...
	// --->
<cfinvoke component="#application.components.cmp_calendar#" method="CreateEvent" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="categories" value="#form.frmcategories#">
	<cfinvokeargument name="color" value="#form.frmcolor#">
	<cfinvokeargument name="showtimeas" value="#form.frmshowas#">
	<cfinvokeargument name="priority" value="2">
	<cfinvokeargument name="location" value="#form.frmlocation#">
	<cfinvokeargument name="privateevent" value="#form.frmprivateevent#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="secretarykey" value="#a_str_secretarykey#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="date_start" value="#a_dt_start#">
	<cfinvokeargument name="date_end" value="#a_dt_end#">
	<cfinvokeargument name="virtualcalendarkey" value="#form.frmvirtualcalendarkey#">

	<!--- repeating type ... --->
	<cfinvokeargument name="repeat_type" value="#form.frmrepeat_type#">
	<cfinvokeargument name="repeat_day_1" value="#form.frmcal_repeat_daily_day1#">
	<cfinvokeargument name="repeat_day_2" value="#form.frmcal_repeat_daily_day2#">
	<cfinvokeargument name="repeat_day_3" value="#form.frmcal_repeat_daily_day3#">
	<cfinvokeargument name="repeat_day_4" value="#form.frmcal_repeat_daily_day4#">
	<cfinvokeargument name="repeat_day_5" value="#form.frmcal_repeat_daily_day5#">
	<cfinvokeargument name="repeat_day_6" value="#form.frmcal_repeat_daily_day6#">
	<cfinvokeargument name="repeat_day_7" value="#form.frmcal_repeat_daily_day7#">
	
	<cfif (form.frmrepeat_use_end IS 1) AND (isDate(form.frm_dt_repeat_end))>
		<!--- send end of recurrence ... --->
		<cfinvokeargument name="repeat_until" value="#LsParseDateTime(form.frm_dt_repeat_end)#">
	</cfif>
	
	<cfinvokeargument name="repeat_day" value="#Day(a_dt_start)#">
	<cfinvokeargument name="repeat_month" value="#Month(a_dt_start)#">
	<cfinvokeargument name="repeat_weekday" value="#DayofWeek(a_dt_start)#">
	<cfinvokeargument name="repeat_weekdays" value="">
</cfinvoke>

<!---//
	send invitations to meetingmembers...
	// --->
<cfinvoke component="#application.components.cmp_calendar#" method="GetMeetingMembers" returnvariable="q_select_meeting_members">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
</cfinvoke>

<cfloop query="q_select_meeting_members">
	<cfif q_select_meeting_members.sendinvitation IS 1>
		<cfinvoke component="#application.components.cmp_calendar#" method="SendInvitation" returnvariable="a_bol_return">
			<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
			<cfinvokeargument name="type" value="#q_select_meeting_members.type#">
			<cfinvokeargument name="parameter" value="#q_select_meeting_members.parameter#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		</cfinvoke>
	</cfif>
</cfloop>

<!---//
	create reminders ...
	// --->
<cfif form.frmcbreminderemail is 1>
	<!--- create email reminder --->
	<cfset a_dt_remind = DateAdd('n', -form.frmemailremindminutes, a_dt_start)>
	
	<cfinvoke component="#application.components.cmp_calendar#" method="CreateReminder" returnvariable="a_bol_return">
		<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="type" value="0">
		<cfinvokeargument name="dt_remind" value="#a_dt_remind#">
		<cfinvokeargument name="emailaddress" value="#form.frmreminderemailaddress#">
		<cfinvokeargument name="eventtitle" value="#form.frmtitle#">
		<cfinvokeargument name="eventstart" value="#GetLocalTime(a_dt_start)#">		
	</cfinvoke>
</cfif>

<cfif form.frmcbremindersms is 1>
	<!--- create sms reminder --->
	<cfset a_dt_remind = DateAdd('n', -form.frmsmsremindminutes, a_dt_start)>
	
	<cfinvoke component="#application.components.cmp_calendar#" method="CreateReminder" returnvariable="a_bol_return">
		<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="type" value="1">
		<cfinvokeargument name="dt_remind" value="#a_dt_remind#">
		<cfinvokeargument name="eventtitle" value="#form.frmtitle#">
		<cfinvokeargument name="eventstart" value="#GetLocalTime(a_dt_start)#">
	</cfinvoke>
</cfif>

<cfif form.frmcbreminderreminder is 1>
	<!--- create email reminder --->
	<cfset a_dt_remind = DateAdd('n', -form.frmreminderremindminutes, a_dt_start)>
	
	<cfinvoke component="#application.components.cmp_calendar#" method="CreateReminder" returnvariable="a_bol_return">
		<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="type" value="2">
		<cfinvokeargument name="dt_remind" value="#a_dt_remind#">
		<cfinvokeargument name="eventtitle" value="#form.frmtitle#">
		<cfinvokeargument name="eventstart" value="#GetLocalTime(a_dt_start)#">		
	</cfinvoke>
</cfif>

<cfif form.frmshowaspopup IS 1>
	<cflocation addtoken="no" url="show_popup_created.cfm?entrykey=#form.frmentrykey#">
	<cfabort>
</cfif>

<cfif StructKeyExists(form, 'frmredirect') is TRUE>
	<cfif FindNoCase('/calendar/', form.frmredirect) GT 0>
		<cfset a_str_redirect = form.frmredirect>	
	<cfelse>
		<!--- goto cal start page ... --->
		<cflocation addtoken="no" url="default.cfm">
	</cfif>

<cfelse>
	<cfset a_str_redirect = 'default.cfm'>
</cfif>


<cflocation addtoken="no" url="#a_str_redirect#">


