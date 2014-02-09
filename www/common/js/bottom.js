// bottom script
// responsible for caching and more

var a_str_email_compose = '';
var a_arr_res_names = new Array(1);
var a_arr_res_script = new Array(1);
var myscripts = new Array();
var acurrent_scriptname = '';

function GetCachedScript(name) {
	return a_arr_res_script[GetIndexOfScriptCacheByName(name)];
	}

// get index in cache of a certain script name ...
function GetIndexOfScriptCacheByName(name) {
	var i = 0;
	var areturn = -1;

	for (i=0; i<a_arr_res_names.length; ++i) {
		if (a_arr_res_names[i] == name) {return i;}
		}

	return -1;
	}

// does a certain script name exist?
function GetCachedScriptExists(name) {
	return (GetIndexOfScriptCacheByName(name) > -1);
	}
		
/* load field information */
function DisplayCurrentData() {
	var abgget_email = new cBasicBgOperation();
	var abgget_cal = new cBasicBgOperation();
	
	abgget_email.url = '/email/default.cfm?action=DisplayBottomShortInfo';
	abgget_email.id_obj_display_content = 'id_div_bottom_email';
	abgget_email.callback_function = AdjustHeight;
	abgget_email.doOperation();
	
	abgget_cal.url = '/calendar/default.cfm?action=DisplayBottomShortInfo';
	abgget_cal.id_obj_display_content = 'id_div_bottom_calendar';
	abgget_email.callback_function = AdjustHeight;
	abgget_cal.doOperation();
	
	// reload in some minutes ...
	window.setTimeout("DisplayCurrentData()", 200000);
	AdjustHeight();
	}

/* preload next js of list */
function PreloadNextJavaScript() {
	var astrfile = '';
	var abgget = new cBasicBgOperation();
	
	if (myscripts.length == 0) {
		$('#idinfo').hide();
		$('#idinfospacer').hide();
		return;
		}
	
	// set current scriptname
	acurrent_scriptname = myscripts[0];
	
	$('#idinfo').html('<img src="/images/space_1_1.gif" class="si_img" />' + GetLangDataTempTranslation('cm_ph_preloading_resource') + ' ' + myscripts.length);
	
	// get the script ...
	abgget.url = acurrent_scriptname;
	abgget.exec_response_scripts = false;
	abgget.callback_function = handlePreloadedScript;
	abgget.doOperation();	
	
	// remove from list
	myscripts.splice(0,1);
	}
function handlePreloadedScript(s) {
	var ii = a_arr_res_names.length;
	
	// add ...
	a_arr_res_names[ii] = acurrent_scriptname;
	a_arr_res_script[ii] = s;
	
	// goto next script
	PreloadNextJavaScript();
	}

function AdjustHeight() {
	var ah = $('#id_tbl_bottom_view').height() + 10;
	// alert();
	parent.ResizeFrames('*,' + ah);
	}

function processReqNTChange(responsetext) {
	// start next load of data ...
	StartLoadNTTimer(100000);
	}

function LoadNT(companykey, sourceids) {
	}
	
function LoadEmailComposePage() {
	var a_simple_get = new cBasicBgOperation();

	a_simple_get.url = '/email/?action=composemail&to=random&ibxpreload=1';
	a_simple_get.callback_function = processReqLoadEmailComposePage;
	a_simple_get.doOperation();
	}
		
function processReqLoadEmailComposePage(rsp) {
	a_str_email_compose = rsp;
	}
		
function DisplayPreloadedComposeForm() {
	var win = window.open("", "win", "width=800,height=600"); // a window object
	var a_arr_scripts = GetScriptsOutOfResponseText(a_str_email_compose);
		
	with (win.document) {
	
		for (var i = 0; i < a_arr_scripts.length; i++) {
				
			// is it a function or simple JS?
			if (a_arr_scripts[i].indexOf('function') == 0)
				{
				// is a function ... insert into header
				var script= win.document.createElement('script');
				script.text = a_arr_scripts[i];
				win.document.getElementsByTagName('head')[0].appendChild(script);	
				} else
					{
					// execute right now
					// eval(a_arr_scripts[i]);
					}
			
			}		
	  
	  	write(a_str_email_compose);
	  	close();
		}
}

function StartLoadNTTimer(msec) {
	self.setTimeout('LoadNT()', msec);
	}
	
function StartNTScroll() {
	self.setTimeout('ScrollNT()', 300);
	}
	
function OpenNewsTickerItem(s) {
	var mywindownews = open('/rd/nt/g/?'+s,'_blank');
	mywindownews.location.href = '/rd/nt/g/?'+s;	   
	mywindownews.focus();
	}
	
function ScrollNT() {
	var obj1 = findObj('id_div_newsticker');
	return;
	
	obj1.style.marginLeft = parseInt(obj1.style.marginLeft) - 10;
	
	// check if we have to reload the newsticker
	// alert((0 - parseInt(obj1.style.marginLeft)) + ' ' + obj1.offsetWidth);
	
	if ((0 - parseInt(obj1.style.marginLeft)) > (obj1.offsetWidth - 100)) {
		obj1.style.marginLeft = 500;
		LoadNT();
		}
	
	// start timer again ...
	StartNTScroll();
	}