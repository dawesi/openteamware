<!--- //

	Module:        Calendar
	Description:   Left include file
	

// --->

<cfset a_str_link_date = urlencodedformat(dateformat(request.a_dt_current_date, "m/dd/yyyy")) />
<cfset a_str_dt_yourdate_prev = urlencodedformat(dateformat(DateAdd("d", "-1", request.a_dt_current_date), "m/dd/yyyy")) />
<cfset a_astr_dt_yourdate_next = urlencodedformat(dateformat(DateAdd("d", "1", request.a_dt_current_date), "m/dd/yyyy")) />

<div class="divleftnavigation_center">

<form action="rd_goto_date.cfm" name="formgotodate_left" method="post" style="margin:0px; ">

<div class="divleftnavpanelactions">
						
	<cfoutput>
	
	
	<cfset a_dt_prev_month =  Dateadd('m', '-1', request.a_dt_current_date) />
	<cfset a_dt_prev_month = CreateDate(year(a_dt_prev_month), month(a_dt_prev_month), 1) />

	<cfset a_dt_next_month =  Dateadd("m", 1, request.a_dt_current_date) />
	<cfset a_dt_next_month = CreateDate(year(a_dt_next_month), month(a_dt_next_month), 1) />
	
	
	<cfset a_int_month_number = Month(request.a_dt_current_date) />

	<div class="divleftnavpanelheader" style="white-space:nowrap">
		<a href="index.cfm?action=ViewMonth&Date=#A_str_link_date#">#LsDateFormat(CreateDate(1900, a_int_month_number, 1), "mmmm")# #Year(request.a_dt_current_date)#
		<div style="padding:0px;margin-top:10px;">
		<a href="index.cfm?action=ViewDay&Date=#a_str_dt_yourdate_prev#"><img src="/images/si/resultset_previous.png" class="si_img" /></a>
		<a href="index.cfm?action=ViewDay&Date=#A_str_link_date#" style="font-size : 14px;font-weight : bold;">#trim(LSdateformat(request.a_dt_current_date, "ddd, dd.mm."))#</a>
		<a href="index.cfm?action=ViewDay&Date=#a_astr_dt_yourdate_next#"><img src="/images/si/resultset_next.png" class="si_img" /></a>
		</div>
	</div>
	
	<cfset a_str_today_is = GetLangVal('cal_ph_today_is_left_nav') />
	<cfset a_str_today_is = ReplaceNoCase(a_str_today_is, '%DATE%', Day(Now()) & '. ' & LsDateFormat(Now(), 'mmmm')) />
	<ul class="divleftpanelactions">
		<ul class="divleftpanelactions">
			<li>
				<a href="index.cfm?action=ViewDay"><cfoutput>#a_str_today_is#</cfoutput></a>
			</li>
		</ul>
	</ul>
	<ul class="divleftpanelactions">
	<li class="li_a_small">
		
		<cfset a_int_firstday = 1>
		
		<cfset DisplayCalendarMonthRequest.dt_display = request.a_dt_current_date />
		<cfinclude template="mod_create_cal_nav_month.cfm">
		
	</li>
	<li>
		<div>
			<input type="text" name="id_text_cal_goto_date" id="id_text_cal_goto_date" value="<cfoutput>#LSDateFormat(request.a_dt_current_date, request.stUserSettings.default_dateformat)#</cfoutput>" style="width:80px" />
			<img src="/images/si/calendar_view_day.png" class="si_img" />
			
			<cfsavecontent variable="a_str_js">$('##id_text_cal_goto_date').calendar();</cfsavecontent>
			
			<cfscript>
				AddJSToExecuteAfterPageLoad('', a_str_js);
			</cfscript>
		</div>
	</li>
	</ul>
	<div class="divleftnavpanelheader">
		<cfoutput>#GetLangVal('cal_wd_view')#</cfoutput>
	</div>
	<ul class="divleftpanelactions">
	<li class="li_a_small">
		
		<table>
			<tr>
				<td>
					<a href="index.cfm?action=Overview&Date=">#GetLangVal('cal_wd_today')#</a>
				</td>
				<td>
					<a href="index.cfm?action=ViewDay&Date=#A_str_link_date#">#GetLangVal('cal_wd_day')#</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="index.cfm?action=ViewWeek&Date=#A_str_link_date#">#GetLangVal('cal_wd_week')#</a>
				</td>
				<td>
					<a href="index.cfm?action=ViewMonth&Date=#A_str_link_date#">#GetLangVal('cal_wd_month')#</a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="index.cfm?action=ViewYear&Date=#A_str_link_date#">#GetLangVal('cal_wd_year')#</a>
				</td>
				<td>
					<a href="index.cfm?action=ListEvents&Date=#A_str_link_date#">#GetLangVal('cal_wd_list')#</a>
				</td>
			</tr>
		</table>
	
	
	</li>
	</ul>
	
	<div class="divleftnavpanelheader">
		<cfoutput>#GetLangVal('cal_wd_calendars')#</cfoutput>
	</div>
	<ul class="divleftpanelactions">				
	<li>
		
	<div>
		<input type="checkbox" name="frmvirtualcalendar" value="default" onclick="return refreshCalendarView(this.form)" 
            <cfif find('default', request.a_str_virtual_calendar_filter)>checked="checked"</cfif>
            <cfif request.q_select_my_or_subscribed_virtual_calendars.recordCount EQ 0>disabled="disabled"</cfif> />
		
		<span style="background-color:white;height:10px;width:20px;">
			<img src="/images/space_1_1.gif" width="10px" />
		</span>
		&nbsp;<cfoutput>#GetLangVal('cm_wd_default')#</cfoutput>
	</div>
	<cfloop query="request.q_select_my_or_subscribed_virtual_calendars">
		<div>
			<input type="checkbox" name="frmvirtualcalendar" value="#request.q_select_my_or_subscribed_virtual_calendars.entrykey#" onclick="return refreshCalendarView(this.form)" <cfif find(request.q_select_my_or_subscribed_virtual_calendars.entrykey, request.a_str_virtual_calendar_filter)>checked="checked"</cfif>/>
			
			<span style="background-color:#request.q_select_my_or_subscribed_virtual_calendars.colour#;height:10px;width:20px;">
				<img src="/images/space_1_1.gif" width="10px" />
			</span>
			&nbsp;
			#htmleditformat(request.q_select_my_or_subscribed_virtual_calendars.title)#
		</div>
	</cfloop>

	</li>	
	<li>
		<a href="index.cfm?action=VirtualCalendars"><cfoutput>#MakeFirstCharUCase(getLangVal('cm_wd_edit'))#</cfoutput></a>
	</li>	
	</ul>
	
	<div class="divleftnavpanelheader">
		<cfoutput>#GetLangVal('cm_wd_extras')#</cfoutput>
	</div>
	<ul class="divleftpanelactions">	
	<li>
		<a href="/assistants/import/">#GetLangVal('cal_ph_outlook_sync')#</a>
	</li>
	<li>
		<a href="index.cfm?action=invitations" target="_blank">#GetLangVal('cal_wd_invitations')#</a>
	</li>
	<li>
		<a href="index.cfm?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'printmode', 'true')#" target="_blank">#GetLangVal('cal_ph_top_printversion')#</a>
	</li>
	</ul>
	
	</cfoutput>
	

	</div>	

</div>

</form>


