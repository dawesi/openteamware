<!--- //



	get notes data

	

	// --->

	

<cfinclude template="queries/q_select_scratchpad_full_data.cfm">



<result recordcount="<cfoutput>#q_select_scratchpad_full_data.recordcount#</cfoutput>">

<cfoutput query="q_select_scratchpad_full_data">



<!--- add text to the body of the item? --->

<cfset a_str_body = trim(q_select_scratchpad_full_data.notice)>



 <entry>

  <outlook_id>#urlencodedformat(q_select_scratchpad_full_data.outlook_id)#</outlook_id>

  <inboxcc_entrykey>#urlencodedformat(q_select_scratchpad_full_data.entrykey)#</inboxcc_entrykey>

  <Subject>#urlencodedformat(a_str_body)#</Subject> 

  <body>#urlencodedformat(a_str_body)#</body>

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

  <Categories/> 

  <start></start> 

  <End></End> 

  <Location></Location> 

  <Sensitivity/> 

  <status/> 

  <PercentComplete/> 

  <Importance>1</Importance> 

  <BusyStatus>2</BusyStatus> 

  <IsRecurring>0</IsRecurring> 

  <ReminderSet>0</ReminderSet> 

  <ReminderMinutesBeforeStart>15</ReminderMinutesBeforeStart> 

  <RecurrenceType></RecurrenceType> 

  <PatternEndDate/> 

  <DayOfMonth/> 

  <DayOfWeekMask/> 

  <HomeFaxNumber/> 

  </entry>

</cfoutput>

</result>