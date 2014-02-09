<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!--- return rfc/822 email --->
	<cffunction access="remote" name="GetRawMessageContent" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="foldername" type="string" required="yes">
		<cfargument name="id" type="numeric" default="0" required="yes">

		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfset arguments.id = val(arguments.id)>
		<cfset arguments.id = ReplaceNoCase(arguments.id, '.0', '')>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="GetFolders" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
			<cfinvokeargument name="userkey" value="#application.directaccess.securitycontext[arguments.clientkey].myuserkey#">
		</cfinvoke>
		
		  <cfinvoke component="#application.components.cmp_email#" method="loadfolders" returnvariable="a_struct_result_folders">
			<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey].stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#application.directaccess.securitycontext[arguments.clientkey].stUserSettings#">
			<cfinvokeargument name="accessdata" value="#application.directaccess.securitycontext[arguments.clientkey].stSecurityContext.a_struct_imap_access_data#">
		  </cfinvoke>
		  
		  <cfif NOT StructKeyExists(a_struct_result_folders, 'query')>
		  	<cfset a_arr_return[1] = 500>
			<cfset a_arr_return[2] = 'no folders exist'>
			
			<cfreturn a_arr_return>
		  </cfif>
		  
		 <cfset q_select_folders = a_struct_result_folders.query>
		 
		 	<cfquery name="q_select_folders" dbtype="query">
		 	SELECT
		 		*
			FROM
				q_select_folders
			ORDER BY
				fullfoldername
			;
		 	</cfquery>		 
		
		<cfset a_arr_return[3] = ToString(QueryToXMLData(q_select_folders))>		
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="GetFolderContent" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="foldername" type="string" required="yes">
		<cfargument name="orderby" type="string" required="yes">
		<cfargument name="maxrows" type="numeric" default="200" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
			<cfinvokeargument name="userkey" value="#application.directaccess.securitycontext[arguments.clientkey].myuserkey#">
		</cfinvoke>
		
	<!---	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="loadheades" type="html">
			<cfdump var="#arguments#">
		</cfmail>--->
		
		<cfinvoke component="#application.components.cmp_email#"	method="ListMessages"
			returnvariable="a_return_struct">
			<cfinvokeargument name="accessdata" value="#a_struct_imap_access_data#">
			<cfinvokeargument name="foldername" value="#arguments.foldername#">
			<cfinvokeargument name="beautifyfromto" value="true">
			<cfinvokeargument name="loadpreview" value="0">
		</cfinvoke>
		
		<cfif NOT StructKeyExists(a_return_struct, 'query')>
			<cfset a_arr_return[1] = 500>
			<cfset a_arr_return[2] = 'Folder does not exist'>
			<cfreturn a_arr_return>
		</cfif>
		
		<cfset q_select_mailbox = a_return_struct.query>
		
		<cfquery name="q_select_mailbox" dbtype="query">
		SELECT
			subject,date_local,id,afrom,ato,flagged,foldername
		FROM
			q_select_mailbox
		ORDER BY
			date_local DESC
		;
		</cfquery>	
		
		<cfset a_arr_return[3] = ToString(QueryToXMLData(q_select_mailbox))>		
		<!--- build xml file with foldercontent --->
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<cffunction access="remote" name="GetMessage" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="foldername" type="string" required="yes">
		<cfargument name="id" type="numeric" default="0" required="yes">

		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfset arguments.id = val(arguments.id)>
		<cfset arguments.id = ReplaceNoCase(arguments.id, '.0', '')>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
			<cfinvokeargument name="userkey" value="#application.directaccess.securitycontext[arguments.clientkey].myuserkey#">
		</cfinvoke>		
		
		<cfinvoke component="/components/email/cmp_loadmsg" method="LoadMessage" returnvariable="stReturn_load_msg">
			<cfinvokeargument name="server" value="#a_struct_imap_access_data.a_str_imap_host#">
			<cfinvokeargument name="username" value="#a_struct_imap_access_data.a_str_imap_username#">
			<cfinvokeargument name="password" value="#a_struct_imap_access_data.a_str_imap_password#">
			<cfinvokeargument name="foldername" value="#arguments.foldername#">
			<cfinvokeargument name="uid" value="#arguments.id#">
			<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
		</cfinvoke>
				
		<cfif NOT StructKeyExists(stReturn_load_msg, 'query')>
			<cfset a_arr_return[1] = 500>
			<cfset a_arr_return[2] = 'Message does not exist'>
			<cfreturn a_arr_return>
		</cfif>		
		
		<cfset q_select_message = stReturn_load_msg.query>
		<cfset q_select_attachments = stReturn_load_msg.attachments_query>		
		
		<!--- the message itself --->
		<cfset a_arr_return[3] = ToString(QueryToXMLData(q_select_message))>	

		<!--- attachments --->
		<cfset a_arr_return[4] = ToString(QueryToXMLData(q_select_attachments))>	
		
		<cfreturn a_arr_return>
	</cffunction>
	
	<!--- load the specified attachment --->
	<cffunction access="remote" name="LoadAttachment" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="foldername" type="string" required="yes">
		<cfargument name="id" type="numeric" default="0" required="yes">
		<cfargument name="contentid" type="string" default="0" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfreturn a_arr_return>
		
	</cffunction>
	
	
	<cffunction name="ComposeMail" access="remote" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="yes">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="senderaddress" type="string" required="no" default="">
		<cfargument name="toaddresses" type="string" required="yes">
		<cfargument name="ccaddresses" type="string" default="" required="no">
		<cfargument name="subject" type="string" required="no" default="">
		<cfargument name="body" type="string" required="yes" default="">
		<cfargument name="format" type="string" required="no" default="text">
		<cfargument name="priority" type="numeric" default="3" required="no">
		<cfargument name="fileuploadkeys" type="string" default="" required="no">
		<cfargument name="sendimmediately" type="boolean" default="false" required="no">
		<!--- current parameters:
		
			dontsavemessage
			
			...
			
			--->
		<cfargument name="parameter" type="string" default="" required="no">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="compose message debug output" type="html">
			<cfdump var="#arguments#">
		</cfmail>		
		
		<!--- check username ... --->
		<cfset a_str_username = application.components.cmp_user.GetUsernamebyentrykey(entrykey = application.directaccess.securitycontext[arguments.clientkey].myuserkey)>
		
		<!--- load imap access data ... --->
		<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
			<cfinvokeargument name="userkey" value="#application.directaccess.securitycontext[arguments.clientkey].myuserkey#">
		</cfinvoke>
		
		<!--- check attachments ... --->
		<cfif Len(arguments.fileuploadkeys) GT 0>
			<cfinclude template="queries/q_select_attachments.cfm">
			
			<cfif q_select_attachments.recordcount GT 0>
				<!--- ok, create query and so on ... --->
				<cfset variables.q_virtual_attachments = QueryNew('location,afilename,contenttype')>
				
				<cfoutput query="q_select_attachments">
				
						<cfset a_str_att_filename = request.a_str_temp_directory & request.a_str_dir_separator & q_select_attachments.entrykey>
						
						<cfif FileExists(a_str_att_filename)>
							<cfset tmp = QueryAddRow(variables.q_virtual_attachments, 1)>
							<cfset QuerySetCell(variables.q_virtual_attachments, 'afilename', q_select_attachments.filename, variables.q_virtual_attachments.recordcount)>
							<cfset QuerySetCell(variables.q_virtual_attachments, 'location', a_str_att_filename, variables.q_virtual_attachments.recordcount)>
							<cfset QuerySetCell(variables.q_virtual_attachments, 'contenttype', q_select_attachments.contenttype, variables.q_virtual_attachments.recordcount)>
						</cfif>
					
				</cfoutput>
				
			</cfif>
			
		</cfif>
		
		<!--- save mail and open draft window ... --->
		<cfinvoke component="/components/email/cmp_message" method="createmessage" returnvariable="stReturn">
			<cfinvokeargument name="subject" value="#arguments.subject#">
			
			<cfif Len(arguments.senderaddress) IS 0>
				<cfinvokeargument name="from" value="#a_str_username#">
			<cfelse>
				<cfinvokeargument name="from" value="#arguments.senderaddress#">
			</cfif>
			
			<cfinvokeargument name="cc" value="#arguments.ccaddresses#">
			<cfinvokeargument name="bcc" value="">
			<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
			<cfinvokeargument name="body" value="#arguments.body#">
			<cfinvokeargument name="to" value="#arguments.toaddresses#">
			<cfinvokeargument name="format" value="text">
			<!---<cfinvokeargument name="addheaders" value="#a_arr_addheaders#">--->
			
			<cfif StructKeyExists(variables, 'q_virtual_attachments')>
				<!--- include attachments ... --->
				<cfinvokeargument name="q_virtual_attachments" value="#variables.q_virtual_attachments#">
			</cfif>	
		</cfinvoke>		
		
		<cfset a_str_written_filename = stReturn.filename>
		<cfset a_str_msgid = stReturn.messageid>	
				
		<cfif arguments.sendimmediately>
			<cfset a_str_foldername = 'INBOX.Sent'>		
		<cfelse>
			<cfset a_str_foldername = 'INBOX.Drafts'>
		</cfif>
		
		<!--- save email now ... --->
		<cfinvoke component="#application.components.cmp_email#"
			method="AddMailToFolder" returnvariable="a_struct_add_mail_return">
			<cfinvokeargument name="server" value="#a_struct_imap_access_data.a_str_imap_host#">
			<cfinvokeargument name="username" value="#a_struct_imap_access_data.a_str_imap_username#">
			<cfinvokeargument name="password" value="#a_struct_imap_access_data.a_str_imap_password#">
			<cfinvokeargument name="sourcefile" value="#a_str_written_filename#">
			<!--- draft or sent ... --->
			<cfinvokeargument name="destinationfolder" value="#a_str_foldername#">
			<cfinvokeargument name="returnuid" value="true">
			<cfinvokeargument name="ibccheaderid" value="#a_str_msgid#">	
		</cfinvoke>		
		
		<!--- create the link ... and a shortlink ... --->

		
		<cfif arguments.sendimmediately>
			<!--- send now ... --->
			<cfexecute name="/mnt/config/bin/smtp.pl" arguments="#a_str_written_filename#" timeout="120"></cfexecute>
		</cfif>
		
		<!--- compose the href --->
		<cfset a_str_href = 'https://www.openTeamWare.com/rd/da/em/c/?mailbox='&urlencodedformat(a_str_foldername)&'&id='&a_struct_add_mail_return.uid&'&clientkey='&arguments.clientkey&'&appkey='&arguments.applicationkey>
		
		<!--- create a short link ... --->
		<cfinvoke component="/components/tools/cmp_shorturl" method="CreateShortLink" returnvariable="a_str_href_shortlink">
			<cfinvokeargument name="userkey" value="">
			<cfinvokeargument name="href" value="#a_str_href#">
			<cfinvokeargument name="daysvalid" value="99">
		</cfinvoke>
		
		<!--- return the href --->
		<cfset a_arr_return[3] = a_str_href_shortlink>
		
		<cfreturn a_arr_return>		
	</cffunction>

</cfcomponent>