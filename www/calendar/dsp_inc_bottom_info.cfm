<!--- //

	Module:		Calendar
	Action:		DisplayBottomShortInfo
	Description:Display short calendar information
	
// --->

<!--- get utc now --->
<cfset a_dt_start = CreateDate(Year(Now()), month(Now()), day(Now())) />
<cfset a_dt_start = GetUTCTimeFromUserTime(a_dt_start) />

<cfset a_struct_cal_filter = StructNew() />

<!--- friday, add one more day ... --->
<cfif DayOfWeek(Now()) IS 6>
	<cfset a_dt_end = DateAdd('d', 4, a_dt_start) />
<cfelse>
	<cfset a_dt_end = DateAdd('d', 3, a_dt_start) />
</cfif>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#a_dt_end#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadeventsofinheritedworkgroups" value="false">
	<cfinvokeargument name="filter" value="#a_struct_cal_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events />
		
<cfset a_dt_cur_display = DateFormat(DateAdd('d', -1, Now()), 'ddmmyyyy')>

<img src="/images/si/calendar.png" class="si_img" />

<cfif q_select_events.recordcount IS 0>
	<font class="addinfotext"><cfoutput>#GetLangVal('cal_ph_outlook_no_events_found')#</cfoutput></font>
	<cfexit method="exittemplate">
</cfif>

<cfoutput query="q_select_events">

<cfset a_tmp_cur_display = DateFormat(q_select_events.date_start, 'ddmmyyyy')>
<cfset a_int_diff_hours = DateDiff('h', q_select_events.date_start, q_select_events.date_end)>
<cfset a_int_diff_minutes = DateDiff('n', q_select_events.date_start, q_select_events.date_end)>			
<cfset a_dt_start = ParseDateTime(q_select_events.date_start)> 		

<cfif a_tmp_cur_display NEQ a_dt_cur_display>
	<b>#ucase(LSDateFormat(q_select_events.date_start, 'ddd'))#, #ucase(LSDateFormat(q_select_events.date_start, 'dd.mm.'))#</b>
	<cfset a_dt_cur_display = a_tmp_cur_display>
</cfif>

<span style="white-space:nowrap; ">
#TimeFormat(q_select_events.date_start, 'HH:mm')#

<a target="framecontent" href="/calendar/index.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_events.entrykey)#">#htmleditformat(shortenstring(checkzerostring(q_select_events.title), 35))#</a>

<cfif q_select_events.currentrow neq q_select_events.recordcount>
&nbsp;/&nbsp;
</cfif>

</span>
</cfoutput>

