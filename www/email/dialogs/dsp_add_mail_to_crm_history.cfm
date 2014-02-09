<!--- //

	Component:	Service
	Function:	Function
	Description:
	
	Header:	$HeadURL$

// --->

<cfparam name="url.mailbox" type="string">
<cfparam name="url.uid" type="numeric">
<cfparam name="url.messageid" type="string">
<cfparam name="url.contactkey" type="string">

<cfif Len(url.contactkey) IS 0>
	Contactkey is missing
	<cfexit method="exittemplate">
</cfif>

<!--- has the user provided a mail stored in a folder or should we just take the data from the sendmailtmp info? ... --->
<cfif Val(url.uid) GT 0>

	
	<cfinvoke component="#application.components.cmp_email#" method="LoadMessage" returnvariable="stReturn">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
		<cfinvokeargument name="uid" value="#url.uid#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory_local#">
		<cfinvokeargument name="savecontenttypes" value="no/file">
	</cfinvoke>
	
	<cfif NOT stReturn.result>
		Message not found.
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset q_select_msg = stReturn.query />
	<cfset q_select_attachments = stReturn.attachments_query />
	
	<!--- get real attachments ... --->
	<cfquery name="q_select_attachments" dbtype="query">
	SELECT
		*
	FROM
		q_select_attachments
	WHERE
		contentid >= 1
	;
	</cfquery>
	
	<cfset a_str_from = q_select_msg.afrom />
	<cfset a_str_to = q_select_msg.ato />
	<cfset a_str_subject = q_select_msg.subject>
	<cfset a_dt_sender = q_select_msg.date_local />
	<cfset a_str_body = q_select_msg.body />
	<cfset a_str_message_id = url.messageid />

<cfelse>
	
	<!--- just take the information from the sendmailtemp info ... --->
	<cfinvoke component="#application.components.cmp_email#" method="GetSentMessageInformation" returnvariable="q_select_msg">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="entrykey" value="#url.messageid#">
	</cfinvoke>
	
	<cfset a_str_from = q_select_msg.afrom />
	<cfset a_str_to = q_select_msg.ato />
	<cfset a_str_subject = q_select_msg.subject>
	<cfset a_dt_sender = q_select_msg.dt_created />
	<cfset a_str_body = q_select_msg.body />
	<cfset a_str_message_id = q_select_msg.messageid />
	
	<cfquery name="q_select_attachments" datasource="#request.a_str_db_tools#">
	SELECT
		filename AS afilename,
		0 AS asize,
		contenttype
	FROM
		emailattachments
	WHERE
		messageid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_msg.messageid#">
	;
	</cfquery>

</cfif>

<!--- TODO: HTML --->
<cfif FindNoCase('<html', a_str_body) GT 0>
	<cfset a_str_body = StripHTML(a_str_body) />
</cfif>

<!--- build string ... --->
<cfsavecontent variable="a_str_msg"><cfoutput>#GetLangVal('mail_wd_from')#: #trim(a_str_from)##chr(10)#
#GetLangVal('mail_wd_to')#: #trim(a_str_to)##chr(10)#
#GetLangVal('mail_wd_subject')#: #trim(a_str_subject)##chr(10)#
#GetLangVal('mail_wd_date')#: #trim(a_dt_sender)#
#chr(10)#-------------------------#chr(10)#
#trim(a_str_body)##chr(10)#
<cfif q_select_attachments.recordcount GT 0>
-------------------------#chr(10)##chr(13)##chr(10)##chr(13)#
<cfloop query="q_select_attachments">#GetLangVal('mail_wd_attachments')# #chr(10)##chr(10)#
*** #trim(q_select_attachments.afilename)# #byteConvert(q_select_attachments.asize)# ***#chr(10)##chr(10)#
</cfloop>
</cfif>
</cfoutput></cfsavecontent>

<cfinvoke component="#application.components.cmp_crmsales#" method="CreateHistoryItem" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkey" value="#url.contactkey#">
	<cfinvokeargument name="subject" value="#a_str_subject#">
	<cfinvokeargument name="comment" value="#a_str_msg#">
	<cfinvokeargument name="dt_created" value="#a_dt_sender#">
	<cfinvokeargument name="item_type" value="3">
	<!--- linked = email + messageid ... --->
	<cfinvokeargument name="linked_servicekey" value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
	<cfinvokeargument name="linked_objectkey" value="#a_str_message_id#">
</cfinvoke>


<!--- 
<cfoutput>
<!--- <form action="/crm/?action=DoCreateHistoryItem" method="Post" id="form_addcrmhistory" name="form_addcrmhistory" onsubmit="DoHandleAjaxForm(this.id);return false;"> --->
<form action="/crm/?action=DoCreateHistoryItem" method="Post" id="form_addcrmhistory" name="form_addcrmhistory" onsubmit="DoHandleAjaxForm(this.id);return false;">

<!--- add to history of an address book item ... --->
<input type="hidden" name="frmservicekey" value="52227624-9DAA-05E9-0892A27198268072" />
<input type="hidden" name="frmobjectkey" value="#htmleditformat(url.contactkey)#" />
<input type="hidden" name="frmsubject" value="#trim(Trim(a_str_subject))#" />
<input type="hidden" name="frmcomment" value="#trim(a_str_msg)#" />

<input type="hidden" name="frmdt_created" value="#htmleditformat(a_dt_sender)#">


<input type="hidden" name="frmlinked_servicekey" value="" />
<input type="hidden" name="frmlinked_objectkey" value="#htmleditformat()#" />
</form>
</cfoutput> --->


<!--- <script type="text/javascript">
function DoAddNow() {
var a_bg_op = new cBasicBgOperation;
alert('calling doadd');
//a_bg_op.method = 'post';
//a_bg_op.url = '/crm/?action=DoCreateHistoryItem';
//a_bg_op.post_content = SerializeForm(findObj('form_addcrmhistory'));
//a_bg_op.doOperation();
}
window.setTimeout('DoAddNow()', 100);
</script> --->

<cfif stReturn.result>
	<img src="/images/si/accept.png" class="si_img" /> <cfoutput>#GetLangVal('crm_ph_added_sucessfully_to_history')#</cfoutput>
<cfelse>
	<img src="/images/si/exclamation.png" class="si_img" /> This item already exists in the history (Eintrag existiert bereits)
</cfif>
<br /><br />  
<img src="/images/si/vcard.png" class="si_img" /> <cfoutput>#GetLangVal('cm_wd_contact')#</cfoutput>: <a href="#" onclick="GotoLocHrefMain('/addressbook/?action=ShowItem&entrykey=<cfoutput>#url.contactkey#</cfoutput>');return false;"><cfoutput>#htmleditformat(application.components.cmp_addressbook.GetContactDisplayNameData(url.contactkey))#</cfoutput></a>
<br /><br />

<input type="button" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>" onclick="CloseSimpleModalDialog();" class="btn2" />  

