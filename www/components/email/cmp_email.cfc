<!--- //

	Component:	E-Mail
	Description: Main e-mail component
	
// --->

<cfcomponent displayname="email component">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfset a_str_email_folders_hash_name = 'emailfolders_' />
	
	<!--- load all folders for a certain user --->
	<cffunction access="public" name="loadfolders" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="accessdata" type="struct" required="true"
			hint="imap access data (server/username/password)">
		<cfargument name="forceimap" type="boolean" default="false" required="no"
			hint="force usage of IMAP protocal instead of mailspeed">
		<cfargument name="TryToUseCachedVersion" type="boolean" default="false" required="false"
			hint="try to use cached version instead of direct IMAP call ...">
		<cfargument name="CacheFolderData" type="boolean" default="true" required="false"
			hint="Store the folder data in cache after the lookup">
		
		<cfset var a_return_struct = GenerateReturnStruct() />
		<cfset var a_struct_load_imap = StructNew() />
		<cfset var a_bol_speedmail_data_loaded = false />
		<cfset var a_bol_error_occured_loading_folders = false />
		<cfset var a_int_userid = 0 />
		
		<!--- forced or mailspeed has been disabled --->
		<cfset var a_force_imap = (arguments.forceimap OR (request.appsettings.properties.MailSpeedEnabled IS 0)) />
		<cfset var a_str_hash_id = a_str_email_folders_hash_name & Hash(arguments.accessdata.a_str_imap_host & arguments.accessdata.a_str_imap_username) />
		<cfset var a_bol_update_expiration_only = arguments.TryToUseCachedVersion />
		
		<cfset var q_select_mailspeed_folders = 0 />
		<cfset var a_str_foldername = '' />
		<cfset var a_str_parentfoldername = '' />
		<cfset var a_str_fullparentfoldername = '' />
		
		<cfset var a_struct_cache = 0 />
		
		
		<!--- userid ... use current or given in arguments ... --->
		<cfif CompareNocase(arguments.securitycontext.myusername, arguments.accessdata.a_str_imap_username) IS 0>
			<cfset a_int_userid = arguments.securitycontext.myuserid />
		<cfelse>
			<cfset a_int_userid = arguments.securitycontext.myuserid />
			<!--- <cfinclude template="queries/q_select_userid_by_username.cfm">
			<cfset a_int_userid = q_select_userid_by_username.userid /> --->
		</cfif>
		
		<!--- try to load from cache is desired ... --->
		<cfif arguments.TryToUseCachedVersion>
		
			<cfset a_struct_cache = application.components.cmp_cache.CheckAndReturnStoredCacheElement(hashid = a_str_hash_id) />
			
			<!--- is in cache, proceed and return ... --->
			<cfif a_struct_cache.result>
				<cfset a_return_struct.query = a_struct_cache.data.q_select_folders />
				<cfreturn SetReturnStructSuccessCode(a_return_struct) />
			</cfif>
		</cfif>
		
		
		<!--- try to load folders from mailspeed database if enabled and possible --->
		<cfif NOT a_force_imap>
			<cftry>
				
				<cfinclude template="queries/q_select_mailspeed_folders.cfm">
				
				<cfif (q_select_mailspeed_folders.recordcount GT 0)>
				
					<cfset a_return_struct.query = q_select_mailspeed_folders />
					
					<!--- alright, return now ... --->
					<cfreturn SetReturnStructSuccessCode(a_return_struct) />
				</cfif>
			
			<cfcatch type="any">
				<!--- an error occured, proceed with default IMAP call anyway ... --->
			</cfcatch>
			</cftry>
		</cfif>		
		
		<!--- use plain old imap! ... --->
		<cfset a_struct_load_imap = application.components.cmp_email_mailconnector.GetAllFolders(calculatemessagecount = true,
													server = arguments.accessdata.a_str_imap_host,
													username = arguments.accessdata.a_str_imap_username,
													password = arguments.accessdata.a_str_imap_password,
													port = arguments.accessdata.a_int_imap_port,
													useSSL = arguments.accessdata.a_int_use_ssl ) />
				
		<!--- an error occured, could not load folders ... --->									
		<cfif NOT a_struct_load_imap.result>
			<cfreturn SetReturnStructErrorCode(a_return_struct, a_struct_load_imap.error) />
		</cfif>
		
		<!--- cache folder data ... only if everything has worked like a charm ... --->
		<cfif arguments.CacheFolderData>
			<cfset application.components.cmp_cache.AddOrUpdateInCacheStore(hashid = a_str_hash_id,
												description = arguments.accessdata.a_str_imap_username,
												datatostore = a_struct_load_imap,
												updatetimeout_only_if_found = false) />
		</cfif>
			
		<cfset a_return_struct.query = a_struct_load_imap.q_select_folders />
	
		<cfreturn SetReturnStructSuccessCode(a_return_struct) />
	</cffunction>
	
	<cffunction access="public" name="ListMessages" output="false" returntype="struct"
			hint="list messages of a certain folder">
		<cfargument name="accessdata" type="struct" required="true"
			hint="imap access data (server/username/password)">
		<cfargument name="foldername" type="string" required="true"
			hint="name of imap folder">
		<cfargument name="startrow" type="numeric" default="1">
		<cfargument name="maxrows" type="numeric" default="0">
		<cfargument name="orderby" type="string" default="REVERSE DATE">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_speedmail_folder_sync_status = 0 />
		<cfset var q_select_speedmail_meta_data = 0 />
		<cfset var a_struct_load_imap = 0 />
		
		<cfset stReturn.a_bol_speedmail_data_used = false />
		
		<!--- try to user the data stored in database instead of direct IMAP access --->
		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
		
			<!--- is the folder in sync status? --->
			<cfinclude template="queries/q_select_speedmail_folder_sync_status.cfm">
			
			<cfif (q_select_speedmail_folder_sync_status.recordcount IS 1) AND Val(q_select_speedmail_folder_sync_status.syncstatus) IS 1>
		
				<!--- load meta data from the database ... --->		
				<cfinclude template="queries/q_select_speedmail_meta_data.cfm">
							
				<!--- return the data ... and set result to true --->
				<cfset stReturn.query = q_select_speedmail_meta_data />
				<cfset stReturn.a_bol_speedmail_data_used = true />
				
				<!--- done! ... --->
				<cfreturn SetReturnStructSuccessCode(stReturn) />
				
			</cfif>
		</cfif>
		
		<!--- proceed with IMAP ... --->
		<cfset a_struct_load_imap = application.components.cmp_email_mailconnector.ListMessages(foldername = arguments.foldername,
													startrow = arguments.startrow,
													server = arguments.accessdata.a_str_imap_host,
													username = arguments.accessdata.a_str_imap_username,
													password = arguments.accessdata.a_str_imap_password,
													port = arguments.accessdata.a_int_imap_port,
													useSSL = arguments.accessdata.a_int_use_ssl,
													orderby = arguments.orderby,
													maxrows = arguments.maxrows) />
		<cfif NOT a_struct_load_imap.result>
			<cfreturn a_struct_load_imap />
		</cfif>
		
		<cfset stReturn.query = a_struct_load_imap.q_select_messages />
	
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="LoadMessage" output="false" returntype="struct"
			hint="load an email message from IMAP server and return data">
		<cfargument name="accessdata" type="struct" required="true"
			hint="imap access data (server/username/password)">
		<cfargument name="foldername" type="string" required="true"
			hint="name of imap folder">
		<cfargument name="uid" type="numeric" required="true"
			hint="uid of message">
		<cfargument name="savecontenttypes" type="string" required="false" default=""
			hint="content-types to save immediately when loading (to temp dir)">
		<cfargument name="tempdir" type="string" required="false" default=""
			hint="temp directory to save attachments">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_load_imap = 0 />
		
		<!--- proceed with IMAP ... --->
		<cfset a_struct_load_imap = application.components.cmp_email_mailconnector.LoadMessage(foldername = arguments.foldername,
													server = arguments.accessdata.a_str_imap_host,
													username = arguments.accessdata.a_str_imap_username,
													password = arguments.accessdata.a_str_imap_password,
													port = arguments.accessdata.a_int_imap_port,
													useSSL = arguments.accessdata.a_int_use_ssl,
													setseen = true,
													foldername = arguments.foldername,
													uid = arguments.uid,
													tempdir = '/tmp/',
													storecontenttypes = arguments.savecontenttypes) />
		<cfif NOT a_struct_load_imap.result>
			<cfreturn a_struct_load_imap />
		</cfif>
		
		<cfset stReturn.q_select_headers = a_struct_load_imap.q_select_headers />
		<cfset stReturn.q_select_message = a_struct_load_imap.q_select_message />
		<cfset stReturn.attachments_query = a_struct_load_imap.q_select_attachments />
			
		<!--- <cfset var q_select_message = 0 />
		<cfset var q_select_header = 0 />
		<cfset var q_select_attachments = 0 />
		<cfset var IMAPRESULT = 'FALSE' />
		<cfset var a_arr_tmp = 0 />
		
	
		<!--- move to imap connector in future times ... --->
		<cftry>
		<cfx_MailConnector
			server="#arguments.server#"
			username="#arguments.username#"
			password="#arguments.password#"
			loadreceiveline=1
			action="getmessage"
			savecontenttypes="#arguments.savecontenttypes#"
			tempdir="#arguments.tempdir#"
			foldername="#arguments.foldername#" uid=#arguments.uid#>
		<cfcatch type="any">
				<cfset stReturn.mailconnector_error = cfcatch />
				<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
			</cfcatch>
		</cftry>
		
		<cfif IMAPRESULT NEQ 'OK'>
			<cset stReturn.imap_ok = false />
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
	
		<cftry>
		<cfset q_select_message.subject = parsepopsubject(q_select_message.subject)>
		<cfset q_select_message.afrom = Replace(parsepopsubject(q_select_message.afrom), '"null"', '', 'ALL')>
		<cfset q_select_message.ato = Replace(parsepopsubject(q_select_message.ato), '"null"', '', 'ALL')>
		<cfset q_select_message.cc = Replace(parsepopsubject(q_select_message.cc), '"null"', '', 'ALL')>
		<cfset q_select_message.bcc = Replace(parsepopsubject(q_select_message.bcc), '"null"', '', 'ALL')>
		<cfcatch type="any">
			<!--- error parsing the subject, from, to ... --->
		</cfcatch>
		</cftry>
		 
		<!--- decode lines --->
		<cfoutput query="q_select_header">
			<cfset QuerySetCell(q_select_header, "wert", parsepopsubject(q_select_header.wert), q_select_header.currentrow)>
		</cfoutput>
		
		<cfset a_arr_tmp = ArrayNew(1)>
		<cfif ListFindNoCase(q_select_attachments.columnlist, 'filenamelen') IS 0>
			<cfset QueryAddColumn(q_select_attachments, "filenamelen", a_arr_tmp)>
		</cfif>
		
		<cfif ListFindNoCase(q_select_attachments.columnlist, 'simplecontentid') IS 0>
			<cfset QueryAddColumn(q_select_attachments, "simplecontentid", a_arr_tmp)>
		</cfif>
		
		<cfloop query="q_select_attachments">
			<cfset QuerySetCell(q_select_attachments, "simplecontentid", val(q_select_attachments.contentid), q_select_attachments.currentrow)>		
			<cfset QuerySetCell(q_select_attachments, "filenamelen", len(q_select_attachments.afilename), q_select_attachments.currentrow)>
		</cfloop>
		
		
		<cfset stReturn["query"] = q_select_message>
		<cfset stReturn["attachments_query"] = q_select_attachments>
		<cfset stReturn["headers"] = q_select_header>
		 --->

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	
	</cffunction>
	
	<cffunction access="public" name="GetSentMessageInformation" output="false" returntype="query"
			hint="return basic information about sent message">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		
		<cfset var q_select_tmp_sent_info = 0 />
		<cfinclude template="queries/q_select_tmp_sent_info.cfm">
		
		<cfreturn q_select_tmp_sent_info />

	</cffunction>
	
	<cffunction access="public" name="InsertSendEmailJob" output="false" returntype="struct"
			hint="Insert location of mail to send">
		<cfargument name="filename" type="string" required="true"
			hint="path to rfc822 file">
		<cfargument name="fullfilenamewithpath" type="string" required="false" default=""
			hint="full filename with path">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_key = CreateUUID() />
		
		<!--- execute sending directly --->
		<cfif FileExists( arguments.fullfilenamewithpath )>
			<cfexecute name="/mnt/config/bin/smtp.pl" arguments="#arguments.fullfilenamewithpath#" timeout="120"></cfexecute>
		<cfelse>
			<cfinclude template="queries/q_insert_rfc822_file_2_send.cfm">
		</cfif>

		<cfset stReturn.entrykey = a_str_key />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="AddMailToFolder" returntype="struct">
		<cfargument name="server" default="" required="true" type="string"
			hint="name of IMAP server">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="Sourcefile" type="string" required="true"
			hint="the source file of the rfc/822 compilant message file">
		<cfargument name="destinationfolder" type="string" required="true"
			hint="where to store the message">
		<cfargument name="returnuid" type="boolean" default="false" required="false"
			hint="do we have to return the uid of the now stored message?">
		<cfargument name="ibccheaderid" type="string" required="false" default=""
			hint="the id to identify the newly added message">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_add_mail = 0 />
		<cfset var a_str_hash_id = a_str_email_folders_hash_name & Hash(arguments.server & arguments.username) />
		<cfset application.components.cmp_cache.RemoveElementFromCache(a_str_hash_id) />
		<cfset var a_return_struct_search = 0 />
		
		<cfset a_struct_add_mail = application.components.cmp_email_mailconnector.AddNewEmail(foldername = arguments.destinationfolder,
													sourcefilename = arguments.sourcefile,
													server = arguments.server,
													username = arguments.username,
													password = arguments.password,
													returnuid = arguments.returnuid,
													ibxccheaderid = arguments.ibccheaderid) />
		<!--- check returned uid ... --->
		<cfif NOT a_struct_add_mail.result>
			<cfreturn a_struct_add_mail />
		</cfif>
		
		<cfif arguments.returnuid AND (len(arguments.ibccheaderid) GT 0)>
			<!--- search for the uid ... --->
			
			<cfinvoke component="/components/email/cmp_tools"
				method="search" returnvariable="a_return_struct_search">
				<cfinvokeargument name="server" value="#arguments.server#">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="foldername" value="#arguments.destinationfolder#">
				<cfinvokeargument name="searchstring" value="#arguments.ibccheaderid#">
			</cfinvoke>
			
			<!--- do we have a valid answer? --->
			<cfif a_return_struct_search.query.recordcount is 1>
				<cfset stReturn.uid = a_return_struct_search.query.id />
			</cfif>
			
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="DeleteMessages" output="false" returntype="struct"
			hint="delete given messages in the folder">
		<cfargument name="server" default="" required="true" type="string">
		<cfargument name="username" default="" type="string" required="true">
		<cfargument name="password" default="" type="string" required="true">	
		<cfargument name="uids" type="string" required="true"
			hint="list of uids to delete">
		<cfargument name="foldername" type="string" default="" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_hash_id = a_str_email_folders_hash_name & Hash(arguments.server & arguments.username) />
		<cfset application.components.cmp_cache.RemoveElementFromCache(a_str_hash_id) />
		<cfset var a_struct_delete_mails = 0 />

		<cfif request.appsettings.properties.MailSpeedEnabled IS 1>
			<cfinclude template="queries/q_delete_speedmail_mail_data.cfm">
		</cfif>
		
		<!--- call IMAP delete now ... --->
		<cfset a_struct_delete_mails = application.components.cmp_email_mailconnector.DeleteMessages(foldername = arguments.foldername,
												uids = arguments.uids,
												server = arguments.server,
												username = arguments.username,
												password = arguments.password) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="SaveAllAttachments" output="false" returntype="struct"
			hint="save all attachments of an email ...">
		<cfargument name="uid" type="numeric" required="true" default="0">
		<cfargument name="foldername" type="string" required="true" default="INBOX.Drafts">
		<cfargument name="tempdir" type="string" required="true" default="">
		<cfargument name="server" type="string" required="true" default="mail.openTeamware.com">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="password" type="string" required="true" default="">
		<cfargument name="ignorebodyparts" type="boolean" default="true" required="false"
			hint="only return 'real' attachments">	
		
		<!--- load message and save all attachments ... --->
		<cfset var stReturn = GenerateReturnStruct() />
		<!--- this is the query returned ... --->
		<cfset var q_return_attachments = QueryNew("afilename,contentid,location,contenttype,filenamelen") />
		<cfset var q_select_read_attachments = 0 />
		<cfset var a_struct_msg_load = LoadMessage(tempdir = arguments.tempdir,
											server = arguments.server,
											username = arguments.username,
											password = arguments.password,
											uid = arguments.uid,
											foldername = arguments.foldername,
											savecontenttypes = '*') />
		<cfset var a_str_file_location = '' />
		
		
		<!--- error? ... --->
		<cfif NOT a_struct_msg_load.result>
			<cfreturn a_struct_msg_load />
		</cfif>
		
		<!--- get the attachments query ... --->
		<cfset q_select_read_attachments = a_struct_msg_load.attachments_query />
		
		<!--- select all "real" attachments ... not the body f.e. --->
		<cfif arguments.ignorebodyparts>
		
			<!--- remove f.e. text/html contentid 0/filenamelen=0) part --->
			<cfquery name="q_select_read_attachments"dbtype="query">
			SELECT
				contentid,afilename,contenttype,tempfilename
			FROM
				q_select_read_attachments
			WHERE
				(contentid >= 1) AND (filenamelen > 0)
			;
			</cfquery>
		</cfif>
		
		<!--- loop now over attachments ... --->
		<cfoutput query="q_select_read_attachments">
		
			<cfset a_str_file_location = q_select_read_attachments.tempfilename />
		
			<!--- add this file now to the virtual query --->
			<cfset QueryAddRow(q_return_attachments, 1) />
			<cfset QuerySetCell(q_return_attachments, "location", a_str_file_location, q_return_attachments.recordcount) />	
			<cfset QuerySetCell(q_return_attachments, "afilename", q_select_read_attachments.afilename,q_return_attachments.recordcount) />
			<cfset QuerySetCell(q_return_attachments, "contenttype", q_select_read_attachments.contenttype,q_return_attachments.recordcount) />
			<cfset QuerySetCell(q_return_attachments, "contentid", q_select_read_attachments.contentid,q_return_attachments.recordcount) />
			<cfset QuerySetCell(q_return_attachments, "filenamelen", len(q_select_read_attachments.afilename),q_return_attachments.recordcount) />
		
		</cfoutput>
		
		<cfset stReturn.q_attachments = q_return_attachments />
	
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>


</cfcomponent>

