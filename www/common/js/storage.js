function OpenCategoriesPopup() {
   	var url;
    url = "/workgroups/dialogs/categories/?categories="+escape(document.formeditnewtask.frmcategories.value)+'&form=formeditnewtask';
    var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=270,HEIGHT=540");
    mywin.window.focus();
	}
	
function PlayAudioFile(entrykey) {
	var url;
    url = "default.cfm?action=ShowPlayAudioFile&entrykey="+escape(entrykey);
    var mywin = window.open(url, "_ibxaudioplayer", "RESIZABLE=no,SCROLLBARS=no,WIDTH=400,HEIGHT=60");
    mywin.window.focus();
}

function DisplayRecentFiles(type) {
	var a_simple_get = new cBasicBgOperation();
	a_simple_get.url = 'index.cfm?action=DisplayLatelyAddedFilesList&type=' + escape(type);
	a_simple_get.id_obj_display_content = 'id_div_recent_files';
	a_simple_get.doOperation();
	}	
	
function DoCreateExclusiveLock() {
	var req = new cSimpleAsyncXMLRequest();
	req.action = 'DoCreateExclusiveLock';
	req.AddParameter('entrykey', document.forms.formcreateexclusivelock.frmentrykeys.value);
	req.AddParameter('comment', document.forms.formcreateexclusivelock.frmcomment.value);
	req.AddParameter('duration', document.forms.formcreateexclusivelock.frmduration.value);
	req.doCall();
}

function ConfirmDeleteFile(entrykey) {
	ShowSimpleConfirmationDialog('index.cfm?frm_entrykey=' + entrykey + '&frm_parentdirectorykey=&action=deletefile&confirmed=1');
	}

function DeleteExclusiveLock(entrykey) {
var req = new cSimpleAsyncXMLRequest();
	req.action = 'DoRemoveExclusiveLock';
	req.AddParameter('entrykey', entrykey);
	req.doCall();	
}
	
// open preview box
function ShowPreviewTemplate(path) {
	
	var a_height = document.body.offsetHeight;
	var a_width = document.body.offsetWidth;
	var a_simple_modal_dialog = new cSimpleModalDialog();
	
	// compose the full path
	path = location.pathname + path;
	
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customwidth = '630px';
	a_simple_modal_dialog.customtitle = 'Preview';
	a_simple_modal_dialog.customcontent_load_from_url = path + '&preview_width=' + a_width + '&preview_height= ' + a_height;
	a_simple_modal_dialog.ShowDialog();	
	return false;		
	}
	
function AllFiles() 
	 { 
	   for(var x=0;x<document.fileform.elements.length;x++) 
	     { var y=document.fileform.elements[x]; 
	       if(y.name!='frmcbselectall') y.checked=document.fileform.frmcbselectall.checked; 
	     }
	 }

function OpenWorkgroupShareDialog(entrykey)
	{
	var url, obj1;
	
	url = "/workgroups/dialogs/workgroupshare/?servicekey=5222ECD3-06C4-3804-E92ED804C82B68A2&objectname="+escape(document.form_editcreate_folder.frm_directoryname.value)+"&entrykey="+escape(entrykey);
	var mywin = window.open(url, "idpermissions", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=550,HEIGHT=400");
	mywin.window.focus();
	
	//idiframeworkgroups.style.display = '';
	obj1 = findObj('iddivworkgroups');
	obj1.style.display = '';
	

	obj1 = findObj('idtdopenworkgorupiframe');
	obj1.style.display = 'none';
		
	obj1 = findObj('idtdcloseworkgroupiframe');
	obj1.style.display = '';	
		
	}
	
function OpenAssignTaskWindow(entrykey,userkeys)
	{
	var url, obj1;
	
	// open window ...
	url = "/workgroups/dialogs/tasks/selectmembers/?servicekey=52230718-D5B0-0538-D2D90BB6450697D1&objectname="+escape(document.formeditnewtask.frmtitle.value)+"&entrykey="+escape(entrykey)+"&userkeys="+escape(userkeys);
	var mywin = window.open(url, "idassignedto", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=650,HEIGHT=450");
	mywin.window.focus();
	
	// document.formeditnewtask.frmassigendto.size = 4;
	}
	
function SetStorageMultiAction(a) {
	$('#id_form_action_action_name').val(a);
	findObj('fileform').submit();
	}
	
// let user create excl lock
function ShowCreateExlusiveLock(filekey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'Lock';
	a_simple_modal_dialog.customcontent_load_from_url = 'index.cfm?action=CreateExclusiveLock&filekey=' + escape(filekey);
	a_simple_modal_dialog.ShowDialog();	
	}
	
// display short information about lock
function ShowLockShortInformation(filekey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = 'Lock';
	a_simple_modal_dialog.customcontent_load_from_url = 'index.cfm?action=DisplayShortLockInformation&filekey=' + escape(filekey);
	a_simple_modal_dialog.ShowDialog();	
	}
	
function CloseWorkgroupShareIframe()
	{
	var obj1;
	obj1 = findObj('idtdopenworkgorupiframe');
	obj1.style.display = '';
	
	obj1 = findObj('iddivworkgroups');
	obj1.style.display = 'none';
	
	obj1 = findObj('idtdcloseworkgroupiframe');
	obj1.style.display = 'none';		
	}
function SetService()
	{
	if (parent.parent.parent.frametop)
		{
		parent.parent.parent.frametop.SetService('storage');
		}
	}