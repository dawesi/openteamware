<!--- //

	Module:		Calendar
	Description:Outlook on startpage
	

// --->

<cfset a_dt_start = CreateDate(Year(Now()), month(Now()), day(Now())) />

<cfset a_dt_start = GetUTCTimeFromUserTime(a_dt_start) />

<cfset a_struct_cal_filter = StructNew() />

<!--- friday, add one more day ... --->
<cfif DayOfWeek(Now()) IS 6>
	<cfset a_dt_end = DateAdd('d', 5, a_dt_start) />
<cfelse>
	<cfset a_dt_end = DateAdd('d', 4, a_dt_start) />
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

<cfset a_int_dt_current_display = DateFormat(DateAdd('d', -1, Now()), 'ddmmyyyy') />

	<table class="table table_details">
	<!--- <tr>
		<td colspan="2">
			<a href="/calendar/" class="nl"><img src="/images/si/calendar.png" class="si_img" /><cfoutput>#GetLangVal('cm_ph_next_events_days')#</cfoutput></a>
		</td>
	</tr> --->
	<cfif q_select_events.recordcount IS 0>
		<tr>
			<td colspan="2">
				<cfoutput>#GetLangVal('cal_ph_outlook_no_events_found')#</cfoutput><img alt="" src="/images/space_1_1.gif" class="si_img" />
			</td>
		</tr>
		
	</cfif>
	<cfoutput query="q_select_events">
	
		<cfset a_dt_cur_display = DateFormat(q_select_events.date_start, 'ddmmyyyy')>
		
			<!--- Day(q_select_events.date_start) NEQ Day(Now()) AND --->
			<cfif  Compare(a_int_dt_current_display,  a_dt_cur_display) NEQ 0>
			
				<!--- new display --->
				<cfset a_int_dt_current_display = DateFormat(q_select_events.date_start, 'ddmmyyyy')>
				<tr>
					<td class="addinfotext" nowrap colspan="2">
					<cfset a_str_dt_link_day = DateFormat(q_select_events.date_start, 'mm/dd/yyyy')>
					
					#LSDateFormat(q_select_events.date_start, 'dddd')#, #LSDateFormat(q_select_events.date_start, 'dd. mmmm')#<img src="/images/space_1_1.gif" alt="" class="si_img" />
					
					</td>
				</tr>

				
			</cfif>
	  <tr>
	  
		<cfset a_int_diff_hours = DateDiff('h', q_select_events.date_start, q_select_events.date_end)>
		<cfset a_int_diff_minutes = DateDiff('n', q_select_events.date_start, q_select_events.date_end)>			
	  
		<td valign="top" nowrap style="width:33%; ">
			<cfset a_dt_start = ParseDateTime(q_select_events.date_start) />
			
			<img src="/images/si/calendar.png" class="si_img" /> #TimeFormat(q_select_events.date_start, 'HH:mm')# - #TimeFormat(q_select_events.date_end, 'HH:mm')#<img alt="" src="/images/space_1_1.gif" class="si_img" />	
		</td>
		<td style="width:66%;" <cfif Len(q_select_events.color) GT 0>style="background-color:#q_select_events.color#"</cfif>>

			<a <cfif Day(q_select_events.date_start) IS Day(now())>style="font-weight:bold;"</cfif> href="/calendar/index.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_events.entrykey)#">#htmleditformat(shortenstring(checkzerostring(q_select_events.title), 35))#<cfif q_select_events.privateevent IS 1> (#GetLangVal('cm_wd_private')#)</cfif></a>
			
			<cfif val(q_select_events.repeat_type) GT 0><img src="/images/si/arrow_rotate_clockwise.png" class="si_img" /></cfif>
		
			<cfif Len(q_select_events.location) GT 0>
				(#htmleditformat(q_select_events.location)#)
			</cfif>
		
			<img src="/images/space_1_1.gif" class="si_img" />		
		</td>
	  </tr>
	</cfoutput>
	</table>
	

