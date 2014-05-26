<!--- convert a message from format a) to b) 

	either from text to html or from html to text ...

	--->

<cfif form.frmformat is "text">
	<!--- text ... remove all tags and replace <br> with chr(13) chr(10) --->
	<cfset a_str_new_text = StripHTML(form.mailbody)>		

	<cfloop list="#a_str_new_text#" index="a_str_line" delimiters="#chr(13)#">
		<cfoutput>#trim(a_str_line)#<br></cfoutput>
	</cfloop>

<cfelse>
	<!--- convert to html ... --->
	<!---<cfset a_str_new_text = form.mailbody>
	<cfset a_str_new_text = ReplaceNoCase(a_str_new_text, chr(13)&chr(10), '<br>', 'ALL')>
	<cfset a_str_new_text = htmleditformat(a_str_new_text)>--->
	
	<cfset a_str_new_text= ''>
	
	<cfloop list="#form.mailbody#" delimiters="#chr(10)#" index="a_str_line">
		<cfset a_str_new_text = a_str_new_text & htmleditformat(trim(a_str_line)) & '<br />'>
	</cfloop>
</cfif>


<cfif val(form.frmDraftId) gt 0>
	<!--- this message has already been saved ...
		replace the existing version! --->
	
	<!--- load attachments ... --->
	<cfinvoke component="#application.components.cmp_email#" method="SaveAllAttachments" returnvariable="stReturn">
		<cfinvokeargument name="uid" value="#form.frmDraftId#">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">			
	</cfinvoke>
	
	<!--- this query contains now information about the
		already included attachments --->
	<cfset q_avaliable_attachments = stReturn.q_attachments />
	
	<!--- check out the "real" attachments ... --->
	<cfquery name="q_avaliable_attachments" dbtype="query">
	SELECT contentid,afilename,contenttype,location FROM q_avaliable_attachments
	WHERE (contentid >= 1)
	AND (Filenamelen > 0);
	</cfquery>
	
</cfif>

<!--- create now the message ... --->
<cfinvoke component="/components/email/cmp_message" method="createmessage" returnvariable="stReturn">
	<cfinvokeargument name="subject" value="#form.mailsubject#">
	<cfinvokeargument name="from" value="#form.mailfrom#">
	<cfinvokeargument name="cc" value="#form.mailcc#">
	<cfinvokeargument name="bcc" value="#form.mailbcc#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="body" value="#a_str_new_text#">
	<cfinvokeargument name="to" value="#form.mailto#">
	<cfinvokeargument name="format" value="#form.frmFormat#">
	<cfinvokeargument name="deleteattachmentsafteradding" value="true">
	
	<cfif IsDefined("q_avaliable_attachments")>
	<!--- do we've a query? --->
		<cfinvokeargument name="attachments" value="#q_avaliable_attachments#">
	</cfif>
	
	<cfif IsDefined("q_add_virtual_attachments")>
		<cfinvokeargument name="q_virtual_attachments" value="#q_add_virtual_attachments#">
	</cfif>	
</cfinvoke>

<!--- get the written filename ... --->
<!---<cfdump var="#stReturn#">--->
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

<cfif val(form.frmDraftId) gt 0>
	<!--- delete original message ... --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_return">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="uids" value="#form.frmDraftId#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	</cfinvoke>
</cfif>
	
<!---<cfdump var="#stReturn#">--->
<!--- forward now to original message ... --->
<cfset a_int_uid = stReturn["uid"]>

<cflocation addtoken="no" url="index.cfm?action=composemail&type=0&draftid=#a_int_uid#">
