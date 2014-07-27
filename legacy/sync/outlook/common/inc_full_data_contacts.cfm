<!--- //



	get calendar data

	

	// --->

	

<cfinclude template="queries/q_select_contacts_full_data.cfm">



<result recordcount="<cfoutput>#q_select_contacts_full_data.recordcount#</cfoutput>">

<cfoutput query="q_select_contacts_full_data">

<cfif Len(trim(q_select_contacts_full_data.birthday)) gt 0 AND IsDate(q_select_contacts_full_data.birthday)>
	<cfset a_str_dt_birthday = DateFormat(q_select_contacts_full_data.birthday, "dd.mm.yyyy")&" "&TimeFormat(q_select_contacts_full_data.birthday, "HH:mm:ss")>
<cfelse>
	<cfset a_str_dt_birthday = ''>
</cfif>

<!--- speichern des eintrages unter ... --->
<cfset a_str_fileas = trim(q_select_contacts_full_data.firstname&' '&q_select_contacts_full_data.surname)>

<!--- add text to the body of the item? --->
<cfset a_str_body = trim(q_select_contacts_full_data.notice)>

 <entry>
  <outlook_id>#urlencodedformat(q_select_contacts_full_data.outlook_id)#</outlook_id>
  <inboxcc_entrykey>#urlencodedformat(q_select_contacts_full_data.entrykey)#</inboxcc_entrykey>
  <Subject>#urlencodedformat(a_str_fileas)#</Subject> 
  <Body>#urlencodedformat(a_str_body)#</Body> 
  <Firstname>#urlencodedformat(q_select_contacts_full_data.firstname)#</Firstname>
  <Surname>#urlencodedformat(q_select_contacts_full_data.surname)#</Surname>
  <FileAs>#urlencodedformat(a_str_fileas)#</FileAs>
  <Email1Address>#urlencodedformat(q_select_contacts_full_data.email_prim)#</Email1Address>
  <Email2Address>#urlencodedformat(q_select_contacts_full_data.email_adr)#</Email2Address>
  <LastModificationTime/> 
  <EntryID>#urlencodedformat(q_select_contacts_full_data.outlook_id)#</EntryID> 
  <CompanyName>#urlencodedformat(q_select_contacts_full_data.company)#</CompanyName>
  <Department>#urlencodedformat(q_select_contacts_full_data.department)#</Department> 
  <jobTitle>#urlencodedformat(q_select_contacts_full_data.aposition)#</jobTitle> 
  <BusinessAddressCity>#urlencodedformat(q_select_contacts_full_data.b_city)#</BusinessAddressCity> 
  <BusinessAddressCountry>#urlencodedformat(q_select_contacts_full_data.b_country)#</BusinessAddressCountry>
  <BusinessAddressStreet>#urlencodedformat(q_select_contacts_full_data.b_street)#</BusinessAddressStreet>
  <BusinessAddressPostalCode>#urlencodedformat(q_select_contacts_full_data.b_zipcode)#</BusinessAddressPostalCode>
  <BusinessTelephoneNumber>#urlencodedformat(q_select_contacts_full_data.b_telephone)#</BusinessTelephoneNumber>
  <BusinessFaxNumber>#urlencodedformat(q_select_contacts_full_data.b_fax)#</BusinessFaxNumber>
  <HomeAddressCity>#urlencodedformat(q_select_contacts_full_data.p_city)#</HomeAddressCity>
  <HomeAddressCountry>#urlencodedformat(q_select_contacts_full_data.p_country)#</HomeAddressCountry>
  <HomeAddressStreet>#urlencodedformat(q_select_contacts_full_data.p_street)#</HomeAddressStreet>
  <HomeAddressPostalCode>#urlencodedformat(q_select_contacts_full_data.p_zipcode)#</HomeAddressPostalCode>
  <HomeTelephoneNumber>#urlencodedformat(q_select_contacts_full_data.p_telephone)#</HomeTelephoneNumber>
  <Home2TelephoneNumber>#urlencodedformat(q_select_contacts_full_data.p_mobile)#</Home2TelephoneNumber>
  <HomeFaxNumber>#urlencodedformat(q_select_contacts_full_data.p_fax)#</HomeFaxNumber>
  <MobileTelephoneNumber>#urlencodedformat(q_select_contacts_full_data.b_mobile)#</MobileTelephoneNumber>
  <Birthday>#urlencodedformat(a_str_dt_birthday)#</Birthday> 
  <Webpage>#urlencodedformat(q_select_contacts_full_data.b_url)#</Webpage> 
  <Categories>#urlencodedformat(q_select_contacts_full_data.categories)#</Categories> 
  <start></start> 
  <End></End> 
  <Location></Location> 
  <Sensitivity>#q_select_contacts_full_data.privatecontact#</Sensitivity>
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
  </entry>
</cfoutput>
</result>