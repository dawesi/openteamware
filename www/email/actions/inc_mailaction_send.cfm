<!--- //

	Module:		EMail
	Action:		ActCheckSendMailOperation
	Description:Send an email
	

// --->

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
	<cfset q_avaliable_attachments = stReturn["q_attachments"]>

</cfif>

<cfif form.frmcbvcard IS 1>
	<!--- attach vcard if wanted ... --->
	<cfinclude template="utils/inc_attach_vcard.cfm">
</cfif>

<!--- are we sending a message to the employees or workgroup members? --->
<cfif FindNoCase('ibworkgroup@', form.mailto, 1) is 1>
	
	<!--- check which type and check permission --->
	<cfset a_str_workgroupkey = Mid(form.mailto, FindNoCase('ibworkgroup@', form.mailto, 1)+Len('ibworkgroup@'), len(form.mailto))>	
	
	<!--- all users ... --->
	<cfif a_str_workgroupkey IS 'all'>
	
		<!--- check if user is company admin --->
		<cfinvoke component="/components/management/customers/cmp_customer" method="IsUserCompanyAdmin" returnvariable="a_bol_return_is_company_admin">
			<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
		</cfinvoke>
		
		<cfif NOT a_bol_return_is_company_admin>
			You're not allowed to send messages to ALL company employees.
			<cfabort>
		</cfif>
		
		<!--- load all employees --->
		<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_company_users">
			<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
		</cfinvoke>
		
		<cfloop query="q_select_company_users">

			<!--- get standard address for this user --->			
			<cfinvoke component="/components/email/cmp_accounts" method="GetStandardAddressFromTag" returnvariable="a_str_from_adr">
				<cfinvokeargument name="userkey" value="#q_select_company_users.entrykey#">
			</cfinvoke>
			
			<cfset a_str_email_to = ExtractEmailAdr(a_str_from_adr)>
			
			<cfif Len(a_str_email_to) GT 0>
				<cfset form.mailbcc = ListAppend(form.mailbcc, a_str_email_to)>
			</cfif>
			
			<!--- ok, recipient list has been created --->
			
		</cfloop>
	<cfelse>
		<!--- check if user has WRITE right in the desired workgroup --->
		<cfquery name="q_Select_rights_workgroup" dbtype="query">
		SELECT
			permissions
		FROM
			request.stSecurityContext.q_select_workgroup_permissions
		WHERE
			workgroup_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_workgroupkey#">
		;
		</cfquery>
		
		<cfdump var="#q_Select_rights_workgroup#">
		
		<cfif ListFind(q_Select_rights_workgroup.permissions, 'write') GT 0>
			<!--- ok, --->
			<cfinvoke component="#request.a_str_component_workgroups#" method="GetWorkgroupMembers" returnvariable=q_select_workgroup_members>
				<cfinvokeargument name="workgroupkey" value=#a_str_workgroupkey#>
			</cfinvoke>		
			
			<cfloop query="q_select_workgroup_members">
				
				<cfinvoke component="/components/email/cmp_accounts" method="GetStandardAddressFromTag" returnvariable="a_str_from_adr">
					<cfinvokeargument name="userkey" value="#q_select_workgroup_members.userkey#">
				</cfinvoke>
				
				<cfset a_str_email_to = ExtractEmailAdr(a_str_from_adr)>
				
				<cfif Len(a_str_email_to) GT 0>
					<cfset form.mailbcc = ListAppend(form.mailbcc, a_str_email_to)>
				</cfif>
			
			</cfloop>
			
		<cfelse>
			<h4>You're not allowed to do that</h4>
			<cfabort>
		</cfif>
		
	</cfif>
	
	<!--- set special header --->
	<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
	<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "Precedence", true)>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", "List", true)>			
	
	<!--- set from = to --->	
	<cfset form.mailto = form.mailFrom>
		
</cfif>

<!--- do we've got a mailinglist? --->
<cfif FindNoCase('IBCCMLIST@', form.mailto, 1) is 1>

	<!--- load addresses and set the bcc ... set to = sender --->
	<cfset a_str_listkey = Mid(form.mailto, FindNoCase('IBCCMLIST@', form.mailto, 1)+Len('IBCCMLIST@'), len(form.mailto)) />

	<!--- load list id --->
	<cfset GetListProperties.entrykey = a_str_listkey>
	<cfinclude template="../../addressbook/queries/q_select_list.cfm">

	<cfset ExecuteLastSentUpdateRequest.entrykey = q_select_list.entrykey>
	<cfinclude template="../../addressbook/queries/q_update_lastsent_mlist.cfm">

	<!--- set BCC header --->
	<cfset form.mailbcc = ValueList(q_select_list_members.emailadr) />
	
	<!--- set to = sender --->
	<cfset form.mailto = form.mailFrom>

	<!--- set special header --->
	<cfset a_int_new_header = ArrayLen(a_arr_addheaders)+1>
	<cfset a_arr_addheaders[a_int_new_header] = StructNew()>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "key", "Precedence", true)>
	<cfset tmp = StructInsert(a_arr_addheaders[a_int_new_header], "value", "List", true)>		

	<!--- // mlist done! // --->
	<cfset DeleteTmpMlistRequest.listkey = q_select_list.entrykey>
	<cfinclude template="../../addressbook/queries/q_delete_tmp_mlist.cfm">

</cfif>

<cfset form.mailbody = ReplaceList(form.mailbody, "#chr(145)#,#chr(146)#,#chr(147)#,#chr(148)#", "',',"",""")>

<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company_data">
	<cfinvokeargument name="entrykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfif q_select_company_data.status IS 1>
	<cfif ListLen(form.mailbcc) GTE 5>
		<!--- do spammers a favour ... --->
		<cfset form.mailbcc = ListLeft(form.mailbcc, 1, 4)>
	</cfif>
	
	<cfif ListLen(form.mailto) GTE 5>
		<!--- do spammers a favour ... --->
		<cfset form.mailto = ListLeft(form.mailto, 1, 4)>
	</cfif>
	
	<cfif ListLen(form.mailcc) GTE 5>
		<!--- do spammers a favour ... --->
		<cfset form.mailcc = ListLeft(form.mailcc, 1, 4)>
	</cfif>		
	
	<!---<cfset form.mailbcc = ListAppend(form.mailbcc, '')>--->
	
	<!--- send the mail also to the spamtest tool ... --->
	<!---
	commented out
	<cfinvoke component="/components/email/cmp_message" method="createmessage" returnvariable="stReturn">
		<cfinvokeargument name="subject" value="#form.mailsubject#">
		<cfinvokeargument name="from" value="#form.mailfrom#">
		<cfinvokeargument name="priority" value="#form.FRMPRIORITY#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
		<cfinvokeargument name="body" value="#form.mailbody#">
		<cfinvokeargument name="to" value="office@musterfirma.at">
		<cfinvokeargument name="format" value="#form.frmformat#">
		<cfinvokeargument name="deleteattachmentsafteradding" value="true">
		<cfinvokeargument name="addheaders" value="#a_arr_addheaders#">
		<cfinvokeargument name="charset" value="#request.stUserSettings.mailcharset#">
	</cfinvoke>
	
	<cfset a_str_written_filename = stReturn["filename"]>
	
	<cfexecute name="/mnt/config/bin/smtp.pl" arguments="#a_str_written_filename#" timeout="120"></cfexecute>
	--->

</cfif>

<!--- create now the message ... --->
<cfinvoke component="#application.components.cmp_email_message#" method="createmessage" returnvariable="stReturn">
	<cfinvokeargument name="subject" value="#trim(form.mailsubject)#">
	<cfinvokeargument name="from" value="#form.mailfrom#">
	<cfinvokeargument name="cc" value="#form.mailcc#">
	<cfinvokeargument name="bcc" value="#form.mailbcc#">
	<cfinvokeargument name="priority" value="#form.FRMPRIORITY#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="body" value="#form.mailbody#">
	<cfinvokeargument name="to" value="#form.mailto#">
	<cfinvokeargument name="format" value="#form.frmformat#">
	<cfinvokeargument name="deleteattachmentsafteradding" value="true">
	<cfinvokeargument name="addheaders" value="#a_arr_addheaders#">
	
	<cfinvokeargument name="charset" value="#request.stUserSettings.mailcharset#">
	
	<cfif Len(form.mailbody_text) GT 0>
		<!--- in case of html ... if a special text part has been given, use it --->
		<cfinvokeargument name="body_textpart" value="#form.mailbody_text#">
	</cfif>

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
	method="AddMailToFolder" returnvariable="sReturn">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
	<cfinvokeargument name="destinationfolder" value="#form.frmsaveinfolder#">
	<cfinvokeargument name="returnuid" value="false">
	<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
</cfinvoke>

<cflog text="mailfile: #a_str_written_filename# #request.stSecurityContext.myusername#" type="Information" log="Application" file="ib_sendmail">

<!--- <cfexecute name="perl" arguments="/mnt/config/bin/smtp.pl #a_str_written_filename#" timeout="120"></cfexecute> --->

<!--- insert send job ... --->
<cfinvoke component="#request.a_str_component_email#" method="InsertSendEmailJob" returnvariable="stReturn_insert_job">
	<cfinvokeargument name="filename" value="#GetFileFromPath( a_str_written_filename )#">
	<cfinvokeargument name="fullfilenamewithpath" value="#a_str_written_filename#">
</cfinvoke>

<!--- insert lookup job ... --->
<cfinclude template="queries/q_insert_uid_lookup_job.cfm">

<!--- insert and get result --->
<cfinclude template="queries/q_insert_tmp_sent_info.cfm">

<cfif val(form.frmDraftId) GT 0>

	<!--- delete now draft message --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="uids" value="#form.frmDraftId#">
	</cfinvoke>

</cfif>

<!--- forward to confirmation page ... --->
<cflocation addtoken="no" url="default.cfm?action=ShowSendConfirmation&entrykey=#urlencodedformat(sReturn_entrykey)#">


