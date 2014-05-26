<!--- //

	Module:		E-Mail
	Description:Remove an attachment
	

	
	
	1) store new message, user might have modified text
	2) add msg
	3) remove att from this file
	4) store new mail
	
	needs to be optimized
	
// --->

<cfinvoke component="#application.components.cmp_email#" method="SaveAllAttachments" returnvariable="a_struct_saveatt_return">
	<cfinvokeargument name="uid" value="#form.frmDraftId#">
	<cfinvokeargument name="foldername" value="INBOX.Drafts">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">			
</cfinvoke>

<!--- load the avaliabel attachments ... --->
<cfset q_avaliable_attachments = a_struct_saveatt_return.q_attachments />

<!--- now, create the message from scratch ... --->
<cfinvoke component="/components/email/cmp_message" method="createmessage" returnvariable="a_struct_createmsg_return">
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
	<cfinvokeargument name="attachments" value="#q_avaliable_attachments#">

	<cfif IsDefined("q_add_virtual_attachments")>
		<cfinvokeargument name="q_virtual_attachments" value="#q_add_virtual_attachments#">
	</cfif>	

</cfinvoke>

<!--- receive the new data ... --->
<cfset a_str_written_filename = a_struct_createmsg_return.filename />
<cfset a_str_msgid = a_struct_createmsg_return.messageid />

<!--- save email now ... --->
<cfinvoke component="#application.components.cmp_email#"
	method="AddMailToFolder" returnvariable="a_str_addmail_return">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
	<cfinvokeargument name="destinationfolder" value="INBOX.Drafts">
	<cfinvokeargument name="returnuid" value="true">
	<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
</cfinvoke>

<!--- receive the new UID --->
<cfset a_int_uid = a_str_addmail_return.uid />

<!--- delete, old original message ... --->
<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_msg">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="foldername" value="INBOX.Drafts">
	<cfinvokeargument name="uids" value="#form.frmDraftId#">
</cfinvoke>

<!--- NOW, call the remove method ... remove att from the new message (a_int_uid) ... delete newly created message as well! --->
<cfinvoke component="/components/email/cmp_message" method="removeattachment" returnvariable="stReturn">
	<cfinvokeargument name="uid" value="#a_int_uid#">
	<cfinvokeargument name="foldername" value="INBOX.Drafts">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">			
	<cfinvokeargument name="removeattachmentid" value="#form.frmpartidtoremove#">
	<cfinvokeargument name="deleteoriginalmessage" value="true">
</cfinvoke>

<cflocation addtoken="no" url="index.cfm?action=composemail&type=0&draftid=#stReturn.uid#&mailbox=INBOX.Drafts">

