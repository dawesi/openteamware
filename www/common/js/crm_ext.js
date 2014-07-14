// javascripts with crm extensions ... mainly important for the contact administration

function OpenMsgInNewWindow(mailbox,uid,userkey) {
	window.open('/email/index.cfm?action=showmessage&fullheader=1&id='+escape(uid)+'&mailbox='+escape(mailbox)+'&popup=1&userkey='+escape(userkey), '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=820,height=700');
	}
	
// load rest of history item and display
function LoadFullHistoryItem(servicekey, objectkey, entrykey, id_obj) {
	var a_simple_get = new cBasicBgOperation();
	$('#' + id_obj).html(a_str_loading_status_img);
	a_simple_get.url = '/crm/index.cfm?Action=LoadFullHistoryItem&servicekey=' + escape(servicekey) + '&entrykey=' + escape(entrykey) + '&objectkey=' +  escape(objectkey);
	a_simple_get.id_obj_display_content = id_obj;
	a_simple_get.doOperation();
	}
	

function DisplayActivitiesAssignedToObject(contactkey, editmode) {
	var a_editmode = false;
	var a_simple_get = new cBasicBgOperation();
	
	if (editmode) {
		a_editmode = editmode;
		}
	
	a_simple_get.url = '/crm/?action=IncShowItemActivities&entrykeys=' + escape(contactkey) + '&editmode=' + a_editmode + '&r=' + escape(Math.random());
	a_simple_get.id_obj_display_content = 'id_div_crm_show_contact_tasks_and_appointments';
	a_simple_get.id_obj_show_if_not_empty_display_content = 'id_fieldset_tasks_appointments_followups';
	a_simple_get.doOperation();
	}

function DisplayFilesAttachedToContact(contactkeys, directorykey, editmode) {
	var a_editmode = false;	
	var a_simple_get = new cBasicBgOperation();
		
	if (editmode) {a_editmode = editmode;}
		
	a_simple_get.url = '/addressbook/crm/show_div_files_attached_to_user.cfm?contactkey=' + escape(contactkeys) + '&directorykey=' + escape(directorykey) + '&rights=delete,edit,write,create&managemode=' + a_editmode;
	a_simple_get.id_obj_display_content = 'id_div_crm_show_contact_files';
	a_simple_get.id_obj_hide_if_empty_display_content = 'id_div_fieldset_files_assigned_to_user';
	a_simple_get.callback_function = processReqDisplayContactFilesDataChange;
	a_simple_get.doOperation();	
	}

function processReqDisplayContactFilesDataChange(responseText) {
	var obj1 = findObj('id_div_crm_show_contact_files');

	if (obj1.offsetHeight > 120)
		{
		obj1.style.height = 120;
		obj1.style.overflow = 'auto';
		}	
	}
	
// display information about assigned persons
// TODO: remove this function ... not needed any more!
function DisplayAssignmentsToContact(contactkeys,editmode) {
	var a_editmode = false;
	var a_simple_get = new cBasicBgOperation();
	
	if (editmode) {a_editmode = editmode;}
		
	a_simple_get.url = '/addressbook/crm/utils/inc_load_assignment_information.cfm?contactkeys=' + escape(contactkeys) + '&rights=delete,edit,write,create&managemode=' + a_editmode;
	a_simple_get.callback_function = processReqDisplayAssignments;
	a_simple_get.doOperation();		
	}
	
function processReqDisplayAssignments(responseText) {
	var obj1 = findObj('id_div_crm_show_contact_assignments');
	var obj2 = findObj('id_div_fieldset_assignments');
	
	obj1.innerHTML = responseText;	
		
	if ((obj2) && (responseText == '')) {
		// hide if no data
		obj2.style.display = 'none';					
		}
	}
	
	
// display information about linked contacts
function DisplayContactLinksAttachedToContact(contactkeys,editmode) {
	var a_editmode = false;
	var a_simple_get = new cBasicBgOperation();
	
	if (editmode) {a_editmode = editmode;}
		
	a_simple_get.url = '/addressbook/crm/utils/inc_load_linked_contacts_information.cfm?contactkeys=' + escape(contactkeys) + '&rights=delete,edit,write,create&managemode=' + a_editmode;
	a_simple_get.callback_function = processReqDisplayLinkedContacts;
	a_simple_get.doOperation();		
	}
	
function processReqDisplayLinkedContacts(responseText) {
	var obj1 = findObj('id_div_crm_show_contact_linked_contacts');
	var obj2 = findObj('id_div_fieldset_contacts_linked_to');
	
	obj1.innerHTML = responseText;	
		
	if ((obj2) && (responseText == '')) {
		// hide if no data
		obj2.style.display = 'none';					
		}
	}

// open the file upload popup
function OpenUploadPopup(contactkey, directorykey) {
	window.open('/addressbook/crm/show_upload_file_attached_to_contact.cfm?contactkey=' + escape(contactkey) + '&directorykey=' + escape(directorykey),'_blank','toolbar=no,location=no,directories=no,status=no,copyhistory=no,scrollbars=yes,resizable=yes,height=200,width=600');
	}
	
// delete an assigned file
function DeleteAssignedFile(contactkey, directorykey, entrykey) {
	var a_str_url = '/addressbook/crm/act_delete_assigned_file.cfm?contactkey=' + escape(contactkey) + '&directorykey=' + escape(directorykey) + '&entrykey=' + escape(entrykey);
	location.href = a_str_url;
	}
	
// create a new folder
function CreateNewDirectoryDialog(contactkey, currentdirectorykey) {
	alert('n/a yet');
	}
	
function call_new_item_for_contact(entrykey, item_type, param1, param2) {
	var a_url = '';
	var a_modal_dlg = new cSimpleModalDialog();
	
	switch (item_type) {
	  case "history":
	  	// "new history" ... call form
		a_url = '/crm/index.cfm?action=CreateEditHistoryItem&forcepagetype=inpage&objectkey=' + escape(entrykey) + '&projectkey=' + escape(param1) + '&servicekey=52227624-9DAA-05E9-0892A27198268072' + '&type=' + escape(param2);
		a_modal_dlg.type = 'custom';
		a_modal_dlg.customtitle = GetLangData(8);
		a_modal_dlg.customcontent_load_from_url = a_url;
		a_modal_dlg.ShowDialog();			
	  	break;
	  case "project":
		GotoLocHref('/project/index.cfm?action=newproject&type=1&contactkey=' + escape(entrykey));
		break;	
	  case "product":
		GotoLocHref('/crm/index.cfm?action=addProductToContact&contactkey=' + escape(entrykey));
		break;					
	  case "task":
	  	a_url = '/crm/show_create_task.cfm?addressbookkeys=' + escape(entrykey);
		OpenNewWindowWithParams(a_url);						  
		break;
	  case "followup":
	  	GotoLocHref('/crm/?action=CreateFollowup&objectkey=' + escape(entrykey) + '&servicekey=52227624-9DAA-05E9-0892A27198268072');
		break;
	  case "appointment":
		a_url = '/crm/?action=CreateAppointmentWithContact&addressbookkeys=' + escape(entrykey);
		GotoLocHref(a_url);
		// OpenNewWindowWithParams(a_url);						  
		break;
	  case "contact_link":
    	a_url = '/crm/dialogs/edit_links/index.cfm?entrykey='+ escape(entrykey) +'&servicekey=52227624-9DAA-05E9-0892A27198268072';
    	mywin = window.open(a_url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=780,HEIGHT=500");
    	mywin.window.focus();
		break;
	  case "file":
	  	OpenUploadPopup(entrykey, '');
		break;
	  case "email":
	  	OpenEmailPopup(entrykey, '');
		break;
	  case "contact":
	  	GotoLocHref('/addressbook/index.cfm?Action=createnewitem');
		break		
		}

	}
	
var a_current_history_area = 'activities';

function GetCurrentCRMHistoryDays(){
	return document.forms.form_set_crm_history_days.frmdays.value;
	}

// var a_http_display_activities_of_contacts;
// show activities statistics ... 
// parameter
// area ... area of data ...
// days ... number of days to go back ... 0 = show everything
function ShowActivitiesData(contactkeys,area,days,editmode) {
	var a_editmode = false;
	var a_simple_get = new cBasicBgOperation();
	
	// set current area
	a_current_history_area = area;
	
	if (editmode) {a_editmode = editmode;}
	
	a_simple_get.url = '/crm/?action=DisplayAddresBookItemHistory&entrykeys=' + escape(contactkeys) + '&area=' + escape(area) + '&days=' + days + '&managemode=' + a_editmode + '&r=' + escape(Math.random());
	a_simple_get.id_obj_display_content = 'id_content_output_activities';
	a_simple_get.doOperation();
	}
	
// reset a filter criteria ...
function ResetFilterCriteria(id) {
	var obj1 = findObj('frmoperator' + id);
	var obj2 = findObj('frmcompare' + id);
	
	obj1.selectedIndex = 0;
	obj2.value = '';
	obj2.selectedIndex = 0;
	CheckShowCriteriaUsed(obj1, id);
	}
	
// set a follow up job to done
function SetFollowUpDone(entrykey, contactkey) {
	// open history text
	var req = new cSimpleAsyncXMLRequest();
	req.servicekey = '7E68B84A-BB31-FCC0-56E6125343C704EF';
	req.action = 'SetFollowUpDone';
	req.AddParameter('entrykey', entrykey);
	req.AddParameter('objectkey', contactkey);
	req.doCall();
	}
	
// call dlg for creating account
function DoCreateAutoAccountForContactDlg(contactkey) {
	var req = new cSimpleAsyncXMLRequest();
	
	req.action = 'DoCreateAccountForContact';
	req.AddParameter('contactkey', contactkey);
	req.doCall();	
	}
	
// check if a criteria has been selected ...
function CheckShowCriteriaUsed(o, id) {
	var a_select_value = o.value;
	var obj1 = findObj('id_tr_field' + id);
	var obj2 = findObj('id_td_displayname' + id);
	
	if (a_select_value == '-1') {
		obj1.className = '';
		obj2.style.fontWeight = '';
		}
			else {
				// use this criteria and show it!
				obj1.className = 'over';
				obj2.style.fontWeight = 'bold';
				}
	}
	