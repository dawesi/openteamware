<!--- //

	Module:		Calendar
	Action:		CreateEvent / EditEvent
	Description:Create or edit an event
	

// --->

<cfparam name="Variables.NewOrEditEvent.action" type="string" default="create">

<!--- maybe provided in case of a new event --->
<cfparam name="Variables.NewOrEditEvent.startdate" type="string" default="">
<cfparam name="Variables.NewOrEditEvent.enddate" type="string" default="">
<cfparam name="Variables.NewOrEditEvent.redirect" type="string" default="#ReturnRedirectURL()#">

<!--- CRM parameters --->
<cfparam name="Variables.NewOrEditEvent.assigned_addressbookkeys" type="string" default="">
<cfparam name="Variables.NewOrEditEvent.assigned_userkey" type="string" default="">
<cfparam name="Variables.NewOrEditEvent.crm_mode_enabled" type="numeric" default="0">
<cfparam name="Variables.NewOrEditEvent.title" type="string" default="">
<cfparam name="Variables.NewOrEditEvent.location" type="string" default="">

<cfparam name="Variables.NewOrEditEvent.ShowAsPopup" type="numeric" default="0">

<cfparam name="Variables.NewOrEditEvent.Query" type="query" default="#QueryNew('entrykey,title,description,location,categories,date_start,date_end,repeat_until,repeat_type,repeat_day_1,repeat_day_2,repeat_day_3,repeat_day_4,repeat_day_5,repeat_day_6,repeat_day_7,privateevent,virtualcalendarkey,color,showtimeas')#">

<cfif Variables.NewOrEditEvent.action is 'create'>
	<!--- new event ... --->
	<cfset QueryAddRow(Variables.NewOrEditEvent.Query, 1)>
	
	<!--- check if valid data have been provided from URL scope ... --->
	<cfif Len(Variables.NewOrEditEvent.startdate) GT 0 AND isDate(Variables.NewOrEditEvent.startdate)>
		<!--- use provided date/time ... --->
		<cfset a_dt_now_start = ParseDateTime(Variables.NewOrEditEvent.startdate)>
	<cfelse>
		<cfset a_dt_now_start = DateAdd('h',-request.stUserSettings.utcdiff,GetUTCTime(Now()))>
	</cfif>
	
	<!--- save with the end date ... --->
	<cfif Len(Variables.NewOrEditEvent.enddate) GT 0 AND isDate(Variables.NewOrEditEvent.enddate)>
		<cfset a_dt_now_end = ParseDateTime(Variables.NewOrEditEvent.enddate)>
	<cfelse>
		<!--- add one hour ... --->
		<cfset a_dt_now_end = DateAdd('h', 1, a_dt_now_start)>
	</cfif>
	
	<!--- load city of user ... --->
	<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
		<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	</cfinvoke>
	
	<cfset QuerySetCell(Variables.NewOrEditEvent.query, 'entrykey', CreateUUID(), 1) />
	<cfset QuerySetCell(Variables.NewOrEditEvent.query, 'repeat_type', 0, 1) />

    <!--- construct the location from current user's address --->
    <cfset a_str_location = '' />
	
    <cfif Len(q_select_user_data.address1) GT 0>
        <cfset a_str_location = ListAppend(a_str_location, q_select_user_data.address1) />
    </cfif>
    <cfif Len(q_select_user_data.zipcode) GT 0>
        <cfset a_str_location = ListAppend(a_str_location, q_select_user_data.zipcode) />
    </cfif>
    <cfif Len(q_select_user_data.city) GT 0>
        <cfset a_str_location = ListAppend(a_str_location, q_select_user_data.city) />
    </cfif>
    <cfif Len(q_select_user_data.country) GT 0>
        <cfset a_str_location = ListAppend(a_str_location, q_select_user_data.country) />
    </cfif>
    
	<cfset QuerySetCell(Variables.NewOrEditEvent.query, 'location', replacenocase(a_str_location, ',', ', ', 'ALL'), 1)>
	<cfset QuerySetCell(Variables.NewOrEditEvent.Query, 'date_start', DateFormat(a_dt_now_start, request.a_str_default_dt_format)&" "&TimeFormat(a_dt_now_start, "HH:mm:ss"), 1)>
	<cfset QuerySetCell(Variables.NewOrEditEvent.Query, 'date_end', DateFormat(a_dt_now_end, request.a_str_default_dt_format)&" "&TimeFormat(a_dt_now_end, "HH:mm:ss"), 1)>	
	
	<cfif Len(Variables.NewOrEditEvent.title) GT 0>
		<cfset QuerySetCell(Variables.NewOrEditEvent.query, 'title', Variables.NewOrEditEvent.title, 1)>
	</cfif>
	
	<cfif Len(Variables.NewOrEditEvent.location) GT 0>
		<cfset QuerySetCell(Variables.NewOrEditEvent.query, 'location', Variables.NewOrEditEvent.location, 1)>
	</cfif>	
	
	<cfloop list="#Variables.NewOrEditEvent.assigned_addressbookkeys#" delimiters="," index="a_str_parameter">
		
		<cfinvoke component="#application.components.cmp_calendar#" method="AddAttendeeToEvent" returnvariable="stReturn_add_contact">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="eventkey" value="#Variables.NewOrEditEvent.query.entrykey#">
			<cfinvokeargument name="type" value="1">
			<cfinvokeargument name="parameter" value="#a_str_parameter#">
		</cfinvoke>
		
	</cfloop>
	
</cfif>

<cfif Variables.NewOrEditEvent.action is 'create'>
	<cfset a_str_form_action = 'index.cfm?action=createEvent'>
	<!--- <cfset QuerySetCell(Variables.NewOrEditEvent.query, 'entrykey', CreateUUID(), 1) /> --->
<cfelse>
	<cfset a_str_form_action = 'index.cfm?action=updateEvent' />
</cfif>


<!--- load some common elements and invoke some common queries ... --->
<cfinvoke component="#request.a_str_component_secretary#" method="GetAllAttendedUsers" returnvariable="q_select_attended_users">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_calendar#" method="GetVirtualCalendarsOfUser" returnvariable="q_select_virtual_calendars">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfset ExportTranslationValuesAsJS('cal_wd_participants,cm_wd_resources') />

<cfset StartNewTabNavigation() />
<cfset a_str_id_overview = AddTabNavigationItem(GetLangVal('cm_wd_overview'), '', '') /> 
<cfset a_str_id_participants = AddTabNavigationItem(GetLangVal('cal_wd_participants') & '/' & GetLangVal('cm_wd_resources'), '', '') />
<cfset a_str_id_repeating = AddTabNavigationItem(GetLangVal('cal_wd_newedit_repeatings'), '', '') /> 
<cfset a_str_id_reminders = AddTabNavigationItem(GetLangVal('cal_wd_reminders'), '', '') /> 

<form style="margin:0px;" onSubmit="DisplayStatusInformation('<cfoutput>#GetLangValJS('cm_ph_status_saving')#</cfoutput>');return ValidateForm();" action="<cfoutput>#a_str_form_action#</cfoutput>" method="post" name="formneworeditevent">
<input type="hidden" name="frmredirect" value="<cfoutput>#htmleditformat(Variables.NewOrEditEvent.redirect)#</cfoutput>">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(Variables.NewOrEditEvent.Query.entrykey)#</cfoutput>">
<input type="hidden" name="frmdurationtype" value="simple">
<input type="hidden" name="frmshowaspopup" value="<cfoutput>#Variables.NewOrEditEvent.ShowAsPopup#</cfoutput>">

<div style="padding-bottom:6px;">
<input class="btn btn-primary" name="frmsubmit" id="frmsubmit" type="submit" value="Speichern" />
<input style="width:auto;" type="button" class="btn" value="Abbrechen" onclick="alert('2do');" />
</div>

<cfoutput>#BuildTabNavigation('', false)#</cfoutput>


<div id="<cfoutput>#a_str_id_overview#</cfoutput>" class="b_all div_module_tabs_content_box">
<cfinclude template="dsp_inc_neworedit_event_overview.cfm">
</div>

<div id="<cfoutput>#a_str_id_participants#</cfoutput>" class="b_all div_module_tabs_content_box">
<cfinclude template="dsp_inc_neworedit_event_participants.cfm">
</div>

<div id="<cfoutput>#a_str_id_repeating#</cfoutput>" class="b_all div_module_tabs_content_box">
<cfinclude template="dsp_inc_neworedit_event_repeat.cfm">
</div>

<div id="<cfoutput>#a_str_id_reminders#</cfoutput>" class="b_all div_module_tabs_content_box">
<cfinclude template="dsp_inc_neworedit_event_reminder.cfm">
</div>

</form>


<cfsavecontent variable="a_str_js">
	var cal1 = new CalendarPopup();
	var cal12 = new CalendarPopup();
	var cal13 = new CalendarPopup();
	var cal14 = new CalendarPopup();
	var cal4 = new CalendarPopup();
	
	$('#frm_dt_start').calendar();
	
function ValidateForm() {
		
	if (document.formneworeditevent.frmtitle.value == '')
		{
		alert('<cfoutput>#jsstringformat(GetLangVal('cal_ph_create_event_error_notitle'))#</cfoutput>');
		return false;
		}
	
	if (isDate(document.formneworeditevent.frm_dt_start.value,'<cfoutput>#request.a_str_default_js_dt_format#</cfoutput>') == false)
		{
		<cfset a_str_msg = GetLangVal('cal_ph_create_event_error_invalid_format') />
		<cfset a_str_msg = ReplaceNoCase(a_str_msg, '%FORMAT%', request.a_str_default_js_dt_format) />
		alert('<cfoutput>#jsstringformat(a_str_msg)#</cfoutput>)');
		return false;
		}
	
	return true;
	
	}
	
function CancelEdit() {
	// abort operation and return
	if (confirm('Sind Sie sicher?') == true) {
		location.href = '<cfoutput>#cgi.HTTP_REFERER#</cfoutput>';
		}
	}
	
</cfsavecontent>

<cfset AddJSToExecuteAfterPageLoad('CheckOtherEvents();', a_str_js) />


