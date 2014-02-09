<!--- //

	Module:		EMail
	Action:		DoCheckSendMailOperation
	Description:Save the message as DRAFT
	

// --->

<cfif val(form.frmDraftId) GT 0>
	<!--- this message has already been saved ... replace the existing version! --->
	
	<!--- load attachments ... --->
	<cfinvoke component="#application.components.cmp_email#" method="SaveAllAttachments" returnvariable="stReturn">
		<cfinvokeargument name="uid" value="#form.frmDraftId#">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">			
	</cfinvoke>
	
	<cfif NOT stReturn.result>
		<h4>This message does not exist. Please check the .Drafts folder</h4>
		<cfexit method="exittemplate">
	</cfif>
	
	<!--- this query contains now information about the
		already included attachments --->
	<cfset q_avaliable_attachments = stReturn.q_attachments />
	
</cfif>

<!--- create now the message ... --->
<cfinvoke component="#application.components.cmp_email_message#" method="createmessage" returnvariable="stReturn">
	<cfinvokeargument name="subject" value="#form.mailsubject#">
	<cfinvokeargument name="from" value="#form.mailfrom#">
	<cfinvokeargument name="cc" value="#form.mailcc#">
	<cfinvokeargument name="bcc" value="#form.mailbcc#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="body" value="#form.mailbody#">
	<cfinvokeargument name="to" value="#form.mailto#">
	<cfinvokeargument name="format" value="#form.frmformat#">
	<cfinvokeargument name="deleteattachmentsafteradding" value="true">
	<cfinvokeargument name="requestreadconfirmation" value="true">
	<cfinvokeargument name="priority" value="3">
	<cfinvokeargument name="addheaders" value="#a_arr_addheaders#">
	
	<cfif StructKeyExists(variables, 'q_avaliable_attachments')>
	<!--- do we've a query? --->
		<cfinvokeargument name="attachments" value="#q_avaliable_attachments#">
	</cfif>
	
	<cfif StructKeyExists(variables, 'q_add_virtual_attachments')>
		<cfinvokeargument name="q_virtual_attachments" value="#q_add_virtual_attachments#">
	</cfif>	
</cfinvoke>

<!--- get the written filename ... --->
<cfset a_str_written_filename = stReturn.filename />
<cfset a_str_msgid = stReturn.messageid />

<!--- save email now ... --->
<cfinvoke component="#application.components.cmp_email#"
	method="AddMailToFolder" returnvariable="stReturn_addmail">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
	<cfinvokeargument name="destinationfolder" value="INBOX.Drafts">
	<cfinvokeargument name="returnuid" value="true">
	<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
</cfinvoke>

<cfif NOT stReturn_addmail.result>
	<html>
		<head>
			<title>Saving to draft failed.</title>
		</head>
		<body>
			Saving to draft folder failed.
		</body>
	</html>
	<cfexit method="exittemplate">
</cfif>

<cfif val(form.frmDraftId) GT 0>
	
	<!--- Delete old Draft message ... --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="stReturn_delete_msg">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="uids" value="#form.frmDraftId#">
	</cfinvoke>
	
</cfif>


<!--- is it autosave or not? ... --->
<html>
	<head>
		
<cfif NOT form.frmDraftAutoSave>

		<script type="text/javascript">
			function DoActionAndCloseWindow() {
				// TODO: TRANSLATE
				alert('Die Nachricht wurde im Entwurf-Ordner gespeichert.');
				window.close();
				}
		</script>
	

<cfelse>
	
		<script type="text/javascript">
			function DoActionAndCloseWindow() {
				
				// set new draft UID
				parent.document.sendform.frmDraftId.value = '<cfoutput>#stReturn_addmail.uid#</cfoutput>';
				
				// alert('<cfoutput>#form.frmDraftId#</cfoutput> new: <cfoutput>#stReturn_addmail.uid#</cfoutput>');
				}
		</script>
		
		
	<h1>autosave done <cfoutput>#Now()#</cfoutput></h1>

</cfif>

	</head>
<body onLoad="DoActionAndCloseWindow();">

</body>
</html>
