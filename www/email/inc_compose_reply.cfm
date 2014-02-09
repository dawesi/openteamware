<!--- //

	Module:		E-Mail
	ACtion:		ComposeMail
	Description:Load data for answering 
	

// --->
<cfparam name="url.mailbox" default="INBOX" type="string">
<cfparam name="url.id" type="numeric" default="0">

<!--- load message now ... --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">

<cfinvoke component="#application.components.cmp_email#" method="LoadMessage" returnvariable="stReturn">
  <cfinvokeargument name="server" value="#request.a_str_imap_host#">
  <cfinvokeargument name="username" value="#request.a_str_imap_username#">
  <cfinvokeargument name="password" value="#request.a_str_imap_password#">
  <cfinvokeargument name="foldername" value="#url.mailbox#">
  <cfinvokeargument name="uid" value="#url.id#">
  <cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
  <cfinvokeargument name="savecontenttypes" value="text/html">
</cfinvoke>

<cfif NOT stReturn.result>
	<br /><br />
	Diese Nachricht wurde nicht gefunden.
	<br /><br />
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_ph_go_back')#</cfoutput></a>
	
	<cfabort>
</cfif>

<cfset q_reply = stReturn.query />
<cfset q_select_original_attachments = Duplicate(stReturn.attachments_query) />
<cfset q_select_attachments = stReturn["attachments_query"] />
<cfset q_select_headers = stReturn["headers"] />

<cftry>
<cfquery name="q_select_attachments" dbtype="query">
SELECT * FROM q_select_attachments WHERE SIMPLECONTENTID >=1; 
</cfquery>
<cfcatch type="any">
	<cfdump var="#q_select_attachments#">
</cfcatch>
</cftry>

<!--- // wrap message // --->
<cfset a_str_new_body = "> "&WrapText(rtrim(q_reply.body), 70, chr(13) & chr(10) & "> ") />

<!--- die obligatorischen Infos hinzuf�gen --->
<cfset a_str_info = "------------
#GetLangVal("mail_ph_original_message")#
#GetLangVal("cm_wd_from")#: #htmleditformat(q_reply.AFrom)#
#GetLangVal("cm_wd_subject")#: #htmleditformat(q_reply.Subject)#
#GetLangVal("mail_ph_datetime")#: #LSDateFormat(parsedatetime(q_reply.date_local), "dddd, dd. mmmm yyyy")# #TimeFormat(parsedatetime(q_reply.date_local), "HH:mm:ss")#">

<cfset a_str_new_body = Chr(13)&Chr(10)&Chr(13)&Chr(10)&a_str_info&Chr(13)&Chr(10)&Chr(13)&Chr(10)&a_str_new_body>
<!--- attachments? --->
<cfif q_select_attachments.recordcount gt 0>
  <cfset a_str_new_body = a_str_new_body&Chr(13)&Chr(10)&">"&Chr(13)&Chr(10)>
</cfif>
<cfoutput query="q_select_attachments"> 
  <cfset a_str_new_body = a_str_new_body&"> Attachment ##"&q_select_attachments.currentrow&": "&checkzerostring(q_select_attachments.afilename)&" ("&q_select_attachments.contenttype&")"&Chr(13)&Chr(10)>
</cfoutput> 
<cfset url.body = a_str_new_body />

<!--- check if we've got an html message ... --->
<cfset a_bol_is_html_message = false>

<cfif (q_reply.contenttype IS 'text/html') OR (q_select_original_attachments.recordcount GT 0)>
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
				<cfset a_bol_is_html_message = true />
	
				<cfif Len(q_select_html_attachments.charset) IS 0>
					<cfset a_str_html_charset = 'ISO-8859-1' />
				<cfelse>
					<cfset a_str_html_charset = q_select_html_attachments.charset />
				</cfif>		
					
				<!--- set new body --->
				<cffile action="read" file="#q_select_html_attachments.tempfilename#" charset="#a_str_html_charset#" variable="a_str_html_text">
				
			<cfelse>
				<cfthrow message="123">
			</cfif>
			
		<cfelse>
			<cfset a_str_html_text = q_reply.body>
		</cfif>
			
			<cfset ii = FindNoCase('<body', a_str_html_text)>
			
			<!--- beautify text --->
			<!--- get content between <body></body> --->
			<cfset a_str_html_text = Mid(a_str_html_text, ii, Len(a_str_html_text)) />
			
			<cfset a_str_html_text = ReReplaceNoCase(a_str_html_text, '<body[^>]*>', '', 'ONE') />
			<cfset a_str_html_text = ReplaceNoCase(a_str_html_text, '</body>', '', 'ALL') />
			<cfset a_str_html_text = ReplaceNoCase(a_str_html_text, '</html>', '', 'ALL') />
								
			<cfset a_str_info = "------------<br />
<b>#GetLangVal("mail_ph_original_message")#</b><br />
#GetLangVal("cm_wd_from")#: #htmleditformat(q_reply.AFrom)#<br />
#GetLangVal("cm_wd_subject")#: #htmleditformat(q_reply.Subject)#<br />
#GetLangVal("mail_ph_datetime")#: #LSDateFormat(parsedatetime(q_reply.date_local), "dddd, dd. mmmm yyyy")# #TimeFormat(parsedatetime(q_reply.date_local), "HH:mm:ss")#<br /><br />" />
			
			<cfset a_str_new_body = '<p></p><br /><blockquote style="border-left:solid blue 2px; margin-left:5px; padding-left:5px;margin-right:10px;padding-right:10px;">' & a_str_info & a_str_html_text & '</blockquote>'>
	
			<cfset url.body = a_str_new_body />
			<cfset url.format = 'html' />
	
	
	<cfcatch type="any">
		<!--- do nothing ... --->
	</cfcatch>
	</cftry>

</cfif>


<!--- set recipient --->
<cfset url.to = q_reply.AFRom>

<!--- extract the account ... --->
<cfif len(q_reply.account) is 0>
	<cfset url.mailfrom = request.stSecurityContext.myusername />
<cfelse>
  <!--- extract ... --->
  <!--- select the emailaddress for this account ... --->
  <cfquery name="q_select_reply_account" dbtype="query">
  SELECT emailadr FROM Q_SELECT_ALL_POP3_DATA WHERE pop3server = 
  <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_reply.account#">
  ; 
  </cfquery>
  <cfset url.mailfrom = q_select_reply_account.emailadr>
</cfif>

<CFIF (FindNoCase("Re:", Left(Trim(q_reply.Subject), 3)) IS 0)>
  <CFSET NewSubject = "Re: " & Trim(q_reply.Subject)>
  <CFELSE>
  <CFSET NewSubject = Trim(q_reply.Subject)>
</CFIF>

<!--- set subject --->
<cfset url.subject = NewSubject>

<!--- maybe also other people have received this email --->
<cfparam name="url.all" default="0">

<cfif url.all is "1">
  <cfset AAllTo = q_reply.ATo&","&q_reply.cc>
  <cfset AAllTo = ReplaceNoCase(AAllTo, " ", ",", "ALL")>
  <cfloop list="#AAllTo#" index="aline" delimiters=",">
    <!--- extract email address --->
    <cfset a_str_emailadr = ExtractEmailAdr(aline)>
    <cfif (Len(a_str_emailadr) gt 0) AND
					  (FindNoCase(a_str_emailadr, url.to, 1) is 0) AND
					  (Trim(a_str_emailadr) neq q_reply.account) AND
					  (a_str_emailadr neq request.stSecurityContext.myusername)>

      <cfset url.to = url.to & ", " & trim(aline)>

    </cfif>
  </cfloop>
</cfif>

<cfset a_arr_headers = QueryToArrayOfStructures(q_select_headers)>
<cfset a_str_references = ''>

<cfset a_int_array_len = arraylen(a_arr_headers)>

<cfloop from="1" to="#a_int_array_len#" index="ii">
	<cfif (a_arr_headers[ii].feld IS 'References')>
		<cfset a_str_references = a_arr_headers[ii].wert>
	</cfif>
	
	<cfif (a_arr_headers[ii].feld IS 'In-Reply-To')>
		<cfset a_str_references = ListPrepend(a_arr_headers[ii].wert, a_str_references)>
	</cfif>	
	
	<cfif (a_arr_headers[ii].feld IS 'Reply-To') AND (url.all IS 0) AND (Len(ExtractEmailAdr(a_arr_headers[ii].wert)) GT 0)>
		<cfset url.to = a_arr_headers[ii].wert>
	</cfif>
</cfloop>

<!--- load references ... --->
<cfinvoke component="/components/email/cmp_tools" method="GetMessageReferences" returnvariable="q_select_reference_messages">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="messageid" value="#q_reply.messageid#">
	<cfinvokeargument name="references" value="#a_str_references#">
</cfinvoke>

<cfset a_str_references = ValueList(q_select_reference_messages.messageid, ' ')>
<cfset a_str_references = trim(ListDeleteDuplicates(ListPrepend(a_str_references, q_reply.messageid, ' '), ' '))>
	
<cfset url.frmreferences = a_str_references>


