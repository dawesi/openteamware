<!--- //

	show an overview of the events today, due tasks and so on
	
	// --->
	
<cfset a_dt_start = CreateDate(Year(request.a_dt_current_date), month(request.a_dt_current_date), day(request.a_dt_current_date))>

<cfset a_dt_start = GetUTCTimeFromUserTime(a_dt_start)>
	
<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.virtualcalendars = request.a_str_virtual_calendar_filter>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#DateAdd('d', 2, a_dt_start)#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events>
<cfset a_struct_events = QueryToArrayOfStructures(q_select_events)>

<cfset a_str_dt_formatted = DateFormat(request.a_dt_current_date, "m/d/yyyy")>

<cfsavecontent variable="a_str_buttons">
	<cfoutput>
	<input onClick="location.href = 'index.cfm?Action=ShowNewEvent&startdate=#urlencodedformat(a_str_dt_formatted)#';" type="button" value=" #htmleditformat(GetLangVal('cm_wd_new'))# " class="btn btn-primary">
	<input onClick="location.href = 'index.cfm?Action=ViewDay&startdate=#urlencodedformat(a_str_dt_formatted)#';" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_day')#">
	<input onClick="location.href = 'index.cfm?Action=ViewWeek&startdate=#urlencodedformat(a_str_dt_formatted)#';" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_week')#">
	<input onClick="location.href = 'index.cfm?Action=ViewMonth&startdate=#urlencodedformat(a_str_dt_formatted)#';" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_month')#">	
	
	&nbsp;
	<a href="../settings/index.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('cal_ph_set_standard_view')#</cfoutput></a>
			
	</cfoutput>
</cfsavecontent>		


<br>

<cfsavecontent variable="a_str_today_overview"></cfsavecontent>

<cfset a_str_title = LSDateFormat(request.a_dt_current_date, "dddd") & ', ' & LSDateformat(request.a_dt_current_date, "dd. mmmm yyyy") & ' ' & TimeFormat(GetLocalTime(GetUTCTime(Now())), "HH:mm")>
	
<cfoutput>#WriteNewContentBox(a_str_title, a_str_buttons, a_str_today_overview)#</cfoutput>
		


<table border="0" cellspacing="0" cellpadding="4" style="padding-top:0px; " width="100%">
  <tr>
    <td valign="top">
	
	<cfoutput>#Week(request.a_dt_current_date)#</cfoutput>. <cfoutput>#GetLangVal('cal_wd_week')#</cfoutput> / <cfoutput>#DayofYear(request.a_dt_current_date)#</cfoutput>. <cfoutput>#GetLangVal('cal_ph_day_of_year')#</cfoutput>

	<!--- display events for today --->
	<table border="0" cellspacing="0" cellpadding="1" width="100%">
	
	<cfset a_int_old_diff = CreateTime(0,0,0)>
	<cfset a_int_events_today_count = 0>
	
	<cfloop index="ii" from="1" to="#arraylen(a_struct_events)#">
	
		<cfif CompareNoCase(DateFormat(a_struct_events[ii].date_start, "ddmmyyyy"), DateFormat(request.a_dt_current_date, "ddmmyyyy")) is 0>
			<!--- include display routine --->
			
			<!--- increase counter --->
			<cfset a_int_events_today_count = a_int_events_today_count +1>
			
			<cfset a_int_hours_diff = DateDiff("h", a_int_old_diff, a_struct_events[ii].date_start)>
			
			<cfif a_int_hours_diff lt 0><cfset a_int_hours_diff = 0 - a_int_hours_diff></cfif>

			<cfif a_int_hours_diff lte 1>
				<cfset a_str_background_color = "red">
			<cfelseif a_int_hours_diff lte 3>
				<cfset a_str_background_color = "yellow">
			<cfelse>
				<cfset a_str_background_color = "green">
			</cfif>
			
			<cfset a_int_old_diff = a_struct_events[ii].date_start>
			
			
					  
					  <cfset a_int_diff_hours_from_now = DateDiff("h", DateAdd("h", request.stUserSettings.utcdiff, now()), a_struct_events[ii].date_start)-2>
					  
					  <tr>
					  	<td width="10px" valign="middle" style="padding-left:10px; ">
							<span style="width:8px;height:8px;background-color:<cfoutput>#a_str_background_color#</cfoutput>"><img src="/images/space_1_1.gif" height="1" width="1" border="0"></span>
						</td>
    					<td style="padding:10px;line-height:16px;">
						<cfset a_dt_end = ParseDateTime(a_struct_events[ii].date_end)>
						<cfoutput>#TimeFormat(a_struct_events[ii].date_start, "HH:mm")# - #TimeFormat(a_dt_end, "HH:mm")#</cfoutput>
						
						<cfif a_int_diff_hours_from_now gt 0>
							<font class="addinfotext">(<cfoutput>#GetLangVal('cm_wd_in')#</cfoutput> <cfoutput>#a_int_diff_hours_from_now#</cfoutput> h)</font>
						</cfif>
						
						
						<cfset ShowEventRequest.a_struct_event = a_struct_events[ii]>
						<cfset ShowEventRequest.ShowNoDate = true>
						<cfinclude template="dsp_inc_show_event.cfm">
						
						</td>
  					  </tr>

		</cfif>
	</cfloop>
	</table>

	<cfif a_int_events_today_count is 0>
		<cfoutput>#GetLangVal('cal_ph_overview_no_events_found')#</cfoutput>
		<br>
	</cfif>
	
	<cfinvoke component="#application.components.cmp_calendar#" method="GetOpenInvitations" returnvariable="q_select_open_invitations">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>
	
	<cfif q_select_open_invitations.recordcount GT 0>
	
		<cfset a_cmp_users = application.components.cmp_user>
		<cfset a_cmp_addressbook = application.components.cmp_addressbook>
	  		
		<cfset a_str_text = GetLangVal('cal_ph_outlook_open_invitations')>
		<cfset a_str_text = ReplaceNoCase(a_str_text, '%RECORDCOUNT%', q_select_open_invitations.recordcount)>
			
		<cfoutput>#a_str_text#</cfoutput> 
			
		<ul style="margin-bottom:5px;margin-top:5px;">
			<cfoutput query="q_select_open_invitations">
				
				<cfswitch expression="#q_select_open_invitations.type#">
                    <cfcase value="0">
						<!--- user ... --->
						<cfset a_str_param = a_cmp_users.GetUsernamebyentrykey(q_select_open_invitations.parameter)>
                    </cfcase>
                    <cfcase value="1">
						<!--- contact ... --->
                        <cfset q_select_contact = a_cmp_addressbook.GetContact(
                                            securitycontext=request.stSecurityContext, 
                                            usersettings=request.stUserSettings, 
                                            entrykey=q_select_open_invitations.parameter).q_select_contact >
						<cfset a_str_param = q_select_contact.surname & ', ' & q_select_contact.firstname>
                    </cfcase>
					<cfcase value="2">
						<!--- E-mail ... --->
						<cfset a_str_param = q_select_open_invitations.parameter>
					</cfcase>
				</cfswitch>
				
				<li>#a_str_param# #GetLangVal('cal_ph_outlook_open_invitations_to_event')# <a href="/calendar/?action=showevent&entrykey=#q_select_open_invitations.entrykey#">#htmleditformat(q_select_open_invitations.title)#</a></li>
				</cfoutput>
		</ul>
		
	  </cfif>	

	</td>
	
    <td valign="top" class="bl" style="width:240px;">
	
		<!--- display tasks --->
		<div id="id_div_display_due_tasks_in_calendar"></div>
		
	</td>
  </tr>
</table>

<cfscript>
	AddJSToExecuteAfterPageLoad('DisplayDueTasksInCalendarOverview()', '');
</cfscript>


<cfinclude template="dsp_inc_show_day_week.cfm">