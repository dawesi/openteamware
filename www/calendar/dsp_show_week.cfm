<!--- //

	Module:        Calendar
	Description:   Show week 
	
	Header:	       

// --->

<cfparam name="session.a_struct_other_securitycontext" type="struct" default="#StructNew()#">
<cfparam name="url.virtualcalendarkey" type="string" default="">

<!--- get the week number ... --->
<cfset a_int_weekno = GetISOWeek(request.a_dt_current_date) />

<!--- get the week start ... in UTC (calculate from local time) --->
<cfset a_dt_start = GetUTCTimeFromUserTime(weekStartDate(a_int_weekno, year(request.a_dt_current_date), true))>

<cfset a_int_weekno_plus = DateAdd("d", 7, request.a_dt_current_date)>
<cfset a_int_weekno_minus = DateAdd("d", -7, request.a_dt_current_date)>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.virtualcalendars = request.a_str_virtual_calendar_filter>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_start#">
	<cfinvokeargument name="enddate" value="#DateAdd('d', 7, a_dt_start)#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events />
<cfset a_dt_day_week =  request.a_dt_current_date />

<!--- navigation on top --->
<cfoutput>
<div align="center" style="padding:10px;">
	
	<a href="index.cfm?action=ViewWeek&Date=#urlencodedformat(DateFormat(a_int_weekno_minus, "mm/dd/yyyy"))#"><img src="/images/si/resultset_previous.png" class="si_img nl" />#GetLangVal('cal_ph_nav_prev_week')#</a>
	&nbsp;&nbsp;|&nbsp;&nbsp;
	<span style="font-weight:bold;">#GetLangVal('cal_wd_week')# #CalculateRealStandardISOWeek(request.a_dt_current_date)#
	(#lsDateFormat(a_dt_start, request.stUserSettings.default_dateformat)#
	-
	#lsDateFormat(DateAdd('d', 7, a_dt_start), request.stUserSettings.default_dateformat)#)
	</span>
	&nbsp;&nbsp;|&nbsp;&nbsp;
	<a href="index.cfm?action=ViewWeek&Date=#urlencodedformat(DateFormat(a_int_weekno_plus, "mm/dd/yyyy"))#">#GetLangVal('cal_ph_nav_next_week')#<img src="/images/si/resultset_next.png" class="si_img" /></a>
</div>
</cfoutput>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cal_wd_week') & ' ' & CalculateRealStandardISOWeek(request.a_dt_current_date)) />

<cfset tmp = StartNewTabNavigation() />
<cfset a_arr_nav_items = AddTabNavigationItem(GetLangValJS('cal_ph_own_calendar'), 'javascript:ShowCalendarForUser(''#request.stSecurityContext.myuserkey#'');', '')> 

<!--- create structure containing all appointments for all users / resources  ... --->
<cfset a_struct_user_calendars = StructNew() />

<!--- start with own appointments ... --->
<cfset a_struct_user_calendars[request.stSecurityContext.myuserkey] = StructNew() />
<cfset a_struct_user_calendars[request.stSecurityContext.myuserkey].q_select_events = q_select_events />

<!--- load calendars of other users / resources? ... --->
<cfset a_str_load_other_persons_calendars_resources = GetUserPrefPerson('calendar', 'display.includeusercalendars', '', '', false) />

<!--- go through the list now and check if it a user or a resource ... --->
<cfloop list="#a_str_load_other_persons_calendars_resources#" delimiters="," index="a_str_userkey">

	<cfset a_bol_user_exists = application.components.cmp_user.UserkeyExists(userkey = a_str_userkey) />
	
	<cfif a_bol_user_exists>
		<!--- is a user ... --->
	
		<!--- add to nav struct --->
		<cfset tmp = AddTabNavigationItem(application.components.cmp_user.GetFullNameByentrykey(a_str_userkey), 'javascript:ShowCalendarForUser(''#a_str_userkey#'');', '') /> 

		<!--- load security context or use exising one ... --->
		<cfif NOT StructKeyExists(session.a_struct_other_securitycontext, a_str_userkey)>
	
			<!--- load securitycontext ... --->
			<cfset stReturn_userkey = application.components.cmp_security.GetSecurityContextStructure(userkey = a_str_userkey) />
			
			<cfset session.a_struct_other_securitycontext[a_str_userkey] = stReturn_userkey />
		<cfelse>
			<cfset stReturn_userkey = session.a_struct_other_securitycontext[a_str_userkey] />
		</cfif>		
		
		<!--- get usersettings of other user ... --->
		<cfset stReturn_usersettings = application.components.cmp_user.GetUsersettings(userkey = a_str_userkey) />
	
		<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="a_struct_user_return">
			<cfinvokeargument name="startdate" value="#a_dt_start#">
			<cfinvokeargument name="enddate" value="#DateAdd('d', 7, a_dt_start)#">
			<cfinvokeargument name="securitycontext" value="#stReturn_userkey#">
			<cfinvokeargument name="usersettings" value="#stReturn_usersettings#">
            <cfinvokeargument name="loadeventofsubscribedcalendars" value="false">
		</cfinvoke>
		
		<cfset a_struct_user_calendars[a_str_userkey] = a_struct_user_return />
		
		<cfset SelectMeetingMembersAtOnline.q_select_events = a_struct_user_return.q_select_events />
		<cfinclude template="utils/inc_select_meeting_members_at_once.cfm">		
		
	<cfelse>
		<!--- must be a resource! --->
		<cfset a_bol_resource_exists = application.components.cmp_resources.DoesResourceExists(securitycontext = request.stSecurityContext, entrykey = a_str_userkey) />
		
		<cfif a_bol_resource_exists>
			load "appointments" of this resource
			TODO hp: find a way to do that in an easy way
			<cfset tmp = AddTabNavigationItem(application.components.cmp_resources.GetResourcesByEntrykeys(a_str_userkey).title, 'javascript:ShowCalendarForUser(''#a_str_userkey#'');', '') /> 
		</cfif>
	
	</cfif>
</cfloop>

<cfif ListLen(a_str_load_other_persons_calendars_resources) GT 0>
	<!--- display "ALL" tab --->
	<cfset a_arr_nav_items = AddTabNavigationItem(GetLangValJS('cm_wd_all'), 'javascript:ShowCalendarForUser(''all'');', '') /> 
</cfif>

<!--- display further calendars --->
<cfset a_arr_nav_items = AddTabNavigationItem(GetLangValJS('cal_ph_add_user_calendars'), 'javascript:ShowDialogIncludeUserCalendar();', '') /> 

<!--- move request.stSecurityContext.myuserkey to first position ... --->
<cfset a_str_userkeys = StructKeyList(a_struct_user_calendars) />
<cfset ii = ListFindNoCase(a_str_userkeys, request.stSecurityContext.myuserkey) />
<cfset a_str_userkeys = ListDeleteAt(a_str_userkeys, ii) />
<cfset a_str_userkeys = ListPrepend(a_str_userkeys, request.stSecurityContext.myuserkey) />

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>

<cfloop list="#a_str_userkeys#" index="a_str_userkey" delimiters=",">

	<!--- use generic week display ... --->
	<cfset DisplayWeek = StructNew() />
	<cfset DisplayWeek.query = a_struct_user_calendars[a_str_userkey].q_select_events />
	<cfset DisplayWeek.Prefix = ReplaceNoCase(CreateUUID(), '-', '', 'ALL') />
	<cfset DisplayWeek.date_first_day = a_dt_start />

	<div style="display:;width:98%;margin-bottom:10px;" id="id_div_user_calendar_<cfoutput>#a_str_userkey#</cfoutput>" <cfif a_str_userkey NEQ request.stSecurityContext.myuserkey>class="b_all"<cfelse>class="bl br bb"</cfif>>
		<cfif a_str_userkey NEQ request.stSecurityContext.myuserkey>
			<div style="padding:4px; " class="mischeader">
				<cfoutput>
					
					<cfset q_select_user_data = application.components.cmp_user.GetUserData(userkey = a_str_userkey) />
					
					<cfif q_select_user_data.smallphotoavaliable IS 1>
						<img align="absmiddle" src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_user_data.entrykey)#" height="60">&nbsp;&nbsp;&nbsp;
					</cfif>
									
					<span style="font-weight:bold;">#application.components.cmp_user.getusernamebyentrykey(entrykey = a_str_userkey)#</span>
					&nbsp;&nbsp;&nbsp;
					<input type="button" class="btn" value="#GetLangVal('cm_wd_close_btn_caption')#" onclick="GotoLocHref('act_remove_usercalendar.cfm?userkey=#urlencodedformat(a_str_userkey)#');" />
				</cfoutput>
			</div>
		<cfelse>
			
		</cfif>
		
		<cfset DisplayWeek.userkey = a_str_userkey />
		<cfinclude template="inc_display_week_new.cfm">
	</div>
	
</cfloop>

<!--- add javascript ... containing information about displayed calendars --->
<cfsavecontent variable="a_str_js">
	<cfloop list="#a_str_userkeys#" index="a_str_userkey" delimiters=",">
	a_arr_currenty_displayed_calendars[a_arr_currenty_displayed_calendars.length] = '<cfoutput>#a_str_userkey#</cfoutput>';
	</cfloop>
</cfsavecontent>

<!--- show own calendar on load --->
<cfscript>
	AddJSToExecuteAfterPageLoad('ShowCalendarForUser("#request.stSecurityContext.myuserkey#")', a_str_js);
</cfscript>

<!--- //

	$Log: dsp_show_week.cfm,v $
	Revision 1.11  2007-09-04 00:53:35  hansjp
	use new security structure propertiesnew redirection methodremoved old JavaScript script language tag
	use new custom properties of user (e.g. name, address)
	update debug cfmails to notifyaddress stored in .properties fileuse new crmsalesbinding stored in securitycontextfixing several minor bugs

	Revision 1.10  2007-05-30 13:04:56  hansjp
	add new links and images

	Revision 1.9  2007-05-09 17:38:40  hansjp
	deleted old, unused files
	use new images

	Revision 1.8  2007/04/14 00:05:06  hansjp
	updated participants viewadded new code for selecting other user calendarsadded various todos for hansjpreformatted list viewreformatted create/edit form (plus added ajax code)
	
	Revision 1.7  2007/03/13 15:10:43  hansjp
	filtering selected virtualcalendars in getEventsFromTo calls
	
	// --->