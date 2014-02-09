<!--- //

	load all message properties for a message in order to display the
	set values in the compose window

	folder: INBOX.Drafts

	uid: a_int_draft_id
	// --->

<cfinvoke component="/components/email/cmp_loadmsg" method="LoadMessage" returnvariable="stReturn">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="foldername" value="INBOX.Drafts">
	<cfinvokeargument name="uid" value="#a_int_draft_id#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory_local#">
	<cfinvokeargument name="savecontenttypes" value="image/x-png,image/jpeg,text/html,image/gif,text/plain,image/jpg,message/rfc,message/rfc822,image/pjpeg,rfc/822,binary/email,text/vcard">
</cfinvoke>

<cfif StructKeyExists(stReturn, 'query') IS FALSE>
	<cfset a_int_draft_id = 0>
	<cfset q_select_read_attachments = QueryNew('dummy')>
	<cfexit method="exittemplate">
</cfif>

<cfset url.format = 'text'>

<!---<cfdump var="#stReturn#">--->

<cfset q_select_message = stReturn["query"]>
<cfset q_select_attachments = stReturn["attachments_query"]>
<cfset q_Select_headers = stReturn["headers"]>

<!--- check priority ... --->
<cfquery name="q_select_priority" dbtype="query">
SELECT
	wert
FROM
	q_select_headers
WHERE
	feld = 'X-Priority'
;
</cfquery>

<cfif q_select_priority.recordcount is 1>
	<cfset url.priority = q_select_priority.wert>
</cfif>

<!--- check read confirmation --->
<cfquery name="q_select_r_o_confirmation" dbtype="query">
SELECT
	wert
FROM
	q_select_headers
WHERE
	feld = 'Disposition-Notification-To'
;
</cfquery>

<cfif q_select_r_o_confirmation.recordcount is 1>
	<cfset url.requestreadconfirmation = 1>
</cfif>

<!--- securemail operation ... --->
<cfquery name="q_select_sm_operation" dbtype="query">
SELECT
	wert
FROM
	q_select_headers
WHERE
	feld = 'X-SecureMailOperation'
;
</cfquery>

<cfif q_select_sm_operation.recordcount is 1>
	<cfset a_str_default_sm_action = q_select_sm_operation.wert>
</cfif>

<!--- attach vcard? --->
<cfquery name="q_select_attach_vcard" dbtype="query">
SELECT
	wert
FROM
	q_select_headers
WHERE
	feld = 'X-Attachvcard'
;
</cfquery>

<cfif q_select_sm_operation.recordcount is 1>
	<cfset a_int_attach_vcard_enabled = val(q_select_attach_vcard.wert)>
</cfif>

<cfset url.subject = q_select_message.subject>

<cfset url.to = q_select_message.ato>

<cfset url.to = ReplaceNoCase(url.to, '"null" ', '', 'ALL')>

<cfset url.body = q_select_message.body>

<cfset url.mailfrom = q_select_message.afrom>

<cfset url.cc = q_select_message.cc>

<cfset url.bcc = q_select_message.bcc>

<cfset url.priority = q_select_message.priority>

<cfset a_str_messageid = q_select_message.messageid>

<cfset url.format = 'text'>


<!--- check the content-type - do we have an alternativ part (that means html body)? --->

<cfif FindNoCase("multipart/", q_select_message.contenttype) gt 0>

	<cfquery name="q_select_alternativ_version" maxrows="1" debug="yes" dbtype="query">
	SELECT
		*
	FROM
		q_select_attachments
	WHERE
		(contentid <= 1)
	AND
		(filenamelen = 0)
	AND
		(UPPER(contenttype) = 'TEXT/HTML')
	;
	</cfquery>

	<cfif q_select_alternativ_version.recordcount is 1>

		<!--- load html text ... --->
		<cfset a_str_html_filename = q_select_alternativ_version.tempfilename>
			
		<cfif Len(q_select_alternativ_version.charset) IS 0>
			<cfset a_str_html_charset = 'ISO-8859-1'>
		<cfelse>
			<cfset a_str_html_charset = q_select_alternativ_version.charset>
		</cfif>
	
		<cftry>
	
		<!---<cffile action="read" file="#a_struct_result["savepath"]#" variable="a_Str_filecontent" charset=#a_str_html_charset#>--->
		
		<!--- load file ... --->
		<cffile action="read" file="#a_str_html_filename#" variable="a_Str_filecontent" charset=#a_str_html_charset#>
		
		<cfcatch type="any">
			<cfdump var="#q_select_alternativ_version#" label="q_select_alternativ_version">
			<cfdump var="#a_struct_result#" label="a_struct_result">
			<cfdump var="#cfcatch#" label="cfcatch">
			<cfabort>
		</cfcatch>
		</cftry>

		<cfset url.format = "html">

		<!--- extract the body only (no html) --->
		<cfset a_str_original_filecontent = a_Str_filecontent>

		<cfset url.body = trim(a_Str_filecontent)>
	
	</cfif>

</cfif>