<!--- //
	load full data of tasks
	// --->
	
	<!---OlTaskStatus-Konstanten sind möglich: 
	olTaskComplete(2), 
	olTaskDeferred(4), 
	olTaskInProgress(1), 
	olTaskNotStarted(0) oder 
	olTaskWaiting(3).
	
	olImportanceHigh(2), olImportanceLow(0) oder olImportanceNormal(1).--->
	




<cfinclude template="queries/q_select_tasks_full_data.cfm">

<result recordcount="<cfoutput>#q_select_tasks_full_data.recordcount#</cfoutput>">
<cfoutput query="q_select_tasks_full_data">

<cfif isDate(q_select_tasks_full_data.dt_due)>
	<cfset a_str_dt_due = DateFormat(q_select_tasks_full_data.dt_due, "dd.mm.yyyy")&" "&TimeFormat(q_select_tasks_full_data.dt_due, "HH:mm:ss")>
<cfelse>
	<cfset a_str_dt_due = ''>
</cfif>

<!--- add text to the body of the item? --->
<cfset a_str_body = trim(q_select_tasks_full_data.notice)>

<!--- select the name of the workgroup --->
 <entry>
  <outlook_id>#urlencodedformat(q_select_tasks_full_data.outlook_id)#</outlook_id>
  <inboxcc_entrykey>#urlencodedformat(q_select_tasks_full_data.entrykey)#</inboxcc_entrykey>
  <Subject>#urlencodedformat(q_select_tasks_full_data.title)#</Subject> 
  <body>#urlencodedformat(a_str_body)#</body>
  <FileAs/> 
  <LastModificationTime/> 
  <EntryID></EntryID> 
  <Categories>#urlencodedformat(trim(q_select_tasks_full_data.categories))#</Categories>
  <Sensitivity/> 
  <duedate>#urlencodedformat(a_str_dt_due)#</duedate>
  <status>#urlencodedformat(q_select_tasks_full_data.status)#</status> 
  <PercentComplete>#urlencodedformat(q_select_tasks_full_data.percentdone)#</PercentComplete> 
  <Importance>#urlencodedformat(q_select_tasks_full_data.priority)#</Importance> 
  <BusyStatus></BusyStatus> 
  <IsRecurring></IsRecurring> 
  <ReminderSet></ReminderSet> 
  <ReminderMinutesBeforeStart></ReminderMinutesBeforeStart> 
  <RecurrenceType></RecurrenceType> 
  <PatternEndDate/> 
  <DayOfMonth/> 
  <DayOfWeekMask/> 
  <HomeFaxNumber/> 
  <Milage>#urlencodedformat(trim(q_select_tasks_full_data.mileage))#</Milage>
  <billinginformation>#urlencodedformat(q_select_tasks_full_data.billinginformation)#</billinginformation>
  <totalwork>#urlencodedformat(trim(q_select_tasks_full_data.totalwork))#</totalwork>
  <actualwork>#urlencodedformat(trim(q_select_tasks_full_data.actualwork))#</actualwork>
  </entry>
</cfoutput>
</result>