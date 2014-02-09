function ChangeNoDueDateEnabled( setting )
	{
	var ainput = $('#frmdt_due');
	
	if (setting == true)
		{
		ainput.hide();
		}
		else
			{
			ainput.show();
			}
	}
	
function OpenCategoriesPopup()
	{
   	var url;
    url = "/workgroups/dialogs/categories/?categories="+escape(document.formeditnewtask.frmcategories.value)+'&form=formeditnewtask';
    var mywin = window.open(url, "", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=270,HEIGHT=540");
    mywin.window.focus();
	}

function OpenWorkgroupShareDialog(entrykey)
	{
	var url, obj1;
	
	url = "/workgroups/dialogs/workgroupshare/?servicekey=52230718-D5B0-0538-D2D90BB6450697D1&objectname="+escape(document.formeditnewtask.frmtitle.value)+"&entrykey="+escape(entrykey);
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
	
function AddSelectedMembers(workgroupkey)
	{
	
	obj1 = findObj('idtrworkgroup'+escape(workgroupkey));
	
	if (obj1 !== null)
		{
		// loop through all entries
		
		}
	
	}
	
function AddResource()
	{
	// open the popup and let the user select the resource to add (from all workgroups)
	}
	
function RemoveResource()
	{
	alert(document.frmnewtask.frmresources.selectedindex);
	document.frmnewtask.frmresources.options[1] = null;
	document.frmnewtask.frmresources.length=2;
	}
	
function SetUserKeyAssignedTo(username,userkey)
	{
	var i,obj1;
	obj1 = findObj('frmassigendto');
	
	for (i=0;i<obj1.length;i++)
		{
		if (obj1.options[i].value == userkey)
			{
			SetAssignedToUserkeys();
			return;
			}
		}
	
	 
	obj1.options[obj1.options.length] = new Option(username,userkey);	
	// obj1.disabled = false;
	obj1.size = obj1.options.length;
	SetAssignedToUserkeys();

	}
	
function SetAssignedToUserkeys()
	{
	var i,a_str,obj2,obj1;
	obj1 = findObj('frmassigendto');
	obj2 = findObj('frmassignedtouserkeys');
	a_str = '';
	
	for (i=0;i<obj1.length;i++)
		{
		a_str = a_str + ',' + obj1.options[i].value;
		}
		
	obj2.value = a_str;
	
	}	
	
function RemoveAllAssignedUserkeys()
	{
	var i,obj1,obj2;
	
	obj1 = findObj('frmassigendto');
	
	for (i=0;i<obj1.length;i++)
		{
		obj1.options[i] = null;
		}
		
	// obj1.disabled = true;
	
	obj2 = findObj('frmassignedtouserkeys');
	obj2.value = '';
	}
	
function SetService()
	{
	if (parent.parent.parent.frametop)
		{
		parent.parent.parent.frametop.SetService('tasks');
		}
	}