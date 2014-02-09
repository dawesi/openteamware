<!--- //

	Module:		Email
	Action:		Compose message forwarding
	Description:	
	

// --->
<cfparam name="url.mailbox" default="INBOX" type="string">
<cfparam name="url.id" type="numeric" default="0">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "forward.format"
	defaultvalue1 = "easy"
	savesettings = true
	setcallervariable1 = "a_str_email_forward_format">

<!--- load message now ... --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">

<!--- save message to a file ... --->
<cfif a_str_email_forward_format IS 'attachment'>
	
	<!--- forward message as attachment ... save to file ... --->
	<cfinvoke
		component="/components/email/cmp_tools"
		method="getrawmessage"
		returnvariable="a_str_result">
			<cfinvokeargument name="server" value="#request.a_str_imap_host#">
			<cfinvokeargument name="username" value="#request.a_str_imap_username#">
			<cfinvokeargument name="password" value="#request.a_str_imap_password#">
			<cfinvokeargument name="foldername" value="#url.mailbox#">
			<cfinvokeargument name="uid" value="#url.id#">
			<cfinvokeargument name="savepath" value="#request.a_str_temp_directory#">
	</cfinvoke>
	
	<cfset a_str_eml_file = a_str_result />
</cfif>

<!--- load message ... --->
<cfinvoke component="/components/email/cmp_loadmsg" method="LoadMessage" returnvariable="stReturn">
  <cfinvokeargument name="server" value="#request.a_str_imap_host#">
  <cfinvokeargument name="username" value="#request.a_str_imap_username#">
  <cfinvokeargument name="password" value="#request.a_str_imap_password#">
  <cfinvokeargument name="foldername" value="#url.mailbox#">
  <cfinvokeargument name="uid" value="#url.id#">
  <cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
  <cfinvokeargument name="savecontenttypes" value="*">
</cfinvoke>

<cfif stReturn.result IS 'error'>
	<h4><cfoutput>#GetLangVal('mail_ph_msg_error_not_found')#</cfoutput></h4>
	<cfabort>
</cfif>

<!--- get queries ... --->
<cfset q_forward = stReturn["query"]>
<cfset q_select_attachments = stReturn["attachments_query"]>
<cfset q_select_original_attachments = stReturn.attachments_query>

<!--- set data ... --->
<cfset url.subject = 'Fw: ' & q_forward.subject />

<cfif len(q_forward.account) is 0>
  <cfset url.mailfrom = request.stSecurityContext.myusername />
<cfelse>
  <!--- extract ... --->
  
  <!--- select the emailaddress for this account ... --->
  <cfquery name="q_select_forward_account" dbtype="query">
  SELECT
  	emailadr
  FROM
  	Q_SELECT_ALL_POP3_DATA
  WHERE
  	pop3server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_forward.account#">
  ; 
  </cfquery>

  <cfset url.mailfrom = q_select_forward_account.emailadr>

</cfif>

<cfif q_forward.contenttype is "text/html">
  <!--- text/html ... --->
  <cfset url.format = "html">
  <cfset a_str_body = "<br />----------------------<br />"&

"<b>#GetLangVal("mail_ph_original_message")#</b><br />

#GetLangVal("cm_wd_from")#: #htmleditformat(q_forward.AFrom)#<br />

#GetLangVal("cm_wd_to")#: #htmleditformat(q_forward.ato)#<br />

#GetLangVal("cm_wd_subject")#: #htmleditformat(q_forward.Subject)#<br />

#GetLangVal("mail_ph_datetime")#: #LSDateFormat(parsedatetime(q_forward.date_local), "dddd, dd. mmmm yyyy")# #TimeFormat(parsedatetime(q_forward.date_local), "HH:mm:ss")#<br /><br />"&q_forward.body>
  <cfelse>
  <!--- all other types ... --->
  <cfset a_str_body = "----------------------"&chr(13)&chr(10)&
"#GetLangVal("mail_ph_original_message")#
#GetLangVal("cm_wd_from")#: #htmleditformat(q_forward.AFrom)#
#GetLangVal("cm_wd_to")#: #htmleditformat(q_forward.ato)#
#GetLangVal("cm_wd_subject")#: #htmleditformat(q_forward.Subject)#
#GetLangVal("mail_ph_datetime")#: #LSDateFormat(parsedatetime(q_forward.date_local), "dddd, dd. mmmm yyyy")# #TimeFormat(parsedatetime(q_forward.date_local), "HH:mm:ss")#"&chr(13)&chr(10)&q_forward.body>
</cfif>
<!--- set body variable now --->
<cfset url.body = a_str_body>

<cfif (q_forward.contenttype IS 'text/html') OR (q_select_original_attachments.recordcount GT 0)>
	<!--- do we have attachments? --->
	
	<cftry>
	
		<cfif q_select_original_attachments.recordcount GT 0>
			<cfquery name="q_select_html_attachments" dbtype="query">
			SELECT
				*
			FROM
				q_select_original_attachments
			WHERE
				SIMPLECONTENTID <=1
				AND
				CONTENTTYPE = 'text/html'
				AND
				FILENAMELEN = 0
			; 
			</cfquery>
		
			<cfif q_select_html_attachments.recordcount IS 1>
				<cfset a_bol_is_html_message = true>
	
				<cfif Len(q_select_html_attachments.charset) IS 0>
					<cfset a_str_html_charset = 'ISO-8859-1'>
				<cfelse>
					<cfset a_str_html_charset = q_select_html_attachments.charset>
				</cfif>		
					
				<!--- set new body --->
				<cffile action="read" file="#q_select_html_attachments.tempfilename#" charset="#a_str_html_charset#" variable="a_str_html_text">
			<cfelse>
				<cfthrow message="123">
			</cfif>
			
		<cfelse>
			<cfset a_str_html_text = q_forward.body>
		</cfif>
			
			<cfset ii = FindNoCase('<body', a_str_html_text)>
			
			<!--- beautify text --->
			<!--- get content between <body></body> --->
			<cfset a_str_html_text = Mid(a_str_html_text, ii, Len(a_str_html_text))>
			<cfset a_str_html_text = ReReplaceNoCase(a_str_html_text, '<body[^>]*>', '', 'ONE') />
			<cfset a_str_html_text = ReplaceNoCase(a_str_html_text, '</body>', '', 'ALL')>
			<cfset a_str_html_text = ReplaceNoCase(a_str_html_text, '</html>', '', 'ALL')>
								
			<cfset a_str_info = "------------<br />
<b>#GetLangVal("mail_ph_original_message")#</b><br />
#GetLangVal("cm_wd_from")#: #htmleditformat(q_forward.AFrom)#<br />
#GetLangVal("cm_wd_subject")#: #htmleditformat(q_forward.Subject)#<br />
#GetLangVal("mail_ph_datetime")#: #LSDateFormat(parsedatetime(q_forward.date_local), "dddd, dd. mmmm yyyy")# #TimeFormat(parsedatetime(q_forward.date_local), "HH:mm:ss")#<br />">
			
			<cfset a_str_new_body = '<p></p><br /><blockquote style="border-left:solid blue 2px; margin-left:5px; padding-left:5px;margin-right:10px;padding-right:10px;">' & a_str_info & a_str_html_text & '</blockquote>'>
	
			<cfset url.body = a_str_new_body>
			<cfset url.format = 'html'>
	
	
	<cfcatch type="any">
		<!--- do nothing ... --->
	</cfcatch>
	</cftry>

</cfif>


<!--- create virtual query ... --->
<cfset q_add_virtual_attachments = QueryNew("afilename,contenttype,location,asize") />

<!--- forward the eml version ... --->
<cfif a_str_email_forward_format IS 'attachment'>

	<!--- forward as attachment ... --->
	<cfset tmp = QueryAddRow(q_add_virtual_attachments, 1)>
	<cfset a_int_recordcount = q_add_virtual_attachments.recordcount>
	<cfset tmp = QuerySetCell(q_add_virtual_attachments, 'afilename', 'Nachricht.eml', a_int_recordcount)>
	<cfset tmp = QuerySetCell(q_add_virtual_attachments, 'contenttype', 'binary/email', a_int_recordcount)>
	<cfset tmp = QuerySetCell(q_add_virtual_attachments, 'location', a_str_eml_file, a_int_recordcount)>
	<cfset tmp = QuerySetCell(q_add_virtual_attachments, 'asize', FileSize(a_str_eml_file), a_int_recordcount)>
</cfif>

<!--- check if in "easy" mode and attachments are available ... --->
<cfif a_str_email_forward_format IS 'easy' AND q_select_attachments.recordcount gt 0>
  <!--- real attachments are avaliable ... --->
  <!--- and now, get the raw message and save it ! --->
  <cfinvoke component="/components/email/cmp_tools" method="getrawmessage" returnvariable="sReturn">
    <cfinvokeargument name="server" value="#request.a_str_imap_host#">
    <cfinvokeargument name="username" value="#request.a_str_imap_username#">
    <cfinvokeargument name="password" value="#request.a_str_imap_password#">
    <cfinvokeargument name="foldername" value="#url.mailbox#">
    <cfinvokeargument name="uid" value="#url.id#">
    <cfinvokeargument name="savepath" value="#request.a_str_temp_directory#">
  </cfinvoke>
  
  <cfset a_str_rfc_filename = sReturn>

  <cfoutput query="q_select_attachments"> 

    <cfif Len(q_select_attachments.afilename) GT 0 AND len(q_select_attachments.tempfilename) gt 0>
	
      <cfset tmp = QueryAddRow(q_add_virtual_attachments, 1)>
      <cfset a_int_recordcount = q_add_virtual_attachments.recordcount>
      <cfset tmp = QuerySetCell(q_add_virtual_attachments, 'afilename', q_select_attachments.afilename, a_int_recordcount)>
      <cfset tmp = QuerySetCell(q_add_virtual_attachments, 'contenttype', q_select_attachments.contenttype, a_int_recordcount)>
      <cfset tmp = QuerySetCell(q_add_virtual_attachments, 'location', q_select_attachments.tempfilename, a_int_recordcount)>
      <cfset tmp = QuerySetCell(q_add_virtual_attachments, 'asize', q_select_attachments.asize, a_int_recordcount)>
	  
    </cfif>

  </cfoutput> 

</cfif>

<!--- dsp_compose will use this variable --->
<cfset q_select_attachments = q_select_attachments />

<!--- convert to a wddx package ... --->
<cfwddx action="cfml2wddx" input="#q_add_virtual_attachments#" output="a_str_output" usetimezoneinfo="yes">
<input type="hidden" name="frmq_virtual_attachments" value="<cfoutput>#htmleditformat(a_str_output)#</cfoutput>">
