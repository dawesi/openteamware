// Background and display routines for various services
var normalColor;
var a_str_add_marker_title = '';
var a_str_servicekey_add_marker = '';
var counter_menu = 0;
var a_current_menu_displayed = '';
var a_current_open_inpage_popup_div_name = '';
var a_http_load_in_page_popup;
var a_current_simple_modal_dialog;
var a_http_load_object;
var a_str_last_http_call_responseText = '';
// the current service entrykey
var vl_current_service_entrykey = '';
// service app name
var vl_app_name = 'openTeamWare';
// current username
var vl_current_username = '';
var js_timer_close_html_action_popup;
var vl_tmr_load_email_count;

/* smartload */
var vl_timer_check_async_ready;
var a_str_current_smartload_url = '';
var vl_bol_check_links_active = false;

// supported services = supported directories!
var a_arr_supported_services = new Array('calendar', 'addressbook', 'designguidelines', 'import', 'email');
// supported actions ...
a_arr_supported_services['email'] = new Array('ShowMailbox', 'folders', 'newfolder');
a_arr_supported_services['calendar'] = new Array('ViewDay', 'ViewWeek', 'ViewMonth', 'ViewYear', 'ShowEvent', 'newevent', 'listevents');
a_arr_supported_services['addressbook'] = new Array('ShowContact', 'OwnContactCard', 'RemoteEdit', 'mailinglists', 'birthdaylist', 'telephonelist');
a_arr_supported_services['designguidelines'] = new Array('table', 'datasingle', 'confirm', 'form');
a_arr_supported_services['import'] = new Array('uploadfile', 'importdata');

// auto-generated from gen_js_data.cfm
var a_arr_lang_data = new Array(5);
a_arr_lang_data[0] = new Array("Ja","Nein","Sind Sie sicher?","Bitte warten ...","Speichern","Bestätigung","Schließen","Information","Auswahl","Mehr Details","löschen","bearbeiten");
a_arr_lang_data[1] = new Array("Yes","No ","Are you sure?","Please wait...","Save","Confirmation","Close","","","","Delete","Edit");
a_arr_lang_data[2] = new Array("ano","ne","skutečně povrdit?","","uložit","","zavřít","","","","smazat","zpracovat");
a_arr_lang_data[3] = new Array("ano","ne","skutecne povrdit?","","uložit","","zavrít","","","","smazat","zpracovat");
a_arr_lang_data[4] = new Array("Tak","Nie","Czy jesteś pewny?","","zapamiętaj","Potwierdzenie","Zamknąć","","","","Usunąć","Opracować");
a_arr_lang_data[5] = new Array("Da","Nu","Sunteţi sigur?","Vă rugăm aşteptaţi ...","Memorare","Confirmare","Închide","Informaţie","Selecţie","","şterge","Prelucrare");

var a_str_loading_status_img = '<p align="center"><img alt="" border="0" src="/images/status/img_circle_loading.gif" width="32" height="32" border="0"/></p>';

// get lang data ... language is saved in cookie, index must be provided
function GetLangData(index) {
	var a_lang_no = readCookieEx('USER_LANGUAGE');
	if (a_lang_no == null) {a_lang_no = 0;}
	return (a_arr_lang_data[a_lang_no][index]);
	}
	
// display "loading status" ...
function ShowLoadingStatus() {
	DisplayStatusInformation(GetLangData(3));
	}// set the current service key ...
function SetCurrentServiceEntrykey(s) {
	vl_current_service_entrykey = s;
	}

// open page in sl mode ... testing only
function ChangeLocHref(service, action, params) {
	OpenPage(service, action, params);
	}
	
// do a default location.href, but parse it for SL usage ...
function GotoLocHref(u) {
	ShowLoadingStatus();
	location.href = u;
	}
	
// change loc.href of main frame
function GotoLocHrefMain(u) {
	
	}
	
// return 0/1 based on true /false
function Return01OfTrueFalse(v) {
	if (v == true) {return 1;} else {return 0;}
}
	
// trim string
function Trim(s) {
	var areturn = s.replace(/^\s+/, '');
	return areturn.replace(/\s+$/, '');
	}

// init the in page background div ... for inPage popups
function initInPagePopupThings() {	
	// a) content
	$("body").append('<div id="id_div_inpage_popup"/>');
	$('#id_div_inpage_popup').css({display:"none", zIndex:"202"}).addClass('in_page_popup_default');
	
	// b) background
	$("body").append('<div id="id_div_background_mask_in_page_popup"/>');
	$('#id_div_background_mask_in_page_popup').css({display:"none"}).addClass('in_page_popup_background_mask');
	
	// c HTMLActionPopup
	$("body").append('<div id="id_div_action_menu_popup"/>');
	$('#id_div_action_menu_popup').css({display:"none", width:"auto"}).html('').addClass('div_action_popup');
	}

// center a certain object on screen
function CenterElementToBody(element) {
	var t,l;
	netto    = $(window).height();
	divHoehe = $(element).outerHeight();
	divPos = (netto-divHoehe)/2;
	t = divPos + document.body.scrollTop;
	
	if (t < 20) {
		t = 20;
	}
	
	netto    = $(window).width();
	divWidth = $(element).outerWidth();
	divPos = (netto-divWidth)/2;
	
	$(element).css('left', divPos).css('top', t);			
	}

function hilite(id) {
	$('#' + id).toggleClass('ContentAlternateRow');
	}

function restore(id) {
	$('#' + id).removeClass('ContentAlternateRow');
	}

function getDim(el) {
   var coords = {x: 0, y: 0};
   while (el) {
     coords.x += el.offsetLeft;
     coords.y += el.offsetTop;
     el = el.offsetParent;
   }
   return coords;
}

function findObj(n, d) { 
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
  d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

// check if the page has been loaded in a frameset ...
function PageIsLoadedInFrameSet() {
	return (parent.location.href !== location.href);
	}
// check if page is loaded in the frameset
function CheckFrameSet() {
	// TODO hp: add check for double frameset loading
	return;
	var url = location.pathname + location.search;
	if (parent.location.href == location.href) {
		location.href = '/start/default/?url='+escape(url);
		}				
	}
// change main frame only
function GotoLocHrefMain(u) {
	if (parent.location.href == location.href) {
		location.href = '/start/default/?url='+escape(u);
		} else parent.location.href = u;
	}
	
function OpenComposePopupTo(email_adr) {
	var ato = '';
	if (email_adr) {ato = email_adr;}
	window.open('mailto:'+ escape(email_adr));
	return;
	window.open('/email/default.cfm?action=composemail&to='+escape(ato), '_blank', 'resizable=1,location=0,directories=0,status=1,menubar=0,scrollbars=1,toolbar=0,width=840,height=620');
	}
	
function OpenAssignWindow(servicekey,objectkey,title) {
    var options = "width=600,height=300,";
    options += "resizable=yes,scrollbars=yes,status=yes,";
    options += "menubar=no,toolbar=no,location=no,directories=no";
    var newWin = window.open('/tools/assign_items/show_popup.cfm?servicekey='+escape(servicekey)+'&objectkey='+escape(objectkey)+'&title='+escape(title), 'wd_assignwindow', options);
    newWin.focus();
  }	
  
function OpenNewWindowWithParams(tg) {
	var url = tg;
	var mywin = window.open(url, "_blank", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=840,HEIGHT=620");
	mywin.window.focus();
	}
	
function SetSelectElementsVisibleStatus(onoff) {
	if (onoff == true) {a_str_style = 'visible';} else {a_str_style = 'hidden';}
	
	counter_menu = 0;
	
	CheckDocumentForSelectAndIframes(document);	
	}
	
function CheckDocumentForSelectAndIframes(docum, style) {
	var select_boxes = docum.getElementsByTagName("select");
	DoSetVisibilityOfSelectElements(select_boxes, a_str_style);
	
	counter_menu = counter_menu + 1;

	if (counter_menu > 4) {
		return;
		}
	try
		{		
		// check if frames
		var f_rames = docum.getElementsByTagName("frame");
		
		for (ii=0; ii<f_rames.length; ii=ii+1) {
			if (counter_menu > 4) return;
			CheckDocumentForSelectAndIframes(docum.frames[f_rames[ii].id].document, style);
			}
		
		// check if iframes
		var i_frames = docum.getElementsByTagName("iframe");
		for (ii=0; ii<i_frames.length; ii=ii+1) {
			if (counter_menu > 4) return;
			CheckDocumentForSelectAndIframes(docum.frames[i_frames[ii].id].document, style);
			}
			
		}
	catch (e) {  }
	}
	
// set visible true or false
function DoSetVisibilityOfSelectElements(coll, style) {
	for (ii=0; ii<coll.length; ii=ii+1)
		{
		coll[ii].style.visibility = style;
		}
	}
		
		
// @@ update heights ...
function UpdateHeights() {
	var user_browser = browserSniffer();
	}
			
function AddHiddenMenuToList(title,href) {
	var exists = false;
	// check if exists
	for (ii=0; ii<js_arr_menu_extras.length; ii=ii+1) {
		if (js_arr_menu_extras[ii][0] == title) {exists = true;}
		}
	if (exists != true) {
		js_arr_menu_extras[js_arr_menu_extras.length] = new Array(title, href);
		}
	}
	
// get free space ...
function GetAvaMenuFreeWidth() {
	var obj1,obj2;
	var obj1_width = 0;
	var obj2_width = 0;
	
	obj1 = findObj('id_table_menu_top');
	if (obj1) {obj1_width = obj1.offsetWidth; }
	
	obj2 = findObj('id_span_nav_right');
	if (obj2) {obj2_width = obj2.offsetWidth; }
	
	return (document.body.offsetWidth - obj1_width - obj2_width);
	}		
// request a page using GET without any further processing
function SimpleRequestPage(url, onreadystate) {
	if (window.XMLHttpRequest) {
	req = new XMLHttpRequest();
	if (onreadystate) {req.onreadystatechange = onreadystate;}
	req.open("GET", url, true);
	req.send(null);
	}
	else if (window.ActiveXObject)
		{
		req = new ActiveXObject("Microsoft.XMLHTTP");
		if (req)
			{
			if (onreadystate) {req.onreadystatechange = onreadystate;}
			req.open("GET", url, true);
			req.send();
			}
		}	
			
	return req;
}

// display history
function OpenHistoryList() {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'History';
	a_simple_modal_dialog.customcontent_load_from_url = '/tools/history/show_div_history.cfm';
	a_simple_modal_dialog.ShowDialog();		
	}
			
// call GET
function CallHTTPGet(obj, url, eventOnChange) {
	obj.onreadystatechange = eventOnChange;
	obj.open("GET", url, true);
	obj.send(null);
	}
		
// return a new http object
function GetNewHTTPObject() {
	var obj1;		
	if (window.XMLHttpRequest) {
		obj1 = new XMLHttpRequest();
		} else 
				if (window.ActiveXObject) {
					obj1 = new ActiveXObject("Microsoft.XMLHTTP");
					}
	return obj1;
	}
/* Browser detection script */
function browserSniffer() {
 	var browserName = navigator.appName;
 	var browserVersion = parseInt(navigator.appVersion);
 	var a_return = 'other';	
	
	if (browserName == "Netscape" && browserVersion >= 5) {a_return = "netscape"; }
	
	if (browserName == "Microsoft Internet Explorer" && browserVersion >= 4) {a_return = "ie"; }

	return a_return;	
	}	

// in printmode?
function PageInPrintMode() {
	var a = location.search;
	return (a.indexOf('printmode') > 0);
	}

// hide status information on top ...
function HideStatusInformation() {
	var obj1 = findObj('id_top_status_information');
	
	if (obj1) {
		obj1.style.display = 'none';
		} else {
				try {
				// if in e-mail mode, try parent
				parent.HideStatusInformation();
				} catch (e) { }
			}			
	return true;
	}
	
// display status information on top
function DisplayStatusInformation(s,autohide) {
	var obj1 = GetDisplayStatusObj();
	var a_bol_autohide = false;
	
	if (autohide) {a_bol_autohide = autohide;}
	
	if (obj1) {
		$(obj1).html( s ).show();
		
		if (a_bol_autohide == true) {
			window.setTimeout("HideStatusInformation()", 3000);
			}
		}
		
	}
	
// return the object displaying the current status ...
function GetDisplayStatusObj() {
	var obj1 = findObj('id_top_status_information');
	
	if (!obj1) {
			// maybe in parent window ...
			try
				{
				return parent.parent.GetDisplayStatusObj();
				} catch (e) {}
			}
			
	return obj1;
	}
	
function dummyfunction() {
	// just a dummy function (needed in certain cases)
	}

// has the document finished loading?
function DocumentLoadFinished() {
	return (document.readyState == 'complete');		
	}
	
// close all opened actions popups
function CloseOpenActionPopups(fadeout) {
	var obj1 = findObj(a_current_open_inpage_popup_div_name);
	
	if (fadeout) {
		$(obj1).fadeOut("slow");
		window.clearTimeout(js_timer_close_html_action_popup);
		}
	}
	
function StopHTMLActionPopupCloseTimer() {
	if (window.js_timer_close_html_action_popup) {
		window.clearTimeout(js_timer_close_html_action_popup);
		}
	}
	
// default popup display
function ShowHTMLActionPopup(sender_id, menu_items_or_div_with_items, inner_part) {
	var obj1;
	var sender_object = findObj(sender_id);
	var allLinks;
	var a_pos_left;
	var a_pos_top;
	var a_dim_sender;
	var a_real_popup_div;
	var a_in_inner_part = true;
	var a_int_scroll_top = 0;
	var a_obj_scrolltop = document.body;
	
	// inner part ... check scrollTop position of inner Div
	if (inner_part != undefined) {
			a_in_inner_part = inner_part;
			}
			
	// get ScrollTop from inner Content div
	if (a_in_inner_part){
		
		// check container ... default = document.body (see above)
		// next: standalone window
		if (findObj('id_div_main_fullwindow')) {
			a_obj_scrolltop = findObj('id_div_main_fullwindow');
			}
		// next: default div for inner content
		if (findObj('iddivmaincontent_innerdiv')) {
			a_obj_scrolltop = findObj('iddivmaincontent_innerdiv');
			}
		a_int_scroll_top = a_obj_scrolltop.scrollTop;
		}
	
	// the real div container holding the items later ... created on run-time
	a_real_popup_div = findObj('id_div_action_menu_popup');
	if (!a_real_popup_div)
		{
		// div popup has not been created yet ...
		}	
	a_real_popup_div.style.height = 'auto';
	
	if (typeof(menu_items_or_div_with_items) == 'string')
		{
		// find the div using the given ID
		obj1 =  findObj(menu_items_or_div_with_items);
		// take html from original DIV and set default DIV to the new current DIV
		a_real_popup_div.innerHTML = obj1.innerHTML;
		}
			else
				{
				// glue the action popup menu string together
				$(a_real_popup_div).html(BuildHTMLActionPopupMenuFrom_Class(menu_items_or_div_with_items.menu_items));
				}
	
	obj1 = a_real_popup_div;
	
	// remove timer is enabled
	try {StopHTMLActionPopupCloseTimer();} catch(e) {}
	
	// close other maybe opened popups
	CloseOpenActionPopups(false);
	
	// a_current_open_inpage_popup_div_name
	a_current_open_inpage_popup_div_name = menu_items_or_div_with_items;
	
	// test with always same name
	a_current_open_inpage_popup_div_name = 'id_div_action_menu_popup';
	
	// attach various events ...
	addEventEx(obj1, 'mouseout', HTMLActionPopupOnMouseOut);
	addEventEx(obj1, 'mousemove', HTMLActionPopupOnMouseMove);
	
	// get all hyperlinks ...
	allLinks = obj1.getElementsByTagName('a'); 
	
	for (var i=0;i<allLinks.length;i++) { 
		// close on click
		addEventEx(allLinks[i], 'click', CloseOpenActionPopups);
		// check mouse out
		addEventEx(allLinks[i], 'mouseout', HTMLActionPopupOnMouseOut);
		// check mouse move
		addEventEx(allLinks[i], 'mousemove', HTMLActionPopupOnMouseMove);
		}
	
	// display (and display properly)
	obj1.style.display = '';
	
	a_dim_sender = getDim(sender_object);
	
	// top	
	// left
	a_pos_left = a_dim_sender.x;
	a_pos_top = parseInt(a_dim_sender.y) + $(sender_object).outerHeight();//  - parseInt(a_int_scroll_top);

	$(obj1).css( 'top', a_pos_top).css( 'left', a_pos_left);
	
	// check if too far right
	/*a_pos_left = (obj1.offsetWidth + a_pos_left);
	
	if (a_pos_left >= document.body.offsetWidth) {
		// move to left
		// obj1.style.left = document.body.offsetWidth - obj1.offsetWidth - 40;
		}	
	
	// restrict size
	if (obj1.offsetHeight > 340) {
		obj1.style.height = 340;
		$(obj1).css('paddingRight', '10px').css('borderRight', '0').css('overflow', 'auto');
		}*/
		
	HTMLActionPopupOnMouseOut();
	
		
	}
	
// on MO, close action popup
function HTMLActionPopupOnMouseOut() {
	// clear old event and create new one
	try {StopHTMLActionPopupCloseTimer();} catch(e) {}
	window.js_timer_close_html_action_popup = setTimeout('CloseOpenActionPopups(true)', 1000);
	}

// on Mouse move, keep open
function HTMLActionPopupOnMouseMove() {
	try {StopHTMLActionPopupCloseTimer();} catch(e) {}
	}
	
function findPosX(obj) {
	var curleft = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent)
		{
			curleft += obj.offsetLeft
			obj = obj.offsetParent;
		}
	}
	else if (obj.x)
		curleft += obj.x;
	return curleft;
	}

function findPosY(obj) {
	var curtop = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent)
		{
			curtop += obj.offsetTop
			obj = obj.offsetParent;
		}
	}
	else if (obj.y)
		curtop += obj.y;
	return curtop;
	}		// add an event for an object
// compatible with IE and mozilla
// taken from quirksmode.org
function addEventEx(obj, evType, fn) {
	if (obj.addEventListener) {
		obj.addEventListener(evType, fn, false);
		}
	else if (obj.attachEvent) {
		//alert('attach');
		// obj["e"+evType+fn] = fn;
		//obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
		//obj.attachEvent("on" + type, obj[type+fn] );
		//alert(obj.id);
		try {
			obj.attachEvent("on"+evType, fn); 
			} catch(e) {
					// alert(e);
					}
		
		}
	return true;
}

function removeEventEx( obj, type, fn ) {
	if (obj.removeEventListener)
		obj.removeEventListener( type, fn, false );
	else if (obj.detachEvent)
	{
		obj.detachEvent( "on"+type, obj[type+fn] );
		obj[type+fn] = null;
		obj["e"+type+fn] = null;
	}
}

// read a cookie by name - return null if nothing found
function readCookieEx(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		}
	return null;
	}


// class for holding action popup menu items
function cActionPopupMenuItems() {
	this.menu_items = new Array(0);
	var self = this;
	
	this.AddItem = function(title,href,onClick,alt,style,target) {
		var a_target = '';
		var a_onClick = '';
		var a_alt_title = '';
		var a_style = '';
		// append an item
		// title, href, onclick event, title and style attributes
		if (target) {a_target = target;}
		if (alt) {a_alt_title = alt;}
		if (style) {a_style = style;}
		if (onClick) {a_onClick = onClick;}
		self.menu_items[self.menu_items.length] = new Array(title,href,a_onClick,a_alt_title,a_style,a_target);
		}
	}
	
// write html content ...
function BuildHTMLActionPopupMenuFrom_Class(items) {
	var a_str_html = '';
	var onClickEvent = '';
	var aAltTitle = '';
	var aStyle = '';
	var aTarget = '';
	
	a_str_html = '<ul>';
	
	for(var i=0;i < items.length;i++)
		{
		onClickEvent = '';
		aAltTitle = '';
		aStyle = '';
		aTarget = '';
		
		if (items[i][2].length > 0) {
			onClickEvent = ' onClick="' + items[i][2] + '" ';
			}
			
		if (items[i][3].length > 0) {
			aAltTitle = ' title="' + items[i][3] + '" ';
			}		
			
		if (items[i][4].length > 0) {
			aStyle = ' style="' + items[i][4] + '" ';
			}	
			
		if (items[i][5].length > 0) {
			aStyle = ' target="' + items[i][5] + '" ';
			}					
			
		if (items[i][0] == '-')
			{
			// divider
			a_str_html += '<li style="height:10px;"><hr size="1" noshade/></li>';
			}
				else
					{
					// default
					a_str_html += '<li>';
					a_str_html += '<a href="' + items[i][1] + '"' + onClickEvent + aAltTitle + aStyle + '>&nbsp;&nbsp;&nbsp;&nbsp;' + items[i][0] + '&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					a_str_html += '</li>';
					}
		}
	
	a_str_html += '</ul>';
	return a_str_html;
	}

// ************************************* new: modal dialog

// call the desired action if the user has confirmed something ...
// must be an own function because is called by form
function CallConfirmationYesAction() {
	DisplayStatusInformation(GetLangData(3));
	
	if (a_current_simple_modal_dialog.backgroundexecute) {
		CallHTTPGet(a_current_simple_modal_dialog.a_http_object, a_current_simple_modal_dialog.executeurl, a_current_simple_modal_dialog.backgroundexecute_callback_function);
		} else  {
				// simple call to the right target ...
				switch (a_current_simple_modal_dialog.target) {
					case '_top': {
						window.top.location.href = a_current_simple_modal_dialog.executeurl;
						break;
						}
					default: {
						location.href = a_current_simple_modal_dialog.executeurl;
						}
					}
				}	
	}
	

// class for simple modal dialog
function cSimpleModalDialog() {
	// information, confirmation, warning, custom
	this.type = 'information';
	// window title
	this.customtitle = '';
	// custom content in the window
	this.customcontent = '';
	// load custom content from url ...
	this.customcontent_load_from_url = '';
	// for "confirmation" dialogs, url to call on "yes" click
	this.executeurl = '';	
	// target for yes click
	this.target = '';
	// execute in the background (ajax)?
	this.backgroundexecute = false;
	// function to call after background url has been called
	this.backgroundexecute_callback_function = null;
	// custom content already loaded
	this.customcontent_already_loaded_from_url = false;
	// custom width?
	this.customwidth = '';
	// place this dialog on top of page instead of in the middle
	this.placedialogontop = false;
	// should all found elements of the given form be submitted to the called page?
	this.submitallformelementsofformid = '';
	
	// reference for use in private methods/functions
	var self = this;
	
	// close (maybe) open dialog
	CloseSimpleModalDialog(true);
	
	// global reference
	a_current_simple_modal_dialog = this;
	
	var a_str_header_div_start = '<div id="id_div_inpage_popup_header" class="in_page_popup_title_header">';
	var a_str_header_div_title_start = '<span id="id_page_popup_title">';
	var a_str_header_div_title_end = '</span>';
	var a_str_header_div_end = '</div>';
	var a_str_header_close = '<a href="javascript:CloseSimpleModalDialog();"><img alt=\'' + GetLangData(6) + '\' src="/images/menu/img_close_17x13_white.gif" align="right" vspace="0" hspace="0" border="0"/></a>';
	var a_str_id_load_external_content_div = 'id_div_modal_dialog_load_http_content';
		
	// load content from given custom URL
	function LoadCustomContentFromURL() {
		var a_bg_op = new cBasicBgOperation;
		
		if (self.submitallformelementsofformid != '') {
			a_bg_op.method = 'POST';
			a_bg_op.post_content = SerializeForm(findObj(self.submitallformelementsofformid));
			}
		
		a_bg_op.url = self.customcontent_load_from_url;
		a_bg_op.exec_response_scripts = false;
		a_bg_op.callback_function = processReqLoadCustomContentFromURLChange;
		a_bg_op.doOperation();
		}
		
	function CheckMaxHeightModalBox() {
		var oDlg = $('#id_div_inpage_popup');
		
		oDlg.css( 'overflow', 'auto' );
		
		
		
		// set a max height ...
		if (oDlg.height() > (document.body.offsetHeight - 100)) {
			oDlg.height() = (document.body.offsetHeight - 100);
			}
			
		var iExtContentHeight = $('#id_div_modal_dialog_load_http_content').height();
		
		$('#id_div_modal_dialog_load_http_content').css('height', '400px' ).css('overflow', 'auto');
		
		}
		
	function processReqLoadCustomContentFromURLChange(responsetext) {
		var a_response = responsetext;
		var a_str_content_dlg = a_response + ' ';
		a_str_content_dlg = a_str_content_dlg.replace(/<script /g, '<!-- <span style="display:none" ').replace(/<\/script>/g, '</span> -->');
		
		// set html body of div waiting for content
		$('#' + a_str_id_load_external_content_div).html(a_str_content_dlg);

		// execute scripts ... 
		GetAndEvalScriptsOutOfText(a_response);
		// *** TEST ***
		
		// center object
		CheckMaxHeightModalBox();
		CenterElementToBody(findObj('id_div_inpage_popup'));
		}		
		
	// private function ...
	// build the dialog
	function BuildDialogProperties() {
		var a_str_inner_html = '';
		var a_str_onclick_yes_action = '';
		
			switch(self.type)
				{
				case 'information': {
					a_str_inner_html = a_str_header_div_start + a_str_header_close + ' Information' + a_str_header_div_end;
					a_str_inner_html += '<div style="padding:20px;">'  + self.customcontent + '</div>';
					a_str_inner_html += '<p align="center" style="padding:8px;"><input id="id_modal_dialog_default_button" type="submit" class="btn" onClick="CloseSimpleModalDialog();" value="' + GetLangData(6) + '">' + '</p>';
					break;
					}
				case 'confirmation': {
					a_str_inner_html = a_str_header_div_start + a_str_header_close + GetLangData(5) + a_str_header_div_end;
					// has user given custom text?
					if (self.customcontent.length > 0)
						{
						a_str_custom_text = self.customcontent;
						} else {
							   a_str_custom_text = GetLangData(2);
							   }
							   
					// custom inner text
					a_str_inner_html += '<div style="padding:10px;">' + a_str_custom_text + '</div>';
					
					// yes/no
					a_str_inner_html += '<p align="center" style="padding:8px;">';
					
					a_str_onclick_yes_action = 'CallConfirmationYesAction();';
					
					a_str_inner_html += '<input target="' + self.target + '" onClick="' + a_str_onclick_yes_action + '" id="id_modal_dialog_default_button" type="button" value="' + GetLangData(0) + '" class="btn">&nbsp;&nbsp;&nbsp;';
					// no ... just close
					a_str_inner_html += '<input type="button" value="' + GetLangData(1) + '" class="btn2" onClick="CloseSimpleModalDialog();">';
					
					a_str_inner_html += '</p>';
					
					break;
					}
				case 'custom': {
					// custom dialog
					a_str_inner_html = a_str_header_div_start + a_str_header_close + a_str_header_div_title_start + self.customtitle + a_str_header_div_title_end + a_str_header_div_end;
					a_str_inner_html += '<div style="padding:10px;">'  + self.customcontent + '</div>';
					// a_str_inner_html = a_str_inner_html + '<p align="center" style="padding:8px;"><input type="submit" class="btn" onClick="CloseSimpleModalDialog();" value="' + GetLangData(6) + '">' + '</p>';
					break;
					}
				default: {
					}
				}  
				
		return a_str_inner_html; 
		}
		
	// set url
	this.SetTitle = function(s) {
		self.customtitle = s;
		return self;
		}
		
	// set url
	this.SetCustomContentURL = function(u) {
		self.customcontent_load_from_url = u;
		return self;
	}
	
	// set the type
	this.SetType = function(t) {
		self.type = t;
		return self;
	}		
	
	// call dialog
	this.ShowDialog = function() {
		var obj1 = findObj('id_div_inpage_popup');
		var obj2;
		var a_str_dialog_content = '';
		var obj_bg_mask = findObj('id_div_background_mask_in_page_popup');
		// for top dlg
		var a_str_div_top_id = 'id_div_inpage_popup_page_top';
		var a_str_div_start = '<div id="' + a_str_div_top_id + '" class="b_all" style="display:none;padding:0px;">';
		var a_str_div_end = '</div>';
		var a_str_top_dlg_content = '';		
		
		obj1.innerHTML = '';
		obj1.style.height = 'auto';
		
		if ((self.customcontent_load_from_url.length > 0) && (self.customcontent_already_loaded_from_url == false)) {
			// url has been given, but not been called yet
			self.customcontent = '<div style="padding:0px;" id="' + a_str_id_load_external_content_div +'">' + a_str_loading_status_img + '</div>';
			// load http content ...
			LoadCustomContentFromURL();
			}
		
		// disable select elements
		SetSelectElementsVisibleStatus(false);
		
		// get the dialog content ...
		a_str_dialog_content = BuildDialogProperties();
		
		if (self.placedialogontop == true) {
			
			a_str_top_dlg_content = a_str_div_start +  a_str_dialog_content + a_str_div_end;
			$('#iddivmaincontent_innerdiv').prepend(a_str_top_dlg_content);
			$('#' + a_str_div_top_id).fadeIn();
			FixCSS();
			
			} else {
				obj_bg_mask.style.height = document.body.scrollHeight;
				obj_bg_mask.style.display = 'block';
				
				obj1.innerHTML = a_str_dialog_content;
				$(obj1).fadeIn("fast", "");
				
				// custom width set?
				if (self.customwidth != '') {
					obj1.style.width = self.customwidth;
					}
				
				// center
				CheckMaxHeightModalBox();
				CenterElementToBody(obj1);
				FixCSS();
				
						
				// if "yes" button has been found, focus it!
				obj2 = findObj('id_modal_dialog_default_button');
				if (obj2) {
					try {
						obj2.focus();
						} catch(err) {}
						}	
				
				
			}
				
		
		}
		
	}
	
// close the simple modal dialog
function CloseSimpleModalDialog(simple) {
	var a_simple = false;
	
	if (simple) {a_simple = simple;}
	
	$("#id_div_background_mask_in_page_popup").css("display","none");
	
	if (a_simple) {
	$('#id_div_inpage_popup').html('').hide();
	$('#id_div_inpage_popup_page_top').hide();
	} else {	
	$('#id_div_inpage_popup').html('').fadeOut();
	$('#id_div_inpage_popup_page_top').fadeOut();
	}
	
	SetSelectElementsVisibleStatus(true);
	}
	
// set the title of the inpage popup
function SetTitleOfModalDialog(s) {
	$('#id_page_popup_title').html(s);
	}
	
// put all form tags together ... elements is an array holding "name" and "value" elements
function encode_form_post(elements) {
	var str = '';
	for (i=0; i < elements.length; i++)
		{
		// name / value paris ... encodeURIComponent is important for posting!
		str = str + elements[i].name + "=" + encodeURIComponent(elements[i].value)+ "&";
		}
	return str;
	}
	
function GetNewXMLObjectWithContent(xml_content) {
	var xmlDoc;
	var moz = (typeof document.implementation != 'undefined') && (typeof document.implementation.createDocument != 'undefined');
 	var ie = (typeof window.ActiveXObject != 'undefined');

 	if (moz) {
   		xmlDoc = document.implementation.createDocument("", "", null)
   		xmlDoc.onload = readXML;
 		} else if (ie) {
   			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
   			xmlDoc.async = false;
   			while(xmlDoc.readyState != 4) {};
 			}
 	
	xmlDoc.loadXML(xml_content);
	
	// return the new XML document
	return xmlDoc;
	}
	
// simple basic class for background operations ...
function cBasicBgOperation() {
	this.a_http_object = new GetNewHTTPObject();
	this.url = '';
	// GET or POST
	this.method = 'GET';
	this.callback_function = null;
	this.id_obj_display_content = null;
	this.id_obj_hide_if_empty_display_content = null;
	this.id_obj_show_if_not_empty_display_content = null;
	this.exec_response_scripts = true;
	// 2 parameters especially for POST commands
	this.name_value_pairs = new Array();
	this.post_content = '';
	
	var _self = this;
	
	// execute call ... GET or POST
	this.doOperation = function() {
		
		$('#id_img_server').show();
		
		if (_self.method.toLowerCase() == 'post') {
			
			var a_str_post_content = _self.post_content;
			
			if (_self.post_content.length == 0) {
				encode_form_post(_self.name_value_pairs)
				}
		
			// call post Now
			CallHTTPPost(_self.a_http_object, _self.url, a_str_post_content, OnHTTPReqChangeState);
			} else {
				CallHTTPGet(_self.a_http_object, _self.url, OnHTTPReqChangeState);
				}
		}
	
	// status change ... do call callback function
	function OnHTTPReqChangeState() {
		var a_str_simple_content = '';
		
		if ((_self.a_http_object.readyState == 4) && (_self.a_http_object.status == 200)) {
			
			// set last response
			a_str_last_http_call_responseText = _self.a_http_object.responseText;
				
			// exec scripts?
			if (_self.exec_response_scripts == true) {
				GetAndEvalScriptsOutOfText(a_str_last_http_call_responseText);
				}
				
			// display content somewhere?
			if (_self.id_obj_display_content != null) {
				// rename script tags so that nothing can happen ... set element content to given string
				a_str_simple_content = a_str_last_http_call_responseText + ' ';
				a_str_simple_content = a_str_simple_content.replace('<script type="text/javascript">', '<!--').replace('</script>', '-->');
				$('#' + _self.id_obj_display_content).html(a_str_simple_content);
				}
			
			// if empty, hide an element?			
			if ((_self.id_obj_hide_if_empty_display_content != null) && (Trim(a_str_last_http_call_responseText).length == 0)) {
				$('#' + _self.id_obj_hide_if_empty_display_content).slideUp();
				}
				
			// if *not* empty, show an element?
			if ((_self.id_obj_show_if_not_empty_display_content != null) && (Trim(a_str_last_http_call_responseText).length > 0)) {
				$('#' + _self.id_obj_show_if_not_empty_display_content).slideDown();
				}
			
			// call callback function?
			if (_self.callback_function) {
				_self.callback_function(a_str_last_http_call_responseText);
				}
			
			// hide status info
			$('#id_img_server').hide();
			}
		}	
	}
	
// call post ... request needs to be name/value pairs
function CallHTTPPost(httpobj, url, request, callbackfunction) {
	httpobj.open("POST", url, true);
	httpobj.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	httpobj.setRequestHeader("Connection", "close");
	httpobj.send(request);
	
	if (callbackfunction) {
		httpobj.onreadystatechange = callbackfunction;
		}
	}
	
// basic class for simple background operations
function cSimpleBackgroundOperationRequest() {
	// servicekey
	this.servicekey = '';
	// GET or POST
	this.method = 'GET';
	// query string to add
	this.query_string = '';
	// action name
	this.action = '';
	// entrykey (if possible, otherwise query_string)
	this.entrykey = '';
	// post content ...
	this.post_content = '';
	// callback function
	this.callback_function = null;
		
	var _self = this;
	
	this.DoExecute = function() {
		var a_simple_request;
		var request_method = _self.method.toLowerCase();
		// compose URL
		var a_str_url = '/async_calls/?servicekey=' + escape(_self.servicekey) + '&action=' + escape(_self.action) + '&entrykey=' + escape(_self.entrykey) + '&' + _self.query_string;
		
		if (_self.method == 'get') {
			a_simple_request = new cBasicBgOperation();
			a_simple_request.url = a_str_url;
			a_simple_request.callback_function = _self.callback_function;
			a_simple_request.doOperation();				
			} else {
				// post request
				a_simple_request = new cBasicBgOperation();
				a_simple_request.method = 'post';
				a_simple_request.post_content = _self.post_content;
				a_simple_request.callback_function = _self.callback_function;
				a_simple_request.url = a_str_url;
				a_simple_request.doOperation();
				}
		
		}
	}
// simple function for calling background operation things ...
// more for simple async operations than for e.g. loading contents
function doExeCuteAsyncOperation(servicekey, action, entrykey, query_string, method, post_content, callback_function) {
	var a_simple_operation = new cSimpleBackgroundOperationRequest();
	var a_post_content = '';
	var a_callback_function = null;
	
	if (post_content) {a_post_content = post_content;}
	if (callback_function) {a_callback_function = callback_function;}
	
	// make simple request
	a_simple_operation.servicekey = servicekey;
	a_simple_operation.method = method;
	a_simple_operation.action = action;
	a_simple_operation.entrykey = entrykey;
	a_simple_operation.query_string = query_string;
	a_simple_operation.post_content = a_post_content;
	a_simple_operation.callback_function = a_callback_function;
	
	a_simple_operation.DoExecute();
	
	return true;
	}
	
// select a new tab in the tab menu system
function SelectNewTab(ul_holder_id, li_sender_id) {
	var a_ul_holder = findObj(ul_holder_id);
	var a_li_sender = findObj(li_sender_id);
	var i = 0;
	var a_li_elements;
	
	// get all li elements
	a_li_elements = a_ul_holder.getElementsByTagName('li');
	
	for (var i=0;i<a_li_elements.length;i++) { 
		a_li_elements[i].className = '';			
		}		
	
	// set new active tab
	a_li_sender.className = 'active_tab';
	}
	
// select a new div in the autopage mode ... hide all known DIVs of
// this tab and show the given tab element
function SelectNewTabDefaultPagingMechanismn(tabid, tabitemid_toselect) {
	$('div[@id*="' + tabid + '"]').hide();
	$('#' + tabitemid_toselect).show();
	}
	
function submitenter(myfield,e)	{
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	else return true;
	
	if (keycode == 13) {
	   myfield.form.submit();
	   return false;
	   }
	else
	   return true;
	}
	
function OpenEmailQuickSearch() {
	var url = '/email/show_popup_search.cfm';
	window.open(url, 'show_email_search','resizable=no,width=750,height=450');
	}
	
// show information string in top header of page
function ShowHeaderTopInformationString(s) {
	$('#id_span_header_top_info').html(s);
	
	document.title = s + ' - ' + document.title;
	}
	
// add comment ...
function AddComment(servicekey,objectkey) {
	var mywindow=open('/tools/comments/show_add_comment.cfm?servicekey='+escape(servicekey)+'&objectkey='+escape(objectkey),'show_add_comment','resizable=no,width=380,height=250');
	mywindow.location.href = '/tools/comments/show_add_comment.cfm?servicekey='+escape(servicekey)+'&objectkey='+escape(objectkey);
	if (mywindow.opener == null) mywindow.opener = self;
	mywindow.focus();		
	}
	
// load user switch data ...
function LoadUserSwitchData() {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'Single Sign On';
	a_simple_modal_dialog.customwidth = '70%';
	a_simple_modal_dialog.customcontent_load_from_url = '/tools/switch/show_switch_to_other_user.cfm';
	a_simple_modal_dialog.ShowDialog();	
	}

// background operation has been finished	
function onBGPostOperationFinished(rt) {
	DisplayStatusInformation('bg operation' + rt);
	}
	
// variables for universal selector
var a_prop_universal_sel_call_formid;
var a_prop_universal_sel_call_inputid;
var a_prop_universal_sel_call_inputvalue;
var a_prop_universal_sel_call_displayid;
var a_prop_universal_sel_call_displaytype;
var a_prop_universal_sel_call_servicekey;
var a_prop_universal_sel_call_objectkey;

// call universal selector inpage
function CallUniversalSelectorInpage(datatype,formid,inputid,inputvalue,displayid,displaytype,servicekey,objectkey,displayvalue,sendfieldvalues) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var a_str_send_field_values = '';
	
	a_prop_universal_sel_call_formid = formid;
	a_prop_universal_sel_call_inputid = inputid
	a_prop_universal_sel_call_inputvalue = inputvalue;
	a_prop_universal_sel_call_displayid = displayid;
	a_prop_universal_sel_call_displaytype = displaytype;
	
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.submitallformelementsofformid = formid;
	a_simple_modal_dialog.customtitle = GetLangData(8);
	a_simple_modal_dialog.customcontent_load_from_url = '/tools/universalselector/?type=' + escape(datatype) + '&formid=' + escape(formid) + '&inputid=' + escape(inputid) + '&inputvalue=' + escape(inputvalue) + '&displayid=' + escape(displayid) + '&displaytype=' + escape(displaytype) + '&servicekey=' + escape(servicekey) + '&objectkey=' + escape(objectkey) + '&displayvalue=' + escape(displayvalue);
	a_simple_modal_dialog.ShowDialog();
	}
	
// universal selector return (set values of input and display)
function UniversalSelectorSetReturnValues(input_value, display_value) {	
	$('#' + a_prop_universal_sel_call_inputid).val(input_value);

	if (a_prop_universal_sel_call_displaytype == 'div') {
		$('#' + a_prop_universal_sel_call_displayid).html(display_value);
		} else {
			$('#' + a_prop_universal_sel_call_displayid).val(display_value);
			}
	
	CloseSimpleModalDialog();
	}
	
// * take an element (by id) and collect all values of
// all following, checked checkboxes ... generic approach
function CollectCheckedSelectBoxesValues(parentid) {
	var sReturn = '';
	$("#" + parentid + "  input:checked").each(function(i) {
		sReturn = sReturn + ',' + $(this).val();
		});
	return TrimList(sReturn);
	}
	
// loop through checked elements, find corresponding display name (name = given prefix + selected value
function UniversalSelectorGetDisplayValuesOfCheckedElements(parentid, input_id_prefix) {
	var sReturn = '';
	
	$("#" + parentid + "  input:checked").each(function(i) {
		sReturn = sReturn + ',' + $('#' + input_id_prefix + $(this).val()).val();
		});

	return TrimList(sReturn);
	}
	
// check if last item of a list if comma, if true, remove
function TrimList(s) {
	var sReturn = s;
	
	if (sReturn.length > 0) {
		sReturn = sReturn.substr(1, sReturn.length);
		}
		
	return sReturn;
	}
	
// display error message ...
function OpenErrorMessagePopup(errorno, errormsg) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(7);
	a_simple_modal_dialog.customcontent_load_from_url = '/tools/errormsg/?errorno=' + escape(errorno) + '&errormsg=' + escape(errormsg);
	a_simple_modal_dialog.ShowDialog();
	}
	
function OpenInfoMessagePopup(infono, infomsg) {
	var a_simple_modal_dialog = new cSimpleModalDialog();	
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(7);
	a_simple_modal_dialog.customcontent_load_from_url = '/tools/infomsg/?infono=' + escape(infono) + '&infomsg=' + escape(infomsg);
	a_simple_modal_dialog.ShowDialog();
	}
	
function DisplayPleaseWaitMsgOnLocChange() {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(3);
	a_simple_modal_dialog.customcontent = GetLangData(3) + a_str_loading_status_img;
	a_simple_modal_dialog.ShowDialog();
	}

// return the directory by the servicekey
function GetDirectoryByServiceKey(s) {
	
	switch (s) {
		
		case 'crm':
			return 'crm';
			break;
		case '7E68B84A-BB31-FCC0-56E6125343C704EF':
			return 'crm';
			break;
		case '52227624-9DAA-05E9-0892A27198268072':
			return 'addressbook'
			break;
		case '5222B55D-B96B-1960-70BF55BD1435D273':
			return 'calendar'
			break;
		case '52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5':
			return 'email';
			break;
		case '7E70C2DD-9866-2B68-C78B1C805A2905F6':
			return 'settings';
			break;
		case '5222ECD3-06C4-3804-E92ED804C82B68A2':
			return 'storage';
			break;
		case '66A3CE92-923A-0620-7656393EA07FAB3B':
			return 'forum';
			break;			
		default:
			return 'unknownrequest';
			break;
		}
	}
	
// simple asynchronous request
function cSimpleAsyncXMLRequest() {
	this.servicekey = '';
	this.action = '';
	this.callback_function = null;
	this.id_show_call_output = null;
	this.exec_response_scripts = true;
	this.xmlstring = "<?xml version='1.0' encoding='utf-8'?><data>";
	this.a_post_cmd = new cBasicBgOperation();
	
	var _self = this;
	
	// add a new value
	this.AddParameter = function(name, value) {
		_self.xmlstring = _self.xmlstring + '<' + name + '><![CDATA[' + encodeURIComponent(value) + ']]></' + name + '>';
  		}
		
	// build string holding the request
	this.doCall = function() {
		var a_arr_elements = new Array();
		a_arr_elements[0] = 'frmrequest=' + encodeURIComponent(_self.xmlstring) + '</data>';
		a_arr_elements[1] = 'frmaction=' + encodeURIComponent(_self.action);
		
		// if no servicekey has been provided, use the current one ...
		if (_self.servicekey == '') {
			_self.servicekey = vl_current_service_entrykey;
			}
		
		// create the post structure
		a_str_post_content = a_arr_elements.join("&");
		_self.a_post_cmd.post_content = a_str_post_content;
		// exec scripts?
		_self.a_post_cmd.exec_response_scripts = _self.exec_response_scripts;
		// post to the general background action (!)
		_self.a_post_cmd.url = '/' + GetDirectoryByServiceKey(_self.servicekey) + '/?action=doPostBackgroundAction';
		// bg options?
		if (_self.callback_function != null) {
			_self.a_post_cmd.callback_function = _self.callback_function;
			}
			
		_self.a_post_cmd.id_obj_display_content = _self.id_show_call_output;
		_self.a_post_cmd.method = 'POST';
		
		_self.a_post_cmd.doOperation();
		}

	}
	
// extract and eval scripts out of text
function GetAndEvalScriptsOutOfText(s, add_tmp_id) {
	var a_arr_scripts = new Array(1);
	var a_str_ScriptFragment = '(?:<script.*?>)((\n|.)*?)(?:<\/script>)';
	var _match, r, i;
	var a_scripts = new Array(1);
	var a_add_tmp_id = false;
	
	// add a temporary ID to the script added to header
	if (add_tmp_id) {a_add_tmp_id = add_tmp_id;}
	
	_match = new RegExp(a_str_ScriptFragment, 'img');
	r = s.replace(_match, '');
	a_scripts  = s.match(_match); 		
	_match = new RegExp(a_str_ScriptFragment, 'im');
	
	if (a_scripts) {
		for (var i = 0; i < a_scripts.length; i++) {
			a_arr_scripts[i] = a_scripts[i].match(_match)[1].replace(/^\s+/g, "").replace(/\s+$/g, "");
			}
		
		for (var i = 0; i < a_arr_scripts.length; i++) {
			// is it a function or simple JS? insert into header if necessary
			
			if (a_arr_scripts[i].indexOf('function') == 0) {
				var script=document.createElement('script');
				script.text = a_arr_scripts[i];
				
				if (a_add_tmp_id == true) {
					script.setAttribute('type', 'text/javascript');
					script.setAttribute('id', 'ibx_sl_tmp' + i); // + Math.floor(Math.random() * 6));
					}
				document.getElementsByTagName('head')[0].appendChild(script);	
				} else {
					// execute right now
					eval(a_arr_scripts[i]);
					}
			}
		}
	return true;
	}
   	
// display logout dialog
function ShowLogoutDialog() {
	ShowSimpleConfirmationDialog('/logout.cfm?confirmed=true', '_top');
	}
	
// show a basic and simple confirmation dialog and execute the given action if user accepts
function ShowSimpleConfirmationDialog(executeurl, target) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	var a_target = '';
	
	if (target) {a_target = target;}
	
	a_simple_modal_dialog.type = 'confirmation';
	a_simple_modal_dialog.customcontent = '';
	a_simple_modal_dialog.target = a_target;
	a_simple_modal_dialog.executeurl = executeurl;
	a_simple_modal_dialog.ShowDialog();	
	}
	

// remove all old temporary scripts ...
function RemoveOldTempScripts() {
	var allscripts = document.getElementsByTagName('script'); 
	
	for (var i=0;i<allscripts.length;i++) {
		if ((allscripts[i].id != '') && (allscripts[i].id.toUpperCase().indexOf('IBX_SL_TMP') == 0)) {
			alert('remove this JS');
			allscripts[i].parentNode.removeChild(allscripts[i]);
			}
		}
	}
	
// open a new page
// service ... one of the openTeamware.com services
// action ... URL action
// params ... array of arguments ... just passed to the template ...
function OpenPage(service, action, params) {
	var a_bg_op = new cBasicBgOperation;		
	var a_str_current_smartload_url = '/' + service + '/default.cfm?smartload=1&action=' + action + '&' + params;			
		
	DisplayStatusInformation(GetLangData(3));
	
	a_bg_op.url = a_str_current_smartload_url;
	a_bg_op.callback_function = processSmartLoadReqLoadAsyncDataChange;
	a_bg_op.doOperation();
	
	}
	
// someone has clicked a link ...
function SmartLoadClick(e) {
	var _target;
	
	if (window.event) {
		_target = window.event.srcElement; 
	} else if (e) { 
		_target = e.target; 
	} else return; 
	
	if (_target.nodeName.toLowerCase() != 'a') return; 

	// cancel event ...
	if (window.event) { 
	   window.event.cancelBubble = true; 
	   window.event.returnValue = false; 
	 	}  
	 
	  if (e && e.preventDefault && e.stopPropagation) { 
	   e.preventDefault(); 
	   e.stopPropagation(); 
	 	} 	
		
	// param get out
	action = argItems(_target.href, 'action');
	
	// goto dhtml load			
	OpenPage(GetCurrentService(), action, ReturnQueryStringWithoutAction(_target.href));

	return false;
	}
	
// get the service out of the pathname ...
function GetCurrentService() {
	var vl_service = location.pathname;
	var i = vl_service.indexOf('/');
	
	if (vl_service.length == 0) return '';
	
	// remove the first "/"
	if (i == 0) { vl_service = vl_service.substr(1); }
	
	vl_service = vl_service.split('/');
	
	if (vl_service.length == 0) return '';

	// return the first item of the array	
	return vl_service[0];
	}

// check if the given service is enabled for smartload
function IsServiceSmartLoadEnabled(servicename) {
	for (var i = 0; i < a_arr_supported_services.length; i++) {
		if (a_arr_supported_services[i] == servicename) {return true};
		}
	return false;
	}
	
// return the supported actions of a specific service ...
function GetSupportedActionsOfService(servicename) {
	return a_arr_supported_services[servicename];
	}
	
// check if a certain action is supported
function SmartLActionSupported(arr, action) {
	var aresult = false;
	
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].toUpperCase() == action.toUpperCase()) aresult = true;
		}
	
	return aresult;
	}
	
function argItems (lnk, theArgName) {
	var a_arr_lnk = new Array(1);
	var alink = lnk;
	
	if (alink.indexOf('?') == -1) {
		return '';
		}
	
	// copy query string (from ?)
	alink = '&' + lnk.substr(lnk.indexOf('?') + 1);
	// split parameters ...			
	a_arr_lnk = alink.split('&');		
	// loop through parameters
	for (var i = 0; i < a_arr_lnk.length; i++)
		{
		// split url string
		if (a_arr_lnk[i].toUpperCase().indexOf(theArgName.toUpperCase() + '=') > -1)
			{
			return a_arr_lnk[i].split('=')[1];
			}
		}
	return '';
	}
	
function ReturnQueryStringWithoutAction(s) {
	var areturn = '';
	var a_arr_lnk = new Array(1);
	
	if (s.indexOf('?') == -1) {
		return '';
		}		
		
	s = s.substr(s.indexOf('?') + 1);
	
	a_arr_lnk = s.split('&');
	
	for (var i = 0; i < a_arr_lnk.length; i++) {
		if (a_arr_lnk[i].toUpperCase().indexOf('ACTION=') == -1) {
			areturn = areturn + '&' + a_arr_lnk[i];
			}
		}
	
	return areturn;
	}
	
// add event to an element ...
function SmartLAddEvent(elm, evType, fn, useCapture)  { 

	 if (elm.addEventListener){ 
	   elm.addEventListener(evType, fn, useCapture); 
	   return true; 
	 } else if (elm.attachEvent){ 
	   var r = elm.attachEvent("on"+evType, fn); 
	   return r; 
	 } 
	}  
	
function processSmartLoadReqLoadAsyncDataChange(responseText) {
	var obj2,a_str_http_async_load;
	var obj1 = findObj('iddivmainbody');						
	a_str_http_async_load = responseText;					
				
	// replace main box html id ... otherwise we would have the same ID twice						
	a_str_http_async_load = responseText.replace('<div id="iddivmainbody" class="div_main_box">', '<div id="iddivmainbody_smartload">');
				
	// remove old temp scripts
	RemoveOldTempScripts();
				
	// set html content ...
	obj1.innerHTML = a_str_http_async_load;
				
	// get and eval javascripts
	GetAndEvalScriptsOutOfText(responseText, true);
			
	obj2 = findObj('id_iframe_smartload_history');
			
	if (obj2) {
		obj2.location.href = '/tools/smartload/history/show_create_history_item.cfm?r=' + escape(Math.random()) +'&target=' + escape(a_str_current_smartload_url);
		}
		
	HideStatusInformation();
						
	// check links ...
	setTimeout("CheckLinks();", 50);		
	}
	
// check links ...
function CheckLinks() {
	var allLinks = document.getElementsByTagName('a'); 
	var a_doc_url = location.protocol + '//' + location.hostname  + ':' + location.port + location.pathname;
	var a_arr_supported_actions;
	var a_current_service = GetCurrentService();
	
	// disable for now ...
	return;
	
	// only do the check once per page load ...
	if (vl_bol_check_links_active == true) {return false;}
	
	vl_bol_check_links_active = true;
	
	// is smartload enabled for this service?
	if (IsServiceSmartLoadEnabled(a_current_service) == false) {return;}
	
	// get supported actions ...
	a_arr_supported_actions = GetSupportedActionsOfService(a_current_service);
	
	// loop through all links
	for (var i=0;i<allLinks.length;i++) { 
		var lnk = allLinks[i];
		var action = '';
		
		// only catch links relative to the current service ...
		if ((lnk.href) && (lnk.href.indexOf('#') == -1) && (lnk.href.toUpperCase().indexOf(a_doc_url.toUpperCase()) > -1))
			{
			// get action of link
			action = argItems(lnk.href, 'action');
			if ((action !== '') && SmartLActionSupported(a_arr_supported_actions, action))
				{
				// add event onClick
				SmartLAddEvent(lnk,'click',SmartLoadClick);
				}
			}
			
		}
	
	vl_bol_check_links_active = false;
	//DisplayStatusInformation('SmartLoad done');
	}// get temporary added translation ...
function GetLangDataTempTranslation(entryname) {
	var obj1 = eval('vl_ibx_langdata_' + entryname) || '';
	return obj1;
	}
	
// include a dynamic script ...
function IncludeDynJSFile(loc, temporary) {
	var script=document.createElement('script');
	script.setAttribute('src', loc);
	alert(loc);
	script.setAttribute('type', 'text/javascript');
	
	if (temporary == true) {
		script.setAttribute('id', 'ibx_sl_tmp' + Math.floor(Math.random() * 6));
		}
	document.getElementsByTagName('head')[0].appendChild(script);	
	return false;
	}
	
// Handle Ajax sending of Form
function DoHandleAjaxForm(form_id) {
	var a_http = new cBasicBgOperation();
	var a_form = document.forms[form_id];
	var a_action_url = a_form.action;
	var q_string = SerializeForm(a_form);
	var a_method = a_form.method;
	
	if (a_method.toLowerCase() == 'post') {
		a_http.method = 'POST';
		a_http.post_content = q_string;
		a_http.url = a_action_url;
		} else {
			// get request, add all URL parameters ...
			a_http.url = a_action_url + '/?' + q_string;
		}
	
	$('#id_div_modal_dialog_load_http_content').html(a_str_loading_status_img);
	
	a_http.id_obj_display_content = 'id_div_modal_dialog_load_http_content';
	
	a_http.doOperation();
	return false;
	}
	
// Serialize the form ... thanks to matt for this function
function SerializeForm(theform) {
	var els = theform.elements;
	var len = els.length;
	var queryString = "";
	
	this.addField = function(name,value) {
		if (queryString.length>0) { queryString += "&"; }
		queryString += encodeURIComponent(name) + "=" + encodeURIComponent(value); };
		
	for (var i=0; i<len; i++) {
		var el = els[i];
		if (!el.disabled) {
			switch(el.type) {
				case 'text': case 'password': case 'hidden': case 'textarea': this.addField(el.name,el.value); break;
				case 'select-one': if (el.selectedIndex>=0) { this.addField(el.name,el.options[el.selectedIndex].value); } break;
				case 'select-multiple': for (var j=0; j<el.options.length; j++) { if (el.options[j].selected) { this.addField(el.name,el.options[j].value); } } break;
				case 'checkbox': case 'radio': if (el.checked) { this.addField(el.name,el.value); } break; } } }
	return queryString;
	}
	
// highlight rows in overview tables
function HLOverviewTbl() {
	$(".table_overview tr").mouseover(function() {$(this).addClass("over");}).mouseout(function() {$(this).removeClass("over");});
	return true;
	}
	
// fix various css ... buttons, radio and checkboxes should have auto width
function FixCSS() {
	$('input:radio').css('width', 'auto');
	$('input:checkbox').css('width', 'auto');
	$('input:button').css('width', 'auto');
	$('input:submit').css('width', 'auto');
}
	
// init basic things on read
function InitBasicDoc(servicekey, checkframeset) {
	var a_curAction =  location.search;
	var a_path = location.pathname.substring(1);
	
	initInPagePopupThings();
	SetCurrentServiceEntrykey(servicekey);

	if (checkframeset == true) {
		CheckFrameSet();
		}

	// assign events
	$(window).resize(UpdateHeights);
	// update heights now
	UpdateHeights();
	
	// do style things ...
	HLOverviewTbl();
	FixCSS();
	
	// highlight current action on the left
	//if (a_curAction != '') {
		//$('.divleftpanelactions li a[href$="' + a_curAction + '"]').parent().addClass('divleftnavhighlightitem');
	//	}
	
	// highlight top nav	
	$('#id_top_menu_nav li a[href*="' + a_path + '"]:first').css('backgroundColor', 'rgb( 47,74,112 )');
	
	vl_tmr_load_email_count = window.setTimeout('RefreshActivityMonitor()', 30000);

	return true;
	}
	
// reload activity monitoring
function RefreshActivityMonitor() {
	return;
	if ($('#id_activites_new_msg_indicator').size() == 0) {return false;}
	
	window.clearTimeout( vl_tmr_load_email_count );
	
	$.get("/email/default.cfm?action=DisplayBottomShortInfo", function(data){
		  $('#id_activites_new_msg_indicator').html($.trim(data)).fadeIn();
		});
	
	vl_tmr_load_email_count = window.setTimeout('RefreshActivityMonitor()', 60000);
	}
	
// someone has clicked on a rating star in a form
// disable all images, set input value
function DoSetCurrentRating(input_name, value) {
	var i = 0;
	$('#' + input_name).val(value);
	$('#id_div_rating_images_' + input_name + ' img').attr("src","/images/si/bullet_orange.png");
	
	for (var i=1; i<=value; i++) {
		$('#' + input_name + '_' + i).attr("src","/images/si/star.png").blur();
		}
	}
	
// reset a rating to unknown value
function ResetRatingToUnknownValue(input_name) {
	DoSetCurrentRating(input_name, 0);
	}
	
// General routine for storing personal preferences using Ajax
function SetPersonalPreferenceValue(section, entryname, value){
	var req = new cSimpleAsyncXMLRequest();
	req.servicekey = '7E70C2DD-9866-2B68-C78B1C805A2905F6';
	req.action = 'SetPersonalPreference';
	req.AddParameter('section', section);
	req.AddParameter('name', entryname);
	req.AddParameter('value', value);
	req.doCall();
	}
	
// hide left nav side
function HideLeftNavSide(storepref,animation) {

	if (storepref == true) {
		SetPersonalPreferenceValue('display_interface', 'displayleftnavbar', '0');
		}
	
	$('.td_menu_items').css('paddingLeft', '6px');
	$('.td_info_block').css('paddingLeft', '12px');
	
	if ((animation) && (animation == true)) {
		$('#iddivmenuleftinner').fadeOut('slow',  function(){
			$('#iddivmenuleft').css('width', '0px');}
			);
		} else {
			$('#iddivmenuleftinner').hide();
			$('#iddivmenuleft').css('width', '0px');
		}
	
	}
	
