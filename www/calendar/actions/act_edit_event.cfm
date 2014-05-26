<!--- //
	Module:            calendar
	Action:            ShowEditEvent
	Description:       Updates the event, sends inivitations to selected meeting members (+ publish temporary meeting members)
// --->

<cfset a_cmp_calendar = application.components.cmp_calendar />

<cfparam name="form.frmwholedayevent" type="numeric" default="0">

<cfif (form.frmwholedayevent IS 0) AND NOT StructKeyExists(form, 'FRM_DT_START_HOUR')>
	<br><br>
	<cfoutput>#GetLangVal('cal_ph_error_starttimemissing')#</cfoutput>
	<br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfparam name="form.frmprivateevent" type="numeric" default="0">
<cfparam name="form.frmvirtualcalendarkey" type="string" default="">

<cfparam name="form.frmcbremindersms" type="numeric" default="0">
<cfparam name="form.frmcbreminderreminder" type="numeric" default="0">
<cfparam name="form.frmcbreminderemail" type="numeric" default="0">

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
<cfparam name="form.frm_dt_repeat_end" type="string" default="">

<!--- set start/end --->

<cfif form.frmwholedayevent IS 1>
	<!--- whole day event ... --->
	
	<cfset a_dt_start_date = LsParseDateTime(form.frm_dt_start)>
	<cfset a_dt_start = CreateDateTime(Year(a_dt_start_date), Month(a_dt_start_date), Day(a_dt_start_date), 0, 0, 0)>
	<cfset a_dt_start = GetUTCTime(a_dt_start)>
	<cfset a_dt_end = DateAdd('d', 1, a_dt_start)>
	
	<cfset a_dt_start_tmp = a_dt_start>
	
<cfelse>

	<cfset a_dt_start_date = LsParseDateTime(form.frm_dt_start)>
	<cfset a_dt_start = CreateDateTime(Year(a_dt_start_date), Month(a_dt_start_date), Day(a_dt_start_date), form.frm_dt_start_hour, form.frm_dt_start_minute, 0)>
	
	<cfset a_dt_start_tmp = a_dt_start>
	<cfset a_dt_start = GetUTCTime(a_dt_start)>

	<cfif form.frmdurationtype IS 'simple'>
		<!--- add x minutes to the start time ... --->
		<cfset a_dt_end = DateAdd('n', form.frmdurationsimple, a_dt_start)>
	<cfelse>
		<!--- create the full end date ... --->
		<cfset a_dt_end_date = LsParseDateTime(form.frm_dt_end)>
		<cfset a_dt_end = CreateDateTime(Year(a_dt_end_date), Month(a_dt_end_date), Day(a_dt_end_date), form.frm_dt_end_hour, form.frm_dt_end_minute, 0)>
		<cfset a_dt_end = GetUTCTime(a_dt_end)>
	</cfif>

</cfif>	



<cfset stUpdate = StructNew()>
<cfset stUpdate.entrykey = form.frmentrykey>
<cfset stUpdate.title = form.frmtitle>
<cfset stUpdate.description = form.frmdescription>
<cfset stUpdate.location = form.frmlocation>
<cfset stUpdate.color = form.frmcolor>
<cfset stUpdate.showtimeas = form.frmshowas>
<cfset stUpdate.categories = form.frmcategories>
<cfset stUpdate.privateevent = form.frmprivateevent>
<cfset stUpdate.date_start = a_dt_start>
<cfset stUpdate.date_end = a_dt_end>
<cfset stUpdate.virtualcalendarkey = form.frmvirtualcalendarkey>

<cfset stUpdate.repeat_type = form.frmrepeat_type>

<cfif (form.frmrepeat_use_end IS 1) AND IsDate(form.frm_dt_repeat_end)>
	<cfset stUpdate.repeat_until = LSParseDateTime(form.frm_dt_repeat_end)>
<cfelse>
	<cfset stUpdate.repeat_until = ''>
</cfif>

<cfset stUpdate.repeat_day_1 = form.frmcal_repeat_daily_day1>
<cfset stUpdate.repeat_day_2 = form.frmcal_repeat_daily_day2>
<cfset stUpdate.repeat_day_3 = form.frmcal_repeat_daily_day3>
<cfset stUpdate.repeat_day_4 = form.frmcal_repeat_daily_day4>
<cfset stUpdate.repeat_day_5 = form.frmcal_repeat_daily_day5>
<cfset stUpdate.repeat_day_6 = form.frmcal_repeat_daily_day6>
<cfset stUpdate.repeat_day_7 = form.frmcal_repeat_daily_day7>

<!---//
     update event ... 
     // --->
<cfinvoke component="#a_cmp_calendar#" method="UpdateEvent" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="newvalues" value="#stUpdate#">
</cfinvoke>


<!---//
    reminders ... delete reminders of this user ... 
    // --->
<cfinvoke component="#a_cmp_calendar#" method="DeleteReminders" returnvariable="a_bol_return">
	<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
</cfinvoke>




<cfif form.frmcbreminderemail is 1>
	<!--- create email reminder --->
	<cfset a_dt_remind = DateAdd('n', -form.frmemailremindminutes, a_dt_start)>
	
	<cfinvoke component="#a_cmp_calendar#" method="CreateReminder" returnvariable="a_bol_return">
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
	
	<cfinvoke component="#a_cmp_calendar#" method="CreateReminder" returnvariable="a_bol_return">
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
	
	<cfinvoke component="#a_cmp_calendar#" method="CreateReminder" returnvariable="a_bol_return">
		<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="type" value="2">
		<cfinvokeargument name="dt_remind" value="#a_dt_remind#">
		<cfinvokeargument name="eventtitle" value="#form.frmtitle#">
		<cfinvokeargument name="eventstart" value="#GetLocalTime(a_dt_start)#">		
	</cfinvoke>
</cfif>


<cflocation addtoken="no" url="index.cfm?action=ShowEvent&entrykey=#form.frmentrykey#">

