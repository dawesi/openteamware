
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.start" type="string" default="">
<cfparam name="url.starthour" type="numeric" default="0">
<cfparam name="url.starthour" type="numeric" default="0">
<cfparam name="url.userkey" type="string" default="">

<cfif Len(url.userkey) IS 0>
	<cfset url.userkey = request.stSecurityContext.myuserkey>
</cfif>

<cfif Compare(request.stSecurityContext.myuserkey, url.userkey) NEQ 0>
	<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_userkey">
		<cfinvokeargument name="userkey" value="#url.userkey#">
	</cfinvoke>
	
	<cfset request.stSecurityContext = stReturn_userkey>
	
	<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stReturn_usersettings">
		<cfinvokeargument name="userkey" value="#url.userkey#">
	</cfinvoke>
	
	<cfset request.stUserSettings = stReturn_usersettings>
</cfif>	

<!--- the key of the current event --->
<cfparam name="url.eventkey" type="string" default="">

<cfif IsDate(url.start) IS FALSE>
	<cfabort>
</cfif>

<cfset a_dt_start = LSParseDateTime(url.start)>
<cfset a_dt_start = CreateDateTime(Year(a_dt_start), Month(a_dt_start), Day(a_dt_start), 0, 0, 0)>

<!--- calculate from local time (otherwise we would see another date --->
<cfset a_dt_start_display = CreateDateTime(Year(a_dt_start), Month(a_dt_start), Day(a_dt_start), url.starthour, url.startminute, 0)>
<cfset a_dt_start_display = DateAdd('h', -1, a_dt_start_display)>
<cfset a_int_dt_start_display = DateFormat(a_dt_start_display, 'yyyymmdd')&TimeFormat(a_dt_start_display, 'HHmm')>

<!--- end ... --->
<cfset a_dt_end_display = DateAdd('h', 3, a_dt_start_display)>
<cfset a_int_dt_end_display = DateFormat(a_dt_end_display, 'yyyymmdd')&TimeFormat(a_dt_end_display, 'HHmm')>


<cfset a_dt_start = GetUTCTime(a_dt_start)>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#DateAdd('d', 1, a_dt_start)#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>


<cfset q_select_events = stReturn.q_select_events>

<cfquery name="q_select_events" dbtype="query">
SELECT
	title,entrykey,date_start,date_end
FROM
	q_select_events
WHERE
	(int_start_num BETWEEN #Int(a_int_dt_start_display)# AND #Int(a_int_dt_end_display)#)
	<cfif Len(url.eventkey) GT 0>
	AND NOT
	(entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.eventkey#">)
	</cfif>
;
</cfquery>

<cfif q_select_events.recordcount GT 0>
	<cfset a_str_bol_show_iframe = 'true'>
<cfelse>
	<cfset a_str_bol_show_iframe = 'false'>
</cfif>

<cfif q_select_events.recordcount IS 0>
	<div class="addinfotext"><cfoutput>#GetLangVal('cal_ph_related_no_events_found')#</cfoutput></div>
<cfelse>

<table class="table table-hover">
  <tr>
    <td class="addinfotext"><cfoutput>#GetLangVal('cal_wd_title')#</cfoutput></td>
	<td class="addinfotext"><cfoutput>#GetLangVal('cal_wd_start')#</cfoutput></td>
	<td class="addinfotext"><cfoutput>#GetLangVal('cal_wd_duration')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_events">
  <tr>
    <td>
	<a title="#GetLangVal('cal_ph_related_open_in_new_window')#" href="index.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_events.entrykey)#" target="_blank">#htmleditformat(shortenstring(checkzerostring(q_select_events.title), 25))#</a>
	</td>
    <td>
	#TimeFormat(q_select_events.date_start, 'HH:mm')#
	</td>
    <td>
	<cfset a_int_diff_hours = DateDiff('h', q_select_events.date_start, q_select_events.date_end)>
	<cfset a_int_diff_minutes = DateDiff('n', q_select_events.date_start, q_select_events.date_end)>
	
	<cfif a_int_diff_hours GT 0>
	#a_int_diff_hours#h
	<cfelse>
	#a_int_diff_minutes#min
	</cfif>	
	
	</td>
  </tr>
  </cfoutput>
</table>
</cfif>