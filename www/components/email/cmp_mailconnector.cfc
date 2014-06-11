<!--- //

	Module:		EMail
	Action:		Act
	Description: Desc
	
	Communicate with IMAP server
	
	- Connect
	- Return folders
	- Return folder
	- Return Msg
	- Delete Msg
	- Move/Copy Msg
	- Flag
	- ?
	
// --->

<cfcomponent hint="Mail Connector" output="false">
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfset variables.objFlag = CreateObject("Java", "javax.mail.Flags$Flag") />
	<cfset variables.fProfileItem = createObject("java","javax.mail.UIDFolder$FetchProfileItem") />
	<cfset variables.objRecipientType = CreateObject("Java", "javax.mail.Message$RecipientType") />

	<cfscript>
		
		function AttachmentsAvailable(contenttype) {
			return ((FindNoCase('multipart/', contenttype) GT 0) AND (contenttype NEQ 'multipart/alternative'));
			}
		
		function AddFolderToQueryAndCheckSubFolders(q, f, calculatemessagecount, returnfriendlyfoldernames, separator) {
			var ii = (q.recordcount + 1);
			var a_parent_folder = f.getParent();
			var a_parent_foldername = '';
			var a_parent_fullfoldername = '';
			var a_folder_fullname = f.getFullName();
			var a_arr_folders = f.list();
			var i = 0;
			var tmp = 0;
			var a_folder_type = f.getType();
			
			LogIMAPData( a_folder_fullname );
			
			// folder has a name, continue ... otherwise, just check subfolders
			if (Len( a_folder_fullname ) GT 0) {
			
				a_parent_fullfoldername = a_parent_folder.getFullName();
				a_parent_foldername = a_parent_folder.getName();
				
				// add a new row ...
				QueryAddRow(q, 1);			
				QuerySetCell(q, 'foldername', f.getname(), ii);
				
				if (Returnfriendlyfoldernames) {
					QuerySetCell(q, 'foldername', Returnfriendlyfoldername(a_folder_fullname), ii);
					}
							
				QuerySetCell(q, 'fullfoldername', a_folder_fullname, ii);
				QuerySetCell(q, 'uffn', UCase(a_folder_fullname), ii);
				
				// LogIMAPData(a_folder_fullname);
	
				// calculate the number of messages ...
				if ((calculatemessagecount) AND (a_folder_type IS 3) AND (f.exists()) AND (f.HOLDS_MESSAGES IS 1)) {
					
					tmp = QuerySetCell(q, 'messagescount', f.getMessageCount(), ii);
					tmp = QuerySetCell(q, 'unreadmessagescount', f.getUnreadMessageCount(), ii);
					} else {
							tmp = QuerySetCell(q, 'messagescount', 0, ii);
							tmp = QuerySetCell(q, 'unreadmessagescount', 0, ii);
							}
				
				// parent
				tmp = QuerySetCell(q, 'parentfoldername', a_parent_foldername, ii);
				tmp = QuerySetCell(q, 'fullparentfoldername', a_parent_fullfoldername, ii);
				
				// level
				tmp = QuerySetCell(q, 'level', (ListLen(a_parent_fullfoldername, separator ) + 1), ii);
				
				}
			
			for (i=1;i LTE ArrayLen(a_arr_folders); i=i+1) {
				AddFolderToQueryAndCheckSubFolders(q, a_arr_folders[i], calculatemessagecount, returnfriendlyfoldernames, separator);
				}
			
			return q;
			}
	</cfscript>
	
	<cffunction access="private" name="LogIMAPData" output="false" returntype="boolean">
		<cfargument name="logstring" type="string" required="true"
			hint="string to load">
			
		<cflog application="false" file="ib_imap_log" log="Application" type="information" text="#arguments.logstring#">
			
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="GetFolder" output="false" returntype="struct"
			hint="return a certain folder">	
		<cfargument name="store" type="any" required="true"
			hint="reference to the IMAP store">
		<cfargument name="foldername" type="string" required="true"
			hint="full foldername">
		<cfargument name="readwrite" type="boolean" default="false" required="false"
			hint="open in read/write mode?">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_var_folder = arguments.store.getFolder(arguments.foldername) />
		<cfset var tmp = LogIMAPData('start reading folder ' & arguments.foldername & ' ' & ' MessageCount ' & a_var_folder.getMessageCount() & ' next UID: ' & a_var_folder.getUIDNext() ) />
		
		<cfif NOT a_var_folder.exists()>
			<cfreturn SetReturnStructErrorCode(stReturn, 2201) />
		</cfif>
		
		<cfif arguments.readwrite>
			<cfset a_var_folder.open(a_var_folder.READ_WRITE) />
		<cfelse>
			<cfset a_var_folder.open(a_var_folder.READ_ONLY) />
		</cfif>
		
		<!--- return folder now ... --->		
		<cfset stReturn.folder = a_var_folder />
		
		<!--- try to check if something has changed --->
		<cfset stReturn.UidNext = a_var_folder.getUIDNext() />
		<cfset stReturn.MessageCount = a_var_folder.getMessageCount() />
		
		<cfset LogIMAPData('done reading folder ' & arguments.foldername) />

		<cfreturn SetReturnStructSuccessCode(stReturn) />	
	</cffunction>

	<cffunction access="public" name="GetAllFolders" output="false" returntype="struct"
			hint="return the list of folders ... return a query ...">
		<cfargument name="server" type="string" required="yes"
			hint="server name">
		<cfargument name="username" type="string" required="yes"
			hint="username for imap server">
		<cfargument name="password" type="string" required="yes"
			hint="password for imap server">
		<cfargument name="port" type="numeric" required="false" default="143"
			hint="port">
		<cfargument name="useSSL" type="boolean" default="false"
			hint="use encrypted connection">
		<cfargument name="parameters" type="string" required="no" default=""
			hint="parameters for this function ... none available yet">
		<cfargument name="calculatemessagecount" type="boolean" default="true"
			hint="calculate the number of messages or not (slow down!)">
		<cfargument name="ReturnFriendlyFoldernames" type="boolean" default="true"
			hint="return friendly, translated foldernames instead of INBOX, Trash and so on ...">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_root_folder = 'INBOX' />
		<cfset var a_var_folder_inbox = 0 />
		<cfset var a_str_seperator = '.' />
		<cfset var a_default_folder = 0 />
		<!--- query holding folders ... --->
		<cfset var q_select_folders = QueryNew('foldername,fullfoldername,uffn,level,fullparentfoldername,messagescount,parentfoldername,unreadmessagescount', 'Varchar,VarChar,VarChar,Integer,VarChar,Integer,VarChar,Integer') />
	
		<!--- try to connect ... --->
		<cfset var tmp = LogIMAPData('getting all folders for ' & arguments.username) />
		<cfset var a_var_store = ConnectToIMAPAccountAndReturnStore(server = arguments.server,
										username = arguments.username,
										password = arguments.password,
										port = arguments.port,
										useSSL = arguments.useSSL ) />
		
		<!--- error, exit --->
		<cfif NOT a_var_store.result>
			<cfreturn SetReturnStructErrorCode(stReturn, a_var_store.error) />
		</cfif>
		
		<!--- get the default folder --->
		<cfset a_default_folder = a_var_store.store.getDefaultFolder() />		
		<cfset a_str_seperator = a_default_folder.getSeparator() />
		
		<cfset q_select_folders = AddFolderToQueryAndCheckSubFolders(q_select_folders, a_default_folder, arguments.calculatemessagecount, arguments.ReturnFriendlyFoldernames, a_str_seperator.toString() ) />
				
		<cfset stReturn.q_select_folders = q_select_folders />
		
		<cfset LogIMAPData('DONE: getting all folders for ' & arguments.username) />
		
		<cfset CheckCloseConnection(a_var_store) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="private" name="CheckCloseConnection" returntype="boolean" output="false"
			hint="close an IMAP server connection if required">
		<cfargument name="ConnectionStore" type="struct" required="true"
			hint="the structure holding the IMAP store plus the the unique hash id ... used for checking if this connection is in cache status or not (and if not, close connection)">
			
		<cfset var a_bol_return = false />
		<cfset var tmp = false />
		<cfset var a_bol_exists_in_cache = application.components.cmp_cache.ElementExistsInCache(arguments.ConnectionStore.hash_id) />
		
		<!--- exists in cache, exit! ... --->
		<cfif a_bol_exists_in_cache>
			<cfreturn false />
		</cfif>
		
		 <cfset LogIMAPData('Closing connection for ' & arguments.ConnectionStore.username) />
		
		<!--- close connection ... --->
		<cftry>
			<cfset arguments.ConnectionStore.store.close() />
			<cfset arguments.ConnectionStore.store = 0 />
		<cfcatch type="any">
			<!--- log exception --->
			<cfset LogIMAPData('EXCEPTION WHILE CLOSING AN IMAP CONNECTION ' & cfcatch.Message) />
		</cfcatch>
		</cftry>
		
		<cfreturn true />
			
	</cffunction>
	
	<cffunction access="public" name="ConnectToIMAPAccountAndReturnStore" returntype="struct" output="false"
			hint="return IMAP store (try to use cached version)">
		<cfargument name="server" type="string" required="yes"
			hint="server name">
		<cfargument name="username" type="string" required="yes"
			hint="username for imap server">
		<cfargument name="password" type="string" required="yes"
			hint="password for imap server">
		<cfargument name="port" type="numeric" required="true"
			hint="imap server port">
		<cfargument name="useSSL" type="boolean" default="false"
			hint="use encrypted connection">
		<cfargument name="ConnectionCachingEnabled" type="boolean" default="true"
			hint="use connection caching">
		
		<cfset var stReturn = GenerateReturnStruct() />
		
		<!--- generate the hash ID for connection caching ... --->
		<cfset var a_str_hash_id = 'IMAP_CONNECTION_' & Hash(arguments.server & arguments.username & arguments.password) />
		
		<!--- is there a cached connection available? --->
		<cfset var a_bol_use_cached_conn = false />
		<cfset var a_struct_cached_conn_available = 0 />
		<cfset var obj_Properties = 0 />
		<cfset var cls_Session = 0 />
		<cfset var obj_Store = 0 />
		<cfset var tmp = LogIMAPData('connecting to IMAP server using username ' & arguments.username) />
		<cfset var a_imap_port = 143 />
		<cfset var a_imap_store = 'imap' />
		
		<!--- special port? --->
		<cfif Val( arguments.port ) GT 0>
			<cfset a_imap_port = arguments.port />
		</cfif>
		
		<!--- ssl? --->
		<cfif arguments.useSSL>
			<cfset a_imap_port = 993 />
			<cfset a_imap_store = 'imaps' />
		</cfif>
				
		<!--- *** disabled caching ... *** --->
		<cfset arguments.ConnectionCachingEnabled = true />
		
		<!--- return the unique hash id of this connection ... --->
		<cfset stReturn.username = arguments.username />
		<cfset stReturn.hash_id = a_str_hash_id />
		
		<!--- cached conn available? --->
		<cfif arguments.ConnectionCachingEnabled>
			<cfset a_struct_cached_conn_available = application.components.cmp_cache.CheckAndReturnStoredCacheElement(hashid = a_str_hash_id,
													update_expire_time = true) />
		
			<!--- use it? --->
			<cfset LogIMAPData('Checking for cached connection for ' & arguments.username) />
			<cfset a_bol_use_cached_conn = (a_struct_cached_conn_available.result AND a_struct_cached_conn_available.data.IsConnected()) />
		
			<cfif a_bol_use_cached_conn>
				
				<cfset LogIMAPData('Returning cached connection for ' & arguments.username) />
				<cfset stReturn.cachedconnection = true />
				<cfset stReturn.store = a_struct_cached_conn_available.data />
				
				<cfreturn SetReturnStructSuccessCode(stReturn) />
					
			</cfif>
			
		</cfif>
		
		<!--- try to connect to imap server and return stReturn.connection --->
		<cftry>
			
			<cfset LogIMAPData('Used plain old IMAP direct connection ' & arguments.username & ' host: ' & arguments.server & ' port: ' & a_imap_port &  ' store: ' & a_imap_store ) />
			
			<cflock name="#createUUID()#" timeout="5" throwontimeout="true">
						
			<cfscript>
				// create the objects
				obj_Properties = createObject("Java", "java.util.Properties");
				cls_Session = createObject("Java", "javax.mail.Session");
				obj_Store = createObject("Java","javax.mail.Store");
				
				// set various properties
				obj_Properties.init();
				obj_Properties.put("mail.store.protocol", a_imap_store );
				obj_Properties.put("mail.imap.port", a_imap_port ); 
				obj_Properties.put('mail.imap.partialfetch', 'true');
				// obj_Properties.put('mail.imap.connectionpoolsize', '20');
				
				// user plaintext login in the trusted environment
				obj_Properties.put('mail.imap.auth.login.disable', 'true');
				
				// enable debug
				// obj_Properties.put('mail.debug', 'true');
				
				// get session				
				obj_Session = cls_Session.getDefaultInstance(obj_Properties); 
				
				// get store and connect
				obj_Store = obj_Session.getStore( a_imap_store );
				obj_Store.connect(arguments.server, arguments.username, arguments.password); 
				
				// ok, everything ok ...
				stReturn.store = obj_Store;
			</cfscript>
			
			</cflock>
			
			<!--- store in cache ... only if desired --->
			<cfif arguments.ConnectionCachingEnabled>
				
				<cfset LogIMAPData('storing connection in cache for ' & arguments.username) />
				
				<cfset application.components.cmp_cache.AddOrUpdateInCacheStore(hashid = a_str_hash_id,
											datatostore = stReturn.store,
											description = arguments.username & ' @ ' & arguments.server,
											built_in_datatostore_type = 'imap_connection') />
			
			</cfif>
			
			
		
			<cfcatch type="any">
				<!--- an error occured ... --->
				<cfset LogIMAPData('FAILED ' & arguments.username & ' host: ' & arguments.server & '; message: ' & cfcatch.Message ) />

				
				<cfreturn SetReturnStructErrorCode(stReturn, 2000) />
			</cfcatch>
		</cftry>
		
		<!--- return ... --->
		<cfreturn SetReturnStructSuccessCode(stReturn) />		
	</cffunction>
	
	<cffunction access="public" name="DeleteMessages" output="false" returntype="struct" hint="">
		<cfargument name="server" type="string" required="yes"
			hint="server name">
		<cfargument name="username" type="string" required="yes"
			hint="username for imap server">
		<cfargument name="password" type="string" required="yes"
			hint="password for imap server">
		<cfargument name="foldername" type="string" required="true"
			hint="name of folder (full foldername, e.g. INBOX.Sent)">
		<cfargument name="uids" type="string" required="true"
			hint="list of UIDs of messages to delete in this folder">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_int_uid = 0 />
		<cfset var tmp = false />
		<cfset var a_var_store = ConnectToIMAPAccountAndReturnStore(server = arguments.server,
										username = arguments.username,
										password = arguments.password) />
		<cfset var stReturn_delete = 0 />
		<cfset var a_var_folder = 0 />
		
		<!--- error, exit --->
		<cfif NOT a_var_store.result>
			<cfreturn SetReturnStructErrorCode(stReturn, a_var_store.error) />
		</cfif>
		
		<!--- get the folder ... --->
		<cfset a_var_folder = GetFolder(store = a_var_store.store, foldername = arguments.foldername, readwrite = true) />
		
		<cfloop list="#arguments.uids#" delimiters="," index="a_int_uid">
			
			<cfset stReturn_delete = SetFlagForMsg(folder = a_var_folder.folder, uid = a_int_uid, flag = 'DELETED', value = true) />
			
		</cfloop>
		
		<!--- clean folder ... --->
		<cfset a_var_folder.folder.expunge() />
		<cfset a_var_folder.folder.close(true) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="AddNewEmail" output="false" returntype="struct"
			hint="add a new message to a given folder">
		<cfargument name="server" type="string" required="yes"
			hint="server name">
		<cfargument name="username" type="string" required="yes"
			hint="username for imap server">
		<cfargument name="password" type="string" required="yes"
			hint="password for imap server">
		<cfargument name="foldername" type="string" required="true"
			hint="name of folder (full foldername, e.g. INBOX.Sent)">
		<cfargument name="sourcefilename" type="string" required="true"
			hint="name of the source file ...">
		<cfargument name="returnuid" type="boolean" required="false" default="false"
			hint="return the new UID for this message?">
		<cfargument name="ibxccheaderid" type="string" required="false" default=""
			hint="message id to look for in the header ... when returning UID">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_var_store = ConnectToIMAPAccountAndReturnStore(server = arguments.server,
										username = arguments.username,
										password = arguments.password) />
		<cfset var a_var_folder = 0 />
		<cfset var a_arr_messages = ArrayNew(1) />
		<cfset var a_message = CreateObject("Java", "javax.mail.internet.MimeMessage") />
		<!--- create stream ... --->
		<cfset var a_inFile = CreateObject("java","java.io.File").init(arguments.sourcefilename) />
		<cfset var a_fs = CreateObject("java","java.io.FileInputStream").init(a_inFile) />
		
		<cfset var clsSession = createObject("Java", "javax.mail.Session")>
		<cfset var objProperties = createObject("Java", "java.util.Properties") />
		<cfset var objSession = 0 />
		<cfset var a_flags = CreateObject("Java", "javax.mail.Flags$Flag") />
        <cfset var tmp = LogIMAPData('adding new mail ' & arguments.username) />
		
		<!--- error, exit --->
		<cfif NOT a_var_store.result>
			<cfreturn SetReturnStructErrorCode(stReturn, a_var_store.error) />
		</cfif>
		
		<!--- get folder ... --->
		<cfset a_var_folder = GetFolder(store = a_var_store.store, foldername = arguments.foldername, readwrite = true) />	
		
        <cfset objProperties.init() />
		<cfset objSession = clssession.getInstance(objProperties) />
		
		<cfset a_message = CreateObject("Java", "javax.mail.internet.MimeMessage").init(objSession, a_fs) />
		<cfset a_message.setFlag(a_flags['SEEN'], true) />
				
		<!--- add the message ... --->
		<cfset a_arr_messages[1] = a_message />

		<cfset a_var_folder.folder.appendMessages(a_arr_messages) />
		
		<cftry>
		<cfset a_var_folder.folder.close() />
		<cfcatch type="any"></cfcatch></cftry>
		
		 <cfset LogIMAPData('DONE adding new mail ' & arguments.username) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction access="public" name="SetFlagForMsg" output="false" returntype="struct"
			hint="set a flag for a certain message">
		<cfargument name="folder" type="any" required="true"
			hint="folder object">		
		<cfargument name="uid" type="numeric" required="true"
			hint="the uid">
		<cfargument name="flag" type="string" required="true"
			hint="name of the flag">
		<cfargument name="value" type="string" required="true"
			hint="value of the flag">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_flags = CreateObject("Java", "javax.mail.Flags$Flag") />
		<cfset var a_arr_objMessage = 0 />
		<cfset var a_objMessage = 0 />
		<cfset var ii = 0 />
		<cfset var tmp = false />
		
		<cfif NOT arguments.folder.isOpen()>
			<cfset arguments.folder.open(arguments.folder.READ_WRITE) />
		</cfif>
		
		<cfset a_arr_objMessage = arguments.folder.getMessageByUID(arguments.uid) />
		<cftry>
        	<cfset a_arr_objMessage.setFlag(a_flags[arguments.flag], arguments.value) />
		
		<cfcatch type="any">
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfcatch>
		</cftry>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="private" name="GetSimpleContentType" returntype="string" output="false"
			hint="return the simple content type string">
		<cfargument name="contenttype" type="string" required="true">	
		<cfset var sReturn = arguments.contenttype />
		<cfset var ii = FindNoCase(';', sReturn) />
		
		<cfif ii GT 0>
			<cfreturn Mid(sReturn, 1, (ii - 1)) />
		<cfelse>
			<cfreturn sReturn />
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="ListMessages" output="false" returntype="struct"
			hint="return content of a certain folder">
		<cfargument name="server" type="string" required="yes"
			hint="server name">
		<cfargument name="username" type="string" required="yes"
			hint="username for imap server">
		<cfargument name="password" type="string" required="yes"
			hint="password for imap server">
		<cfargument name="port" type="numeric" required="false" default="143"
			hint="port">
		<cfargument name="useSSL" type="boolean" default="false"
			hint="use encrypted connection">			
		<cfargument name="foldername" type="string" required="true"
			hint="name of folder (full foldername, e.g. INBOX.Sent)">
		<cfargument name="beautifyfromto" type="boolean" required="false" default="true"
			hint="beautify to/from">
		<cfargument name="orderby" type="string" default="date_local" required="false"
			hint="order by date_local,afrom,ato">
		<cfargument name="startrow" type="numeric" default="1" required="false"
			hint="where to start">
		<cfargument name="maxrows" type="numeric" default="0" required="false"
			hint="max number of rows to return">
		<cfargument name="uids_to_parse" type="string" default="" required="false"
			hint="a pre-filtered list of UIDs to return to the user">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_var_store = ConnectToIMAPAccountAndReturnStore(server = arguments.server,
										username = arguments.username,
										password = arguments.password,
										port = arguments.port,
										useSSL = arguments.useSSL) />

		<cfset var abegin = GetTickCount() />
		<cfset var a_var_folder = 0 />
        <cfset var q_select_messages = ReturnQueryHoldingMessages() />
		<cfset var objMessage = "" />
        <cfset var a_msgFlags = "" />
        <cfset var fp = createObject("java","javax.mail.FetchProfile") />
		<cfset var a_arr_Messages = 0 />
		<cfset var query_index = 0 />
		<cfset var msg_index = 0 />
		<cfset var a_int_flags = 0 />
		<cfset var a_bol_parse_all_messages = (Len(arguments.uids_to_parse) IS 0) />
		<cfset var a_bol_parse_msg = true />
		<cfset var a_int_uid = 0 />
		<cfset var a_bol_java_return = 0 />
		<cfset var a_str_contenttype = '' />
		<cfset var a_int_to = 0 />
		<cfset var index = 0 />
		<cfset var tmp = LogIMAPData('listing messages for ' & arguments.username & ' folder ' & arguments.foldername) />
		<cfset var a_str_hash_id = '' /> 

		<cfif NOT a_var_store.result>
			<cfreturn SetReturnStructErrorCode(stReturn, a_var_store.error) />
		</cfif>
		
		<!--- open folder in readonly mode ... --->
		<cfset a_var_folder = GetFolder(store = a_var_store.store, foldername = arguments.foldername, readwrite = false) />
		
		<cfif NOT a_var_folder.result>
			<cfreturn a_var_folder />
		</cfif>

		<cfset stReturn.MessageCount = a_var_folder.folder.getMessageCount() />
		
		<!--- use cache? --->
		<cfset a_str_hash_id = 'MESSAGE_LIST_' & Hash(arguments.server & arguments.username & arguments.password & a_var_folder.folder.getMessageCount() & a_var_folder.folder.getUIDNext() ) />
		
		<cfset a_struct_cached_conn_available = application.components.cmp_cache.CheckAndReturnStoredCacheElement(hashid = a_str_hash_id,
													update_expire_time = true) />

		<cfif a_struct_cached_conn_available.result>

			<cfset stReturn.q_select_messages = a_struct_cached_conn_available.data />
			
			<cfset LogIMAPData('Reading message list from cache: ' & arguments.username & ' folder ' & arguments.foldername) />
			
			<cfreturn SetReturnStructSuccessCode(stReturn) />
		</cfif>
		
		<cfset LogIMAPData('Contacting server for message list: ' & arguments.username & ' folder ' & arguments.foldername) />
		
		<!--- get messages --->
		<cfset a_arr_Messages = a_var_folder.folder.getMessages() />
		
		<!--- create fetch profile ... ENVELOPE, Flags, UID plus two additional fields ... --->
        <cfset fp.init() />
        <cfset fp.add(variables.fProfileItem.ENVELOPE) />
        <cfset fp.add(variables.fProfileItem.FLAGS) />
		<cfset fp.add(variables.fProfileItem.UID) />
		<cfset fp.add('X-Priority') />
		<cfset fp.add('Received') />
		<!--- <cfset fp.add('Message-ID') /> --->
		
        <cfset a_var_folder.folder.fetch(a_arr_Messages,fp) />
		
		<!--- start / end ... --->
		<cfif arguments.startrow LTE 0>
			<cfset arguments.startrow = 1 />
		</cfif>
		
		<cfif arguments.maxrows IS 0>
			<cfset arguments.maxrows = arrayLen(a_arr_Messages) />		
		</cfif>
		
		<cfset a_int_to = arguments.startrow + arguments.maxrows - 1 />
		
		<cfif a_int_to GT arrayLen(a_arr_Messages)>
			<cfset a_int_to = arrayLen(a_arr_Messages) />
		</cfif>
		
		<!--- TODO: implement sorting! ... --->
		
		
		<!--- no messages available ... --->
		<cfif a_int_to IS 0>
			<cfset stReturn.q_select_messages = q_select_messages />
		
			<cfset stReturn.runtime = (GetTickCount() - abegin) />
			<cfreturn SetReturnStructSuccessCode(stReturn) />
		</cfif>
		
		<!--- Add rows ... --->
		<cfset queryAddRow(q_select_messages, a_int_to) />
		
		<cfset index = 0 />
		
		<!--- loop through messages ... --->
		<cfloop from="#arguments.startrow#" to="#a_int_to#" step="1" index="msg_index">
		
			<!--- the real index ... not the dummy loop index ... --->
			<cfset query_index = query_index + 1 />
			
			<!--- <cfset LogIMAPData('parsing message ' & msg_index & ' of ' & a_int_to) /> --->
			
            <cfset objMessage = a_arr_Messages[msg_index] />
			<cfset a_int_uid = a_var_folder.folder.getUID(objMessage) />
			
			<!--- should we parse this message? ... either we should parse all messages or this message is in the
					list of messages to parse --->
			<cfif a_bol_parse_all_messages OR (ListFindNoCase(uids_to_parse, a_int_uid) GT 0)>
			
				<cfset ParseMessageAndSetQueryData(q = q_select_messages, MessageObject = objMessage, q_row = msg_index,
												uid_to_set = a_int_uid, foldername_to_set = arguments.foldername,
												server_to_set = arguments.server,
												beautifyfromto = true) />	
			</cfif>		
        </cfloop>
		
		<!--- insert into CACHE --->
		<cfset application.components.cmp_cache.AddOrUpdateInCacheStore(hashid = a_str_hash_id,
											datatostore = q_select_messages,
											description = arguments.username & ' @ ' & arguments.server,
											built_in_datatostore_type = 'imap_message_list' ) />
											
		<cfset stReturn.q_select_messages = q_select_messages />
		
		<cfset stReturn.runtime = (GetTickCount() - abegin) />
		
		<cfset LogIMAPData('DONE: listing messages for ' & arguments.username & ' folder ' & arguments.foldername) />
		
		<cfset a_var_folder.folder.close(true) />
		<cfset CheckCloseConnection(a_var_store) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="private" name="ParseMessageAndSetQueryData" returntype="void" output="false"
			hint="parse and set query data of a message object">
		<cfargument name="MessageObject" type="any" required="true"
			hint="the message object">
		<cfargument name="q" type="query" required="true"
			hint="the query object">
		<cfargument name="q_row" type="numeric" required="true"
			hint="the row number to set">
		<cfargument name="beautifyfromto" type="boolean" default="false">
		<cfargument name="uid_to_set" type="numeric" required="true"
			hint="UID of message">
		<cfargument name="foldername_to_set" type="string" required="true"
			hint="foldername of message">
		<cfargument name="server_to_set" type="string" required="true"
			hint="server/account name to set">
		<cfargument name="loadfulldetails" type="boolean" default="false" required="false"
			hint="load data like message-id?">
		<cfargument name="q_headers" type="query" required="false"
			hint="query holding header data ... (optional)">
		
		<cfset var objMessage = arguments.MessageObject />
		<cfset var query_index = arguments.q_row />
		<cfset var q_select_messages = arguments.q />
		<cfset var a_headers = 0 />
		<cfset var a_msgFrom = objMessage.getFrom() />
		<cfset var a_msgTo = 0 />
		<cfset var a_msgFlags = 0 />
		<cfset var a_str_headers = '' />
		<cfset var a_int_utc_diff = 0 />
		<cfset var a_int_uid = 0 />
		<cfset var a_dt_local = 0 />
		<cfset var a_str_contenttype = '' />
		<cfset var a_str_from = '' />
		<cfset var header = 0 />
		<cfset var a_str_header_feld = '' />
		<cfset var a_str_header_value = '' />
		<cfset var tmp = false />
		<cfset var content = '' />
		<cfset var a_int_flags = 0 />
		<cfset var a_bol_java_return = 0 />
		
        <cfif NOT IsDefined("a_msgFrom")>
            <cfset a_msgFrom = ArrayNew(1) />
		<cfelse>
			<cfset a_str_from = a_msgFrom[1].getPersonal() & ' <' & a_msgFrom[1].getAddress() &  '>' />
        </cfif>
					
        <cfset a_msgTo = objMessage.getRecipients(variables.objRecipientType.TO) />

        <cfif NOT IsDefined("a_msgTo")>
            <cfset a_msgTo = ArrayNew(1) />
        </cfif>
		
		<!--- TODO: solve using giving usersettings or a custom property to this function ... e.g. paramter (struct) containting this setting! ... --->
		<!--- <cfif StructKeyExists(request, 'stUserSettings')>
			<cfset a_int_utc_diff = request.stUserSettings.utcdiffonly />
		</cfif> --->
		
        <cfset a_msgFlags = objMessage.getFlags().getSystemFlags() />
		<cfset a_int_uid = arguments.uid_to_set />
		
		<cftry>
			<cfset a_dt_local = DateAdd('h', 0, objMessage.getReceivedDate()) />
		<cfcatch type="any">
			<cfset a_dt_local = DateAdd('h', 0, objMessage.getSentDate()) />
		</cfcatch>	
		</cftry>
		<cfset a_str_contenttype = GetSimpleContentType(objMessage.getContentType()) />
		
		<cfset querySetCell(q_select_messages,"id", a_int_uid, query_index) />
		<cfset querySetCell(q_select_messages,"date_local", a_dt_local, query_index) />
		<cfset querySetCell(q_select_messages,"dt_local_number", DateFormat(a_dt_local, 'yyyymmdd'), query_index) />
		
		<!--- beautify to/from ... --->
		<cfif arguments.beautifyfromto>
		
			<!--- try to get personal string ... --->
			<cftry>
			<cfset a_bol_java_return = a_msgFrom[1].getPersonal() />
			<cfcatch type="any"></cfcatch></cftry>
			
			<cftry>
			<cfif IsDefined('a_bol_java_return')>
				<cfset querySetCell(q_select_messages, "afrom", a_bol_java_return, query_index) />
			<cfelse>
				<cfset querySetCell(q_select_messages, "afrom", a_str_from, query_index) />
			</cfif>
			<cfcatch type="any">
				<cfset querySetCell(q_select_messages, "afrom", a_str_from, query_index) />
			</cfcatch>
			</cftry>
			
			<!--- try to get personal string ... --->
			<cftry>
			<cfset a_bol_java_return = a_msgTo[1].getPersonal() />
			<cfcatch type="any"></cfcatch></cftry>
			
			<cftry>
			<cfif IsDefined('a_bol_java_return')>
				<cfset querySetCell(q_select_messages, "ato", a_bol_java_return, query_index) />
			<cfelse>
				<cfset querySetCell(q_select_messages, "ato", arrayToList(a_msgTo), query_index) />
			</cfif>
			<cfcatch type="any">
				<cfset querySetCell(q_select_messages, "ato", arrayToList(a_msgTo), query_index) />
			</cfcatch>
			</cftry>
			
		
		<cfelse>
			<cfset querySetCell(q_select_messages, "afrom", a_str_from, query_index) />
			<cfset querySetCell(q_select_messages, "ato", arrayToList(a_msgTo), query_index) />
		</cfif>
		
		<!--- <cfif arguments.beautifyfromto>
			<cfset querySetCell(q_select_messages, "afrom", BeautifyAddress(a_str_from), index) />
			<cfset querySetCell(q_select_messages, "ato", BeautifyAddress(arrayToList(a_msgTo)), index) />
		</cfif> --->
		
		<cfset querySetCell(q_select_messages, "asize", objMessage.getSize(), query_index) />
		<cfset querySetCell(q_select_messages, "subject", objMessage.getSubject(), query_index) />
		
		<cfif ArrayLen(a_msgFrom) GT 0>
			<cfset querySetCell(q_select_messages, "afromemailaddressonly", a_msgFrom[1].getAddress(), query_index) />
		</cfif>
		
		<cfset querySetCell(q_select_messages, "foldername", arguments.foldername_to_set, query_index) />
		<cfset querySetCell(q_select_messages, "contenttype", a_str_contenttype, query_index) />
		
		
		<!--- changes:
		
			ignore
			- asender
			- cc
			- encoding
			- bcc
			- messageid
			
			always set account to hostname --->
		
		<!--- generate the primary key ... --->
		<cfset QuerySetCell(q_select_messages, 'account', arguments.server_to_set, query_index) />
		<cfset QuerySetCell(q_select_messages, 'prim_key', a_int_uid & '_' & arguments.foldername_to_set, query_index) />
		<cfset QuerySetCell(q_select_messages, 'message_age_days', DateDiff('d', a_dt_local, Now()), query_index) />
		
		<!--- <cfset QuerySetCell(q_select_messages, 'messageid', objmessage.getHeader("Message-ID").toString(), index) /> --->
		
		<!--- handling of flags ... --->
		<cfset querySetCell(q_select_messages, "answered", 0, query_index) />
		<cfset querySetCell(q_select_messages, "flagged", 0, query_index) />
		<cfset querySetCell(q_select_messages, "unread", 1, query_index) />
		
		<cftry>
		<cfloop from="1" to="#arrayLen(a_msgFlags)#" step="1" index="a_int_flags">
			<cfif a_msgFlags[a_int_flags] IS variables.objFlag.ANSWERED>
				<cfset querySetCell(q_select_messages, "answered", 1, query_index) />
			<cfelseif a_msgFlags[a_int_flags] IS variables.objFlag.FLAGGED>
				<cfset querySetCell(q_select_messages, "flagged", 1, query_index) />
			<cfelseif a_msgFlags[a_int_flags] IS variables.objFlag.SEEN>
				<cfset querySetCell(q_select_messages, "unread", 0, query_index) />
			</cfif>
		</cfloop>
		<cfcatch type="any"></cfcatch></cftry>
		
		<!--- attachments ... --->
		<cfset QuerySetCell(q_select_messages, 'attachments', ReturnZeroOneOnTrueFalse(AttachmentsAvailable(a_str_contenttype)), query_index) />
		
		<cfset a_bol_java_return = objMessage.getHeader('X-Priority') />
			
		<cfif IsDefined('a_bol_java_return')>
				<cfset QuerySetCell(q_select_messages, 'priority', Val(a_bol_java_return[1]), query_index) />
		<cfelse>
			<cfset QuerySetCell(q_select_messages, 'priority', 3, query_index) />
		</cfif>
			
		<!--- load full data of msg? ... --->
		<cfif arguments.loadfulldetails>
			
			<cfset a_headers = objMessage.getAllHeaders() />
			
			<cfloop condition="#a_headers.hasMoreElements()#">
				<cfset header = a_headers.nextElement() />
				<cfset a_str_header_feld = header.getName() />
				<cfset a_str_header_value = header.getValue() />
				<cfset a_str_headers = a_str_headers & a_str_header_feld & ': ' & a_str_header_value & Chr(13) & Chr(10) />
				
				<cfif StructKeyExists(arguments, 'q_headers')>
					<cfset QueryAddRow(arguments.q_headers, 1) />
					<cfset QuerySetCell(arguments.q_headers, 'feld', a_str_header_feld, arguments.q_headers.recordcount) />
					<cfset QuerySetCell(arguments.q_headers, 'wert', a_str_header_value, arguments.q_headers.recordcount) />
				</cfif>
			</cfloop>
			
			<cfset QuerySetCell(q_select_messages, 'messageid', objMessage.getMessageID(), query_index) />
			<cfset QuerySetCell(q_select_messages, 'fullheader', Trim(a_str_headers), query_index) />

			<!--- is text/ ... content ... --->
			<cfif objMessage.isMimeType("text/*")>
				<cfset content = objMessage.getContent() />
				<cfset QuerySetCell(q_select_messages, 'body', content, query_index) />
			</cfif>
			
		<cfelse>
			<cfset QuerySetCell(q_select_messages, 'fullheader', '', query_index) />
		</cfif>
		
	
	</cffunction>
	
	<cffunction access="private" name="ReturnQueryHoldingMessages" returntype="query" output="false"
			hint="return a CF query holding data of messages">
			
		<cfset var a_str_cols = 'account,afrom,afromemailaddressonly,answered,asize,ato,attachments,bcc,body,body_html,cc,contenttype,date_local,dt_local_number,encoding,flagged,foldername,fullheader,id,messageid,message_age_days,prim_key,priority,replyto,subject,unread' />
	    <cfset var a_str_ColumnTypes = "varchar,varchar,varchar,integer,integer,varchar,integer,varchar,varchar,varchar,varchar,varchar,date,varchar,varchar,varchar,varchar,varchar,integer,varchar,integer,varchar,integer,varchar,varchar,integer" />
        <cfset var q_select_messages = QueryNew(a_str_cols,a_str_ColumnTypes) />
		
		<cfreturn q_select_messages />		
	</cffunction>
	
	<cffunction access="public" name="LoadMessage" output="false" returntype="struct"
			hint="load a message">
		<cfargument name="server" type="string" required="yes"
			hint="server name">
		<cfargument name="username" type="string" required="yes"
			hint="username for imap server">
		<cfargument name="password" type="string" required="yes"
			hint="password for imap server">
		<cfargument name="port" type="numeric" required="false" default="143"
			hint="port">
		<cfargument name="useSSL" type="boolean" default="false"
			hint="use encrypted connection">
		<cfargument name="foldername" type="string" required="true"
			hint="name of folder (full foldername, e.g. INBOX.Sent)">
		<cfargument name="uid" type="string" required="true"
			hint="UID of message">
		<cfargument name="setseen" type="boolean" required="false" default="false"
			hint="set status to seen if unseen">
		<cfargument name="tempdir" type="string" required="true"
			hint="where to store temporary files">
		<cfargument name="storecontenttypes" type="string" default="" required="false"
			hint="list of attachted to store automatically, if * store everything">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_var_store = ConnectToIMAPAccountAndReturnStore(server = arguments.server,
										username = arguments.username,
										password = arguments.password,
										port = arguments.port,
										useSSL = arguments.useSSL) />
		<cfset var a_var_folder = 0 />
		<cfset var a_bol_read_write = false />
		<cfset var objMessage = 0 />
		<cfset var tmp = false />
		<cfset var q_select_message = ReturnQueryHoldingMessages() />
		<cfset var q_select_headers = QueryNew('feld,wert', 'varchar,varchar') />
		<cfset var q_select_attachments = QueryNew('afilename,asize,charset,cid,contentid,contentlanguage,contenttype,encoding,fullheader,tempfilename,simplecontentid,filenamelen',
													'varchar,integer,varchar,Double,Double,varchar,varchar,varchar,varchar,varchar,Integer,Integer') />
		
		<!--- error, exit --->
		<cfif NOT a_var_store.result>
			<cfreturn SetReturnStructErrorCode(stReturn, a_var_store.error) />
		</cfif>
		
		<cfset a_var_folder = GetFolder(store = a_var_store.store, foldername = arguments.foldername, readwrite = a_bol_read_write) />
		
		<cfset objMessage = a_var_folder.folder.getMessageByUID(arguments.uid) />
		
		<!--- message not found? ... --->
		<cfif NOT IsDefined('objMessage')>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfset QueryAddRow(q_select_message, 1) />
		
		<cfset ParseMessageAndSetQueryData(q = q_select_message, MessageObject = objMessage, q_row = 1,
											q_headers = q_select_headers,
											uid_to_set = arguments.uid,
											foldername_to_set = arguments.foldername,
											server_to_set = arguments.server,
											loadfulldetails = true) />
		

		
		<cfset msgTxtBody = '' />
		<cfset msgbody = '' />
		
		<cfif (objMessage.isMimeType("text/*") AND NOT objMessage.isMimeType("text/rfc822-headers")) OR isSimpleValue(objMessage.getContent())>
            <!--- it is NOT a multipart message --->
            <cfset encoding = objMessage.getEncoding()>
            <!--- look for quoted-printable --->
            <cfset content = objMessage.getContent()>
            <cfset parts[1][1] = content>
            <cfif refindnocase("<html[0-9a-zA-Z= ""/:.]*>", content)>
                <cfset parts[1][2] = 2>
            <cfelse>
                <cfset parts[1][2] = 1>
            </cfif>        
        <cfelse>
            <cfset getPartsResult = getParts(objMessage)>
            <cfset parts = getPartsResult.parts>
            <cfset msgAttachments = getPartsResult.attachments>
			
			<cfset stReturn.getPartsResult = getPartsResult>
			
			<!--- compile the parts --->
        <!--- are there any HTML parts? --->
        <cfloop from="1" to="#arraylen(parts)#" index="i">
            <cfif parts[i][2] is 2>
                <cfset msgIsHtml = true>
            </cfif>
        </cfloop>
        <!--- compile the message body --->
        <cfloop from="1" to="#arraylen(parts)#" index="i">
            <cfif parts[i][2] is 2>
                <!--- only add HTML parts to the body --->
                <cfset msgBody = msgBody & parts[i][1]>
                <cfif arraylen(parts) gt i>
                    <cfset msgBody = msgBody & "<hr />" />
                </cfif>
            <cfelse>
                <!--- only add text parts to txtBody --->
                <cfset msgTxtBody = msgTxtBody & htmlEditFormat(parts[i][1])>
            </cfif>
        </cfloop>
        </cfif>

		
		<cfset a_var_folder.folder.close(true) />
		<cfset CheckCloseConnection(a_var_store) />
		
		<cfset QuerySetCell( q_select_message, 'body', msgTxtBody ) />
		<cfset QuerySetCell( q_select_message, 'body_html', msgBody ) />		
		
		<cfset stReturn.q_select_message = q_select_message />
		<cfset stReturn.q_select_headers = q_select_headers />
		<cfset stReturn.q_select_attachments = q_select_attachments />
		
		<cfset stReturn.msgTxtBody = msgTxtBody />
		<cfset stReturn.msgBody = msgBody />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>
	
	<cffunction name="getParts" access="private" output="false" returnType="struct"
        hint="Get the parts of a message.">
        <cfargument name="objMultipart" type="any" required="yes">

        <cfset var retVal = structNew()>    
        <cfset var messageParts = objMultipart.getContent()>
        <cfset var i = 0>
        <cfset var j = 0>
        <cfset var partIndex = 0>
        <cfset var thisPart = "">
        <cfset var disposition = "">
        <cfset var contentType = "">
        <cfset var fo = "">
        <cfset var fso = "">
        <cfset var in = "">
        <cfset var tempFile = "">
        
        <cfset retVal.parts = ArrayNew(2)>
        <cfset retVal.attachments = "">
        

        <!--- get all the parts and put it into an array --->
        <!--- [1] = content, [2] = type --->
        <!--- type, 1=text, 2=html, 3=attachment --->
        <cfloop from="0" to="#messageParts.getCount() - 1#" index="i">
            <cfset partIndex = arraylen(retVal.parts) + 1>
            <cfset thisPart = messageParts.getBodyPart(javacast("int", i))>
            <!--- show all attachments as such --->
            <cfif len(thisPart.getFileName())>
                <cfset retVal.attachments = listappend(retVal.attachments, thisPart.getFileName(),chr(1))>
            </cfif>

            <cfif thisPart.isMimeType("multipart/*")>
                <cfset recurseResults = getParts(thisPart)>
                <cfset retVal.parts = push(retVal.parts, recurseResults.parts)>
                <cfset retVal.attachments = listAppend(retVal.attachments, recurseResults.attachments,chr(1))>
            <cfelse>
                <cfset disposition = thisPart.getDisposition()>
                <cfif not isdefined("disposition")> <!--- is javacast("null", "")> --->
                    <cfset contentType = thisPart.getContentType().toString()>
                    <cfif findNoCase("text/plain",contentType) is 1>
                        <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                        <cfset retVal.parts[partIndex][2] = "1">
                    <cfelseif findNoCase("text/html",contentType) is 1>
                        <!--- This shouldnt happen, at least i dont think --->
                        <!--- note, this should never happen because disposition WILL be defined for HTML parts --->
                        <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                        <cfset retVal.parts[partIndex][2] = "2">
                    <cfelse>
                        <!--- <cfdump var="other">
                        <cfset retVal.parts[i + 1][1] = "Other Content Type:" & contentType.toString() & "<br />" & part.getContent()>
                        <cfset retVal.parts[i + 1][2] = "3"> --->
                        <cfset fo = createObject("Java", "java.io.File")>
                        <cfset fso = createObject("Java", "java.io.FileOutputStream")>
                        <cfset in = thisPart.getInputStream()>
                        <cfset tempFile = getTempDirectory() & session.SessionID>
                        <cfset fo.init(tempFile)>
                        <cfset fso.init(fo)>
                        <cfset j = in.read(variables.byteArray)>
                        <cfloop condition="not(j is -1)">
                            <cfset fso.write(variables.byteArray, 0, j)>
                            <cfset j = in.read(variables.byteArray)>
                        </cfloop>
                        <cfset fso.close()>

                        <cffile action="READ" file="#tempFile#" variable="fileContents">
                        <cffile action="DELETE" file="#tempFile#">
                        <cfif findnocase("text/html", fileContents)>
                            <cfset theText = right(fileContents, len(fileContents) - refindnocase("\r\n\r\n", fileContents, findnocase("text/html", fileContents)))>
                            <cfif refind("--+=\S+--", theText)>
                                <cfset theText = left(theText, refind("--+=\S+--", theText) -1)>
                            </cfif>
                            <cfset retVal.parts[partIndex][1] = theText> <!--- replace(theText, "=20#chr(13)#", "~", "ALL")> --->
                            <cfset retVal.parts[partIndex][2] = "2">
                        <cfelse>
                            <cfset retVal.parts[partIndex][1] = fileContents>
                            <cfset retVal.parts[partIndex][2] = "3">
                            <!--- <cfdump var="#thisPart.getContentType()#  name='#thisPart.getFileName()#' #fileContents#"> --->
                        </cfif>
                    </cfif>
                <cfelseif variables.showTextHtmlAttachmentsInline>
                    <!--- 
                        inline attachments... we already put the filename in
                        the attachments list above, if there was one.  The
                        purpose of this section is to put inline text and HTML
                        attachments INLINE.  I'm personally against this, so
                        I added a "show text and html attachments inline" option.
                    --->
                    <cfif disposition.equalsIgnoreCase(thisPart.INLINE)>
                        <cfset contentType = thisPart.getContentType().toString()>
                        <cfif findNoCase("text/plain",contentType)>
                            <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                            <cfset retVal.parts[partIndex][2] = "1">
                        <cfelseif findNoCase("text/html",contentType)>
                            <!--- This shouldnt happen, at least i dont think --->
                            <cfset retVal.parts[partIndex][1] = thisPart.getContent()>
                            <cfset retVal.parts[partIndex][2] = "2">
                        <cfelse>
                            <!--- can't do inline attachments right now --->
                        </cfif>
                    <cfelse>
                        <!--- <cfset body = body & "<p>Other: " & disposition & "</p>"> --->
                    </cfif>
                <cfelse>
                    <!--- 
                        disposition is set, so it's an attachment,
                        but we're not putting *ANY* attachments inline
                        so don't do anything here
                    --->
                </cfif>
            </cfif>
        </cfloop>
        <cfreturn retVal>
    </cffunction>

    <cffunction name="push" access="private" output="yes"
        hint="Add a new item to the end of an array.">
        <cfargument name="stack" type="array" required="yes">
        <cfargument name="value" required="Yes" type="any">

        <cfset var retVal = arguments.stack>
        <cfset var i = 1>
        
        <cfif isArray(arguments.value)>
            <cfloop from="1" to="#arrayLen(arguments.value)#" step="1" index="i">
                <cfset arrayAppend(retVal, arguments.value[i])>
            </cfloop>
            <cfreturn retVal>
        <cfelse>
            <cfset arrayAppend(retVal, arguments.value)>
            <cfreturn retVal>
        </cfif>
    </cffunction>

    <cffunction name="pop" access="private" output="yes"
        hint="Remove the last item from an array.">
        <cfargument name="stack" type="array" required="yes">

        <cfset var retVal = stack>
        
        <cfif arraylen(retVal) gt 0>
            <cfset arraydeleteat(retVal, arraylen(retVal))>
        </cfif>
        <cfreturn retVal>
    </cffunction>

</cfcomponent>