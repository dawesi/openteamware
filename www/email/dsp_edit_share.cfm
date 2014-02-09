<!---

	share a folder
	
	--->
<script type="text/javascript">
	function OpenWorkgroupShareDialog(entrykey)
	{
	var url, obj1;
	
	url = "/workgroups/dialogs/workgroupshare/?servicekey=52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5&objectname=<cfoutput>#urlencodedformat(url.mailbox)#</cfoutput>&entrykey="+escape(entrykey);
	var mywin = window.open(url, "idpermissions", "RESIZABLE=yes,SCROLLBARS=yes,WIDTH=550,HEIGHT=400");
	mywin.window.focus();
	}
</script>
	
<cfparam name="url.mailbox" type="string" default="INBOX">


<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td align="right">Ordner:</td>
    <td>
		<a href="#"><cfoutput>#url.mailbox#</cfoutput></a>
	</td>
  </tr>
  <tr>
    <td valign="top" align="right">Freigabe:</td>
    <td valign="top">
		
	<div id="iddivworkgroups" style="width:100%;height:80px;" class="b_all">
		<iframe id="idiframeworkgroups" name="idiframeworkgroups" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" src="/tools/security/permissions/iframe/?servicekey=<cfoutput>#urlencodedformat(request.sCurrentServiceKey)#</cfoutput>&sectionkey=&entrykey=<cfoutput>#urlencodedformat(request.stSecurityContext.myuserkey&':'&url.mailbox)#</cfoutput>"></iframe>
	</div>
	
	</td>
  </tr>
</table>


<cfinvoke component="#application.components.cmp_email_tools#" method="GetSharedFolders" returnvariable="q_select_shared_folders">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
</cfinvoke>

<cfdump var="#q_select_shared_folders#">

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td class="bb">Ordner</td>
    <td class="bb">Inhaber</td>
    <td class="bb">Nachrichten</td>
  </tr>
<cfoutput query="q_select_shared_folders">
	<!--- load username ... --->
	
	<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
		<cfinvokeargument name="entrykey" value="#q_select_shared_folders.account#">
	</cfinvoke>
	
   <tr>
    <td>
		<a href="default.cfm?action=ShowMailbox&Mailbox=#urlencodedformat(q_select_shared_folders.foldername)#&userkey=#urlencodedformat(q_select_shared_folders.account)#">#q_select_shared_folders.foldername#</a>
	</td>
    <td>
		#a_str_username#
	</td>
    <td>&nbsp;</td>
  </tr>
</cfoutput>
</table>