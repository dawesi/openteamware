<!--- //

	Module:        Calendar
	Description:   Display the week with all events, all data are passed by DisplayWeek scope
	

// --->
	
<cfparam name="DisplayWeek.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="DisplayWeek.query" type="query">
<cfparam name="DisplayWeek.Prefix" type="string" default="abc">
<cfparam name="DisplayWeek.start_hour" type="numeric" default="8">
<cfparam name="DisplayWeek.end_hour" type="numeric" default="18">
<!--- date of first day of the week --->
<cfparam name="DisplayWeek.date_first_day" type="numeric" default="18">
<!--- monday vs sunday --->
<cfparam name="DisplayWeek.FirstDayOfTheWeek" type="numeric" default="1">

<cfset a_tmp_array_dates_week = ArrayNew(1)>
<cfloop from="1" to="7" index="a_int_day">
	<cfset a_tmp_array_dates_week[a_int_day] = DateAdd('d', a_int_day, DisplayWeek.date_first_day)>
</cfloop>

<cfset a_tmp_array_dates_week_num = ArrayNew(1)>
<cfloop from="1" to="7" index="a_int_day">
	<cfset a_tmp_array_dates_week_num[a_int_day] = DateFormat(a_tmp_array_dates_week[a_int_day], 'yyyymmdd')>
</cfloop>


<table class="table_overview">
	<tr class="tbl_overview_header mischeader">
		<td width="50px" style="vertical-align:middle;text-align:center;" class="addinfotext">h</td>
		<cfloop from="#DisplayWeek.FirstDayOfTheWeek#" to="7" index="a_int_day">
		
			<cfset a_bol_is_today = (CompareNoCase(DateFormat(a_tmp_array_dates_week[a_int_day], 'ddmmyyyyy'), DateFormat(Now(), 'ddmmyyyyy')) IS 0)>

			<td align="center" <cfif a_bol_is_today>class="mischeader"</cfif> style="line-height:18px;">
				<cfoutput>
				<a href="default.cfm?action=ViewDay&Date=#DateFormat(a_tmp_array_dates_week[a_int_day], 'mm/dd/yyyy')#">
					#LsDateFormat(a_tmp_array_dates_week[a_int_day], 'dddd')#
					<cfif a_bol_is_today>
						(#GetLangVal('cal_wd_today')#)
					</cfif>
					<br />
					#LsDateFormat(a_tmp_array_dates_week[a_int_day], 'dd.mm.')#
				</a>
				</cfoutput>
			</td>
		</cfloop>
	</tr>
	
	<!--- 24h events --->
	<tr>
		<td valign="top" align="center" class="addinfotext br mischeader">
			24h
		</td>
		<cfloop from="1" to="7" index="a_int_day">
			<cfset a_tmp_display = DateAdd('d', a_int_day, a_dt_start)>
			<cfset a_int_start_num = DateFormat(a_tmp_display, 'yyyymmdd') & '24h'>
					
			<td id="id_td_date_<cfoutput>#DisplayWeek.Prefix#_#a_int_start_num#</cfoutput>">&nbsp;
				
			</td>
		</cfloop>
	</tr>		
	<!--- events before the main hours --->
	<tr>
		<td align="center" width="50px" class="addinfotext br mischeader" style="white-space:normal;">
			&lt; <cfoutput>#DisplayWeek.start_hour#</cfoutput>
		</td>
		<cfloop from="#DisplayWeek.FirstDayOfTheWeek#" to="7" index="a_int_day">
			<cfset a_int_start_num = a_tmp_array_dates_week_num[a_int_day] & '0000'>
					
			<td id="id_td_date_<cfoutput>#DisplayWeek.Prefix#_#a_int_start_num#</cfoutput>"></td>
		</cfloop>
	</tr>
	<!--- events within the main hours --->
	<cfloop from="#DisplayWeek.start_hour#" to="#DisplayWeek.end_hour#" index="a_int_hour">
	<tr>
		<td width="50" align="center" class="br addinfotext mischeader">
			<cfoutput>#a_int_hour#</cfoutput><sup>00</sup>
		</td>
		<cfloop from="#DisplayWeek.FirstDayOfTheWeek#" to="7" index="a_int_day">
			
			<cfif Len(a_int_hour) IS 1>
				<cfset a_int_hour = '0' & a_int_hour>
			</cfif>
			<cfset a_int_start_num = a_tmp_array_dates_week_num[a_int_day] & a_int_hour & '00'>
			<td width="14%" id="id_td_date_<cfoutput>#DisplayWeek.Prefix#_#a_int_start_num#</cfoutput>"></td>
		</cfloop>
	</tr>
	</cfloop>
	<!--- events after the main hours --->
	<tr>
		<td align="center" class="addinfotext br mischeader" style="white-space:nowrap;">
			&gt; <cfoutput>#DisplayWeek.end_hour#</cfoutput>
		</td>
		<cfloop from="#DisplayWeek.FirstDayOfTheWeek#" to="7" index="a_int_day">
			<cfset a_int_start_num = a_tmp_array_dates_week_num[a_int_day] & '9999'>
					
			<td id="id_td_date_<cfoutput>#DisplayWeek.Prefix#_#a_int_start_num#</cfoutput>"></td>
		</cfloop>
	</tr>
</table>



<div id="id_div_cal_short_info" style="display:none;line-height:20px; "></div>

<!--- array holding the information about the items to place in grid --->
<cfset a_arr_events_to_place = ArrayNew(1)>
<cfset a_arr_events_info = ArrayNew(1)>

<cfset a_arr_js_events_info = ArrayNew(1)>

<cfoutput query="DisplayWeek.query">

	<!--- every (!) events gets an unique key ... --->
	<cfset a_str_eventkey_js = CreateUUIDJS()>
	
	<!--- foreign private event? --->
	<cfset a_bol_is_foreign_private_event = (DisplayWeek.userkey NEQ request.stSecurityContext.myuserkey) AND (DisplayWeek.query.privateevent IS 1)>

	<!--- display in hour, or special? --->
	<cfif Hour(DisplayWeek.query.date_start) LT DisplayWeek.start_hour>
		<cfset a_int_start_num = dateFormat(DisplayWeek.query.date_start, 'yyyymmdd') & '0000'>
	<cfelseif Hour(DisplayWeek.query.date_start) GT DisplayWeek.end_hour>
		<cfset a_int_start_num = dateFormat(DisplayWeek.query.date_start, 'yyyymmdd') & '9999'>
	<cfelse>
		<!--- ok, leave default --->
		<cfset a_int_start_num = dateFormat(DisplayWeek.query.date_start, 'yyyymmdd') & TimeFormat(DisplayWeek.query.date_start, 'HH') & '00'>
	</cfif>	
	
	<cfset a_int_end_num = dateFormat(DisplayWeek.query.date_end, 'yyyymmdd') & TimeFormat(DisplayWeek.query.date_end, 'HH') & '00'>
	
	<cfset a_str_css_bg_color = ''>
	<!--- background-color --->
	<cfif Len(DisplayWeek.query.color) GT 0>
		<cfset a_str_css_bg_color = 'border:' & DisplayWeek.query.color & ' solid 2px;'>
	</cfif>
	
	<cfset a_str_js_start = LsDateFormat(DisplayWeek.query.date_start, request.stUserSettings.default_dateformat) & ' ' & TimeFormat(DisplayWeek.query.date_start, request.stUserSettings.default_timeformat)>
	<cfset a_str_js_end = LsDateFormat(DisplayWeek.query.date_end, request.stUserSettings.default_dateformat) & ' ' & TimeFormat(DisplayWeek.query.date_end, request.stUserSettings.default_timeformat)>
	
	<!--- private? --->
	<cfif DisplayWeek.query.privateevent IS 1>
		<cfset a_str_private_event = GetLangVal('cal_wd_private') & ': ' & GetLangVal('cm_wd_yes')>
	<cfelse>
		<cfset a_str_private_event = ''>
	</cfif>
	
	
	<!--- add to array holding information about all events --->
	<cfsavecontent variable="a_str_js_array">
	<!--- paramters: prefix,uniquekey,entrykey,title,startnum,start,end,description,location,private,addinfo --->
	AddCalendarShortinfo('#jsstringformat(DisplayWeek.Prefix)#', '#jsstringformat(a_str_eventkey_js)#', '#jsstringformat(DisplayWeek.query.entrykey)#', '#jsstringformat(DisplayWeek.query.title)#', '#a_int_start_num#', '#jsstringformat(a_str_js_start)#', '#jsstringformat(a_str_js_end)#', '#jsstringformat(DisplayWeek.query.description)#', '#jsstringformat(DisplayWeek.query.location)#', '#jsstringformat(a_str_private_event)#', '');
	</cfsavecontent>
	
	<!--- set js content --->
	<cfset a_arr_js_events_info[DisplayWeek.query.currentrow] = a_str_js_array>
	
	<div class="mischeader" id="id_event_#DisplayWeek.Prefix#_#a_str_eventkey_js#" style="padding:3px;display:none;#a_str_css_bg_color#">
		<cfif a_bol_is_foreign_private_event>
			#GetLangVal('cm_wd_private')#
		<cfelse>
			<a id="id_link_#DisplayWeek.Prefix#_#a_str_eventkey_js#" onClick="SetCurrentlySelectedEvent(this, '#a_str_eventkey_js#');ShowHTMLActionPopup(this.id, 'id_div_cal_short_info');return false;" href="##">#htmleditformat(ShortenString(DisplayWeek.query.title, 25))#</a>
		</cfif>
	</div>
	
	<script type="text/javascript">
    <!--- clone the event also to 24h row if the event lasts more than one day --->
    <cfif DateDiff("d", DisplayWeek.query.date_start, DisplayWeek.query.date_end) GT 0>
        <cfset a_int_twentyfour_start_num = DateFormat(DisplayWeek.query.date_start, 'yyyymmdd')>
        <cfif DisplayWeek.query.date_start LT a_tmp_array_dates_week[1]>
            <cfset a_int_twentyfour_start_num = DateFormat(a_tmp_array_dates_week[1], 'yyyymmdd')>
        </cfif>
        $('##id_td_date_#DisplayWeek.Prefix#_#a_int_twentyfour_start_num#24h').append('<div>' + $('##id_event_#DisplayWeek.Prefix#_#a_str_eventkey_js#').html() + '</div>');

        
        <cfset a_int_twentyfour_end_num = DateFormat(DisplayWeek.query.date_end, 'yyyymmdd')>
        <cfif DisplayWeek.query.date_end GT a_tmp_array_dates_week[7]>
            <cfset a_int_twentyfour_end_num = DateFormat(a_tmp_array_dates_week[7], 'yyyymmdd')>
        </cfif>
	    <!--- fill the 24hour cell which are within this event --->
	    <cfloop from="#a_int_twentyfour_start_num#" to="#a_int_twentyfour_end_num#" index="a_loop_day">
        	$('##id_td_date_#DisplayWeek.Prefix#_#a_loop_day#24h').addClass('mischeader');
        </cfloop>
    </cfif>
    <!--- fill the cells which are within this event --->
	<cfloop from="#a_int_start_num#" to="#a_int_end_num#" index="ii" step="100">
    	$('##id_td_date_#DisplayWeek.Prefix#_#ii#').addClass('mischeader');
	</cfloop>
	</script>
	
	<cfset a_arr_events_to_place[DisplayWeek.query.currentrow] = StructNew()>
	<cfset a_arr_events_to_place[DisplayWeek.query.currentrow].int_start_num = a_int_start_num>
	<cfset a_arr_events_to_place[DisplayWeek.query.currentrow].color = ''>
	<cfset a_arr_events_to_place[DisplayWeek.query.currentrow].uniquekey = a_str_eventkey_js>
	<cfset a_arr_events_to_place[DisplayWeek.query.currentrow].currentrow = DisplayWeek.query.currentrow>
	
</cfoutput>

<!--- generate fn name ... there might exist other functions with the same name as well! --->
<cfset a_str_js_fn_name = 'PlaceEvents' & CreateUUIDJS()>

<cfsavecontent variable="a_str_js">
<cfoutput>
	function #a_str_js_fn_name#() {
	
		// drop info and place event in grid ...
		<cfloop from="1" to="#ArrayLen(a_arr_events_to_place)#" index="ii">
		#a_arr_js_events_info[ii]#
		PlaceEventInGrid('#a_arr_events_to_place[ii].int_start_num#', '#DisplayWeek.Prefix#', '#a_arr_events_to_place[ii].uniquekey#', '#jsstringformat(a_arr_events_to_place[ii].color)#');
		</cfloop>
		}
</cfoutput>
</cfsavecontent>

<!--- add js --->
<cfscript>
	AddJSToExecuteAfterPageLoad('#a_str_js_fn_name#()', a_str_js);
</cfscript>

