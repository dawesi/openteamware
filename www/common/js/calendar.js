var aoutput = '';
// currently selected shortinfo popup entrykey
var a_current_infopopup_entrykey;
// current row number (of shortinfo popup)
var a_current_infopopup_rownumber;
// array with information about the currently displayed events
var a_arr_shortinfo_events = new Array();
// array containing the currently displyed calendars
var a_arr_currenty_displayed_calendars = new Array();

// the current servicekey
var vl_current_servicekey = '5222B55D-B96B-1960-70BF55BD1435D273';

function OpenAddCalendarPopup() {
	
	}
	
function CallNewEvent(dt) {
	location.href = 'index.cfm?action=ShowNewEvent&startdate='+escape(dt);
	}
	
function GotoMonth(y, num) {
	location.href = "default.cfm?action=ViewMonth&date="+num+"/1/"+y;
	}
	
function DisplayDueTasksInCalendarOverview() {
	var a_simple_get = new cBasicBgOperation();
	a_simple_get.url = '/calendar/utils/inc_display_tasks_calendar.cfm';
	a_simple_get.callback_function = processReqDisplayDueTasksInCal;
	a_simple_get.doOperation();
	}

function processReqDisplayDueTasksInCal(responseText) {
	var obj1 = findObj('id_div_display_due_tasks_in_calendar');										
	obj1.innerHTML = responseText;
	}
	
function OpenWorkgroupShareDialog(entrykey) {
	var url = "/workgroups/dialogs/workgroupshare/?servicekey=5222B55D-B96B-1960-70BF55BD1435D273&objectname="+escape(document.formneworeditevent.frmtitle.value)+"&entrykey="+escape(entrykey);
	var obj1 = findObj('iddivworkgroups');
	var mywin = window.open(url, "idpermissions", "RESIZABLE=yes,SCROLLBARS=yes,status=yes,WIDTH=550,HEIGHT=400");
	
	mywin.window.focus();
	
	obj1.style.display = '';
	

	obj1 = findObj('idtdopenworkgorupiframe');
	obj1.style.display = 'none';
		
	obj1 = findObj('idtdcloseworkgroupiframe');
	obj1.style.display = '';	
	}
	
function OpenTakepartWindow(entrykey,userkeys) {
	var url = "/workgroups/dialogs/calendar/takepart/?servicekey=5222B55D-B96B-1960-70BF55BD1435D273&objectname="+escape(document.formneworeditevent.frmtitle.value)+"&entrykey="+escape(entrykey)+"&userkeys="+escape(userkeys);
	var mywin = window.open(url, "idcaltakepart", "RESIZABLE=yes,SCROLLBARS=yes,STATUS=no,WIDTH=550,HEIGHT=400");
	mywin.window.focus();
	}
	
function OpenResourcesWindow(entrykey,resourceskeys) {
	var url = "/workgroups/dialogs/calendar/selectresources/?servicekey=5222B55D-B96B-1960-70BF55BD1435D273&objectname="+escape(document.formneworeditevent.frmtitle.value)+"&entrykey="+escape(entrykey)+"&resourceskeys="+escape(resourceskeys);
	var mywin = window.open(url, "idcalselectresources", "RESIZABLE=yes,SCROLLBARS=yes,STATUS=yes,WIDTH=450,HEIGHT=300");
	mywin.window.focus();
	}	
	
	
function SetUserKeyAssignedTo(username,userkey) {
	var i;
	var obj1 = findObj('frmtakeworkworkgroupmembers');
	
	for (i=0;i<obj1.length;i++) {
		if (obj1.options[i].value == userkey) {
			// SetAssignedToUserkeys();
			return;
			}
		}
	
	 
	obj1.options[obj1.options.length] = new Option(username,userkey);	
	// obj1.disabled = false;
	obj1.size = obj1.options.length+2;
	SetTakePartUserkeys();

	}
	
function SetTakePartUserkeys() {
	var i;
	var obj1 = findObj('frmtakeworkworkgroupmembers');
	var obj2 = findObj('frmtakepartuserkeys');
	var a_str = '';
	
	for (i=0;i<obj1.length;i++) {
		a_str = a_str + ',' + obj1.options[i].value;
		}
		
	obj2.value = a_str;
	}
	
function RemoveAllAssignedUserkeys() {
	var i;
	var obj2 = findObj('frmtakepartuserkeys');
	var obj1 = findObj('frmtakeworkworkgroupmembers');
	
	for (i=0;i<obj1.length;i++) {
		obj1.options[i] = null;
		}
	
	obj2.value = '';
	}
	
function CheckAvailability(entrykey)
	{
	var url, obj1;
	
	url = "/workgroups/dialogs/calendar/checkavailability/?servicekey=5222B55D-B96B-1960-70BF55BD1435D273&objectname="+escape(document.formneworeditevent.frmtitle.value)+"&entrykey="+escape(entrykey)+"&userkeys="+escape(document.formneworeditevent.frmtakepartuserkeys.value)+"&startdatetime="+escape(document.formneworeditevent.frm_dt_start.value+' '+document.formneworeditevent.frm_dt_start_hour.value+':'+document.formneworeditevent.frm_dt_start_minute.value);
	var mywin = window.open(url, "idcheckavailability", "RESIZABLE=yes,SCROLLBARS=yes,status=no,WIDTH=550,HEIGHT=400");
	mywin.window.focus();
	
	}
	
function ChangeDurationType(s) {
	var obj1 = findObj('iddivdurationsimple');
	var obj2 = findObj('iddivdurationexact');
	
	if (s == 'simple') {
		obj1.style.display = '';
		obj2.style.display = 'none';
		}
			else {
				obj1.style.display = 'none';
				obj2.style.display = '';
				}
				
	document.formneworeditevent.frmdurationtype.value = s;
	}

function OpenCategoriesPopup() {
   	var url = "/workgroups/dialogs/categories/?categories="+escape(document.formneworeditevent.frmcategories.value)+'&form=formneworeditevent';
    var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=270,HEIGHT=540");
    mywin.window.focus();
	}
	
function DisplayEntryStandardOperations(entrykey) {
	var obj1 = findObj('idoptions'+entrykey);
	
	obj1.style.display = '';
	}

function ShowDialogIncludeUserCalendar(workgroup) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var a_str_wg = '';
	var a_url = '';
	
	if (workgroup) {a_str_wg = workgroup;}
	a_url = 'index.cfm?action=ShowDisplayOtherUsersCalendar&workgroupkey=' + escape(a_str_wg);
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(8);
	a_simple_modal_dialog.customcontent_load_from_url = a_url;
	a_simple_modal_dialog.ShowDialog();	
	}
	
function ConfirmDeleteEntry(entrykey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.customcontent = '';
	a_simple_modal_dialog.executeurl = 'act_delete_event.cfm?entrykey='+escape(entrykey)+'&return='+escape(location.href);
	a_simple_modal_dialog.ShowDialog();		
}
	
function ConfirmDeleteVirtualCalendar(entrykey, title) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(5);
	a_simple_modal_dialog.customcontent_load_from_url = 'index.cfm?action=ShowQuestDeleteVirtualCalendar&entrykey=' + escape(entrykey) + '&title=' + escape(title);
	a_simple_modal_dialog.ShowDialog(); 
}

function ConfirmUnsubscribeFromVirtualCalendar(entrykey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.customcontent = '';
	a_simple_modal_dialog.executeurl = 'index.cfm?action=DoUnsubscribeVirtualCalendar&entrykey='+escape(entrykey);
	a_simple_modal_dialog.ShowDialog();	
}

function refreshCalendarView(form) {
	var count = form['frmvirtualcalendar'].length;
	var selectedCount = 0;
	var virtualCalendarEntryKeys = '';
	for (var i = 0; i < count; i++) {
		if (form['frmvirtualcalendar'][i].checked) {
			if (virtualCalendarEntryKeys) {
				virtualCalendarEntryKeys += ',';
			}
			virtualCalendarEntryKeys += form['frmvirtualcalendar'][i].value;
			selectedCount++;
		}
	}
	//if nothing is selected then return false (at least one calendar have to be selected)
	if (selectedCount == 0) {
		return false;
	}
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'SetVirtualCalendarsFilter';
	req.servicekey = vl_current_servicekey;
	req.AddParameter('virtualcalendarkeys', virtualCalendarEntryKeys);
	req.doCall();
	return true;
}
	
function AddAttendeeToEvent(entrykey, type, attendeeName) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = attendeeName;
	a_simple_modal_dialog.customcontent_load_from_url = 'index.cfm?action=AssignNewElementToAppointment&entrykey=' + escape(entrykey) + '&type=' + type;
	a_simple_modal_dialog.ShowDialog(); 
}

function DoAssignElements() {
	$('#id_div_show_assigned_members_resources').html(a_str_loading_status_img);
	
	var a_post_cmd = new cBasicBgOperation();
	var a_str_post_content = SerializeForm(findObj('formSelectElements'));
	
	a_post_cmd.method = 'post';
	a_post_cmd.post_content = a_str_post_content;
	a_post_cmd.url = 'index.cfm?action=DoAssignElementsToAppointment';
	a_post_cmd.callback_function = onElementAssignedRemoved;
	CloseSimpleModalDialog();
	a_post_cmd.doOperation();
}

function loadAssignedResources(entrykey) {
 	var a_cmd = new cBasicBgOperation();
	a_cmd.url = 'index.cfm?action=DisplayAssignedElements&entrykey=' + escape(entrykey);
	a_cmd.callback_function = onElementAssignedRemoved;
	a_cmd.doOperation();
}

function onElementAssignedRemoved(responseText) {
	findObj('id_div_show_assigned_members_resources').innerHTML = responseText;
}

function removeAssignedElement(eventkey, type, parameter) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.customcontent = '';
	a_simple_modal_dialog.executeurl = 'javascript:DoRemoveAttendee(\'' + eventkey + '\', \'' + type + '\', \'' + parameter + '\')';
	a_simple_modal_dialog.ShowDialog();
}

function DoRemoveAttendee(eventkey, type, parameter)  {
	var a_post_cmd = new cBasicBgOperation();
	a_post_cmd.url = 'index.cfm?action=RemoveAssignedElementFromAppointment&eventkey=' + escape(eventkey) + '&type=' + escape(type) + '&parameter=' + escape(parameter);
	a_post_cmd.method = 'post';
	a_post_cmd.callback_function = onElementAssignedRemoved;
	CloseSimpleModalDialog();
	a_post_cmd.doOperation();
}

function SetSendInvitation(eventkey, type, parameter, checked) {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'SetSendInvitationFlag';
	req.servicekey = vl_current_servicekey;
	req.AddParameter('eventkey', eventkey);
	req.AddParameter('type', type);
	req.AddParameter('parameter', parameter);
	req.AddParameter('checked', checked);
	req.doCall();	
}

function SetDisplayEventsOfCertainType(type, entrykey, visible)
	{
	location.href = 'act_set_events_display.cfm?display='+visible+'&type='+escape(type)+'&return='+escape(location.href)+'&entrykey='+escape(entrykey);
	}
function SetService()
	{
	if (parent.parent.parent.frametop)
		{
		parent.parent.parent.frametop.SetService('calendar');
		}
	}
	

function DisplayMonthCalendar(div_id, Monat,Jahr) {

var jetzt = new Date();
var DieserMonat = jetzt.getMonth() + 1;
var DiesesJahr = jetzt.getYear();
if(DiesesJahr < 999) DiesesJahr+=1900;
var DieserTag = jetzt.getDate();
var Zeit = new Date(Jahr,Monat-1,1);
var Start = Zeit.getDay();
if(Start > 0) Start--;
else Start = 6;
var Stop = 31;
if(Monat==4 ||Monat==6 || Monat==9 || Monat==11 ) --Stop;
if(Monat==2) {
 Stop = Stop - 3;
 if(Jahr%4==0) Stop++;
 if(Jahr%100==0) Stop--;
 if(Jahr%400==0) Stop++;
}
aoutput = '<table border="0" cellpadding="1" cellspacing="0" width="97%">';
var Monatskopf = Monatsname[Monat-1] + " " + Jahr;
var Tageszahl = 1;
for(var i=0;i<=5;i++) {
  aoutput = aoutput + "<tr>";
  for(var j=0;j<=5;j++) {
    if((i==0)&&(j < Start))
     WriteCalendarMonthListCell("&#160;", Monat, Jahr);
    else {
      if(Tageszahl > Stop)
        WriteCalendarMonthListCell("&#160;", Monat, Jahr);
      else {
        if((Jahr==DiesesJahr)&&(Monat==DieserMonat)&&(Tageszahl==DieserTag))
         WriteCalendarMonthListCell(Tageszahl, Monat, Jahr);
        else
         WriteCalendarMonthListCell(Tageszahl, Monat, Jahr);
        Tageszahl++;
        }
      }
    }
    if(Tageszahl > Stop)
      WriteCalendarMonthListCell("&#160;", Monat, Jahr);
    else {
      if((Jahr==DiesesJahr)&&(Monat==DieserMonat)&&(Tageszahl==DieserTag))
        WriteCalendarMonthListCell(Tageszahl, Monat, Jahr);
      else
        WriteCalendarMonthListCell(Tageszahl, Monat, Jahr);
      Tageszahl++;
    }
    aoutput = aoutput + "<\/tr>";
  }
aoutput = aoutput + "<\/table>";
findObj(div_id).innerHTML = aoutput;
}

function WriteCalendarMonthListCell(Inhalt, Monat, Jahr) {
	aoutput = aoutput + '<td align="center">';
	aoutput = aoutput + '<a href="default.cfm?action=ViewDay&Date=' + Monat + '/' + Inhalt + '/' + Jahr + '" class="calnav">' + Inhalt + '</a>';
	aoutput = aoutput + "<\/td>";
	}// ** set a td with mischeader class in order to show busy status
function SetHourFieldBusy(id, color) {
	var obj1 = findObj(id);
	
	if (obj1) {
		// obj1.style.color = 'white';
		obj1.className = 'mischeader';
		//obj1.className = 'mischeader';
		}
	}
	
// ** place a div-event in the table grid at the given position
// obj1 = position
// also set busy status (see above)
function PlaceEventInGrid(startnum, prefix, uniquekey, color) {
	var obj1 = findObj('id_td_date_' + prefix + '_' + startnum);
	var obj2;
	
	SetHourFieldBusy('id_td_date_' + prefix + '_' + startnum);
	
	if (obj1) {
		obj2 = findObj('id_event_' + prefix + '_' + uniquekey);
		obj1.appendChild(obj2);
		obj2.style.display = 'block';
		}
	}
	
// set the currently opened item
// copy content to displayed DIV from array with all the information
function SetCurrentlySelectedEvent(sender, uniquekey) {
	var obj1 = findObj('id_div_cal_short_info');
	var a_event_info = ReturnCurrentEventInformationByUniquekey(uniquekey);
	
	// build info and return
	obj1.innerHTML = BuildShortinfoFromJSArray(uniquekey);
	// entrykey has index 2
	a_current_infopopup_entrykey = a_event_info[2];
	}
	
// delete the current item ... ask before
function DeleteCurrentInfoPopupEvent(prefix,uniquekey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.customcontent = '';
	a_simple_modal_dialog.executeurl = 'javascript:InternalSimpleDeleteofEvent("' + prefix + '", "' + uniquekey + '");';
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
	
// user confirmed deletion ... delete and remove from display
function InternalSimpleDeleteofEvent(prefix,uniquekey) {
	var obj1 = findObj('id_event_' + prefix + '_' + uniquekey);
	// simple delete
	doExeCuteAsyncOperation(vl_current_servicekey, 'delete', a_current_infopopup_entrykey, '', 'get');
	// hide object ...
	if (obj1) {
		obj1.style.display = 'none';
		}
	// remove status information and close simple dialog
	HideStatusInformation();
	CloseSimpleModalDialog();
	}
	
// display the calendar of a certain user / resource
function ShowCalendarForUser(userkey) {
	var i;
	var obj1;
	
	// hide all calendars ...
	for (i=0;i<a_arr_currenty_displayed_calendars.length;i++) {
		obj1 = findObj('id_div_user_calendar_' + a_arr_currenty_displayed_calendars[i]);
		
		if ((obj1) && (userkey != 'all')) {
			obj1.style.display = 'none';
			}
			
		// display all
		if ((obj1) && (userkey == 'all')) {
			obj1.style.display = 'block';
			}
		
		}
		
	// display selected
	if (userkey != 'all') {
		findObj('id_div_user_calendar_' + userkey).style.display = '';
		}
	}
	
// return information about the current event by the uniquekey
function ReturnCurrentEventInformationByUniquekey(uniquekey) {
	var i;
	for (i=0;i<a_arr_shortinfo_events.length;i++) {
		// if uniquekey = sender, than we're right!
		if (a_arr_shortinfo_events[i][1] == uniquekey) {
			return a_arr_shortinfo_events[i];
			}
		}
	}
// build the short information from the js array
function BuildShortinfoFromJSArray(uniquekey)
	{
	var i;
	var a_return = '';
	var a_event_info = ReturnCurrentEventInformationByUniquekey(uniquekey);
	
	a_return = '<div style="line-height:20px;padding:10px;width:240px;">';
	a_return += '<a href="javascript:CloseSimpleModalDialog();"><img src="/images/menu/img_close_17x13.gif" align="right" border="0" vspace="4" hspace="4"/></a>';
	a_return += '<a href="default.cfm?action=ShowEvent&entrykey=' + a_event_info[2] + '" style="font-weight:bold;">' + a_event_info[3] + '</a>';
	a_return += '<br/>';
		
	if (a_event_info[7].length > 0) {
		a_return += a_event_info[7] + '<br/>';
		}
	
	a_return += a_event_info[5] + ' - ' + a_event_info[6] + '<br/>';
	//#GetLangVal('cal_wd_when')#?
		
	if (a_event_info[8].length > 0) {
		a_return += a_event_info[8] + '<br/>';
		}
		
	if (a_event_info[9].length > 0) {
		a_return += a_event_info[9] + '<br/>';
		}
			
	a_return += '<div>';
	a_return += '<input onClick="location.href = \'index.cfm?action=ShowEvent&entrykey='+ a_event_info[2] +'\';" class="btn btn-primary" type="button" value="' + GetLangData(9) + '">';
	a_return += '&nbsp;';
	a_return += '<input onClick="DeleteCurrentInfoPopupEvent(\'' + a_event_info[0] + '\',\'' + a_event_info[1] + '\');" class="btn btn-primary" type="button" value="' + GetLangData(10) + '">';
	a_return += '</div>';
	a_return += '</div>';
	
	return a_return;
	}
	
// add a new item to the shortinfo array
function AddCalendarShortinfo(prefix,uniquekey,entrykey,title,startnum,start,end,description,location,private,addinfo) {
	var ii = a_arr_shortinfo_events.length;
	// add item ...
	a_arr_shortinfo_events[ii] = new Array(prefix,uniquekey,entrykey,title,startnum,start,end,description,location,private,addinfo);
	}
	
function DeleteThisEvent(entrykey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.executeurl = 'javascript:DoDeleteThisEvent(\'' + entrykey + '\')';
	// show dialog
	a_simple_modal_dialog.ShowDialog();
	}

function DoDeleteThisEvent(entrykey) {
	doExeCuteAsyncOperation(vl_current_servicekey, 'delete', entrykey, '', 'get');
	history.go(-1);
	}
	
function CheckOtherEvents(eventkey) {
	var userkey = document.formneworeditevent.frmuserkey.value;
	var a_simple_get = new cBasicBgOperation();
	
	$('#id_div_related_other_events').html(a_str_loading_status_img);
	
	a_simple_get.url = 'index.cfm?action=ShowRelatedAppointments&userkey='+escape(userkey)+'&start='+escape(document.formneworeditevent.frm_dt_start.value)+'&starthour='+document.formneworeditevent.frm_dt_start_hour.value+'&startminute='+document.formneworeditevent.frm_dt_start_minute.value+'&eventkey=' + escape(eventkey);
	a_simple_get.id_obj_display_content = 'id_div_related_other_events';
	a_simple_get.doOperation();	
	}
	
function SetWholeDayEvent(v) {
	document.formneworeditevent.frm_dt_start_hour.disabled = v;
	document.formneworeditevent.frm_dt_start_minute.disabled = v;			
	document.formneworeditevent.frm_dt_end.disabled = v;
	document.formneworeditevent.frm_dt_end_hour.disabled=v;
	document.formneworeditevent.frm_dt_end_minute.disabled=v;
	document.formneworeditevent.frmdurationsimple.disabled=v;			
	}
	
function SetPrivateItem(val) {
	var obj1 = findObj('frmassignedtouserkey');
	if ((val == true) && (obj1 !== null)) {
		obj1.selectedIndex = 0;
		}
	}