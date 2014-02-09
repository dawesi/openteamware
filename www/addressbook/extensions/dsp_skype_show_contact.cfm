<!--- display skype extensions ... --->

<cfexit method="exittemplate">

<cfsavecontent variable="a_str_js_skype">
	var a_http_inboxcc_phone_skype;
	

	
	function CallContact(service, number, entrykey, displayname)
		{
		var url;
		// alert('skype');
		
		CheckServiceAvaliable(service);
		
		a_http_inboxcc_phone_skype = GetNewHTTPObject();	
		
		url = 'http://127.0.0.1:7887/?addressbookkey=' + entrykey + '&number=' + escape(number) + '&displayname=' + escape(displayname) + 'rand=' + Math.random() + '&cfid=' + readCookie('CFID') + '&cftoken=' + readCookie('CFTOKEN');
		alert(url);
		
		CallHTTPGet(a_http_inboxcc_phone_skype, url, processInBoxPhoneReqChange);
		}
		
	function CheckServiceAvaliable(service)
		{
		// check if the specified service is running ...
		return true;
		}
	function processInBoxPhoneReqChange()
		{
		var obj1;
		
		if (a_http_inboxcc_phone_skype)
			
			//alert(a_http_inboxcc_phone.status);
			{
			// only if req shows "loaded"
			if (a_http_inboxcc_phone_skype.readyState == 4) {
				// only if "OK"
				findObj('id_fieldset_phone_status').style.display = '';
				// alert(a_http_inboxcc_phone_skype.status);
				if (a_http_inboxcc_phone_skype.status == 200) {
				 } 	else
				 	{
					findObj('id_div_connect_error').style.display = '';
					}
			}
			}
		}
function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}		
</cfsavecontent>


<cfscript>
	// add js in the html header ... 
	AddJSToExecuteAfterPageLoad('', a_str_js_skype);
</cfscript>

<fieldset class="default_fieldset" id="id_fieldset_phone_status" style="display:none;margin:8px;">
	<legend class="addinfotext"><img height="9" width="9" src="/images/arrows/img_indent_small.png" align="absmiddle" border="0" vspace="2" hspace="2"><b>Telefon-Status</b></legend>
	<div>
		
		<div id="id_div_connect_error" style="display:none;border:orange solid 2px;" class="mischeader">
			Bei der Verbindung zu Skype ist ein Fehler aufgetreten.
			<br>
			Pruefen Sie bitte ob die Software gestartet ist (Skype und der Skype Agent).
			<br><br>
			<a href="/download/?product=skypeagent">Download der benoetigten Software ...</a>
		</div>
	</div>
</fieldset>