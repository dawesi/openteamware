<!--- //

	Component:	EMail 
	Action:		Act
	Description: Desc
	

// --->

<cfcomponent displayname="EmailComponentsTools">

	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- load all folders for a certain user --->
	<cffunction access="public" name="getmailboxsize" output="false" returntype="numeric">
	
	<cfargument name="server" default="" required="true" type="string">
	<cfargument name="username" default="" type="string" required="true">
	<cfargument name="password" default="" type="string" required="true">
		
	<cfreturn 0 />
	
	</cffunction>
	
	<!--- move or copy a message --->
	<cffunction access="public" name="moveorcopymessage" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">	
		<cfargument name="uid" type="string" default="0" required="true">
		<cfargument name="sourcefolder" type="string" default="" required="true">
		<cfargument name="destinationfolder" type="string" default="" required="true">
		<cfargument name="copymode" type="boolean" default="false" required="true">
		<cfargument name="deferred" type="boolean" default="false" required="no">
		
		<cfset var a_int_copy = 1 />
		
		<cfif arguments.copymode is false>
			<cfset a_int_copy = 1>
		<cfelse>
			<cfset a_int_copy = 0>
		</cfif>	
		
		<cfif Len(arguments.destinationfolder) IS 0>
			<cfreturn 'FALSE'>
		</cfif>
			
		<!--- update references information ... --->
		<cfif NOT arguments.copymode>
			<cfinclude template="queries/q_update_references_information.cfm">
		</cfif>		
		
		<cfif NOT arguments.copymode AND (request.appsettings.properties.MailSpeedEnabled IS 1)>
			<!--- delete from source folder --->
			<cfinclude template="queries/q_delete_speedmail_mail_data.cfm">
		</cfif>		
			
		<cftry>
		
		<!--- deferred mode ? --->
		
		<!--- TODO Implement new mail handler --->
		
		<cfcatch type="any">
			<!--- error --->
			
			<cfreturn 'FALSE'>
		</cfcatch>
		</cftry>
		
		<cfreturn false />
	
	</cffunction>
	
	<cffunction access="public" name="DeleteMessageOrMoveToTrash" output="false" returntype="struct"
			hint="depeding on the current folder, delete the message or move it to Trash folder">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="foldername" type="string" required="true"
			hint="full folder name, e.g. INBOX.Sent">
		<cfargument name="uid" type="numeric" required="true"
			hint="unique ID of message in folder">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_imap_data = arguments.securitycontext.A_STRUCT_IMAP_ACCESS_DATA />
		<cfset var a_str_result = '' />
		
		<!--- already in trash? delete the message ... otherwise - move to trash ... --->
		<cfif CompareNoCase(arguments.foldername, 'INBOX.Trash') IS 0>
		
			<cfset a_str_result = deletemessages(server = a_struct_imap_data.a_str_imap_host,
										username = a_struct_imap_data.a_str_imap_username,
										password = a_struct_imap_data.a_str_imap_password,
										foldername = arguments.foldername,
										uid = arguments.uid) />
		<cfelse>
		
			<cfset a_str_result = moveorcopymessage(server = a_struct_imap_data.a_str_imap_host,
										username = a_struct_imap_data.a_str_imap_username,
										password = a_struct_imap_data.a_str_imap_password,
										foldername = arguments.foldername,
										uid = arguments.uid,
										sourcefolder = arguments.foldername,
										destinationfolder = 'INBOX.Trash',
										copymode = false) />
		
		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	
	<cffunction access="public" name="deletemessages" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">	
		<cfargument name="uid" type="string" default="0" required="true">
		<cfargument name="foldername" type="string" default="" required="true">
		<cfargument name="deferred" type="boolean" default="false" required="no">
		
		<cfset var IMAPRESULT = '' />
		<cfset var a_str_uid = '' />
		
		<!--- delete in the meta table ... --->
		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_delete_speedmail_mail_data.cfm">
		</cfif>
				
		<cfloop list="#arguments.uid#" delimiters="," index="a_str_uid">
			<cfx_MailConnector server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#" action="deletemessage"
			uid=#a_str_uid#
			foldername=#arguments.foldername#>
		</cfloop>
		
		<cftry>
			<!---<cfx_MailConnector server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#" action="deletemessage"
			uid=#a_str_uid#
			foldername=#arguments.foldername#>--->
			
		<!---<cfelse>
			<cfset IMAPRESULT = true>
		</cfif>--->

		<cfcatch type="any">
		
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="error on deleting a message" type="html">
				<cfdump var="#cfcatch#">
				<cfdump var="#arguments#">
			</cfmail>
		
			<cfreturn 'FALSE'>
		</cfcatch>
		</cftry>
		
		<cfreturn IMAPRESULT>
	
	</cffunction>	
	
	<!--- set the status of a message --->
	<cffunction access="public" name="setmessagestatus" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">	
		<cfargument name="uid" type="string" default="0" required="true">
		<cfargument name="foldername" type="string" default="0" required="true">
		<cfargument name="status" type="numeric" default="0" required="true">
				
		<!--- update in the speedmail table ... --->
		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_update_speedmail_status.cfm">	
		</cfif>	
		
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		password="#arguments.password#" action="setstatus"
		uid=#arguments.uid#
		foldername=#arguments.foldername#
		status=#arguments.status#> --->
		

		
		<cfreturn true />		
	
	</cffunction>
	
	<!--- create a folder --->
	<cffunction access="public" name="createfolder" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">	
		<cfargument name="fullparentfoldername" type="string" default="" required="true">
		<cfargument name="foldername" type="string" default="0" required="true">
		
		<cfset var a_str_full_foldername = '' />
		<cfset var a_bol_Return = false />
		<cfset arguments.foldername = Trim(foldername)>
		
		<!--- TODO Implement new mail handler --->
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		password="#arguments.password#" action="createfolder"
		fullparentfoldername=#arguments.fullparentfoldername#
		foldername=#arguments.foldername#> --->
		
		<!--- add to speedmail folder watch --->
		<cfset a_str_full_foldername = arguments.fullparentfoldername & '.' & arguments.foldername>
		
		<cfinclude template="queries/q_select_userid_by_username.cfm">
		
		<cfif (request.appsettings.properties.MailSpeedEnabled IS 1) AND (q_select_userid_by_username.recordcount IS 1)>
			<cfinvoke component="#request.a_str_component_mailspeed#" method="AddFolderToWatch" returnvariable="a_bol_Return">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="foldername" value="#a_str_full_foldername#">
				<cfinvokeargument name="userid" value="#q_select_userid_by_username.userid#">
			</cfinvoke>
		</cfif>
		
		<cfreturn IMAPRESULT>		
	
	</cffunction>
	
	<!--- delete a folder ... --->
	<cffunction access="public" name="deletefolder" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		<cfargument name="foldername" type="string" default="0" required="true">
		
		<!--- remove from watch table --->
		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_delete_mailspeed_folder_entry.cfm">
		</cfif>
		
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		password="#arguments.password#" action="deletefolder"
		foldername=#arguments.foldername#> --->
		
		<!--- TODO Implement new handler --->
		
		<cfreturn IMAPRESULT>		
	
	</cffunction>
	
	<!--- delete a folder ... --->
	<cffunction access="public" name="renamefolder" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		<cfargument name="sourcefolder" type="string" default="" required="true">
		<cfargument name="destinationfolder" type="string" default="" required="true">
		
		<cfset var a_bol_Return = false />
		
		<!--- delete from watcher table --->
		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_update_rename_folder.cfm">
		</cfif>
		
		<cfinclude template="queries/q_select_userid_by_username.cfm">
		
		<cfif (request.appsettings.properties.MailSpeedEnabled IS 1) AND (q_select_userid_by_username.recordcount IS 1)>
			<cfinvoke component="#request.a_str_component_mailspeed#" method="AddFolderToWatch" returnvariable="a_bol_Return">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="foldername" value="#arguments.destinationfolder#">
				<cfinvokeargument name="userid" value="#q_select_userid_by_username.userid#">
			</cfinvoke>
		</cfif>		
		
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		password="#arguments.password#" action="renamefolder"
		sourcefolder=#arguments.sourcefolder#
		destinationfolder=#arguments.destinationfolder#> --->
		
		<cfreturn false>		
	
	</cffunction>		
	
	<!--- get an attachment --->
	<cffunction access="public" name="loadattachment" output="false" returntype="struct">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		<cfargument name="foldername" type="string" default="0" required="true">
		<cfargument name="uid" type="numeric" default="0" required="true">
		<cfargument name="partid" type="numeric" default="0" required="true">
		<cfargument name="savepath" type="string" default="" required="true">	
		
		<cfset var a_return_struct = StructNew() />
		
		<!--- <cfx_MailConnector
			server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#"
			action="loadattachment"
			foldername=#arguments.foldername#
			uid=#arguments.uid#
			partid=#arguments.partid#
			savepath="#arguments.savepath#"> --->
		
		
	
		<cfset a_return_struct["arguments"] = arguments>
		<cfset a_return_struct["result"] = IMAPRESULT>
		<cfset a_return_struct["savepath"] = savepath>
		
		<cfreturn a_return_struct />

	</cffunction>
	
	<!--- search for messages --->
	<cffunction access="public" name="search" output="false" returntype="struct">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		<cfargument name="foldername" type="string" default="" required="true">
		<cfargument name="searchstring" type="string" default="" required="true">
		<cfargument name="recursive" type="boolean" default="false" required="false">
		<cfargument name="fulltextsearch" type="boolean" default="false" required="no">
		
		<cfset var a_return_struct = StructNew() />
		<cfset var a_int_recursive = 0 />
		
		<cfif arguments.recursive is true>
			<cfset a_int_recursive = 1>
		<cfelse>
			<cfset a_int_recursive = 0>
		</cfif>	
		
		<!--- check if this folder is in sync state ... --->
		<!--- <cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_select_speedmail_folder_sync_status.cfm">
			
			<cfif (q_select_speedmail_folder_sync_status.syncstatus IS 1) AND NOT arguments.fulltextsearch>
				<!--- do a simple database query instead of querying the IMAP server --->
				<cfset a_return_struct["result"] = true>
				<!---<cfset a_return_struct["query"] = q_select_mailbox>--->
			</cfif>
		</cfif> --->
		
		<cftry>
		<!--- <cfx_MailConnector
			server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#"
			action="search"
			recursive=#a_int_recursive#
			foldername=#arguments.foldername#
			searchstring="#arguments.searchstring#"> --->
			
		<cfset a_return_struct["result"] = IMAPRESULT>
		<cfset a_return_struct["query"] = q_select_mailbox>
		
					
		<cfcatch type="any">
			<cfset a_return_struct.result = false>
		</cfcatch>
		</cftry>
		
		<cfreturn a_return_struct>

	</cffunction>
	
	
	<!--- // return rfc822 message // --->
	<cffunction access="public" name="GetRawMessage" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		<cfargument name="foldername" type="string" default="0" required="true">
		<cfargument name="uid" type="numeric" default="0" required="true">
		<cfargument name="savepath" type="string" default="" required="true">		
		
		<!--- <cfx_MailConnector
			server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#"
			action="getrawmessage"
			uid=#arguments.uid#
			foldername=#arguments.foldername#
			savepath="#arguments.savepath#"> --->
			
		<cfreturn Savepath />		
	</cffunction>
	
	
	<!--- parse a raw format message --->
	<cffunction access="public" name="parserawmessage" output="false" returntype="struct">
		<cfargument name="filename" default="" required="true" type="string">
		<cfargument name="tempdir" default="" required="true" type="string">
				
		<cfset var a_return_struct = StructNew()>
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="parse raw message" type="html">
			<cfdump var="#arguments#">
			<cfdump var="#session#">
			<cfdump var="#cgi#">
		</cfmail>--->
				
		<cftry>
		<!--- <cfx_MailConnector
			action="parserawmessage"
			filename="#arguments.filename#"
			tempdir="#arguments.tempdir#">			 --->
		<cfcatch type="any">
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="exception on parserawmessage in cmp_tools" type="html">
				<cfdump var="#arguments#" label="arguments">
				<cfdump var="#cfcatch#" label="cfcatch">
			</cfmail>
			
			<cfset a_return_struct.result = False>
			<cfreturn a_return_struct>
		</cfcatch>
		</cftry>
			
		
	
		<cfset a_return_struct["result"] = IMAPRESULT>
		<cfset a_return_struct["query"] = q_select_message>
		<cfset a_return_struct["attachments_query"] = q_select_attachments>
		<cfset a_return_struct["headers"] = q_select_header>
		
		<cfreturn a_return_struct>				
		
	</cffunction>
	
	<cffunction access="public" name="emptyfolder" output="false" returntype="struct">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">	
		<cfargument name="foldername" default="" required="true" type="string">
		<cfargument name="maxage" default="0" required="true" type="numeric">
				
		<cfset var a_return_struct = StructNew() />
				
		<!--- <cfx_MailConnector
			server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#"		
			action="emptyfolder"
			foldername="#arguments.foldername#"
			maxage="#arguments.maxage#">			 --->
			
		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_mailspeed_empty_folder.cfm">
		</cfif>
			
		
	
		<cfset a_return_struct["result"] = IMAPRESULT>
		
		<cfreturn a_return_struct>				
		
	</cffunction>
	
	<!--- // add the standard folders ... // --->
	<cffunction access="remote" name="CreateStandardFolders" output="false" returntype="struct">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_str_foldername = '' />
		
		<cfset a_str_foldername = "Trash">
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		fullparentfoldername="INBOX"
		password="#arguments.password#" action="createfolder"
		foldername=#a_str_foldername#> --->
		
		<cfset a_str_foldername = "Drafts">
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		fullparentfoldername="INBOX"
		password="#arguments.password#" action="createfolder"
		foldername=#a_str_foldername#> --->
		
		<cfset a_str_foldername = "Sent">
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		fullparentfoldername="INBOX"
		password="#arguments.password#" action="createfolder"
		foldername=#a_str_foldername#> --->
		
		<cfset a_str_foldername = "Junkmail">
		<!--- <cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		password="#arguments.password#" action="createfolder"
		fullparentfoldername="INBOX"
		foldername=#a_str_foldername#>					 --->	
		
		
		<cfreturn stReturn>		
	</cffunction>
	
	
	<!--- check if a pop3 account is valid ... --->
	<cffunction access="public" name="TestPOP3Account" output="false" returntype="string">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">
		
		<cfreturn true>
		<!---<cfx_MailConnector server="#arguments.server#"
		username="#arguments.username#"
		password="#arguments.password#" action="checkpop3account">
	
		<cfreturn IMAPRESULT>	--->			
	
	</cffunction>
	
	<cffunction access="public" name="GetSAWhiteListItems" output="false" returntype="query">
		<cfargument name="username" type="string" required="true">
		<cfinclude template="queries/q_select_whitelist.cfm">
		<cfreturn q_select_whitelist>
	</cffunction>
	
	<cffunction access="public" name="AddWhitelistAddress" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true">
		<cfargument name="emailaddress" type="string" required="true">
		
		<cfinclude template="queries/q_insert_whitelist_item.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="RemoveWhitelistAddress" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true">
		<cfargument name="emailaddress" type="string" required="true">	
	
		<cfinclude template="queries/q_delete_sa_whitelist_item.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="MakeHTMLMailSafe" output="false" returntype="struct"
			hint="remove invalid strings form html mails (e.g. script tags ...)">
		<cfargument name="input_html" required="yes" hint="input" type="string">
		<cfargument name="privacyguard" required="no" type="boolean" default="true">
		<cfargument name="surpress_images" required="no" default="1" type="numeric" hint="supress images?">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_str_file = arguments.input_html />
		
		<!--- is it unsafe? return yes or no ... check for certain tags ... --->
		<cfset var badTags = "SCRIPT,OBJECT,APPLET,EMBED,FORM,LAYER,ILAYER,FRAME,IFRAME,FRAMESET,PARAM,META" />
		<cfset var obracket = find("<", arguments.input_html) />
		<cfset var stripperRE = "</?(" & listChangeDelims(badTags,"|") & ")[^>]*>" />
		<cfset var badTag = REFindNoCase(stripperRE,arguments.input_html,obracket,1) />
		<cfset stReturn.unsafe = (badTag.pos[1] GT 0) />
		
		<cfset stReturn.content = arguments.input_html />
		<cfset stReturn.images_surpressed = false />
		
		<cfinclude template="utils/inc_make_html_mail_safe.cfm">
		
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="GetRedirectTarget" output="false" returntype="string"
			hint="return the URL to redirect to ...">
		<cfargument name="session_scope" type="struct" required="true">
		<cfargument name="md5_querystring" type="string" required="true">
		<cfargument name="foldername" type="string" required="true">
		<cfargument name="uid" type="numeric" required="true">
		<cfargument name="openfullcontent" type="string" default="false" required="false">
		
		<cfset var a_str_target = 'default.cfm?action=ShowMessage' />
		<cfset var a_str_current_item = arguments.uid & '_' & arguments.foldername />
		<cfset var a_int_find_item = '' />
		<cfset var a_int_len_arguments = 0 />
		<cfset var a_int_new_item_row_index = 0 />
		<cfset var a_int_new_item = 0 />
		<cfset var a_str_arguments_session_scope_meta_scroll_data = '' />
		
		<cfinclude template="utils/inc_check_redirect_target.cfm">
		
		<cfreturn a_str_target />

	</cffunction>
	
	<!--- get the message references ... --->
	<cffunction access="public" name="GetMessageReferences" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="messageid" type="string" required="yes">
		<cfargument name="references" type="string" required="yes">
		<cfargument name="originaluid" type="numeric" default="0" required="no">
		<cfargument name="filter" type="struct" default="#StructNew()#" required="no">
		
		<cfset var a_str_rerferences = ''>
		<cfset var a_str_messageids = arguments.messageid>
		<cfset var q_select_reference_messages = 0 />
		<cfset var a_str_id = '' />
				
		<cfloop list="#arguments.references#" index="a_str_id" delimiters=" ">
			<cfset a_str_rerferences = ListAppend(a_str_rerferences, Trim(a_str_id))>
		</cfloop>
				
		<cfif Len(a_str_rerferences) GT 0>
			<cfset a_str_messageids = a_str_messageids & ',' & a_str_rerferences>
		</cfif>
		
		<!--- select first references ... --->
		<cfinclude template="queries/q_select_reference_messages.cfm">	
		
		<cfreturn q_select_reference_messages>		
		
	</cffunction>
	
<cffunction access="public" name="GetQuotaDataForUser" output="false" returntype="struct">
		<!--- the username ... --->
		<cfargument name="username" type="string" required="true">
		
		<cfset var stReturn = StructNew()>
		
		<cfinclude template="queries/q_select_quota.cfm">			
		
		<cfset stReturn.currentsize = Val(q_select_quota.cursize)>
		<cfset stReturn.maxsize = Val(q_select_quota.maxsize)>		
		<cfreturn stReturn>	
	</cffunction>
	
	
	<!--- update the quota (f.e. if email has been deleted or statistics are shown ... --->
	<cffunction access="public" name="UpdateQuotaData" output="false" returntype="boolean">
		<!--- the username ... --->
		<cfargument name="username" type="string" required="true">
		
		<cftry>
		<cfhttp timeout="3" url="http://database01.admin.openTeamware.com/cgi-bin/updatemaildirsize?username=#urlencodedformat(arguments.username)#" resolveurl="no"></cfhttp>
		
		<cfreturn true>	
		<cfcatch type="any">
			<cfreturn false>	
		</cfcatch>
		</cftry>
	
	</cffunction>
	
	<!--- update the maxsize of the user ... --->
	<cffunction access="public" name="UpdateQuota" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="true">
		<cfargument name="quota" type="numeric" default="0" required="true">
		
		<cfif arguments.quota IS 0>
			<cfreturn false>
		</cfif>
		
		<cfinclude template="queries/q_update_quota.cfm">
		
		<cfreturn true>
	</cffunction>
	
<cffunction access="public" name="GetSharedFolders" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="removeownfolders" type="boolean" required="false" default="true">
		
		<cfset var q_select_folders = QueryNew('workgroupkey,account,foldername')>
		<cfset var a_bol_add = false />
		<cfset var a_str_account = '' />
		<cfset var a_str_foldername = '' />
		<cfset var tmp = false />
		<cfset var q_select_shared_folders = 0 />
		
		<cfinclude template="queries/q_select_shared_folders.cfm">
		
		<cfloop query="q_select_shared_folders">
		
			<cfset a_bol_add = true>
			
			<cfset a_str_account = ListGetAt(q_select_shared_folders.folderdata, 1, ':')>
			<cfset a_str_foldername = Mid(q_select_shared_folders.folderdata, FindNoCase(':', q_select_shared_folders.folderdata)+1, Len(q_select_shared_folders.folderdata))>
						
			<cfif arguments.removeownfolders>
				<cfif Compare(a_str_account, arguments.securitycontext.myuserkey) IS 0>
					<cfset a_bol_add = false>
				</cfif>
			</cfif>
		
			<cfif a_bol_add>
				<cfset QueryAddRow(q_select_folders, 1)>
				<cfset QuerySetCell(q_select_folders, 'workgroupkey', q_select_shared_folders.workgroupkey, q_select_folders.recordcount)>
								
				<cfset QuerySetCell(q_select_folders, 'account', a_str_account, q_select_folders.recordcount)>
				<cfset QuerySetCell(q_select_folders, 'foldername', a_str_foldername, q_select_folders.recordcount)>
			</cfif>
		</cfloop>
		
		
		
		<cfreturn q_select_folders>	
	</cffunction>
</cfcomponent>