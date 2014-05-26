<!--- //

	Module:		E-Mail
	Description:Addattachment ...
	

// --->

<!---

first of all, save message to the "drafts" folder ... --->

<cfif val(form.frmDraftId) gt 0>

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

	<!--- this query contains now information about the already included attachments --->
	<cfset q_avaliable_attachments = stReturn.q_attachments />
	
	<!--- check out the "real" attachments ... --->
	<cfquery name="q_avaliable_attachments" dbtype="query">
	SELECT
		contentid,afilename,contenttype,location
	FROM
		q_avaliable_attachments
	WHERE
		(contentid >= 1)
		AND
		(Filenamelen > 0)
	;
	</cfquery>

</cfif>

<!--- create now the message ... --->
<cfinvoke component="/components/email/cmp_message" method="createmessage" returnvariable="stReturn">
	<cfinvokeargument name="subject" value="#form.mailsubject#">
	<cfinvokeargument name="from" value="#form.mailfrom#">
	<cfinvokeargument name="cc" value="#form.mailcc#">
	<cfinvokeargument name="bcc" value="#form.mailbcc#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="body" value="#form.mailbody#">
	<cfinvokeargument name="to" value="#form.mailto#">
	<cfinvokeargument name="format" value="#form.frmformat#">
	<cfinvokeargument name="deleteattachmentsafteradding" value="true">
	<cfinvokeargument name="addheaders" value="#a_arr_addheaders#">

	<cfif IsDefined("q_avaliable_attachments")>
		<!--- do we've a query? --->
		<cfinvokeargument name="attachments" value="#q_avaliable_attachments#">
	</cfif>

	<cfif IsDefined("q_add_virtual_attachments")>
		<cfinvokeargument name="q_virtual_attachments" value="#q_add_virtual_attachments#">
	</cfif>	
</cfinvoke>


<!--- get the written filename ... --->
<cfset a_str_written_filename = stReturn["filename"]>
<cfset a_str_msgid = stReturn["messageid"]>

<!--- save email now ... --->
<cfinvoke component="#application.components.cmp_email#"
	method="AddMailToFolder" returnvariable="stReturn">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
	<cfinvokeargument name="destinationfolder" value="INBOX.Drafts">
	<cfinvokeargument name="returnuid" value="true">
	<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
</cfinvoke>

<cfquery name="q_update_uid_attachments" datasource="#request.a_str_db_tools#">
UPDATE
	emailattachments
SET
	uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#stReturn.uid#">
WHERE
	uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmDraftId#">
	AND
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
;
</cfquery>

<cfif val(form.frmDraftId) gt 0>

	<!--- delete now draft message --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_return">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="uids" value="#form.frmDraftId#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	</cfinvoke>	

</cfif>

<cfset a_str_headerinfo_wddx_filename = request.a_str_temp_directory & request.a_str_dir_separator & Hash(request.a_str_imap_host & request.a_str_imap_username) & stReturn.uid>
<cffile action="write" addnewline="no" charset="utf-8" file="#a_str_headerinfo_wddx_filename#" output="#a_str_wddx_addheader#">

<!--- forward ... --->
<cflocation addtoken="no" url="index.cfm?action=AddAttachment&mailbox=INBOX.Drafts&id=#stReturn.uid#">


