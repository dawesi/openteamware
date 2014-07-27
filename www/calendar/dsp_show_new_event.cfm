<!--- //
	Module:            calendar
	Action:            ShowNewEvent
	Description:       displays edit screen for new event
// --->

	
<cfparam name="url.startdate" type="string" default="">
<cfparam name="url.enddate" type="string" default="">
<cfparam name="url.showaspopup" type="numeric" default="0">
<cfparam name="url.title" type="string" default="">
<cfparam name="url.location" type="string" default="">

<!--- params ... CRM --->
<cfparam name="url.assigned_addressbookkeys" type="string" default="">
<cfparam name="url.assigned_userkey" type="string" default="">

<cfset SetHeaderTopInfoString(GetLangVal('cal_ph_create_new_event'))>

<cfset NewOrEditEvent = StructNew() />
<cfset Variables.NewOrEditEvent.startdate = url.startdate />
<cfset Variables.NewOrEditEvent.enddate = url.enddate />

<cfset Variables.NewOrEditEvent.assigned_userkey = url.assigned_userkey />
<cfset Variables.NewOrEditEvent.assigned_addressbookkeys = url.assigned_addressbookkeys />
<cfset Variables.NewOrEditEvent.ShowAsPopup = url.showaspopup />
<cfset Variables.NewOrEditEvent.title = url.title />
<cfset Variables.NewOrEditEvent.location = url.location />
<cfset Variables.NewOrEditEvent.q_select_meeting_members = QueryNew('type,parameter,status,dt_answered,comment,sendinvitation') />

<cfinclude template="dsp_inc_neworedit_event.cfm">


