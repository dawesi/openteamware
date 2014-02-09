var vl_cur_row = '';
var vl_old_row = '';
var vl_servicekey = '52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5';
// array holding message information
var a_arr_msgs = new Array(0);

var a_mbox_items = new Array(1);

$(document).ready( function() {
	UpdatePageHeight();
});

$(window).resize( function() {
	UpdatePageHeight();
});

function UpdatePageHeight() {
	var totalheight = $(window).height();
	var a_header = parseInt( $('#id_top_header_navigation').outerHeight({ margin: true }) );
	var a_menu_header = parseInt( $('#id_header_menu').outerHeight({ margin: true }) );
	var a_bottom = parseInt( $('#id_bottom_info').outerHeight({ margin: true }) );
	var a_new_height = totalheight - a_header - a_menu_header - a_bottom - 12;
	
	$('#iddivmboxcontent').height( a_new_height );
	$('#id_div_msg_display').height( a_new_height );	
	}

function ConfirmMove(msg) {
	if (confirm(msg) == true) {
		MoveMessage();
		}
	}
function DisplayOtherFoldersMoveTargets() {
	findObj('id_div_move_message_saved_target').style.display = 'none';
	findObj('id_div_move_message_target_folder').style.display = '';
	}
	
// New way to display mailbox content
function DisplayMBoxContentASync(foldername, startrow) {
	var a_simple_get = new cBasicBgOperation();
	var a_startrow = 1;
	if (startrow) {a_startrow = startrow;}
	$('#iddivmboxcontent').html(a_str_loading_status_img);
	a_simple_get.url = 'default.cfm?action=ShowMailboxContent&mailbox=' + encodeURIComponent(foldername) + '&smartload=1&startrow=' + escape(a_startrow);
	a_simple_get.id_obj_display_content = 'iddivmboxcontent';
	a_simple_get.doOperation();
	}
	
// open msg in cols view
function OpenMsgInColView(mailbox,id,userkey,rownumber) {
	ShowLoadingStatus();
	window.frameemailmessage.location.href = 'default.cfm?action=showmessage&mailbox=' + encodeURIComponent(mailbox) + '&rowno=' + encodeURIComponent(rownumber) + '&id=' + escape(id) + '&userkey=' + escape(userkey);
	}
	
// set secure mail action name
function SetSecureMailAction(action) {
	document.sendform.frmsmaction.value = action;
	}
	
function GetSecureMailAction() {
	return '';
	// return document.sendform.frmsmaction.value;
	}

// show quick reply field
function ShowQA() {
	$("#idtableqa").show("slow");
	document.formqa.frmtext.focus();
	}

function CreatePDF() {
	var mywindow = open('show_create_pdf.cfm?' + window.location.search.substring(1), 'show_create_pdf','resizable=no,width=350,height=270');
	mywindow.location.href = 'show_create_pdf.cfm?'+window.location.search.substring(1);
	if (mywindow.opener == null) mywindow.opener = self;
	mywindow.focus();
	}
	
function OpenDraftMsg(id) {
	window.open('/email/default.cfm?action=composemail&draftid=' + escape(id), '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=790,height=680');
	}
	
function OpenComposePopup() {
	window.open('/email/default.cfm?action=composemail', '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=840,height=620');
	}
	
function OpenComposePopupText() {
	window.open('/email/default.cfm?action=composemail&format=text', '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=840,height=620');
	}
function OpenComposePopupHTML() {
	window.open('/email/default.cfm?action=composemail&format=html', '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=840,height=620');
	}
	
function OpenComposeWindow(messagetype,uid,mbox,to,replytoall) {
	if (!replytoall) replytoall = 0;
	window.open('/email/default.cfm?action=composemail&type='+messagetype+'&id='+uid+'&mailbox='+encodeURIComponent(mbox)+'&all='+replytoall, '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=840,height=620');
	return false;
	}
	
function OpenMsgInNewWindow(mailbox,uid,userkey) {
	window.open('/email/default.cfm?action=showmessage&fullheader=1&id='+encodeURIComponent(uid)+'&mailbox='+encodeURIComponent(mailbox)+'&popup=1&userkey='+escape(userkey), '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=860,height=700');
	}

function DisplayOtherMsgUsingSearchWindow(entrykey, email_adr, fromto) {
	var url = '/email/show_popup_search.cfm?addressbookkey=' + escape(entrykey) + '&search=' + encodeURIComponent(email_adr) + '&startsearch=true&fields=' + escape(fromto);
	window.open(url, 'show_email_search','resizable=no,width=750,height=450');
	}
	
// show headers of message
function ShowHeaders(mailbox,uid,caption) {
	var a_str_url = '/email/utils/inc_show_headers_of_msg.cfm?mailbox=' + encodeURIComponent(mailbox) + '&uid=' + encodeURIComponent(uid);
	var a_simple_modal_dialog = new cSimpleModalDialog();
	
	a_simple_modal_dialog.type = 'custom';

	a_simple_modal_dialog.customtitle = caption;

	a_simple_modal_dialog.customcontent_load_from_url = a_str_url;
	a_simple_modal_dialog.ShowDialog();	
	}
	
function BlockAddress(address, windowcaption) {
	var a_str_url = '/email/utils/dsp_inc_block_address.cfm?address=' + encodeURIComponent(address);
	
	var a_simple_modal_dialog = new cSimpleModalDialog();

	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = windowcaption;
	a_simple_modal_dialog.customcontent_load_from_url = a_str_url;
	// show dialog
	a_simple_modal_dialog.ShowDialog();
	}
	
// report a certain message as spam
function ReportAsSpam(mailbox,uid,windowcaption,senderaddress) {	
	var a_str_url = '/email/utils/dsp_report_as_spam.cfm?mailbox=' + encodeURIComponent(mailbox) + '&uid=' + escape(uid) + '&senderaddress=' + escape(senderaddress);
	
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';

	a_simple_modal_dialog.customtitle = windowcaption;

	a_simple_modal_dialog.customcontent_load_from_url = a_str_url;
	// show dialog
	a_simple_modal_dialog.ShowDialog();
	
	}
	

// add item to address book
function CallSimpleAddAddressbookDialog(data,caption) {
	var a_str_url = '/email/utils/dsp_inc_simple_add_to_addressbook.cfm?data=' + encodeURIComponent(data);
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';

	a_simple_modal_dialog.customtitle = caption;

	a_simple_modal_dialog.customcontent_load_from_url = a_str_url;
	// show dialog
	a_simple_modal_dialog.ShowDialog();
	}
	
// call add action of addressbook
function ExecuteSimpleAddAddressbookDialog() {
	var a_simple_get = new cBasicBgOperation();
	var a_str_url = '/email/utils/inc_add_simple_addressbook.cfm?firstname='+encodeURIComponent(document.forms.frm_simpleadd_address.frmfirstname.value) + '&surname=' + encodeURIComponent(document.forms.frm_simpleadd_address.frmsurname.value) + '&email=' + escape(document.forms.frm_simpleadd_address.frmemail.value) + '&company=' + encodeURIComponent(document.forms.frm_simpleadd_address.frmcompany.value) + '&remoteedit=' + encodeURIComponent(document.forms.frm_simpleadd_address.frm_cb_remote_edit.checked);
	
	ShowLoadingStatus();
	
	a_simple_get.url = a_str_url;
	try {
		a_simple_get.callback_function = processReqSimpleAddAddressbookChange;
		} catch(err) {	}
	a_simple_get.doOperation();	
	
	return false;
	}
	
// notify someone ...
function OpenSMSInfoPopup(contactkey,address,subject,senderaddress) {
	var a_str_url = '/mobile/default.cfm?Action=SendSMSNotificationOfMail&email=' + encodeURIComponent(address) + '&contactkey=' + encodeURIComponent(contactkey) + '&subject=' + encodeURIComponent(subject) + '&senderaddress=' + encodeURIComponent(senderaddress);
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.SetType('custom').SetTitle('SMS');
	a_simple_modal_dialog.customcontent_load_from_url = a_str_url;
	a_simple_modal_dialog.ShowDialog();
	}
	
function smsnotifychecklen(feld) {
    var anz = feld.value.length;
    if (anz > 160 ) {
      feld.value = feld.value.substring(0,160);
      frei = 0;
    } else {
      frei = (160-anz);
    }
    document.forms["form1"].num.value = frei;
	
	}
	
function SendQANew(mailbox,id) {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'SendQuickReply';
	req.callback_function = CloseSimpleModalDialog;
	req.AddParameter('frmmailbox', mailbox);
	req.AddParameter('frmid', id);
	req.AddParameter('frmtext', document.forms.formqa.frmtext.value);
	req.AddParameter('frmquote', document.forms.formqa.frmquote.checked);
	req.doCall();	
	}


function MakeLineInvisible(rowno) {
	$('#id_row_' + rowno).hide();
	}
	
function OpenMsgInNewWindow(mailbox,uid,userkey) {
	window.open('default.cfm?action=showmessage&fullheader=1&id='+uid+'&mailbox='+escape(mailbox)+'&popup=1', '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=680,height=600');
	}
	
function tglSelectMsgs() {
	var y;
	var obj1 = $('#iddivactions');
	var aenabled = false;
	
   	for (var x=0;x<document.mboxform.elements.length;x++)  {
		y=document.mboxform.elements[x]; 
       	if (y.checked) {
			obj1.show();
			return;
			}
     	}
    
    obj1.hide();
	}
	
// flag msg (3 = yes, 30 = no)
function FlagMessage(id,row,folder,status) {
	var obj1 = findObj('idimgstatus'+row);
	var myImage = new Image();
	obj1.src = '/images/flag.gif';
	obj1.width = 16;
	obj1.height = 16;
	
	myImage.src = "img_set_status_mail.cfm?mailbox=" + escape(folder) + "&id=" + id + "&status=" + status;
	}
	
	
function AllMessages() { 
   for(var x=0;x<document.mboxform.elements.length;x++) 
     { var y=document.mboxform.elements[x]; 
       if(y.name!='frmcbselectall') y.checked=document.mboxform.frmcbselectall.checked; 
     }
 }	
	
function onQAPostSent(responseText) {
	findObj('id_div_mail_action_list').style.display = '';
	findObj('idtableqa').style.display = 'none';
	findObj('id_tr_qa_sent_successfully_information').style.display = '';
	
	CloseSimpleModalDialog();
	}
	
// further mail properties ...
function ShowMailProperties() {
	var obj1 = findObj('id_div_mail_properties'); 
	if (obj1.style.display == 'block') {
		$("#id_div_mail_properties").hide('slow');
		} else {
			$("#id_div_mail_properties").show('slow'); 
			}
	return false;
	}
	
// modify display of mbox (cols)
function PrepareMBoxColsDisplay() {
	HLOverviewTbl();
	$(".table_overview input:checkbox").click(function() {tglSelectMsgs();});
	$(".table_overview div").addClass("addinfotext");
	
	$('tr[@id*=id_row_]').click(function(event) {
		$('#id_table_msg_header_displays tr').removeClass('highlight');
		$(this).addClass('highlight');
		});
	
	if ($('#id_div_msg_display').html() == '') {
		$('#idhref0').click();			
		}
	}
	
// parse WDDX response
function DoParseCheckA1SigStatus(responseText) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var a_xml_doc = GetNewXMLObjectWithContent(responseText);
	var a_str_status_msg = a_xml_doc.getElementsByTagName("message")[0].childNodes[0].nodeValue;
	var a_str_status_code = a_xml_doc.getElementsByTagName("code")[0].childNodes[0].nodeValue;
	
	// evaluate reponse (will become JS object)
	// eval(responseText);
	
	// if (q_select_status.status[0] == 200)
	if (a_str_status_code == 200) {
		
		// close dialog (other will be opend)
		CloseSimpleModalDialog();
		
		// set securemail action ...
		SetSecureMailAction('a1_sign');
		
		// show status
		a_simple_modal_dialog.type = 'custom';
		a_simple_modal_dialog.customtitle = GetLangData(7);
		a_simple_modal_dialog.customcontent = GetLangDataTempTranslation('mail_ph_status_sending_mail');
		a_simple_modal_dialog.ShowDialog();		
		
		// send form ... and do not stop again for the mobile signature!
		vg_stop_for_mobile_signature = false;
		document.sendform.submit();
		} else {
			CloseSimpleModalDialog();
			// an error occured ...
			alert(a_str_status_msg);
			}
	}
	

// open text blocks window
function opentextblocks(format) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var aurl = 'default.cfm?action=ShowInsertTextBlockSignatur&format=' + escape(format);
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'test';
	a_simple_modal_dialog.customcontent_load_from_url = aurl;
	a_simple_modal_dialog.ShowDialog();	
	}
	
// delete a mailbox
function AskDeleteMailbox(foldername) {
	GotoLocHref('default.cfm?action=DeleteMailbox&mailbox=' + encodeURIComponent(foldername));
	
	/*var a_simple_modal_dialog = new cSimpleModalDialog();
	var aurl = 'default.cfm?action=askdeletemailbox&mailbox=' + escape(foldername);
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.executeurl = ' ';
	a_simple_modal_dialog.ShowDialog();*/
	}
	
// call edit page for a folder
function EditMailbox(mbox) {
	location.href = 'default.cfm?action=editmailbox&mailbox=' + encodeURIComponent(mbox);
	}
	
// restrict display to a certain type
function GotoRestrictedMboxView() {
	location.href = "default.cfm?action=ShowMailbox&mailbox=inbox&restrict="+document.formgotorestrictedmboxview.frmGotoRestrictedVersionOfInbox.value;
	}
	
// signature / textblock edit: insert text
function AddTextToBody(format, inputid) {
	var atext = findObj(inputid).value;
	var oEditor = null;
	
	if (document.sendform.frmFormat.value == 'text') {
		insertAtCaret(document.sendform.mailbody, atext);
		} else {
			oEditor = FCKeditorAPI.GetInstance('mailbody');
			if (format == 'text') {atext = replase(atext); }
			oEditor.InsertHtml(atext) ;
			}
	
	CloseSimpleModalDialog();
	}
	
// replace linebreaks with break for html
function replase(s) {
 	var a=0 , b="", c="" , n=0;

 	for(n = 0; n < s.length; n++)
		{
  		c=s.charAt(n)
  		if(c == '\n'){c="<br/>"}
  		b=b+c;
		}
  
  	return b;
  	}// insert a text at the current position
function insertAtCaret(obj, text) {
	if(document.selection) {
		obj.focus();
		var orig = obj.value.replace(/\r\n/g, "\n");
		var range = document.selection.createRange();

		if(range.parentElement() != obj) {
			return false;
		}

		range.text = text;
		
		var actual = tmp = obj.value.replace(/\r\n/g, "\n");

		for(var diff = 0; diff < orig.length; diff++) {
			if(orig.charAt(diff) != actual.charAt(diff)) break;
		}

		for(var index = 0, start = 0; 
			tmp.match(text) 
				&& (tmp = tmp.replace(text, "")) 
				&& index <= diff; 
			index = start + text.length
		) {
			start = actual.indexOf(text, index);
		}
	} else if(obj.selectionStart) {
		var start = obj.selectionStart;
		var end   = obj.selectionEnd;

		obj.value = obj.value.substr(0, start) 
			+ text 
			+ obj.value.substr(end, obj.value.length);
	}
	
	if(start != null) {
		setCaretTo(obj, start + text.length);
	} else {
		obj.value += text;
	}
}

function setCaretTo(obj, pos) {
	if(obj.createTextRange) {
		var range = obj.createTextRange();
		range.move('character', pos);
		range.select();
	} else if(obj.selectionStart) {
		obj.focus();
		obj.setSelectionRange(pos, pos);
	}
}

// add an email to the CRM history of a contact ...
function AddMailToCRMHistory(foldername,uid,messageid,contactkey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var aurl = 'default.cfm?action=AddMailToCRMHistory&mailbox=' + escape(foldername) + '&uid=' + escape(uid) + '&messageid=' + escape(messageid) + '&contactkey=' + escape(contactkey);
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'abc';
	a_simple_modal_dialog.customcontent_load_from_url = aurl;
	a_simple_modal_dialog.customwidth = '70%';
	a_simple_modal_dialog.ShowDialog();		
	}
	
// delete a message ...
function DeleteMessage(id,mbox,rowno,redirect,openfullcontent, mbox_md5) {
	var req = new cSimpleAsyncXMLRequest();
	
	ShowLoadingStatus();
	
	$('#id_div_msg_display').fadeOut( 'fast' );
	a_mbox_items[rowno].deleted = true;
	MakeLineInvisible( rowno );
		
	req.action = 'DeleteMessage';
	req.AddParameter('uid', id);
	req.AddParameter('foldername', mbox);
	req.AddParameter('redirect', redirect);
	req.AddParameter('openfullcontent', openfullcontent);
	req.AddParameter('mbox_md5', mbox_md5);
	req.doCall();	
	
	LoadNextAvailableMessage( rowno );
	}
	
// move a message ...
/*
function MoveMessage(id,mbox,rowno,redirect,openfullcontent,targetfolder) {
	var req = new cSimpleAsyncXMLRequest();
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.customtitle = GetLangData(7);
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customcontent = $('#id_span_status_move').html() +  a_str_loading_status_img;
	a_simple_modal_dialog.ShowDialog();		
	
	// make line invisible if possible
	if (openfullcontent == false) {
		parent.MakeLineInvisible(rowno);
		}
	
	req.action = 'MoveMessage';
	req.AddParameter('uid', id);
	req.AddParameter('foldername', mbox);
	req.AddParameter('targetfolder', targetfolder);
	req.AddParameter('redirect', redirect);
	req.AddParameter('openfullcontent', openfullcontent);
	req.doCall();	
	}*/
	
// show left folder overview first time ...
function LoadFolderSmallOV() {
	// set personal preference ...
	SetPersonalPreferenceValue('email', 'showfoldersleft', 1);
	ShowLoadingStatus();
	
	$.get("default.cfm?action=ShowFolderOverviewLeft", function(data){
		DspFolderSmallOV(data);
		HideStatusInformation();
		});
	
	}
	
// display folder output
function DspFolderSmallOV(data) {
	var a_str_div_id = 'id_div_email_folders_left';
	var a_div = $('#' + a_str_div_id);
	var a_str_data = '<td class="mischeader" style="vertical-align:top;width:140px"><div id="' + a_str_div_id + '"></div></td>';
			
	if (a_div.size() > 0) {
		a_div.html(data).show();
		} else
			{
			a_str_data = a_str_data.replace('%DATA%', data);
	  		$('#id_left_nav').after(a_str_data);
	  		$('#' +  a_str_div_id ).html(data);
			}
	// generate tv
	$("#id_ul_folder_list_sel").Treeview({collapsed: true });
	
	}
	
// load smart message
function LoadEmailMessage(sender) {
	var sender = $(sender);
	var href = sender.attr('href') + '&smartload=1';
	
	ShowLoadingStatus();
	
	$('#id_div_msg_display').html( a_str_loading_status_img );
	
	$.get(href,
	  function(data){
	    $('#id_div_msg_display').html(data).css('height', 'auto').show();
	    $('#id_div_mox_msg_display').css('height', 'auto');
	    
	    // top scroller
	    UpdatePageHeight();
	  }
	);
	}
	
// load next message
function LoadNextAvailableMessage(rowno) {
	var a_min_diff = 9999;
	var a_new_row = -1;
	
	// console.log( 'deleted: ' + rowno );
	if (a_mbox_items.length == 0) {
		return;
		}
		
	// console.log( a_mbox_items );
		
	for (var i = 0; i < a_mbox_items.length; i++) {
		var adiff = Math.abs( rowno - a_mbox_items[ i ].rowno);
		var a_deleted = a_mbox_items[ i ].deleted;
		// console.log( 'test for row number ' + a_mbox_items[ i ].rowno + ': ' + adiff + ' ' + a_deleted );
		
		if ((a_deleted == false) && (adiff < a_min_diff)) {
			a_new_row = a_mbox_items[ i ].rowno;
			a_min_diff = adiff;
			// console.log( 'new value is ' + a_min_diff );
			}
		
		}
		
	if (a_new_row !== -1) {
		$('#idhref' + a_new_row).click();		
		
	}
	
	// '#idhref' + String( parseInt( rowno ) + 2);
	//alert( rowno + '   ' + a_new_row );
	
	//$(a_new_row).click();
	}