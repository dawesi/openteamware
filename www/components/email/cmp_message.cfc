<!--- //

	Service:	E-Mail
	Function:	Create a whole rfc message
	
	Header:	

	
	
	component for creating the whole rfc message
	with several methods ...
	
// --->
	
<cfcomponent displayname="cmp_message" output="false">
	
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cfscript>
	function returnrfc2047(subject, charset)
	{
		var a =createObject ("java","javax.mail.internet.MimeUtility");
		return a.encodeText(subject,charset,"Q");
		//return a.encodeText(subject);
	}
	function returnsinglerfc2407address(subject,charset)
		{
		// causes exception on multiple addresses
		var a2 =createObject("java","javax.mail.internet.InternetAddress");
		
		if (Len(Subject) IS 0)
			{
			return '';
			}
		
		if (ListLen(subject, '<') GT 2)
			{
			return subject;
			}
			
		a2.init(subject);
	 
		if (len (a2.getPersonal()) )
		return returnrfc2047(a2.getPersonal(), charset)&" <"&a2.getAddress()&">";
		else
		return "<"&a2.getAddress()&">";
		}	
	function returnrfc2407address(subject,charset)
	{
		return subject;
		
		// causes exception on multiple addresses
		//var a2 =createObject ("java","javax.mail.internet.InternetAddress");
		
		if (Len(Subject) IS 0)
			{
			return '';
			}
		
		
		
		if (ListLen(subject, '<') GT 2)
			{
			return subject;
			}
		
		
		a2.init(subject);
	 
		if (len (a2.getPersonal()) )
		return returnrfc2047(a2.getPersonal(), charset)&" <"&a2.getAddress()&">";
		else
		return "<"&a2.getAddress()&">";
	}
	</cfscript>
	
	<!--- beautify email addresses --->
	<cffunction access="private" name="PrepareUnicodeEncodeEmailAddresses" output="false" returntype="string">
		<cfargument name="input" type="string" required="yes">
		<cfargument name="charset" type="string" default="UTF-8">
		
		<cfset var sReturn = ''>		
		<cfset var a_str_new_return = ''>
		<cfset var a_str_item_new = ''>
		<cfset var a_str_name = ''>
		<cfset var a_str_item = '' />
		
		<cfif Len(arguments.input) IS 0>
			<cfreturn ''>
		</cfif>
		
		<!--- replace invalid strings --->
		<cfset sReturn = arguments.input>
		<cfset sReturn = ReplaceNoCase(sReturn, ';', ',', 'ALL')>
		<cfset sReturn = ReplaceNoCase(sReturn, ' ,', ', ', 'ALL')>		
		
		<!--- ok, unicode thing! --->
		<cfloop list="#sReturn#" delimiters="," index="a_str_item">

			<cfset a_str_item = trim(a_str_item)>
			<cfset a_str_item_new = ''>
			<cfset a_str_name = ''>
			
			<!---<cflog text="a_str_item: #a_str_item#" type="Information" log="Application" file="ib_email_to"> --->
			
			<cfif FindNoCase('<', a_str_item) GT 0>				
				<!--- get name --->
				<cfset a_str_name = Trim(Mid(a_str_item, 1, FindNoCase('<', a_str_item)-1))>
				
				<!--- replace all " --->
				<cfset a_str_name = ReplaceNoCase(a_str_name, '"', '', 'ALL')>
				
				<!--- set new recipient "name" <email> ... --->
				<cfset a_str_item_new = '"' & returnrfc2047(a_str_name, arguments.charset) & '" <' & ExtractEmailAdr(a_str_item) & '>'>
			<cfelse>
				<!--- email only --->
				<cfset a_str_item_new = returnrfc2047(a_str_item, arguments.charset)>
			</cfif>
			
			<!--- add item --->
			<cfset a_str_new_return = ListAppend(a_str_new_return, a_str_item_new)>
			
		</cfloop>
		
		<cfreturn a_str_new_return>
	</cffunction>
	
	<!--- create a message using several parameters ... --->
	<cffunction access="public" name="createmessage" output="false" returntype="struct">
		<!--- message properties ... --->
		<cfargument name="to" type="string" required="true" default="">
		<cfargument name="from" type="string" required="true" default="">
		<cfargument name="subject" type="string" required="true" default="">
		<cfargument name="cc" type="string" required="true" default="">
		<cfargument name="bcc" type="string" required="true" default="">
		
		<!--- NEW: encoding ... --->
		<cfargument name="charset" type="string" default="UTF-8" required="false">
		<cfargument name="format" type="string" required="true" default="text" hint="text or html">
		<cfargument name="body" type="string" required="true" default="" hint="the body part">
		
		<cfargument name="body_textpart" type="string" required="no" default="" hint="in case of multipart message, here could go the text part ...
			if empty, the text part will be auto-generated from html body">
		
		<cfargument name="priority" type="numeric" default="3" required="false">
		
		<!--- request read/delivery confirmation= --->
		<cfargument name="requestreadanddeliveryconfirmation" type="boolean" default="false" required="false">
		
		<!--- make attachments avaliable via webdownload? --->
		<cfargument name="sendreallyattachments" type="boolean" default="true" required="true">
		
		<!--- securemail action --->
		<cfargument name="smaction" type="string" required="false" default="">
		
		<!--- where to save the tmp file? --->
		<cfargument name="tempdir" type="string" required="true" default="/tmp/cfmx/">
		<!--- attachments ... 
			
			form:
			
			filename
			contenttype
			location
			charset
			
			--->
		<!--- the "real" attachments ... --->
		<cfargument name="attachments" type="query" required="false">
		
		<!--- linked attachments ... these attachments are just loaded if needed.
		
			i.e. someone wants to send a file from the storage ... --->
		<cfargument name="q_virtual_attachments" type="query" required="false">
		<!--- additional headers ... --->
		<cfargument name="addheaders" type="array" required="false" default="#ArrayNew(1)#">
		<!--- delete the attachments after they've been added? --->
		<cfargument name="deleteattachmentsafteradding" type="boolean" required="false" default="true">
		
		<cfargument name="requestreadconfirmation" type="boolean" required="false" default="false"
			hint="request read confirmation?">
		
		<!--- return the new uid ... --->
		<cfset var stReturn = StructNew() />

		<!--- generate a message id --->
		<cfset var a_str_message_id = "<" & CreateUUID() & "_www@openTeamWare.com>" />
		
		<cfset var a_str_draft_key = CreateUUID() />
		
		<!--- text or multipart? ... --->
		<cfset var a_str_type = "text" />
		<cfset var a_str_text_part = '' />
		
		<cfset var a_tmp_struct = 0 />
		<cfset var sFilename = '' />
		<cfset var sFilename_utf8 = '' />
		<cfset var a_int_array_index = 0 />
		
		<!--- which type? --->
		<cfif arguments.format is "text">
			<cfset a_str_type = "text">
		<cfelse>
			<cfset a_str_type = "Alternative">
		</cfif>
					
		<cfset arguments.to = PrepareUnicodeEncodeEmailAddresses(arguments.to, arguments.charset) />
		<cfset arguments.cc = PrepareUnicodeEncodeEmailAddresses(arguments.cc, arguments.charset) />
		<cfset arguments.bcc = PrepareUnicodeEncodeEmailAddresses(arguments.bcc, arguments.charset) />
		
		<cf_advancedemail 
			from="#returnsinglerfc2407address(trim(arguments.from), arguments.charset)#"
			to="#trim(arguments.to)#"
			server="mail.openTeamware.com"
			inline=false
			tempdir="#arguments.tempdir#"
			spooldir="#arguments.tempdir#"
			format="oet"
			port=25
			CC=#trim(arguments.cc)#
			BCC=#trim(arguments.bcc)#
			type="#a_str_type#"
			charset="#arguments.charset#"

			timeout=20
			variable="a_str_message"
			subject="#arguments.subject#">			
			<!--- subject, cc, bcc --->
			<cf_advancedemailparam name="Subject" value="#returnrfc2047(trim(arguments.subject), arguments.charset)#">
						
			<!--- reply to ... --->
			<cf_advancedemailparam name="Reply-To" value="#returnsinglerfc2407address(trim(arguments.from), arguments.charset)#">
			
			<!--- message id ... --->
			<cf_advancedemailparam name="Message-ID" value="#a_str_message_id#">
			
			<cf_advancedemailparam name="X-Draft-Key" value="#a_str_draft_key#">
			
			<!--- request read confirmation ... --->
			<cfif arguments.requestreadconfirmation>
			<cf_advancedemailparam name="Disposition-Notification-To" value="#arguments.from#">
			</cfif>
			
			<!--- priority ... --->
			<cf_advancedemailparam name="X-Priority" value="#arguments.priority#">

			<!--- custom headers ... --->
			<cfloop from="1" to="#Arraylen(arguments.addheaders)#" index="a_int_array_index">
				<cfset a_tmp_struct = arguments.addheaders[a_int_array_index] />
				<cf_advancedemailparam name="#a_tmp_struct.key#" value="#a_tmp_struct.value#">
			</cfloop>
			
			<cfif Len(arguments.smaction) GT 0>
				<cf_advancedemailparam name="inboxccsmaction" value="#arguments.smaction#">
			</cfif>
			
			<!--- further attachments ... --->
			<cfif IsDefined("arguments.attachments") AND
				  isQuery(arguments.attachments) AND
				  arguments.attachments.recordcount gt 0>
			
			<cfoutput query="arguments.attachments">			
			<cf_advancedemailparam file="#arguments.attachments.location#" filename="#returnrfc2047(arguments.attachments.afilename, arguments.charset)#" cache="FALSE" mime="#arguments.attachments.contenttype#">
			</cfoutput>
			</cfif>
			
			
			<cfif IsDefined("arguments.q_virtual_attachments") AND
				  isQuery(arguments.q_virtual_attachments) AND
				  arguments.q_virtual_attachments.recordcount gt 0>
				  <cfoutput query="q_virtual_attachments">
				  <cf_advancedemailparam file="#arguments.q_virtual_attachments.location#" filename="#arguments.q_virtual_attachments.afilename#" cache="FALSE" mime="#arguments.q_virtual_attachments.contenttype#">
				  </cfoutput>
			</cfif>
<!--- // text/plain or multipart/mixed // --->			
<cfif a_str_type is "text">
<cfoutput>#arguments.body#</cfoutput>
<cfelse>
	<!--- // alternative or multipart/mixed // --->

	<cfif Len(arguments.body_textpart) GT 0>
		<!--- text part has been submitted to the component ... --->
		<cfset a_str_text_part = arguments.body_textpart />
	<cfelse>
		<!--- auto-generate --->
		<cfset a_str_text_part = arguments.body />
		<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, 'body {font-family:"Lucida Grande",Verdana,Arial;font-size:11px;}', '', 'ONE') />
		<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, 'p {margin-top:4px;margin-bottom:0px;}', '', 'ONE') />
		<cfset a_str_text_part = ReplaceNoCase(a_str_text_part, '<br/>', chr(13)&chr(10), 'ALL') />
		<cfset a_str_text_part = trim(striphtml(a_str_text_part)) />
	</cfif>

<cf_advancedemailparam contenttype="text">
<cfoutput>#a_str_text_part#</cfoutput>
</cf_advancedemailparam>

<cf_advancedemailparam contenttype="HTML">

<cfif FindNoCase('<html>', arguments.body) IS 0>
	<!--- no html tags yet added ... do it now --->
	<html>
		<style>
		body {font-family:"Lucida Grande",Verdana,Arial;font-size:11px;}
		p {margin-top:4px;margin-bottom:0px;}
		</style>
	<head>
		<title>E-Mail <cfoutput>#htmleditformat(arguments.subject)#</cfoutput></title>
	</head>
	<body>
</cfif>

<cfset arguments.body = ReplaceNoCase(arguments.body, '<tbody>', '', 'ALL') />
<cfset arguments.body = ReplaceNoCase(arguments.body, '</tbody>', '', 'ALL') />

<cfoutput>#arguments.body#</cfoutput>

<cfif FindNoCase('</body>', arguments.body) IS 0>
	<!--- no html tags yet added ... do it now --->
	<!--- <div style="background-image:URL(https://www.openTeamWare.com/external/email/89f843f848ch83h3/spacer.gif;height:5px;"></div> --->
	</body></html>
</cfif>


</cf_advancedemailparam>
</cfif></cf_advancedemail>		

		<!--- write now file to hard disk ... --->
		<cfset sFilename = arguments.tempdir & "/" & createuuid() />
		<cfset sFilename_utf8 = arguments.tempdir & "/" & createuuid() />
		
		<!--- newMessage  ---->
		<cffile action="write" file="#sFilename_utf8#" charset="#arguments.charset#" output="#a_str_message#" addnewline="no">
		
		<cfset sFilename = sFilename_utf8 />
		
		<!--- delete attachments? --->
		<cfif (arguments.deleteattachmentsafteradding is true) AND
		      IsDefined("arguments.attachments") AND
			  isQuery(arguments.attachments) AND
			  (arguments.attachments.recordcount gt 0)>
			<cfoutput query="arguments.attachments">
			<cfif fileexists(arguments.attachments.location)>
			<cffile action="delete" file="#arguments.attachments.location#">
			</cfif>
			</cfoutput>		
		</cfif>

		<cfset stReturn["create_msg_summary"] = request.summary>
		
		<cfset stReturn["arguments"] = arguments>
		
		<cfset stReturn["messageid"] = a_str_message_id>
		<!--- the filename ... --->
		<cfset stReturn["filename"] = sFilename>
		<!--- utf8 filename --->
		<cfset stReturn.filename_utf8 = sFilename_utf8>	
	
		<!--- return now --->
		<cfreturn stReturn />
	
	</cffunction>
	
	<!--- remove an attachment by it's partid --->
	<cffunction access="public" name="removeattachment" output="false" returntype="struct">
		<cfargument name="uid" type="numeric" required="true" default="0">
		<cfargument name="foldername" type="string" required="true" default="INBOX.Drafts">	
		<cfargument name="server" type="string" required="true" default="mail.openTeamware.com">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="password" type="string" required="true" default="">
		<cfargument name="tempdir" type="string" required="true" default="">
		<cfargument name="removeattachmentid" type="numeric" required="true" default="1">
		<cfargument name="deleteoriginalmessage" type="boolean" required="false" default="false">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_msg = 0 />
		<cfset var q_select_all_attachments = 0 />
		<cfset var a_struct_createmsg_return = 0 />
		<cfset var tmp = false />
		<cfset var a_struct_msg_load = 0 />
		<cfset var q_select_real_attachments = 0 />
		<cfset var a_str_body = '' />
		<cfset var a_str_format = '' />
		<cfset var a_str_msgid = '' /	>
		<cfset var q_select_alternativ_version = 0 />
		<cfset var a_str_written_filename = '' />
		<cfset var a_struct_delete_msg = 0 />
		<cfset var a_struct_addmail_return = 0 />
		<cfset var q_new_attachments = QueryNew("afilename,location,contenttype", 'Varchar,Varchar,VarChar') />
		
		<cfinvoke component="#application.components.cmp_email#" method="LoadMessage" returnvariable="a_struct_msg_load">
			<cfinvokeargument name="tempdir" value="#arguments.tempdir#">
			<cfinvokeargument name="server" value="#arguments.server#">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="password" value="#arguments.password#">
			<cfinvokeargument name="uid" value="#arguments.uid#">
			<cfinvokeargument name="foldername" value="#arguments.foldername#">
			<cfinvokeargument name="savecontenttypes" value="*">
		</cfinvoke>
		
		<cfif NOT a_struct_msg_load.result>
			<cfreturn a_struct_msg_load />
		</cfif>
		
		<cfset q_select_msg = a_struct_msg_load.query />
		<cfset q_select_all_attachments = a_struct_msg_load.attachments_query />
		
		<!--- select the "real" attachments --->
		<cfquery name="q_select_real_attachments" debug="yes" dbtype="query">
		SELECT
			contentid,afilename,contenttype,tempfilename,filenamelen
		FROM q_select_all_attachments
		WHERE
			(contentid >= 1)
			AND
			(Filenamelen > 0)
		;
		</cfquery>
		
		<!--- create a new query for the new attachments ... --->
		
		
		<cfoutput query="q_select_real_attachments">
			<!--- loop through the original attachments --->
			
			<cfif q_select_real_attachments.contentid neq arguments.removeattachmentid>
				<!--- only add if not the attachment item to remove --->
				<cfset QueryAddRow(q_new_attachments, 1) />
				<cfset QuerySetCell(q_new_attachments, "afilename", q_select_real_attachments.afilename, q_new_attachments.recordcount) />
				<cfset QuerySetCell(q_new_attachments, "contenttype", q_select_real_attachments.contenttype, q_new_attachments.recordcount) />
				<cfset QuerySetCell(q_new_attachments, "location", q_select_real_attachments.tempfilename, q_new_attachments.recordcount) />
			</cfif>
			
		</cfoutput>
		
		<!--- check if we have a html message --->
		<cfquery name="q_select_alternativ_version" maxrows="1" dbtype="query">
		SELECT tempfilename FROM q_select_all_attachments
		WHERE (contentid <= 1)
		AND (Filenamelen = 0)
		AND (UPPER(contenttype) = 'TEXT/HTML');
		</cfquery>
		
		<cfset stReturn["att_query_alternative_version"] = q_select_alternativ_version>						
		
		<cfif q_select_alternativ_version.recordcount is 1>
			<!--- it's a html message! --->
			<cfset a_str_format = "html">
			<!--- load the body from the file ... --->
			<cffile action="read" file="#q_select_alternativ_version.tempfilename#" variable="a_str_body" charset="utf-8">
		<cfelse>
			<cfset a_str_format = "text">
			<cfset a_str_body = q_select_msg.body>
		</cfif>
		
		<!--- create now the message file ... --->
		<cfinvoke component="cmp_message" method="createmessage" returnvariable="a_struct_createmsg_return">
			<cfinvokeargument name="subject" value="#q_select_msg.subject#">
			<cfinvokeargument name="from" value="#q_select_msg.afrom#">
			<cfinvokeargument name="cc" value="#q_select_msg.cc#">
			<cfinvokeargument name="bcc" value="#q_select_msg.bcc#">
			<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
			<cfinvokeargument name="body" value="#a_str_body#">
			<cfinvokeargument name="to" value="#q_select_msg.ato#">
			<cfinvokeargument name="format" value="#a_str_format#">
			<cfinvokeargument name="deleteattachmentsafteradding" value="true">			
			<cfinvokeargument name="attachments" value="#q_new_attachments#">
		</cfinvoke>	
		
		<cfset a_str_written_filename = a_struct_createmsg_return.filename />
		<cfset a_str_msgid = a_struct_createmsg_return.messageid />
		
		<!--- add message now to the folder --->
		<cfinvoke component="#application.components.cmp_email#"
			method="AddMailToFolder" returnvariable="a_struct_addmail_return">
			<cfinvokeargument name="server" value="#arguments.server#">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="password" value="#arguments.password#">
			<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
			<cfinvokeargument name="destinationfolder" value="#arguments.foldername#">
			<cfinvokeargument name="returnuid" value="true">
			<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
		</cfinvoke>
		
		<cfif arguments.deleteoriginalmessage>
			<!--- delete the original message if requested ... --->			
			<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_msg">
				<cfinvokeargument name="server" value="#arguments.server#">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="foldername" value="#arguments.foldername#">
				<cfinvokeargument name="uids" value="#arguments.uid#">
			</cfinvoke>
		</cfif>
		
		<!--- return the new uid ... --->		
		<cfset stReturn.loadoldmsg = a_struct_msg_load />
		<cfset stReturn.arguments = arguments />
		<cfset stReturn["addmail"] = a_struct_addmail_return>
		<cfset stReturn["createmsg"] = a_struct_createmsg_return>
		<cfset stReturn["att_new_query"] = q_new_attachments>
		<!--- return the new uid ... --->
		<cfset stReturn.uid = a_struct_addmail_return.uid />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
<!--- // ############################################################################## // --->

	<!--- add one or several attachments --->
	<cffunction access="public" name="addattachment" output="false" returntype="struct">
		<cfargument name="uid" type="numeric" required="true" default="0">
		<cfargument name="foldername" type="string" required="true" default="INBOX.Drafts">
		<!--- filename --->
		
		<!--- the fields ... 
		
			afilename: string ... the filename ...
			contenttype: string
			location: string
			--->
		<cfargument name="attachments" type="query" required="true">
		
		<cfargument name="server" type="string" required="true" default="mail.openTeamware.com">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="password" type="string" required="true" default="">
		<cfargument name="tempdir" type="string" required="true" default="">
		
		<cfset var stReturn = StructNew() />
		<cfset var q_select_msg = 0 />
		<cfset var a_struct_msg_load = 0 />
		<cfset var q_select_all_attachments = 0 />
		<cfset var q_new_attachments = 0 />
		<cfset var q_select_real_attachments = 0 />
		<cfset var q_select_alternativ_version = 0 />
		<cfset var q_update_uid_attachments = 0 />
		<cfset var a_struct_createmsg_return = 0 />
		<cfset var a_struct_addmail_return = 0 />
		<cfset var a_struct_delete_msg = 0 />
		<cfset var a_str_add_headers = '' />
		<cfset var tmp = false />
		<cfset var a_str_format = '' />
		<cfset var a_str_body = '' />
		<cfset var a_str_headerinfo_wddx_filename = '' />
		<cfset var a_str_written_filename = '' />
		<cfset var a_str_msgid = '' />
		
		
		<!--- we have to load the whole old message, add the attachment
			  and return ... --->
			  
		<!--- load the original message ... --->
		<cfinvoke component="cmp_loadmsg" method="LoadMessage" returnvariable="a_struct_msg_load">
			<cfinvokeargument name="tempdir" value="#arguments.tempdir#">
			<cfinvokeargument name="server" value="#arguments.server#">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="password" value="#arguments.password#">
			<cfinvokeargument name="uid" value="#arguments.uid#">
			<cfinvokeargument name="foldername" value="#arguments.foldername#">
			<cfinvokeargument name="savecontenttypes" value="*">
		</cfinvoke>
		
		<cfset q_select_msg = a_struct_msg_load["query"]>
		<cfset q_select_all_attachments = a_struct_msg_load["attachments_query"]>
		
		<cfset stReturn["att_query_all"] = q_select_all_attachments>
		
		<!--- select the "real" attachments (not html body) --->
		<cfquery name="q_select_real_attachments" debug="yes" dbtype="query">
		SELECT contentid,afilename,contenttype,tempfilename,filenamelen FROM q_select_all_attachments
		WHERE (contentid >= 1)
		AND (Filenamelen > 0);
		</cfquery>
		
		<cfset stReturn["att_query_losgmsg"] = q_select_real_attachments>
		
		<!--- add now the new one ... --->
		<cfset q_new_attachments = QueryNew("afilename,location,contenttype")>
		
		<cfoutput query="q_select_real_attachments">
			<!--- loop through the original attachments --->
			<cfset QueryAddRow(q_new_attachments, 1)>
			<cfset QuerySetCell(q_new_attachments, "afilename", q_select_real_attachments.afilename, q_new_attachments.recordcount)>
			<cfset QuerySetCell(q_new_attachments, "contenttype", q_select_real_attachments.contenttype, q_new_attachments.recordcount)>
			<cfset QuerySetCell(q_new_attachments, "location", q_select_real_attachments.tempfilename, q_new_attachments.recordcount)>
		</cfoutput>
		
		<!--- add new row ... and the new attachment --->
		<cfoutput query="arguments.attachments">
			<cfset QueryAddRow(q_new_attachments, 1)>
			<cfset QuerySetCell(q_new_attachments, "afilename", arguments.attachments.afilename, q_new_attachments.recordcount)>
			<cfset QuerySetCell(q_new_attachments, "contenttype", arguments.attachments.contenttype, q_new_attachments.recordcount)>
			<cfset QuerySetCell(q_new_attachments, "location", arguments.attachments.location, q_new_attachments.recordcount)>		
		</cfoutput>
		
		<!--- check the content-type ... --->
		<cfquery name="q_select_alternativ_version" maxrows="1" debug="yes" dbtype="query">
		SELECT tempfilename FROM q_select_all_attachments
		WHERE (contentid <= 1)
		AND (Filenamelen = 0)
		AND (UPPER(contenttype) = 'TEXT/HTML');
		</cfquery>
		
		<cfset stReturn["att_query_alternative_version"] = q_select_alternativ_version>
		
		<cfif q_select_alternativ_version.recordcount is 1>
			<!--- it's a html message! --->
			<cfset a_str_format = "html">
			<!--- load the body from the file ... --->
			<cffile action="read" charset="utf-8" file="#q_select_alternativ_version.tempfilename#" variable="a_str_body">
		<cfelse>
			<cfset a_str_format = "text">
			<cfset a_str_body = q_select_msg.body>
		</cfif>
		
		<!--- check if we've got additional headers ... --->
		<cfset a_str_headerinfo_wddx_filename = request.a_str_temp_directory & request.a_str_dir_separator & Hash(arguments.server & arguments.username) & arguments.uid>
		
		<cfif FileExists(a_str_headerinfo_wddx_filename)>
			<cffile action="read" charset="utf-8" file="#a_str_headerinfo_wddx_filename#" variable="a_str_add_headers">
			<cfwddx action="wddx2cfml" input="#a_str_add_headers#" output="a_arr_add_headers">
			
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="123" type="html">
			<cfdump var="#a_arr_add_headers#">
		</cfmail>			--->
		</cfif>
		

						
		<!--- create now the message file ... --->
		<cfinvoke component="cmp_message" method="createmessage" returnvariable="a_struct_createmsg_return">
			<cfinvokeargument name="subject" value="#q_select_msg.subject#">
			<cfinvokeargument name="from" value="#q_select_msg.afrom#">
			<cfinvokeargument name="cc" value="#q_select_msg.cc#">
			<cfinvokeargument name="bcc" value="#q_select_msg.bcc#">
			<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
			<cfinvokeargument name="body" value="#a_str_body#">
			<cfinvokeargument name="to" value="#q_select_msg.ato#">
			<cfinvokeargument name="format" value="#a_str_format#">
			<cfinvokeargument name="deleteattachmentsafteradding" value="true">			
			<cfinvokeargument name="attachments" value="#q_new_attachments#">
			
			<!--- add headers? --->
			<cfif IsDefined('a_arr_add_headers') AND ArrayLen(a_arr_add_headers) GT 0>
				<cfinvokeargument name="addheaders" value="#a_arr_add_headers#">
			</cfif>
			
		</cfinvoke>

			
		
		<cfset a_str_written_filename = a_struct_createmsg_return["filename"]>
		<cfset a_str_msgid = a_struct_createmsg_return["messageid"]>
		
		<!--- add message now to the folder --->
		<cfinvoke component="#application.components.cmp_email#"
			method="AddMailToFolder" returnvariable="a_struct_addmail_return">
			<cfinvokeargument name="server" value="#arguments.server#">
			<cfinvokeargument name="username" value="#arguments.username#">
			<cfinvokeargument name="password" value="#arguments.password#">
			<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
			<cfinvokeargument name="destinationfolder" value="#arguments.foldername#">
			<cfinvokeargument name="returnuid" value="true">
			<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
		</cfinvoke>
				
		<!--- return the new uid ... --->		
		<cfset stReturn["arguments"] = arguments>
		<cfset stReturn["originalresult"] = a_struct_msg_load>
		<cfset stReturn["addmail"] = a_struct_addmail_return>
		<cfset stReturn["createmsg"] = a_struct_createmsg_return>
		<cfset stReturn["format"] = a_str_format>
		<cfset stReturn["att_new_query"] = q_new_attachments>
		<!--- return the new uid ... --->
		<cfset stReturn["uid"] = a_struct_addmail_return["uid"]>
		<!--- the message id --->
		<cfset stReturn.message_id = a_str_msgid>
		
		<cfquery name="q_update_uid_attachments" datasource="#request.a_str_db_tools#">
		UPDATE
			emailattachments
		SET
			uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_struct_addmail_return.uid#">
		WHERE
			uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.uid#">
			AND
			username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
		;
		</cfquery>
		
		<!--- delete now the old message ... --->
		<!---<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_msg">
				<cfinvokeargument name="server" value="#arguments.server#">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="foldername" value="#arguments.foldername#">
				<cfinvokeargument name="uids" value="#arguments.uid#">
		</cfinvoke>		--->
		
		<cfreturn stReturn>
			
	</cffunction>
	
	

</cfcomponent>

