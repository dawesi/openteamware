<!--- //

	Module:		Calendar
	Description:Main controller file
	
	Header:		

// --->

<cfinclude template="/login/check_logged_in.cfm">

<!--- params ... --->
<cfparam name="url.date" default="" type="string" />
<cfparam name="url.filter" default="0" />
<cfparam name="url.printmode" default="false" type="boolean" />

<!--- select day start/end data ... --->
<cfset a_int_day_starthour = GetUserPrefPerson('calendar', 'calendar.daystarthour', '8', '', false) />
<cfset a_int_day_endhour = GetUserPrefPerson('calendar', 'calendar.dayendhour', '18', '', false) />
<cfset a_str_virtual_calendar_filter = GetUserPrefPerson('calendar', 'calendar.virtualcalendarfilter', 'default', '', false) />

<!--- get default action ... if not defined, start with view week ... --->
<cfset url.action = GetUserPrefPerson('calendar', 'calstartview_action', 'ViewWeek', 'url.action', false) />

<cfset request.a_int_day_starthour = a_int_day_starthour />
<cfset request.a_int_day_endhour = a_int_day_endhour />
<cfset request.a_str_virtual_calendar_filter = a_str_virtual_calendar_filter />
	
<cfinclude template="utils/inc_select_display_settings.cfm">

<!--- load the current data ... ACurrentDate will always hold the current date ...--->
<cfif len(url.date) GT 0>
	
	<!--- we should display something with the last date selected ... check if this is available ... --->
	<cfif url.date IS 'lastdate'>
	
		<cfset a_str_last_shown_date = GetUserPrefPerson('calendar', 'display.last_date_shown', '', '', false) />
		
		<cfif Len(a_str_last_shown_date) GT 0 AND IsDate(a_str_last_shown_date)>
			<cfset url.date = a_str_last_shown_date />
		</cfif>
	
	</cfif>
	
	<cftry>
		<cfset GetLocale() />
		<cfset SetLocale("English (US)") />
		<cfset ACurrentDate = LSParseDatetime(url.date) />
		<cfset SetLocale(tmp) />
		<!--- date --->
	<cfcatch type="Any">
		<cfset url.date = dateformat(now(), "m/dd/yyyy") />
		<cfset ACurrentDate = CreateDateTime(year(now()), month(now()), day(now()), 0, 0, 0) />
	</cfcatch>
	</cftry>
<cfelse>
	<!--- use today --->
	<cfset url.date = dateformat(now(), "m/dd/yyyy") />
	<cfset ACurrentDate = CreateDateTime(year(now()), month(now()), day(now()), 0, 0, 0) />
</cfif>

<!--- set the current date object of the request scope ... --->
<cfset request.a_dt_current_date = ACurrentDate />
<cfset request.a_dt_utc_current_date = GetUTCTimeFromUserTime(ACurrentDate) />

<!--- store the last used date as personal preference ... --->
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.last_date_shown"
	entryvalue1 = #url.date#>

<cfset request.q_select_my_or_subscribed_virtual_calendars = application.components.cmp_calendar.GetMyOrSubscribedCalendars(request.stSecurityContext.myuserkey) />

<cfif url.printmode>
	<!--- do not reload frameset --->
	<cfset url.showaspopup = 1 />
	<cfset request.a_struct_current_service_action.setservice = false />
	<cfset request.a_struct_current_service_action.checkframeset = false />	
</cfif>

<cfoutput>#GetRenderCmp().GenerateServiceDefaultFile(servicekey = '5222B55D-B96B-1960-70BF55BD1435D273',
										pagetitle = GetLangVal('cm_wd_calendar'))#</cfoutput>

<cfif url.printmode>
	<script type="text/javascript">
		function UpdateHeights() {
			return true;
			}
		window.print();
	</script>
</cfif>	

