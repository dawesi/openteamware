<!--- //

	Module:		Calendar
	Description:Show month
	

// --->


<cfparam name="DisplayMonth.Prefix" type="string" default="#ReplaceNoCase(CreateUUID(), '-', '', 'ALL')#">

<cfset a_dt_start = CreateDateTime(Year(request.a_dt_current_date), Month(request.a_dt_current_date), 1, 0, 0, 0) />

<cfset a_int_year = Year(request.a_dt_current_date) />
<cfset a_int_month = Month(request.a_dt_current_date) />

<cfset a_dt_prev_month = DateAdd('m', -1, a_dt_start) />
<cfset a_dt_next_month = DateAdd('m', 1, a_dt_start) />

<cfset a_dt_start_load = GetUTCTime(a_dt_start) />
<cfset a_dt_end_load = DateAdd('d', DaysInMonth(a_dt_start), a_dt_start_load) />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.virtualcalendars = request.a_str_virtual_calendar_filter />

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start_load#">
	<cfinvokeargument name="enddate" value="#a_dt_end_load#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events />

<cfset a_arr_days = ArrayNew(1) />

<cfif q_select_events.recordcount GT 0>
	<cfset tmp = ArraySet(a_arr_days, 1, q_select_events.recordcount, 0) />
</cfif>

<cfset tmp = QueryAddColumn(q_select_events, 'days', a_arr_days) />
<cfset a_struct_events = QueryToArrayOfStructures(q_select_events) />

<!--- welcher monat? --->

<div style="text-align:center;padding:6px; ">
	<cfoutput>
	<a href="?action=ViewMonth&Date=#urlencodedformat(DateFormat(a_dt_prev_month, 'mm/dd/yyyy'))#"><img src="/images/si/resultset_previous.png" class="si_img" /> #LsDateFormat(a_dt_prev_month, 'mmmm yy')#</a>
	&nbsp;|&nbsp;
	<span style="font-weight:bold; ">#LsDateFormat(a_dt_start, 'mmmm yyyy')# (#DaysInMonth(a_dt_start)# #GetLangval("cm_wd_days")#)</span>
	&nbsp;|&nbsp;
	<a href="?action=ViewMonth&Date=#urlencodedformat(DateFormat(a_dt_next_month, 'mm/dd/yyyy'))#">#LsDateFormat(a_dt_next_month, 'mmmm yy')# <img src="/images/si/resultset_next.png" class="si_img" /></a>
	</cfoutput>
</div>

<cfset tmp = SetHeaderTopInfoString(LsDateFormat(a_dt_start, 'mmmm yyyy')) />

<!--- Create the date variables to search the Database by. --->
<cfset a_dt_month_end = CreateDateTime(a_int_year, a_int_month, DaysInMonth(a_dt_start), 23, 59, 59) />

<CFSET OffSet = DayOfWeek(a_dt_start) />
<CFSET LastSlot = OffSet + DaysInMonth(a_dt_start)-1 />
<CFSET a_int_cal_days = (Ceiling(LastSlot/7))*7 />

<CFSET Day = 1 />
<cfset a_int_day_number = 1 />


<cfloop index="ii" from="1" to="#arraylen(a_struct_events)#">
	<!--- write list of days into the structure ... speeds up looping below --->
	
	<!--- this function writes a list into the structure that contains the days
		  where this event is repeating
		  
		  f.e.: a 2-days event has the value "17,18"
		  
		  		a one-day-event has the value "8"
				
		  this way we can use ListFindNoCase instead of complicate walks trough cfif/cfif/cfelse ...
		   --->
	<cfif Compare(Month(a_struct_events[ii].date_start), a_int_month) NEQ 0>
		<cfset A_int_day_start = 1>
	<cfelse>
		<cfset A_int_day_start = Day(a_struct_events[ii].date_start)>
	</cfif> 
	
	<cfif Compare(Month(a_struct_events[ii].date_end), a_int_month) NEQ 0>
		<cfset A_int_day_end = DaysInMonth(a_int_month)>
	<cfelse>
		<!--- a bug ... if the events is a whole day event, the
			next day will be included in the display routine ...
			
			that's wrong ... therefore subtract 1 minute in order
			to get the previous day if neccessay ... f.e. 12.10.2002 00:00 -> 11.10.2002 23:59 --->
		<cfset A_int_day_end = Day(DateAdd("n", "-1",a_struct_events[ii].date_end))>
	</cfif> 	
	
	<cfset a_str_days = "">
	
	<cfloop index="a_int_day" from="#a_int_day_start#" to="#a_int_day_end#">
		<cfset a_str_days = a_str_days & "," & a_int_day>
	</cfloop>

	<cfset tmp = StructInsert(a_struct_events[ii], 'days',  a_str_days, true)>

</cfloop>	
	
<cfset a_dt_first_day_of_month = CreateDate(year(request.a_dt_current_date), Month(request.a_dt_current_date), 1) />

<cfset a_first_day_of_month = Dayofweek(a_dt_first_day_of_month)-1 />

<cfif a_first_day_of_month IS 0>
	<cfset a_first_day_of_month = 7 />
</cfif>

<cfset a_int_days_of_month = DaysInMonth(a_dt_first_day_of_month) />

<table class="table table-hover" border="1" cellpadding="0" bordercolordark="#EEEEEE" bordercolor="#EEEEEE" bordercolorlight="#EEEEEE" style="border-collapse:collapse;">
	<tr class="tbl_overview_header mischeader">
		
	<cfset a_dt_first_day = CreateDate(1899, 12, 31) />

	<cfoutput>
		<td align="center" width="30">&nbsp;W&nbsp;</td>
		
		<cfloop from="1" to="7" index="a_int_day_of_week">
		<td style="width:14%;text-align:center;">#LSDateFormat(DateAdd('d', a_int_day_of_week, a_dt_first_day), 'dddd')#</td>
		</cfloop>

	</cfoutput>
	</tr>
	<tr>
		<td align="center" width="30" valign="middle" class="mischeader" style="vertical-align:middle; ">
			
		<cfif DayOfWeek(a_dt_first_day_of_month) IS 1>
			<cfset a_tmp_week_nav_first = DateAdd('d', -1, a_dt_first_day_of_month) />
		<cfelse>
			<cfset a_tmp_week_nav_first = a_dt_first_day_of_month />
		</cfif>
							
				<a class="addinfotext" href="index.cfm?action=ViewWeek&Date=<cfoutput>#DateFormat(a_dt_first_day_of_month, 'm/dd/yyyy/')#</cfoutput>"><cfoutput>#(DateDiff('ww', CreateDate(Year(a_dt_first_day_of_month), 1, 1), a_tmp_week_nav_first) + 1)#</cfoutput></a>
				
			</td>
			
			<cfif a_first_day_of_month GT 1>
				<td colspan="<cfoutput>#(a_first_day_of_month-1)#</cfoutput>">&nbsp;</td>
			</cfif>
			
			<cfloop from="0" to="#(a_int_days_of_month-1)#" index="ii_day">
			
				<cfset a_int_day_number = ii_day + 1 />
				
				<cfset a_dt_date_day_of_month = DateAdd('d', ii_day, a_dt_first_day_of_month) />
			
				<cfset a_str_dbl_click_data = dateformat(a_dt_date_day_of_month, 'm/dd/yyyy') />
				
				<td onDblClick="CallNewEvent('<cfoutput>#jsstringformat(a_str_dbl_click_data)#</cfoutput>');" class="cal_month_box" <cfif Day(a_dt_date_day_of_month) IS Day(now()) AND Month(a_dt_date_day_of_month) is Month(now())>style="background-color:#D0EBEE;"</cfif>>
					
					<cfset a_int_hours_with_events = '' />
					<cfset a_arr_hours_with_events = ArrayNew(1) />
					<cfset a_arr_birthdays = ArrayNew(1) />
					<cfset a_str_birthdays_text_replace = '' />
	
					<cfset tmp = ArraySet(a_arr_hours_with_events, 1, 24, 0) />
					
					<cfsavecontent variable="a_str_cal_day">
					<div>
					<CFOUTPUT><a href="index.cfm?Action=ViewDay&Date=#dateformat(a_dt_date_day_of_month, "m/dd/yyyy")#" class="a_day">#a_int_day_number#</a></cfoutput>
					</div>
					
					%BIRTHDAYS%
					
					<div style="padding:4px; ">
					<cfloop index="a_int_jj" from="1" to="#arraylen(a_struct_events)#">
					
						<cfif ListFind(a_struct_events[a_int_jj].days, a_int_day_number, ",") GT 0>
						
							<cfif a_struct_events[a_int_jj].type IS 0>
								<cfoutput>
								
								<!--- hours from start to end --->						
								<cfloop from="#Hour(a_struct_events[a_int_jj].date_start)#" to="#Hour(a_struct_events[a_int_jj].date_end)#" index="a_int_dummy">
									<cfset a_int_hours_with_events = ListAppend(a_int_hours_with_events, a_int_dummy)>
									
									<cfif a_int_dummy GT 0>
										<cfset a_arr_hours_with_events[a_int_dummy] = 1>
									</cfif>
								</cfloop>
								
									
									<cfif (DateDiff('d', a_struct_events[a_int_jj].date_start, a_struct_events[a_int_jj].date_end) IS 1)
										  AND
										  (Hour(a_struct_events[a_int_jj].date_start) IS 0)>
										  <span class="mischeader b_all" style="padding:2px; ">24h</span>
									<cfelse>
										  <font style="font-size:10px;" class="addinfotext">#timeformat(a_struct_events[a_int_jj].date_start, 'HH:mm')#</font>
									</cfif>
									<br />  
								  
								  <a <cfif Len(a_struct_events[a_int_jj].color) GT 0>style="background-color:#a_struct_events[a_int_jj].color#"</cfif> href="index.cfm?action=ShowEvent&entrykey=#urlencodedformat(a_struct_events[a_int_jj].entrykey)#" title="#htmleditformat(a_struct_events[a_int_jj].title)#">#htmleditformat(checkzerostring(shortenstring(a_struct_events[a_int_jj].title, 25)))#</a> <cfif Compare(a_struct_events[a_int_jj].privateevent, 1) IS 0><span class="mischeader b_all addinfotext" style="font-size:10px;">&nbsp;P&nbsp;</span></cfif>
								  
								  </cfoutput>
								  
								  <cfif a_struct_events[a_int_jj].repeat_type GT 0>
									<img src="/images/si/arrow_rotate_clockwise.png" class="si_img" />
								  </cfif>
								  
								  <br>
							  <cfelse>
								<!--- type is different from 0 ... ---> 
								<cfset tmp = ArrayAppend(a_arr_birthdays, a_struct_events[a_int_jj])>
							  </cfif>
							  
						</cfif>
						
				
					</cfloop>
					</div>
					
					</cfsavecontent>
					
					
					<!---<div class="cal_month_view_span">
						<!---<cfoutput>#a_int_hours_with_events#</cfoutput>--->
						<cfloop from="1" to="4" index="a_int_section">
						
						<cfset a_str_bg_classname = 'cal_month_day_status_free'>
						
						<!---
						
							1: 08 - 11
							2: 11 - 15
							3: 15 - 18
							4: 18 - 22
							
						--->
						<cfswitch expression="#a_int_section#">
							<cfcase value="1">
								<cfset a_bol_events_exists = (a_arr_hours_with_events[8] + a_arr_hours_with_events[9] + a_arr_hours_with_events[10]) GT 0>
							</cfcase>
							<cfcase value="2">
								<cfset a_bol_events_exists = (a_arr_hours_with_events[11] + a_arr_hours_with_events[12] + a_arr_hours_with_events[13] + a_arr_hours_with_events[14]) GT 0>
							</cfcase>
							<cfcase value="3">
								<cfset a_bol_events_exists = (a_arr_hours_with_events[15] + a_arr_hours_with_events[16] + a_arr_hours_with_events[17] + a_arr_hours_with_events[18]) GT 0>						
							</cfcase>
							<cfcase value="4">
								<cfset a_bol_events_exists = (a_arr_hours_with_events[19] + a_arr_hours_with_events[20] + a_arr_hours_with_events[21] + a_arr_hours_with_events[22]) GT 0>						
							</cfcase>
						</cfswitch>
						
						<cfif a_bol_events_exists>
							<cfset a_str_bg_classname = 'cal_month_day_status_busy'>
						</cfif>					
						
						<span class="b_all <cfoutput>#a_str_bg_classname#</cfoutput>"><img src="/images/space_1_1.gif" width="1" height="1" border="0"></span>
						</cfloop>
					</div>	--->	
					
					
					<cfif ArrayLen(a_arr_birthdays) GT 0>
						
						<cfloop from="1" to="#ArrayLen(a_arr_birthdays)#" index="a_int_index_loop_birthdays">
							<cfset a_str_birthdays_text_replace = ListAppend(a_str_birthdays_text_replace, a_arr_birthdays[a_int_index_loop_birthdays].title)>
						</cfloop>
	
						 <cfset a_str_birthdays_text_replace = '<font title="' & htmleditformat(a_str_birthdays_text_replace) & '" style="font-size:10px;" class="addinfotext">' & getlangval('cal_ph_birthdays') & ': ' & ArrayLen(a_arr_birthdays) & '</font>'>
					</cfif>
					
					<!--- replace and output day info ... --->				
					<cfset a_str_cal_day = ReplaceNoCase(a_str_cal_day, '%BIRTHDAYS%', a_str_birthdays_text_replace)>
					
					<cfoutput>#a_str_cal_day#</cfoutput>
					
					
					
					
				</td>
				<!--- when sunday, break ... --->
				
				<cfif DayOfWeek(a_dt_date_day_of_month) IS 1>
					<!--- break! --->
					</tr>
					<tr>
						<td align="center" width="30" valign="middle" class="mischeader" style="vertical-align:middle;padding-right:10px;padding-left:10px;">
							
							<a class="addinfotext" href="index.cfm?action=ViewWeek&Date=<cfoutput>#DateFormat(DateAdd('d', 3, a_dt_date_day_of_month), 'm/dd/yyyy')#</cfoutput>"><cfoutput>#(DateDiff('ww', CreateDate(Year(a_dt_date_day_of_month), 1, 1), a_dt_date_day_of_month) + 1)#</cfoutput></a>
						</td>
				</cfif>
				
			</cfloop>
			
			<!---<cfif DayOfWeek(a_dt_date_day_of_month) NEQ 2>
				<cfloop from=""
			</cfif>--->
		
	
	</table>


<div align="center" style="padding:5px;">
	<a href="javascript:ShowDialogIncludeUserCalendar();"><img src="/images/si/user.png" class="si_img" /> <cfoutput>#GetLangVal('cal_ph_add_user_calendars')#</cfoutput></a>
</div>


<br />
<cfset a_str_person_entryvalue1 = GetUserPrefPerson('calendar', 'display.includeusercalendars', '', '', false) />
	
<cfset a_struct_user_calendars = StructNew()>

<!--- check if the selected calendars still exist (and permission is given ... --->

<cfloop list="#a_str_person_entryvalue1#" delimiters="," index="a_str_userkey">

	<cfinvoke component="#application.components.cmp_user#" method="UserkeyExists" returnvariable="a_bol_user_exists">
		<cfinvokeargument name="userkey" value="#a_str_userkey#">
	</cfinvoke>
	
	<cfif a_bol_user_exists>
	
		<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_userkey">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
		</cfinvoke>
		
		<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stReturn_usersettings">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
		</cfinvoke>	
	
		<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="a_struct_user_return">
			<cfinvokeargument name="startdate" value="#a_dt_start_load#">
			<cfinvokeargument name="enddate" value="#a_dt_end_load#">
			<cfinvokeargument name="securitycontext" value="#stReturn_userkey#">
			<cfinvokeargument name="usersettings" value="#stReturn_usersettings#">
            <cfinvokeargument name="loadeventofsubscribedcalendars" value="false">
		</cfinvoke>
		
		<cfset a_struct_user_calendars[a_str_userkey] = a_struct_user_return>
	
	</cfif>
</cfloop>



<cfloop list="#StructKeyList(a_struct_user_calendars)#" delimiters="," index="a_str_userkey">
<div class="bb" style="padding:8px;">
	<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
		<cfinvokeargument name="entrykey" value="#a_str_userkey#">
	</cfinvoke>
	
	<cfset q_select_user_data = a_struct_load_userdata.query>
	
	<div class="mischeader" style="padding:4px;">
	<cfif q_select_user_data.smallphotoavaliable IS 1>
		<cfoutput>
		<img src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_user_data.entrykey)#" height="60" align="absmiddle">
		</cfoutput>
	</cfif>
	
	<cfoutput>
	<b>#q_select_user_data.surname#, #q_select_user_data.firstname#</b> (#q_select_user_data.username#)
	</cfoutput>
	
	<cfif q_select_user_data.entrykey NEQ request.stSecurityContext.myuserkey>
		<cfoutput>
		<a href="act_remove_usercalendar.cfm?userkey=#urlencodedformat(q_select_user_data.entrykey)#" class="addinfotext">#GetLangVal('cal_wd_close_external_calendar')#</a>
		</cfoutput>
	</cfif>
	</div>
	
	<table class="table table-hover" style="width:90% ">
	  <cfset q_select_events = a_struct_user_calendars[a_str_userkey].q_select_events>
	  <tr>
	  	<td colspan="3">
			<cfset a_str_text = GetLangVal('cm_ph_items_found')>
			<cfset a_str_text = ReplaceNoCase(a_str_text, '%RECORDCOUNT%', q_select_events.recordcount)>
			<cfoutput>#a_str_text#</cfoutput>
		</td>
	  </tr>
	  <cfoutput query="q_select_events">
	  <tr <cfif Len(q_select_events.color) GT 0>style="background-color:#q_select_events.color#"</cfif>>
		<td>
			<cfif q_select_events.privateevent NEQ 1>
			<a href="index.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_events.entrykey)#">#htmleditformat(q_select_events.title)#</a>
			<cfelse>
			[Privat]
			</cfif>
		</td>
		<td>
			#LSDateFormat(q_select_events.date_start, request.a_str_default_dt_format)# #TimeFormat(q_select_events.date_start, 'HH:mm')#
		</td>
		<td>
			#LSDateFormat(q_select_events.date_end, request.a_str_default_dt_format)# #TimeFormat(q_select_events.date_end, 'HH:mm')#
		</td>
	  </tr>
	  </cfoutput>
	</table>
			
</div>
</cfloop>


