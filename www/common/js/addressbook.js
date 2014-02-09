/* advanced search */
var a_arr_fields_contacts = new Array();
var a_arr_fields_database = new Array();
var a_arr_fields_meta = new Array();
var a_cmp_http_display_criteria;
var a_current_contact_data_business = '';
var a_current_contact_data_private = '';
var a_currently_selected_contact_entrykeys = '';

// skype check ...
var activex = ((navigator.userAgent.indexOf('Win')  != -1) && (navigator.userAgent.indexOf('MSIE') != -1) && (parseInt(navigator.appVersion) >= 4 ));
var CantDetect = ((navigator.userAgent.indexOf('Safari')  != -1) || (navigator.userAgent.indexOf('Opera')  != -1));
var isMacFirefox = ((navigator.userAgent.indexOf('Firefox') != -1) && (navigator.platform.indexOf('Mac') != -1));

function NoSkypeFoundPopup() {
	var a_alg = new cSimpleModalDialog();
	a_alg.type = 'information';
	a_alg.customcontent_load_from_url = '/tools/skype/show_hint_not_installed.cfm';
	a_alg.ShowDialog();	
	return false;
}

function SetPhotoForContact(entrykey) {
	var a_alg = new cSimpleModalDialog();
	a_alg.type = 'custom';
	a_alg.customtitle = 'Photo';
	a_alg.customcontent_load_from_url = 'default.cfm?action=SetPhotoForContact&entrykey=' + escape(entrykey);
	a_alg.ShowDialog();	
}

if(typeof(detected) == "undefined" && activex) {
    document.write(
        ['<script language="VBscript">',
        'Function isSkypeInstalled()',
        'on error resume next',
        'Set oSkype = CreateObject("Skype.Detection")',
        'isSkypeInstalled = IsObject(oSkype)',
        'Set oSkype = nothing',
        'End Function',
        '</script>'].join("\n")
    );
}

// check if skype is has been detected
function skypeCheck() {
    if(CantDetect) {
        return true;
    } else if(!activex) {
        var skypeMime = navigator.mimeTypes["application/x-skype"];
        detected = true;
        if(typeof(skypeMime) == "object") {
            return true;
        } else {
		  if (isMacFirefox) {
			return true;
		  } else {
			return NoSkypeFoundPopup();
		  }
        }
    } else {
        if(isSkypeInstalled()) {
            detected = true;
            return true;
        }
    }
    detected = true;
    return NoSkypeFoundPopup();
}

// select all displayed contacts
function SelectAllDisplayedItems() { 
	   for(var x=0;x<document.formcontacts.elements.length;x++) 
	     { var y=document.formcontacts.elements[x]; 
	       if(y.name!='frmcbselectall') y.checked = true;
	     }
	 }
	 
// set entrykey of currently selected file
function SetCurrentlySelectedContacts(entrykeys) {
	a_currently_selected_contact_entrykeys = entrykeys;
	BuildHTMLActionPopupMenuFrom_Class(a_act_popm.menu_items);
	}
	
// Do something with the currently selected contact ...
function DoHandleCurItemAction(action) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	switch (action){
	case "display":
		location.href = 'default.cfm?action=ShowItem&entrykey=' + escape(a_currently_selected_contact_entrykeys);
		break;
	case "enablere":
		CallRemoteEditDialog(a_currently_selected_contact_entrykeys);
		break;
	case "delete":
		a_simple_modal_dialog.type = 'confirmation';
		a_simple_modal_dialog.customcontent = '';
		a_simple_modal_dialog.executeurl = 'default.cfm?action=deletecontacts&confirmed=true&redirect_start_contacts=true&entrykeys=' + escape(a_currently_selected_contact_entrykeys);
		a_simple_modal_dialog.ShowDialog();	
		break;
	case "edit":
		location.href = 'default.cfm?action=EditItem&entrykey=' + escape(a_currently_selected_contact_entrykeys);
		break;
	case "forward":
		location.href = 'default.cfm?action=forward&entrykeys=' + escape(a_currently_selected_contact_entrykeys);
		break;
	case "googlemaps":
		OpenAddressOptions(a_currently_selected_contact_entrykeys);
		break;
	default : alert("n/a");
		}
	}

// Show Skype status
function ShowSkypeOnlineStatusData(skypeusername, contactkey) {
	var a_simple_get = new cBasicBgOperation();
	a_simple_get.url = '/addressbook/extensions/show_inc_get_skype_status.cfm?skypeusername=' + escape(skypeusername) + '&contactkey=' + escape(contactkey);
	//a_simple_get.callback_function = processSkypeStatusCheckReqChange;
	a_simple_get.id_obj_display_content = 'id_div_skype_status';
	a_simple_get.doOperation();
	}

// call an edit action
function call_edit_contact(entrykey, area) {
	var obj1,url,mywin;
	var a_modal_dlg = new cSimpleModalDialog();
	
	switch (area) {
	  case "projects":
		location.href = '/projects/default.cfm?action=ShowProjectsAssignedToContact&contactkey=' + escape(entrykey);
		break;		
	  case "contactdata":
		location.href = 'default.cfm?action=edititem&entrykey=' + escape(entrykey);
		break;
	  case "assignments":
    	url = '/crm/dialogs/edit_assignments/default.cfm?editmode=true&rights=read,write,edit&entrykeys='+ escape(entrykey) + '&servicekey=52227624-9DAA-05E9-0892A27198268072';
    	mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=780,HEIGHT=500");
    	mywin.window.focus();		
		break;			
	  case "activities":
	  	url = '/crm/?action=IncShowItemActivities&forcepagetype=inpage&editmode=true&rights=read,write,edit&entrykeys='+ escape(entrykey);
		a_modal_dlg.type = 'custom';
		a_modal_dlg.customtitle = GetLangData(8);
		a_modal_dlg.customwidth = '70%';
		a_modal_dlg.customcontent_load_from_url = url;
		a_modal_dlg.ShowDialog();	
    	break;		
	  case "files":
	  	// display files in editmode ...
    	url = '/crm/dialogs/editfilesassignedtocontact/default.cfm?entrykey='+ escape(entrykey);
    	mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=780,HEIGHT=500");
    	mywin.window.focus();
		break;		
	  case "contact_links":
	  	// display files in editmode ...
    	url = '/crm/dialogs/edit_links/default.cfm?entrykey='+ escape(entrykey) +'&servicekey=52227624-9DAA-05E9-0892A27198268072';
    	mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=780,HEIGHT=500");
    	mywin.window.focus();
		break;			
	  case "history":
	  	// display files in editmode ...
		ShowActivitiesData(entrykey, 'activities', '30', true);
		break;			
		}
	}

function OpenCategoriesPopup() {
   	var url = "/workgroups/dialogs/categories/?categories="+escape(document.formcreateeditcontact.frmcategories.value)+'&form=formcreateeditcontact';
    var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=270,HEIGHT=540");
    mywin.window.focus();
	}
	
function OpenCriteriaPopup() {
   	var url = "/tools/criteria/show_select_criteria.cfm/?ids="+escape(document.formcreateeditcontact.frmcriteria.value)+'&form=formcreateeditcontact';
    var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=470,HEIGHT=540");
    mywin.window.focus();
	}	
	
function UpdateCriteriaDisplay() {
	// load data from document field and display criteria data ...
	DisplayCriteriaData(document.formcreateeditcontact.frmcriteria.value);
	}

// display criteria data ...
function DisplayCriteriaData(ids) {
	var a_simple_get = new cBasicBgOperation();		
	a_simple_get.url = '/tools/criteria/show_div_criteria.cfm?ids=' + escape(ids) + '&rand='+escape(Math.random());
	a_simple_get.callback_function = processReqDisplayCriteriaChange;
	a_simple_get.id_obj_display_content = 'id_div_display_criteria';
	a_simple_get.doOperation();	
	}
	
function processReqDisplayCriteriaChange(responseText) {
	var obj1 = findObj('id_div_display_criteria');
	
	if (obj1) {
		if (obj1.offsetHeight > 100) {
			obj1.style.overflow = 'auto';
			obj1.style.height = 100;
			}
		}
	}

function OpenSelectedSuperiorContact(entrykey) {
   	var url = 'crm/show_popup_select_superior_contact.cfm?entrykey='+escape(entrykey);
    var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=470,HEIGHT=440");
    mywin.window.focus();
	}
	

function composemail(adr) {
	location.href = "../email/default.cfm?action=composemail&type=0&to="+adr;
	}

function ComposeSMS2Nr(nr) {
	location.href = "/mobile/default.cfm?action=sms&smsto="+escape(nr);
	}	

function sorrynomobilrnr() {
	alert('Leider haben Sie keine Mobilfunkrufnummer bei diesem Kontakt eintragen.');
	}
function SetService() {
	if (parent.parent.parent.frametop)
		{
		parent.parent.parent.frametop.SetService('addressbook');
		}
	}
function SetContactItemType(v)
	{
	var obj1,obj2,obj3,obj4;
	obj1 = findObj('idtrsectionprivatedata');
	obj2 = findObj('idtrpartbirthday');
	obj3 = findObj('idtrpartfirstnamesurname');
	obj4 = findObj('idtrparttitlesex');
	
	if (v == '1')
		{
		obj1.style.display = 'none';
		obj2.style.display = 'none';
		obj3.style.display = 'none';
		obj4.style.display = 'none';
		}
			else
				{
				obj1.style.display = '';
				obj2.style.display = '';
				obj3.style.display = '';
				obj4.style.display = '';
				}
	}
	

	
	function CheckCompareValueSelected(id)
		{
		var obj1;
		// someone enters something in a field ... has a compare value already been selected?
		
		obj1 = findObj('frmoperator' + id);
		
		if (obj1.value == -1)
			{
			// invalid ... select the next item ...
			obj1.selectedIndex = 1;
			
			CheckShowCriteriaUsed(obj1, id);
			}
		}
	

	
function CallRemoteEditDialog(entrykeys) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.SetType('custom').SetTitle('RemoteEdit').SetCustomContentURL('default.cfm?Action=ActiveREInpage&entrykeys=' + escape(entrykeys)).ShowDialog();
	}
	
// do duplicate a contact
function DuplicateContact(entrykey,contacttype) {
	location.href = 'default.cfm?Action=createnewitem&datatype=' + contacttype + '&clonefromcontactkey=' + escape(entrykey);
	}
	
// update last contact
function DoUpdateLastContactOfContact(entrykey) {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'UpdateLastContact';
	req.AddParameter('entrykey', entrykey);
	req.doCall();
	}
	
// check for duplicated on create/edit ...
function DoCheckForDuplicatesOnCreateEdit() {
	var asurname = document.forms.formcreateeditcontact.frmsurname.value;
	var afirstname = document.forms.formcreateeditcontact.frmfirstname.value;
	var adatatype = document.forms.formcreateeditcontact.frmcontacttype.value;
	var aentrykey = document.forms.formcreateeditcontact.frmentrykey.value;
	
	var req = new cSimpleAsyncXMLRequest();
	
	req.action = 'DoSimpleDupCheck';
	req.AddParameter('firstname', afirstname);
	req.AddParameter('surname', asurname);
	req.AddParameter('datatype', adatatype);
	req.AddParameter('entrykey', aentrykey);
	req.doCall();
	
	ShowLoadingStatus();
	}
	
// launch open call dialog (plus mobile ops) ...
function OpenCallPopup(contactkey, telnr, type) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	if (type) {atype = type;} else {atype = '';}
	
	a_simple_modal_dialog.placedialogontop = true;
	a_simple_modal_dialog = a_simple_modal_dialog.SetType('custom').SetTitle('telnr');
	a_simple_modal_dialog.customcontent_load_from_url = 'default.cfm?Action=OpenCallDialog&contactkey=' + escape(contactkey) + '&telnr=' + escape(telnr) + '&type=' + escape(atype);
	a_simple_modal_dialog.ShowDialog();	
	}
	
// launch address options dialog ...
function OpenAddressOptions(contactkey,adr_type,street,zipcode,city,country) {
	
	var sQ = encodeURIComponent(street + ', ' + zipcode + ' ' + city + ', ' + country);
	
	window.open('http://maps.google.at/maps?q=' + sQ );
	
	return;
	var a_dlg = new cSimpleModalDialog();
	a_dlg.type = 'custom';
	a_dlg.customtitle = 'Location';
	a_dlg.customwidth = '780px';
	a_dlg.customcontent_load_from_url = 'default.cfm?Action=OpenAddressOptionsDialog&adr_type=' + encodeURIComponent(adr_type) + '&contactkey=' + encodeURIComponent(contactkey) + '&street=' + encodeURIComponent(street) + '&city=' + encodeURIComponent(city) + '&zipcode=' + encodeURIComponent(zipcode) + '&country=' + encodeURIComponent(country);
	a_dlg.ShowDialog();	
	}
	
// launch email dialog
function OpenEmailPopup(contactkey,emailadr) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'E-Mail';
	a_simple_modal_dialog.customcontent_load_from_url = 'default.cfm?Action=OpenEmailDialog&contactkey=' + escape(contactkey) + '&emailadr=' + escape(emailadr);
	a_simple_modal_dialog.ShowDialog();	
	}
	
// open remote edit page
function DoActivateREInpage() {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'EnableRemoteRequest';
	req.callback_function = CloseSimpleModalDialog;
	req.AddParameter('entrykeys', document.forms.idformactivatereinpage.frmentrykeys.value);
	req.AddParameter('msg', document.forms.idformactivatereinpage.frmshortmsg.value);
	req.doCall();
	}
	
// set internal field for parentcontactkey to empty string
function UpdateEmptyParentContactkey() {
	$('#frmcompany').val('');
	}
	
// display filter area data ...
function ShowFilterAreaData(viewkey, area, fieldname, datatype) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(8);
	a_simple_modal_dialog.customcontent_load_from_url = 'default.cfm?Action=ShowDlgAddFilterCriteria&area=' + escape(area) + '&datatype=' + escape(datatype) + '&viewkey=' +  escape(viewkey) + '&fieldname=' + escape(fieldname);
	a_simple_modal_dialog.ShowDialog();			
	}
	
// inpage dialog: add crm filter criteria
// needed: fieldname (internal, area, viewkey, data
function AddFilterCriteria(fieldname, area, viewkey, data) {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'AddFilterCriteria';
	req.callback_function = CloseSimpleModalDialog;
	req.AddParameter('fieldname', fieldname);
	req.AddParameter('area', area);
	req.AddParameter('data', data);
	req.AddParameter('viewkey', viewkey);
	req.callback_function = function() {location.reload();}
	req.doCall();
	}