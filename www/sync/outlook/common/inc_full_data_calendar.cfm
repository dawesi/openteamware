<!--- //



	get calendar data

	

	// --->

	

<cfinclude template="queries/q_select_cal_full_data.cfm">



<result recordcount="<cfoutput>#q_select_cal_full_data.recordcount#</cfoutput>">

<cfoutput query="q_select_cal_full_data">
<cfset a_str_dt_start = DateFormat(q_select_cal_full_data.date_Start, "dd.mm.yyyy")&" "&TimeFormat(q_select_cal_full_data.date_Start, "HH:mm:ss")>
<cfset a_str_dt_end = DateFormat(q_select_cal_full_data.date_end, "dd.mm.yyyy")&" "&TimeFormat(q_select_cal_full_data.date_end, "HH:mm:ss")>

<cfif q_select_cal_full_data.date_end lt q_select_cal_full_data.date_Start>
	<!--- this is invalid!! --->
	<cfset a_dt_end_tmp = DateAdd("h", 1, q_select_cal_full_data.date_Start)>
	<cfset a_str_dt_end = DateFormat(a_dt_end_tmp, "dd.mm.yyyy")&" "&TimeFormat(a_dt_end_tmp, "HH:mm:ss")>
</cfif>

<cfif isdate(q_Select_cal_full_data.repeat_until)>
	<cfset a_str_dt_repeat_until = DateFormat(q_select_cal_full_data.repeat_until, "dd.mm.yyyy")&" "&TimeFormat(q_select_cal_full_data.repeat_until, "HH:mm:ss")>
<cfelse>
	<cfset a_str_dt_repeat_until = "">
</cfif>

<!--- add text to the body of the item? --->
<cfset a_str_body = trim(q_select_cal_full_data.description)>

 <entry>
  <outlook_id>#urlencodedformat(q_select_cal_full_data.outlook_id)#</outlook_id>
  <inboxcc_entrykey>#urlencodedformat(q_select_cal_full_data.entrykey)#</inboxcc_entrykey>
  <Subject>#urlencodedformat(q_select_cal_full_data.title)#</Subject> 
  <Body>#urlencodedformat(a_str_body)#</Body> 
  <Firstname/> 
  <Surname/> 
  <FileAs/> 
  <Email1Address/> 
  <LastModificationTime/> 
  <EntryID></EntryID> 
  <CompanyName/> 
  <Department/> 
  <jobTitle/> 
  <BusinessAddressCity/> 
  <BusinessAddressCountry/> 
  <BusinessAddressStreet/> 
  <BusinessAddressPostalCode/> 
  <BusinessTelephoneNumber/> 
  <BusinessFaxNumber/> 
  <HomeAddressCity/> 
  <HomeAddressCountry/> 
  <HomeAddressStreet/> 
  <HomeAddressPostalCode/> 
  <HomeTelephoneNumber/> 
  <Home2TelephoneNumber/> 
  <MobileTelephoneNumber/> 
  <Birthday/> 
  <Webpage></Webpage> 
  <Categories>#urlencodedformat(q_select_cal_full_data.categories)#</Categories> 
  <start>#urlencodedformat(a_str_dt_start)#</start> 
  <End>#urlencodedformat(a_str_dt_end)#</End> 
  <Location>#urlencodedformat(q_select_cal_full_data.location)#</Location> 
  <Sensitivity>#Val(q_select_cal_full_data.privateevent)#</Sensitivity>
  <status/> 
  <PercentComplete/> 
  <Importance>2</Importance> 
  <BusyStatus>2</BusyStatus> 
  <IsRecurring><cfif val(q_select_cal_full_data.repeat_type) gt 0>1<cfelse>0</cfif></IsRecurring> 
  <ReminderSet>0</ReminderSet> 
  <ReminderMinutesBeforeStart>15</ReminderMinutesBeforeStart> 
  <RecurrenceType>#val(q_select_cal_full_data.repeat_type)#</RecurrenceType> 
  <PatternEndDate>#urlencodedformat(a_str_dt_repeat_until)#</PatternEndDate> 
  <DayOfMonth></DayOfMonth> 
  <DayOfWeekMask>#val(q_select_cal_full_data.repeat_weekday)#</DayOfWeekMask>
  <Interval></Interval>
  <DayOfMonth>#val(q_select_cal_full_data.repeat_day)#</DayOfMonth>
  <MonthOfYear>#val(q_select_cal_full_data.repeat_month)#</MonthOfYear>
  <Instance></Instance>
  <repeatday1>#val(q_select_cal_full_data.repeat_day_1)#</repeatday1>
  <repeatday2>#val(q_select_cal_full_data.repeat_day_2)#</repeatday2>
  <repeatday3>#val(q_select_cal_full_data.repeat_day_3)#</repeatday3>
  <repeatday4>#val(q_select_cal_full_data.repeat_day_4)#</repeatday4>
  <repeatday5>#val(q_select_cal_full_data.repeat_day_5)#</repeatday5>
  <repeatday6>#val(q_select_cal_full_data.repeat_day_6)#</repeatday6>
  <repeatday7>#val(q_select_cal_full_data.repeat_day_7)#</repeatday7>
  <HomeFaxNumber/> 
  </entry>
</cfoutput>
</result>