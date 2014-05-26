// various JavaScripts for email compose function ...

// set email action
var vl_timeout;
var vl_sm_use_fixed_font = false;
var vg_tmr_autosave_data;﻿

// action ...
function SetMailAction(wert, waitdlg) {
	var a_wait_dlg = waitdlg;
	
	if (a_wait_dlg == undefined) {a_wait_dlg = true;}
	
	if (a_wait_dlg == true) {
		DisplayPleaseWaitMsgOnLocChange();
		}
		
	document.sendform.mailAction.value = wert;
	}

// set id of attachment
function SetAttachmentsID(id) {
	document.sendform.mailAttachments.value = id;
	}
	
// autosave email ...
function AutoSaveEmailData() {
	
	// set new target ... plus set autosave to TRUE
	document.sendform.target = 'id_iframe_autosave_draft';
	document.sendform.frmDraftAutoSave.value = 'true';
	
	// submit as draft and display no wait dlg
	SetMailAction('savedraft', false);
	document.sendform.submit();
	
	// reset ...
	document.sendform.target = '';
	document.sendform.frmDraftAutoSave.value = 'false';
	
	// restart timer
	window.setTimeout("AutoSaveEmailData()", 200000);
	
	// display status msg
	DisplayStatusInformation('<img src="/images/si/accept.png" class="si_img" alt="" /> ' + vl_ibx_langdata_mail_ph_mail_has_been_autosaved, true);
	
	return true;
	}

// A1 Signature code	
// get secure mail operation job entrykey
function GetSecuremailJobkey() {
	return document.forms.sendform.frmjobkey.value;
	}
	
function DoCallA1SecureViewerNow() {
	// call A1 SecureViewer
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var a_post_cmd = new cBasicBgOperation();
	
	var a_str_post_content = '';
	var a_arr_elements = new Array();
	
	// validate (from, to, ...) commented out because done of SendMethod itself
	// var a_bol_check_mail = ValidateForm();
	
	//if (a_bol_check_mail == false)
	//	{
	//	return;
	//	}
	
	// create POST content
	a_arr_elements[0] = 'subject=' + encodeURIComponent(document.sendform.mailSubject.value);
	a_arr_elements[1] = 'from=' + encodeURIComponent(document.sendform.mailfrom.value);
	a_arr_elements[2] = 'to=' + encodeURIComponent(document.sendform.mailto.value);
	a_arr_elements[3] = 'jobkey=' + encodeURIComponent(GetSecuremailJobkey());
	a_arr_elements[4] = 'body=' + encodeURIComponent(document.sendform.mailbody.value);
	a_arr_elements[5] = 'fixed_font=' + encodeURIComponent(vl_sm_use_fixed_font);
	
	// join ...
	a_str_post_content = a_arr_elements.join("&");

	// show waiting dialog ... close maybe open dialog
	CloseSimpleModalDialog();
	
	a_simple_modal_dialog.type = 'custom';	
	a_simple_modal_dialog.customtitle = 'A1 Signatur';
	a_simple_modal_dialog.customcontent_load_from_url = '/email/sm/show_a1_progress.cfm?jobkey=' + escape(GetSecuremailJobkey()) + '&subject=' + escape(document.sendform.mailSubject.value);
	
	// show dialog
	a_simple_modal_dialog.ShowDialog();			
	
	// post content ...
	a_post_cmd.method = 'post';
	a_post_cmd.post_content = a_str_post_content;
	a_post_cmd.url = '/email/sm/act_post_a1_sig_content.cfm';
	a_post_cmd.callback_function = onA1PostSigContentProgress;
	a_post_cmd.DoPost();
	}
	

// check the status of the a1 secure viewer ...
function CheckA1SigStatus(done) {
	var a_simple_get = new cBasicBgOperation();
	a_simple_get.url = '/email/sm/act_get_a1_sig_status.cfm?jobkey=' + escape(GetSecuremailJobkey());
	a_simple_get.callback_function = DoParseCheckA1SigStatus;
	a_simple_get.doOperation();
	return true;
	}
	
function LaunchA1SecureViewer() {
	var w = 1000;
	var h = 600;
	var a1_viewer;
 	var winl = (screen.width - w) / 2;
    var wint = (screen.height - h) / 2;
    winprops = 'height=' + h + ',width=' + w + ',top='+wint+',left='+winl+'resizable=1,status=1';
  	a1_viewer = window.open("/email/sm/do_post_a1_secure_viewer.cfm?jobkey=" + escape(GetSecuremailJobkey()), "", winprops);
	}
	
// show email properties
function ShowAdditionalMailProperties() {
	var obj1 = findObj('id_div_additional_mail_properties');
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'titel dieses fensters';
	a_simple_modal_dialog.customcontent = obj1.innerHTML;
	// show dialog
	a_simple_modal_dialog.ShowDialog();	
	}
	
// securemail ...
function CheckSM() {
	var obj1;
	var mywindow2;
	
	return true;
	
	/*var      x = screen.width ;
	var      y = screen.height ;
	var  width = 400;
	var height = 250;
	var    top = parseInt( ( y - height ) / 2 ) ;
	var    left = parseInt( ( x - width  ) / 2 ) ;		
	
	// check for signedmail operation ...
	if (document.sendform.frmsmaction.value.length > 0)
		{
		
		// a1 sign operation? and stop on checking?
		if ((document.sendform.frmsmaction.value == 'a1_sign') && (vg_stop_for_mobile_signature == true))
			{
			
			// text only!
			if (document.forms.sendform.frmFormat.value != 'text') {
				alert('Sie koennen nur Text-Nachrichten signieren. Bitte wechseln Sie die Format - Einstellung.');
				return false;
				}
			
			if (a_int_attachments_count > 0) {
				alert('Bei aktivier A1 Signatur sind keine Attachments moeglich - bitte entfernen Sie diese und kopieren Sie den zu signierenden Inhalt direkt in die E-Mail.');
				return false;
				}
			
			
			// do not continue but call secure viewer ...
			DoCallA1SecureViewerNow();
			
			// false = form will not submit
			return false;
			}
				else
					{
					// different operation
					// check if sm window exists ...
					
					mywindow2=open('sm/show_check_sm_active.cfm','show_sm_active','resizable=no,width=400,height=250,left='+left+',top='+top);
					mywindow2.location.href = 'sm/show_check_sm_active.cfm';
					if (mywindow2.opener == null) mywindow2.opener = self;
					mywindow2.focus();
			
					// return false ... do NOT send the message out		
					return false;
					}
					
		} else return true;
	*/
	}
	
// set new status
function SetA1SigProperties(enabled,fix_font) {
	var obj1 = findObj('id_span_a1_sig_enabled');
	CloseSimpleModalDialog();
		
	// use fix font or not?
	vl_sm_use_fixed_font = fix_font;
		
	// set action and status text
	if (enabled == true) {
		SetSecureMailAction('a1_sign');
		obj1.style.display = '';
		} else {
			SetSecureMailAction('');
			obj1.style.display = 'none';
			}
	}
	
// content has been posted to the server
// open now window for A1 signature ...
function onA1PostSigContentProgress(e) {
	// try to open window for a1 secure viewer
	LaunchA1SecureViewer();
	}
	
// open the dialog for the a1 signature ...
function OpenA1SigDialog() {
	var a_simple_modal_dialog = new cSimpleModalDialog();
		
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'A1 Signatur';
	a_simple_modal_dialog.customcontent_load_from_url = '/email/sm/show_a1_properties.cfm?smaction=' + escape(GetSecureMailAction()) + '&use_fix_font=' + escape(vl_sm_use_fixed_font);
	a_simple_modal_dialog.ShowDialog();	
	}
	

// check if everything is alright and let user (maybe) confirm sending
function ValidateForm(confirmsending)
	{
	var areturn,a_bol_result, obj1;
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var strRecipient = document.sendform.mailto.value;
	
	// close other maybe open dialogs ...

	if (strRecipient == "") {
		a_simple_modal_dialog.type = 'information';
		a_simple_modal_dialog.customcontent = GetLangDataTempTranslation('mail_ph_compose_no_recipients_entered');
		a_simple_modal_dialog.ShowDialog();	
		
		// out of the game
		return false;
		}
	
	// check securemail/a1 Signature
 	areturn = CheckSM();
		
 	if (areturn == false) {
		// out of the game
		return false;
		}
				
   // ask for confirmation?
   if (confirmsending == 1) {			
		a_bol_result = confirm(GetLangDataTempTranslation('mail_ph_compose_confirm_sending_js_box'));
		} else {
			a_bol_result = true;
			}
	
	if (a_bol_result == true) {			
		DisplayPleaseWaitMsgOnLocChange();		
		}

	return a_bol_result;
}
	
	


// show fields
function ShowEncryptionInfo() {
	idtdsecurityinfo.style.display = "";
	idtrsecurityspacertop.style.display = "";
	idtrsecurityspacerbottom.style.display = "";
	idtrmsgmainproperties.style.dispay = "none";
	document.sendform.mailbody.value=document.sendform.mailbody.value+' ';
	idtrmsgmainproperties.style.display = "none";
	}

	
// execute spell checker
function StartSpellCheck() {
	sendtext();
	}

// create a new account ...
function CheckCreateNewAccount() {

	if (document.sendform.mailfrom.value == "gotocreatenewaccount") {
		document.sendform.mailfrom.selectedIndex  = 0;
		mywindow3=open('../rd/settings/email/createnewaccount/','show_create_new_account');
		mywindow3.location.href = '../rd/settings/email/newaccount/';
		if (mywindow3.opener == null) {mywindow3.opener = self;}
		mywindow3.focus();
		}
	}	

// do lookup addresses
function RequestOpenLookup() {

	document.sendform.frmcancellookupwindowopen.value = "1";

	clearTimeout(vl_timeout);

	vl_timeout = setTimeout("OpenLookup();",1000);

	}

	

// set msg format
function SetMsgFormat(format) {
	$('#frmFormat').val(format);
	// set new msg type
	SetMailAction('convertmsgformat');
	document.sendform.submit();
	}

// add an attachment
function AddAttachment() {
	var obj1 = findObj('frmsmaction');
	
	DisplayPleaseWaitMsgOnLocChange();
	
	SetMailAction('addattachment');
	document.sendform.submit();
	}

function SetWindowTitle(str)
	{
	document.title = str+' [E-Mail]';
	}


// remove an attachment ...
function RemoveAttachment(id) {
	SetMailAction('removeattachment');
	document.sendform.frmpartidtoremove.value = id;
	document.sendform.submit();
	}




function Showccandbccfields() {
	Showccfield();
	Showbccfield();
	}		

function Showccfield() {
	$('#idtrcc').show();
	}	

function Showbccfield() {
	$('#idtrbcc').show();
	}

function SwitchView(n) {		
	dspObject1 = findObj('IDtablepreferences');
	dspObject2 = findObj('IDtableaddressbook');
	dspObject3 = findObj('IDaddressbooklink');
	dspObject4 = findObj('IDsettingslink');

	if (n=='0')
		{
		dspObject1.style.display="none";
		dspObject2.style.display="";
		dspObject3.style.fontWeight="bold";
		dspObject4.style.fontWeight="normal";
		}
		else
		{
		dspObject3.style.fontWeight="normal";
		dspObject4.style.fontWeight="bold";
		dspObject1.style.display="";
		dspObject2.style.display="none";
		}

	

}

// load smartload contacts (for faster address input)
function SmartLoadContactDataFromAddressbook()
	{
	var obj1 = findObj('id_iframe_load_contacts');
	var a_src = '/email/utils/show_iframe_load_contacts.cfm';
	
	if (obj1.src) (obj1.src = a_src)
		else (obj1.location.href = a_src);
	}

// check if address book search has been loaded
function CheckLoadAddressBookSearch() {
	var obj1 = findObj('idiframeadddressbook');
	var a_url = 'index.cfm?Action=ShowAddressBookSearchInpage';
	
	if (obj1.src) {
		// firefox
		if (obj1.src.indexOf('show_addressbook_search') == -1) {
			obj1.src = a_url;
			}	
		}
			else {
				// IE
				if (obj1.location.href.indexOf('show_addressbook_search') == -1) {
					obj1.location.href = a_url;
					}	
				}
	}

// show or hide address book 
function ShowOrHideAddressbook() {
	dspObject1 = findObj('idtraddressbook');
	dspObject3 = findObj('idiframeadddressbook');
	dspObject4 = findObj('idtraddressbookend');		
	dspObject2 = findObj('buttonshoworhideaddressbook');

	if (dspObject1.style.display == "") {			
		dspObject1.style.display = "none";
		dspObject4.style.display = "none";			
		if (dspObject2)
			{
			dspObject2.disabled = false;
			}
		} else
			{
			CheckLoadAddressBookSearch();
			
			document.getElementById('idtraddressbook').style.display = '';
			document.getElementById('idtraddressbook').height = 200;

			dspObject1.style.height=200;
			dspObject1.style.display = "";
			dspObject4.style.display = "";
			
			if (dspObject2) {
				dspObject2.disabled = true;
				}
			}

	}
	
function AddHTMLTextToBody(s) {
	// Get the editor instance that we want to interact with.
	var oEditor = FCKeditorAPI.GetInstance('mailbody');

	// Insert the desired HTML.
	oEditor.InsertHtml(s) ;
	}
	
// @@ resize text box for mail input field (text/html)
function AOnCheckResize() {
	var a_top_header_height = $('#id_tbl_top_mail_header').height();
	var abody_height = $(window).height();
	var aheight = abody_height - a_top_header_height;
	var aformat = $('#frmFormat').val();

	$('#id_div_main_fullwindow').css('height', abody_height );
	
	$('#id_div_main_fullwindow').height(abody_height).css('overflow', 'hidden');


	if (aformat == 'html') {
		$('#id_div_mailbody').height(aheight - 5);
		$('#id_div_mailbody div:first').css('height', '100%');
		} else {
			$('#id_mailbody_fieldset').css('height', (aheight));
		}

	// special treatment for the internet explorer necessary
	//if ($.browser.msie == true) {
		//$('#id_mailbody_fieldset').css('height', (aheight - 20));
		//$('#mailbody').css('height', (aheight - 20));
	//	} else $('#mailbody').css('height', '97%');
	}// ** EMAIL autocomplete follows
var currentinputfield;

function UpdateInputHeight(o) {					
	// var o = event.srcElement;
	if (o == null || o.tagName != "TEXTAREA" ) return;
	var clientHeight = parseInt(o.clientHeight);
	var scrollHeight = parseInt(o.scrollHeight);
	var maxHeight = 200;
	
	if (maxHeight == null) maxHeight = 200;

	if (( Math.abs( clientHeight - scrollHeight ) > 3 ) ||
	( clientHeight < scrollHeight )) { // second case added to clear up problems where the text area

	scrollHeight += 3; // TEXTAREA frame

	if ( ( maxHeight != null ) && ( scrollHeight > maxHeight ) )
		scrollHeight = maxHeight;

	if ( scrollHeight != o.offsetHeight )
		o.style.height = scrollHeight + "px";
	}
	
	}
	
function DoLookupSearch(o) {
	clearTimeout(vl_timeout);
	vl_timeout = setTimeout('DoLookup();',100);					
	}
	
function HideLookup() {
	$('#iddivlookup' + GetCurrentInputField()).fadeOut('slow');
	}
	
function ShowLookup() {
	$('#iddivlookup' + GetCurrentInputField()).fadeIn('slow');
	}				
	
function strim(s) {
	s = s.replace(/^\s+/,'').replace(/\s+$/,'');
	return s;
	}	

function DoLookup() {
	var obj1;								
	var searchstring = strim(findObj('mail'+GetCurrentInputField()).value);
	var astr = '';
	var count = 0;
	
	try {
		obj1 = q_select_contacts_wddx;
		}
		catch(er)
			{
				return false;
			}

	
	// parse the search string and take only the part beginning after the last ","
	if (searchstring.indexOf(',') !== -1) {
		var a_int_search = searchstring.split(',');						
		searchstring = strim(a_int_search[a_int_search.length - 1]);	
		}
		
	if (searchstring == '') {
		HideLookup();
		return false;
		}
	
	searchstring = searchstring.toLowerCase();
	
	for(i=0;i<q_select_contacts_wddx.getRowCount();i++) {
		if (count < 7  && ((q_select_contacts_wddx.surname[i].toLowerCase().indexOf(searchstring) !== -1) || (q_select_contacts_wddx.firstname[i].toLowerCase().indexOf(searchstring) !== -1) || (q_select_contacts_wddx.company[i].toLowerCase().indexOf(searchstring) !== -1) || (q_select_contacts_wddx.email_prim[i].toLowerCase().indexOf(searchstring) !== -1)))
			{
			count = count + 1;
			astr = astr + '<div style="padding:2px;" class="bgWhite" onmouseover="ACItemHover(this);" onmousedown="ACItemhClicked(this);"><a style="color:black;text-decoration:none;" onClick="return false;" title="'+q_select_contacts_wddx.firstname[i]+' '+q_select_contacts_wddx.surname[i]+'" href="ac:'+q_select_contacts_wddx.email_prim[i]+'"><img src=/images/si/vcard.png width=16 height=16 border=0 align=absmiddle> <b>'+q_select_contacts_wddx.surname[i] + '</b>, '+q_select_contacts_wddx.firstname[i]+' ('+q_select_contacts_wddx.email_prim[i]+')</a></div>';
			}
		
		}
		
	$('#iddivlookup'+GetCurrentInputField()).html(astr);
	
	if (count == 1) {
		// one hit ... select the first one ...
		highlight_item = document.getElementById('iddivlookup'+GetCurrentInputField()).firstChild;	
		highlight_item.setAttribute("id","lookupHighlight");
		highlight_item.className = 'mischeader';
		}
	
	if (count == 0) HideLookup(); else ShowLookup();
	}
	
function ACSearchKeyPress(event) {
	var a_full_adr;

	if (event.keyCode == 40 )
		{
		// key down
		highlight_item = findObj("lookupHighlight");
		
		if (!highlight_item)
			 {		
			 highlight_item = document.getElementById('iddivlookup'+GetCurrentInputField()).firstChild;	
			 }
				else
				{
				highlight_item.className = 'bgWhite';
				highlight_item.removeAttribute("id");
				highlight_item = highlight_item.nextSibling;
				}						
		
		if (highlight_item)
			{
			highlight_item.setAttribute("id","lookupHighlight");		
			highlight_item.className = 'mischeader';
			} 
		
		}
		
		else if (event.keyCode == 38 )
			{
			// key up
			highlight_item = findObj("lookupHighlight");
			
			if (!highlight_item)
				{
				highlight_item = document.getElementById('iddivlookup'+GetCurrentInputField()).lastChild;
				} 
				else
					{
					highlight_item.className = 'bgWhite';
					highlight_item.removeAttribute("id");
					highlight_item = highlight_item.previousSibling;
					}
			
			if (highlight_item)
				{
				highlight_item.setAttribute("id","lookupHighlight");
				highlight_item.className = 'mischeader';
				}							
			
			}
				else if (event.keyCode == 13 )
					{
					// enter
					
					// check if object exists ...
					try {
						obj_dummy = highlight_item;
						}
						catch(er)
							{
								return false;
							}
					
					if (highlight_item)
						{
					
						/*if (highlight_item && highlight_item.firstChild) 
							{
							highlight_item = document.getElementById("iddivlookupcc").firstChild;	
							}*/
						
						// load autocomplete data ...
						a_full_adr = '';

						if (strim(highlight_item.lastChild.getAttribute("title")).length > 0)
							{
							a_full_adr = '"' + highlight_item.lastChild.getAttribute("title") + '" ';
							}
							
						a_full_adr = a_full_adr + '<' + highlight_item.lastChild.getAttribute("href").replace('ac:', '') + '>';
						a_full_adr = strim(a_full_adr);
						
						AddACAddress(a_full_adr);
						
						HideLookup();
						
						}
					// cleanup input field
					setTimeout("TrimTA(findObj('mail'+GetCurrentInputField()));",1);	
					
					return false;
					}
					else DoLookupSearch(this);
	}
	
	
function AddACAddress(a) {
	var obj1 = findObj('mail' + GetCurrentInputField());
	var oldvalue;
	
	// replace the "ac:"
	a = a.replace('ac:', '');
	
	// replace everything after the last ,
	if (obj1.value.indexOf(',') !== -1)
		{
		oldvalue = '';
		
		a_int_search = obj1.value.split(',');	
		
		searchstring = a_int_search[a_int_search.length - 1];
		
		for(i=0;i<(a_int_search.length - 1 );i++)
			{
			oldvalue = oldvalue + strim(a_int_search[i]) + ', ';
			}
		
		obj1.value = oldvalue + a + ', ';
		}			
			else
				{
				// the first item ...
				obj1.value = a+', ';
				}		
	}
	
function TrimTA(o) {
	o.value = strim(o.value);
	o.value = o.value + ' ';
	}
function SetCurrentInputField(s) {
	currentinputfield = s;
	}
function GetCurrentInputField(s) {
	return currentinputfield;
	}
	
function ACItemHover(el) {
	highlight_item = document.getElementById("lookupHighlight");
	if (highlight_item) {
		highlight_item.removeAttribute("id");
		highlight_item.className = 'bgWhite';
		}
	el.setAttribute("id","lookupHighlight");
	el.className = 'mischeader';
	}

function ACItemhClicked(el) {
	highlight_item = document.getElementById("lookupHighlight");
	if (highlight_item) {
		highlight_item.removeAttribute("id");
		highlight_item.className = 'bgWhite';
		}
	el.setAttribute("id","lookupHighlight");
	el.className = 'mischeader';

	a_full_adr = '';

	if (strim(el.lastChild.getAttribute("title")).length > 0) {
		a_full_adr = '"' + el.lastChild.getAttribute("title") + '" ';
		}

	a_full_adr = a_full_adr + '<' + el.lastChild.getAttribute("href").replace('ac:', '') + '>';
	a_full_adr = strim(a_full_adr);

	AddACAddress(a_full_adr);

	HideLookup();
}						


// other functions
function AttachNeccessaryEvents() {
	
	$('#mailto').keyup(function() {UpdateInputHeight(this);});
	
	if (navigator.product == "Gecko") {	
		// add resize listener
		window.addEventListener("onresize", AOnCheckResize, false);	
		document.getElementById('mailcc').addEventListener("keypress",ACSearchKeyPress,false);	
		document.getElementById('mailcc').addEventListener('onKeyUp',UpdateInputHeight,false);
		document.getElementById('mailcc').addEventListener('oncut',UpdateInputHeight,false);
		document.getElementById('mailcc').addEventListener('onMouseOut',UpdateInputHeight,false);
		document.getElementById('mailcc').addEventListener('onSelect',UpdateInputHeight,false);	
		document.getElementById('mailto').addEventListener("keypress",ACSearchKeyPress,false);	
		// document.getElementById('mailto').addEventListener('onKeyUp',UpdateInputHeight,false);
		document.getElementById('mailto').addEventListener('oncut',UpdateInputHeight,false);
		document.getElementById('mailto').addEventListener('onMouseOut',UpdateInputHeight,false);
		document.getElementById('mailto').addEventListener('onSelect',UpdateInputHeight,false);	
		document.getElementById('mailbcc').addEventListener("keypress",ACSearchKeyPress,false);	
		document.getElementById('mailbcc').addEventListener('onKeyUp',UpdateInputHeight,false);
		document.getElementById('mailbcc').addEventListener('oncut',UpdateInputHeight,false);
		document.getElementById('mailbcc').addEventListener('onMouseOut',UpdateInputHeight,false);
		document.getElementById('mailbcc').addEventListener('onSelect',UpdateInputHeight,false);										
	} else {
		window.attachEvent("onresize", AOnCheckResize);
		document.getElementById('mailcc').attachEvent('onkeydown',ACSearchKeyPress);
		document.getElementById('mailcc').attachEvent('onkeyup',UpdateInputHeight);
		document.getElementById('mailcc').attachEvent('oncut',UpdateInputHeight);
		document.getElementById('mailcc').attachEvent('onmouseout',UpdateInputHeight);
		document.getElementById('mailcc').attachEvent('onselect',UpdateInputHeight);
		document.getElementById('mailto').attachEvent('onkeydown',ACSearchKeyPress);
		document.getElementById('mailto').attachEvent('onkeyup',UpdateInputHeight);
		document.getElementById('mailto').attachEvent('oncut',UpdateInputHeight);
		document.getElementById('mailto').attachEvent('onmouseout',UpdateInputHeight);
		document.getElementById('mailto').attachEvent('onselect',UpdateInputHeight);		
		document.getElementById('mailbcc').attachEvent('onkeydown',ACSearchKeyPress);
		document.getElementById('mailbcc').attachEvent('onkeyup',UpdateInputHeight);
		document.getElementById('mailbcc').attachEvent('oncut',UpdateInputHeight);
		document.getElementById('mailbcc').attachEvent('onmouseout',UpdateInputHeight);
		document.getElementById('mailbcc').attachEvent('onselect',UpdateInputHeight);		
		isIE = true;
		}
	}