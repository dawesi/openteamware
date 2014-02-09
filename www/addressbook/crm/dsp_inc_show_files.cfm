<script type="text/javascript">
var a_http_load_files_attached_to_user;
var a_str_div_name;
var a_http_create_new_user_directory;

function DisplayFilesAttachedToContact(contactkey, directorykey, divname)
	{
	a_http_load_files_attached_to_user = GetNewHTTPObject();
	
	a_str_div_name = divname;
	
	a_str_url = '/addressbook/crm/show_div_files_attached_to_user.cfm?contactkey=' + escape(contactkey) + '&directorykey=' + escape(directorykey) + '&divname=' + escape(divname) + '&rights=delete,edit,write,create';
	
	CallHTTPGet(a_http_load_files_attached_to_user, a_str_url, processReqDisplayContactFilesDataChange);
	}
	
function processReqDisplayContactFilesDataChange()
	{
	var obj1;
		
	if ((a_http_load_files_attached_to_user) && (a_http_load_files_attached_to_user.readyState == 4) &&(a_http_load_files_attached_to_user.status == 200))
		{		
		obj1 = findObj(a_str_div_name);										
		obj1.innerHTML = a_http_load_files_attached_to_user.responseText;	
														
		if (obj1.offsetHeight > 120)
			{
			obj1.style.height = 120;
			obj1.style.overflow = 'auto';
			}									
		}
	}

function OpenUploadPopup(contactkey,directorykey)
	{
	// open upload popup ...
	var w = window.open('/addressbook/crm/show_upload_file_attached_to_contact.cfm?contactkey=' + escape(contactkey) + '&directorykey=' + escape(directorykey),'_blank','toolbar=no,location=no,directories=no,status=no,copyhistory=no,scrollbars=yes,resizable=yes,height=300,width=400');
	}
	
function CreateNewDirectoryDialog(contactkey, parentdirectorykey)
	{
	var dirname = prompt('Please enter the name of the new directory:', '');
	
	if (dirname == '') return;
	
	a_http_create_new_user_directory = GetNewHTTPObject();
	
	a_str_url = '/addressbook/crm/show_create_new_directory_for_user_attached_files.cfm?contactkey=' + escape(contactkey) + '&directorykey=' + escape(parentdirectorykey) + '&rights=delete,edit,write,create' + '&directoryname=' + escape(dirname);
	
	CallHTTPGet(a_http_create_new_user_directory, a_str_url, dummyfunction);			
	
	alert('Please reload the page to see the new directory');				
	}
</script><fieldset class="default_fieldset">
<legend class="addinfotext">
	<b><img height="9" width="9" src="/images/arrows/img_indent_small.png" align="absmiddle" border="0" vspace="2" hspace="2"> <cfoutput>#GetLangVal('cm_wd_files')#</cfoutput></b>
</legend>
<div>

	<div id="id_div_storage_files_user_">...</div>
	
	<script type="text/javascript">
		DisplayFilesAttachedToContact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', '', 'id_div_storage_files_user_');
	</script>
		
</div>
</fieldset>



<br>