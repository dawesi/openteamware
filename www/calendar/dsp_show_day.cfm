<!--- //

	Component:	Calendar
	Action:		ViewDay
	Description:
	
	Header:	

// --->
<cfset a_struct_contacts_cached_info = StructNew() />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.ignoreeventsofinheritedworkgroups = true />
<cfset a_struct_filter.virtualcalendars = request.a_str_virtual_calendar_filter />

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#request.a_dt_utc_current_date#">
	<cfinvokeargument name="enddate" value="#DateAdd('d', 1, request.a_dt_utc_current_date)#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events />

<cfquery name="q_select_events_original" dbtype="query">
SELECT
	*
FROM
	q_select_events
;
</cfquery>

<!--- show tasks on the right side? --->
<cfset a_int_show_open_tasks = GetUserPrefPerson('calendar', 'display.day.opentasks', '1', '', false) />
	
<!--- always to false! --->
<cfset a_int_show_open_tasks = 0>
	
<cfif url.printmode>
	<cfset a_int_show_open_tasks = 0>
</cfif>

<!--- select events before eight o'clock ... --->
<cfset a_dt_before = CreateDateTime(year(request.a_dt_current_date), month(request.a_dt_current_date), day(request.a_dt_current_date), request.a_int_day_starthour, 0, 0)>
<cfset a_int_dt_before = DateFormat(a_dt_before, "yyyymmdd")&timeformat(a_dt_before, "HHmm")>

<cfset a_int_tmp_endhour = request.a_int_day_endhour+1>

<cfif a_int_tmp_endhour is 24>
	<cfset a_int_tmp_endhour = 23>
</cfif>

<cfset a_dt_afterwards = CreateDateTime(year(request.a_dt_current_date), month(request.a_dt_current_date), day(request.a_dt_current_date), a_int_tmp_endhour, 0, 0)>
<cfset a_int_dt_afterwards = DateFormat(a_dt_afterwards, "yyyymmdd")&timeformat(a_dt_afterwards, "HHmm")>

<cfset a_dt_dayend= CreateDateTime(year(request.a_dt_current_date), month(request.a_dt_current_date), day(request.a_dt_current_date), 23, 59, 59)>
<cfset a_int_dt_dayend = DateFormat(a_dt_dayend, "yyyymmdd")&timeformat(a_dt_dayend, "HHmm")>

<!--- do now all sub queries --->
<cfinclude template="queries/q_select_day_view_queries.cfm">

<!--- create the structure holing all events ... --->
<cfset a_struct_main_events = StructNew()>

<!--- load calendar of other users ... --->
<cfinclude template="utils/inc_check_select_user_calendars.cfm">

<cfloop from="0" to="23" index="ii">
	<cfset a_struct_main_events[ii] = ''>
</cfloop>

<cfloop query="q_select_events_main">
	<cfset a_int_hour = Hour(q_select_events_main.date_start)>
	
	<cfif a_int_hour IS 24>
		<cfset a_int_hour = 23>
	</cfif>
	
	<cfset a_int_hours_diff = DateDiff('h', q_select_events_main.date_start, DateAdd('n', -1, q_select_events_main.date_end))>
	<!---<cfoutput> #a_int_hour# #a_int_hours_diff#</cfoutput>--->
	
	<cfset a_int_tmp_end_hour = a_int_hour + a_int_hours_diff>
	
	<cfif a_int_tmp_end_hour GT 23>
		<cfset a_int_tmp_end_hour = 23>
	</cfif>
	
	<cfloop from="#a_int_hour#" to="#a_int_tmp_end_hour#" index="ii">
		<cfset a_struct_main_events[ii] = a_struct_main_events[ii] & ',' & q_select_events_main.entrykey>
	</cfloop>
</cfloop>


<cfset a_arr_displayed_events = ArrayNew(1)>
		
<cfset a_int_diff_days = DateDiff('d', request.a_dt_current_date, Now())>


<cfset tmp = SetHeaderTopInfoString(lsDateFormat(request.a_dt_current_date, 'dddd, dd.mmmm yyyy'))>


<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td valign="top">
	
	<!--- Busy today with reports --->
	<!--- <a href="javascript:HideLeftNavSide(true);">hide left side</a> --->


<cfif StructCount(a_struct_user_calendars) IS 0>
	<!--- include other calendars ... --->
	<div align="right">
		<a href="javascript:ShowDialogIncludeUserCalendar();"><img src="/images/si/user.png" class="si_img" /> <cfoutput>#GetLangVal('cal_ph_add_user_calendars')#</cfoutput></a>
	</div>
</cfif>

	<table class="table_overview" cellpadding="6">
	
	<!--- do we need special headers? --->
	<cfif StructCount(a_struct_user_calendars) GT 0>
	<tr>
		<td colspan="4" class="bb" align="right" style="padding:6px;">
			<a href="javascript:ShowDialogIncludeUserCalendar();"><img src="/images/si/add.png" class="si_img" /> <cfoutput>#GetLangVal('cal_ph_add_user_calendars')#</cfoutput></a>
		</td>
		
		<cfloop list="#StructKeyList(a_struct_user_calendars)#" delimiters="," index="a_str_userkey">
		
		<td align="center" width="120px" class="bl bb" style="padding:0px;" valign="bottom">
		
		<cfinvoke component="#application.components.cmp_load_user_data#" method="LoadUserData" returnvariable="a_struct_load_userdata">
			<cfinvokeargument name="entrykey" value="#a_str_userkey#">
		</cfinvoke>
		
				<cfset q_select_tmp_events = a_struct_user_calendars[a_str_userkey].q_select_events>
		
				<cfquery name="q_select_whole_day_events_external_user" dbtype="query">
				SELECT
					*
				FROM
					q_select_tmp_events
				WHERE
					(int_start_num = #DateFormat(request.a_dt_current_date, 'yyyymmdd')#0000)
					AND
					(dt_duration = 1000000)
					AND NOT
					(title LIKE '#GetLangVal('cal_wd_type_birthday')#%')					
				;
				</cfquery>		
				
				<cfquery name="q_select_whole_day_events_external_user_birthdays" dbtype="query">
				SELECT
					title,entrykey
				FROM
					q_select_tmp_events
				WHERE
					(dt_duration = 1000000)
					AND
					(title LIKE '#GetLangVal('cal_wd_type_birthday')#%')
				;
				</cfquery>						
				
				<cfquery name="q_select_events_before_external_user" dbtype="query">
				SELECT
					*
				FROM
					q_select_tmp_events
				WHERE
					(int_start_num < #a_int_dt_before#)
					AND
					(dt_duration <> 1000000)
					AND NOT
					(title LIKE '#GetLangVal('cal_wd_type_birthday')#%')							
				ORDER BY
					date_start
				;
				</cfquery>					
				
				<cfquery name="q_select_events_afterwards_external_user" dbtype="query">
				SELECT
					*
				FROM
					q_select_tmp_events
				WHERE
					(int_start_num >= #a_int_dt_afterwards#)
					AND NOT
					(title LIKE '#GetLangVal('cal_wd_type_birthday')#%')		
				ORDER BY
					date_start
				;
				</cfquery>				
		
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<cfif a_struct_load_userdata.query.smallphotoavaliable IS 1>				
					<img height="60" src="../tools/img/show_small_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(a_str_userkey)#</cfoutput>" border="0" align="absmiddle">
				<cfelse>	
					<img src="/images/si/user.png" class="si_img" />&nbsp;						
				</cfif>
				</td>
				<td align="center">
				<cfoutput>
				<a href="../workgroups/index.cfm?action=ShowUser&entrykey=#urlencodedformat(a_str_userkey)#">#a_struct_load_userdata.query.surname#, #a_struct_load_userdata.query.firstname#</a>
				</cfoutput>
				<br>
				<div style="padding:2px;margin-top:3px;">
					<a class="addinfotext" href="act_remove_usercalendar.cfm?userkey=<cfoutput>#urlencodedformat(a_str_userkey)#</cfoutput>"><cfoutput>#GetLangVal('cal_wd_include_other_calendars_close')#</cfoutput></a>
				</div>
				</td>
			</tr>
			
			<cfif (q_select_whole_day_events_external_user.recordcount GT 0) OR 
				  (q_select_events_before_external_user.recordcount GT 0) OR
				  (q_select_events_afterwards_external_user.recordcount GT 0) OR
				  (q_select_whole_day_events_external_user_birthdays.recordcount GT 0)>
				<tr>
					<td colspan="2">
	
					
					<cfif q_select_whole_day_events_external_user.recordcount GT 0>
						<div class="b_all mischeader" style="padding:4px;">
						<b>0 - 24</b>
						<cfoutput query="q_select_whole_day_events_external_user">
							<cfif q_select_whole_day_events_external_user.privateevent IS 1>
								(#GetLangVal('cal_wd_private')#)
							<cfelse>
								<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_whole_day_events_external_user, q_select_whole_day_events_external_user.currentrow)>
								<cfinclude template="dsp_inc_show_event.cfm">
							</cfif>
						</cfoutput>
						</div>
					</cfif>
					
					<cfif q_select_whole_day_events_external_user_birthdays.recordcount GT 0>
						<div class="bb bt mischeader" style="padding:4px; ">
							<cfoutput>#q_select_whole_day_events_external_user_birthdays.recordcount#</cfoutput> <cfoutput>#GetLangVal('cal_ph_birthdays')#</cfoutput>:
							
							<cfoutput query="q_select_whole_day_events_external_user_birthdays">
								<cfset a_str_name = ReplaceNoCase(q_select_whole_day_events_external_user_birthdays.title, GetLangVal('cal_ph_birthday_of'), '')>
								
								<a href="index.cfm?action=showevent&entrykey=#q_select_whole_day_events_external_user_birthdays.entrykey#">#htmleditformat(trim(a_str_name))#</a><cfif q_select_whole_day_events_external_user_birthdays.currentrow NEQ q_select_whole_day_events_external_user_birthdays.recordcount>, </cfif>
							</cfoutput>
						</div>
					</cfif>
					
					<cfif q_select_events_before_external_user.recordcount GT 0>
						<div class="b_all mischeader" style="padding:4px;">
						<cfoutput query="q_select_events_before_external_user">
							<cfif q_select_events_before_external_user.privateevent IS 1>
								(#GetLangVal('cal_wd_private')# #TimeFormat(q_select_events_before_external_user.date_start, 'HH:mm')# - #TimeFormat(q_select_events_before_external_user.date_end, 'HH:mm')#)<br>
							<cfelse>
								<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_events_before_external_user, q_select_events_before_external_user.currentrow)>
								<cfinclude template="dsp_inc_show_event.cfm">
							</cfif>
						</cfoutput>
						</div>
					</cfif>
					
					<cfif q_select_events_afterwards_external_user.recordcount GT 0>
						<div class="b_all mischeader" style="padding:4px;">
						<cfoutput query="q_select_events_afterwards_external_user">
							<cfif q_select_events_afterwards_external_user.privateevent IS 1>
								(#GetLangVal('cal_wd_private')# #TimeFormat(q_select_events_afterwards_external_user.date_start, 'HH:mm')# - #TimeFormat(q_select_events_afterwards_external_user.date_end, 'HH:mm')#)<br>
							<cfelse>
								<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_events_afterwards_external_user, q_select_events_afterwards_external_user.currentrow)>
								<cfinclude template="dsp_inc_show_event.cfm">
							</cfif>
						</cfoutput>
						</div>
					</cfif>
					</td>
				</tr>
			</cfif>
		</table>
		
		</td>
		
		</cfloop>
	</tr>
	</cfif>
	
	<cfif q_select_whole_day_events.recordcount GT 0>
		<tr>
			<td class="br bb addinfotext" align="center">0-24</td>
			<td colspan="3" class="mischeader bb">
			<b style="text-transform:uppercase;"><cfoutput>#GetLangVal('cal_wd_wholeday_events')#</cfoutput></b><br>
			<cfoutput query="q_select_whole_day_events">
				<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_whole_day_events, q_select_whole_day_events.currentrow)>
				<cfinclude template="dsp_inc_show_event.cfm">
			</cfoutput>			
			</td>
		</tr>
	</cfif>
	
	<cfif q_select_events_before.recordcount GT 0>
		<!--- events before the official start time ... --->		
		<tr>
			<td colspan="3">&nbsp;</td>
			<td>
			<cfoutput query="q_select_events_before">
				<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_events_before, q_select_events_before.currentrow)>
				<cfinclude template="dsp_inc_show_event.cfm">
			</cfoutput>
			</td>
		</tr>	
	</cfif>
	
	<cfloop from="#request.a_int_day_starthour#" to="#request.a_int_day_endhour#" index="a_int_hour">
	
	  <tr>
	  	<!--- are events avaliable? --->
	  	<cfset a_str_event_avaliable = (Len(a_struct_main_events[a_int_hour]) GT 0) />
	  
		<td width="30" align="center" class="addinfotext br<cfif a_str_event_avaliable> mischeader</cfif>">
			<cfoutput>#a_int_hour#</cfoutput><sup>00</sup>
		</td>
		<td width="20" class="cal_bb_light">
		
		<!--- new event ... --->
		<cfset a_dt_start = DateFormat(request.a_dt_current_date, "mm/dd/yyyy")&' '&a_int_hour&':00'>
		
		<a class="nl" href="index.cfm?action=ShowNewEvent&startdate=<cfoutput>#urlencodedformat(a_dt_start)#</cfoutput>"><img src="/images/si/add.png" class="si_img" alt="" /></a>
		</td>
		<td width="4" style="padding:0px;" class="cal_bb_light" valign="middle" align="center">&nbsp;
		
		</td>
		<td class="cal_bb_light">
		<!--- show events ... --->
		
		<cfset a_bol_events_found_this_hours = false>

		<cfif Len(a_struct_main_events[a_int_hour]) GT 0>
		
			<cfquery name="q_select_events_this_hour" dbtype="query">
			SELECT
				*
			FROM
				q_select_events_main
			WHERE
				entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_main_events[a_int_hour]#" list="yes">)
				
			<cfif Len(ArrayToList(a_arr_displayed_events)) GT 0>
			AND NOT
				entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(a_arr_displayed_events)#" list="yes">)
			</cfif>
			;
			</cfquery>
			
			<cfloop query="q_select_events_this_hour">
				<cfset a_arr_displayed_events[arraylen(a_arr_displayed_events)+1] = q_select_events_this_hour.entrykey>
				<!--- display event ... --->				
				<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_events_this_hour, q_select_events_this_hour.currentrow)>
				<cfinclude template="dsp_inc_show_event.cfm">
			</cfloop>
			
		
			<cfset a_bol_events_found_this_hours = q_select_events_this_hour.recordcount GT 0>
		</cfif>
		
		<cfif a_bol_events_found_this_hours is false>&nbsp;</cfif>
		</td>
		
		<!--- loop through the user calendars ... --->
		<cfloop list="#StructKeyList(a_struct_user_calendars)#" delimiters="," index="a_str_userkey">
		
		<cfset q_select_tmp_events = a_struct_user_calendars[a_str_userkey].q_select_events>
		
				<cfquery name="q_select_events_avaliable" dbtype="query">
				SELECT
					*
				FROM
					q_select_tmp_events
				WHERE
					(starthour = #a_int_hour#)
				;	
				</cfquery>		
			
			
		<td class="cal_bb_light bl <cfif q_select_events_avaliable.recordcount GT 0>mischeader</cfif>"  width="140px">
		
			
			
			<cfif q_select_tmp_events.recordcount GT 0>
			
				<cfquery name="q_select_tmp_events2" dbtype="query">
				SELECT
					*
				FROM
					q_select_tmp_events
				WHERE
					(starthour = #a_int_hour#)
				;	
				</cfquery>
				
				<cfif q_select_tmp_events2.recordcount IS 0>&nbsp;</cfif>
				
				<!--- display events ... --->
				<cfloop query="q_select_tmp_events2">
				
					<!--- private? --->
					
					<div>
					<cfif q_select_tmp_events2.privateevent IS 1>
						(Privat <cfoutput>#TimeFormat(q_select_tmp_events2.date_start, 'HH:mm')# - #TimeFormat(q_select_tmp_events2.date_end, 'HH:mm')#</cfoutput>)
					<cfelse>
						<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_tmp_events2, q_select_tmp_events2.currentrow)>
						<cfinclude template="dsp_inc_show_event.cfm">
						<!---&gt; <a href="index.cfm?action=ShowEvent&entrykey=<cfoutput>#urlencodedformat(q_select_tmp_events2.entrykey)#</cfoutput>"><cfoutput>#htmleditformat(shortenstring(q_select_tmp_events2.title, 20))#</cfoutput></a>--->
					</cfif>
					<br>
					
					</div>
				
				</cfloop>

			<cfelse>
			&nbsp;
			</cfif>
			
		
		</td>
		</cfloop>
	  </tr>		  	
	</cfloop>
	
	<cfif q_select_events_afterwards.recordcount GT 0>
		<tr>
			<td colspan="3" class="addinfotext" align="right" valign="top">ab <cfoutput>#(request.a_int_day_endhour+1)#</cfoutput> Uhr</td>
			<td>
			<cfoutput query="q_select_events_afterwards">
				<cfset ShowEventRequest.a_struct_event = queryRowToStruct(q_select_events_afterwards, q_select_events_afterwards.currentrow)>
				<cfinclude template="dsp_inc_show_event.cfm"><br>
			</cfoutput>			
			</td>
		</tr>			
	</cfif>	
	</table>
	

	
	<!---
	<script type="text/javascript">
		function OpenQuickEntry()
			{
			var obj1,obj2;
			
			obj1 = findObj('idtrquickentry');
			obj1.style.display = '';
			
			obj2 = findObj('idtrquickentryheader');
			obj2.style.display = '';
			
			document.formquickentry.frmTitle.focus();
			}
	</script>--->
	

	</td>
	
	<cfset a_bol_hidden_events_available = q_select_events_original.recordcount NEQ q_select_events.recordcount>
	
	<cfif (a_int_show_open_tasks IS 1) OR
		a_bol_hidden_events_available>
    <td valign="top" width="200">
	<!--- right column --->
	<!--- next day event ... --->		
		
		<cfif a_bol_hidden_events_available>
			<!--- filtering has happend!! remove displayed items --->
			
			<cfif request.stSecurityContext.myusername IS 'hp@openTeamware.com'>
			<cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="calendar hidden found" type="html">
				<cfdump var="#stReturn#">
				<cfdump var="#q_select_events_original#">
				<cfdump var="#q_select_events#">
				<cfdump var="#request.stSecurityContext#">
			</cfmail>
			</cfif>
			
			<cfset a_str_delete_rows = '' />
			
			<cfoutput query="q_select_events_original">
				<cfif ListFind(a_str_list_display_events, q_select_events_original.entrykey) GT 0>
					<cfset a_str_delete_rows = ListPrepend(a_str_delete_rows, q_select_events_original.currentrow)>
				</cfif>
			</cfoutput>
			
			<cfset q_select_hidden_events = QueryDeleteRows(q_select_events_original, a_str_delete_rows)>
				
			<table border="0" cellspacing="0" cellpadding="2" width="100%" class="b_all" style="margin-top:8px;">
			<tr>
				<td class="mischeader bb" style="padding:4px;">
				<b><cfoutput>#si_img('arrow_right')# #GetLangVal('cal_wd_hidden')#</cfoutput> (<cfoutput>#q_select_hidden_events.recordcount#</cfoutput>)</b>
				</td>
			</tr>
			<cfoutput query="q_select_hidden_events">
			  <!---<tr>
				<td class="addinfotext">
				#TimeFormat(q_select_hidden_events.date_start, 'HH:mm')#
				</td>
			  </tr>--->			
			  <tr>
				<td>
				<font style="font-size:10px;">#timeformat(q_select_hidden_events.date_start, "HH:mm")# (#q_select_hidden_events.dt_duration#)</font><br>
				<a href="index.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_hidden_events.entrykey)#">#htmleditformat(q_select_hidden_events.title)#</a>
				</td>
			  </tr>
			</cfoutput>
			</table>
			
			</div>
		
		</cfif>		
				
		
	
	<cfif (a_int_show_open_tasks IS 1)>
		
		<div id="id_div_display_due_tasks_in_calendar" class="b_all"></div>
		
		<cfscript>
			AddJSToExecuteAfterPageLoad('DisplayDueTasksInCalendarOverview()', '');
		</cfscript>
	</cfif>
	
	</td>
	</cfif>
  </tr>
</table>


<cfinclude template="dsp_inc_show_day_week.cfm">


