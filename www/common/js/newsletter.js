function SetListType(i)
	{
	var obj1 = findObj('id_tr_crm_filter');
	
	if (i == 0) {obj1.style.display = '';} else {obj1.style.display = 'none';}
	}
	
// send out test mails
function SendTestMails(listkey,issuekey) {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	a_simple_modal_dialog.type = 'custom';
	a_simple_modal_dialog.customtitle = GetLangData(8);
	a_simple_modal_dialog.customcontent_load_from_url = 'index.cfm?Action=SendTestMails&listkey=' + escape(listkey) + '&issuekey=' + escape(issuekey);
	a_simple_modal_dialog.ShowDialog();		
	}
	
// calculate number of subscribers
function CalcNumberOfSubscribers(listkey, id) {
	var a_simple_get = new cBasicBgOperation();
	a_simple_get.url = 'index.cfm?action=CalcNumberOfSubscribers&listkey=' + escape(listkey);
	a_simple_get.id_obj_display_content = id;
	a_simple_get.doOperation();
	}