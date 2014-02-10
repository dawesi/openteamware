<cfsetting requesttimeout="30000">

<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
	<cfinvokeargument name="userkey" value="#arguments.userkey#">
</cfinvoke>

<cfset variables.a_str_imap_username = a_struct_imap_access_data.a_str_imap_username>
<cfset variables.a_str_imap_password = a_struct_imap_access_data.a_Str_imap_password>

<cfscript>
	obj_Properties = createObject("Java", "java.util.Properties");
	obj_Properties.init();
	obj_Properties.put("mail.store.protocol","imap");
	obj_Properties.put("mail.imap.port","143"); 
	cls_Session = createObject("Java", "javax.mail.Session");
	obj_Session = cls_Session.getInstance(obj_Properties); 
	obj_Store = createObject("Java","javax.mail.Store");
	obj_Store = obj_Session.getStore();
	obj_Store.connect(a_struct_imap_access_data.a_str_imap_host, variables.a_str_imap_username, variables.a_str_imap_password); 
</cfscript>

<cfset a_str_backup_dir = CreateUUID()>

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'email'>

<!--- create the email directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

<cfinvoke component="#application.components.cmp_email#" method="loadfolders" returnvariable="struct_result">
<cfinvokeargument name="securitycontext" value="#variables.stSecurityContext#">
<cfinvokeargument name="usersettings" value="#variables.stUserSettings#">
<cfinvokeargument name="accessdata" value="#variables.stSecurityContext.a_struct_imap_access_data#">
</cfinvoke>

<cfset variables.q_select_folders = struct_result.query>

<cfloop query="variables.q_select_folders">

	<!--- backup all folders except junkmail --->
	<cfif ListFindNoCase('INBOX.Junkmail', variables.q_select_folders.fullfoldername) IS 0>
		<cfset tmp = LogMessage('current folder: ' & variables.q_select_folders.fullfoldername)>
	
		
		<cfset a_str_current_backup_dir = a_str_backup_dir & request.a_str_dir_separator & variables.q_select_folders.fullfoldername & request.a_str_dir_separator>
		
		<!--- create the directory --->
		<cfdirectory action="create" directory="#a_str_current_backup_dir#">
		
		<!--- // load folder // --->
		
		<cfset a_bol_folder_opened = false>
		
		<cftry>
		
			<cfscript>
			obj_Folder = obj_Store.getFolder(variables.q_select_folders.fullfoldername);
			obj_Folder.open(obj_Folder.READ_ONLY); 
			// folder opened sucessfully
			a_bol_folder_opened = true;
			</cfscript>
		
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
		</cfcatch>
		</cftry>
		
		<cfif a_bol_folder_opened>
		
			<cfscript>
			ar_Messages = obj_Folder.getMessages(); 
			daFile = createObject("java", "java.io.File");
			fileIO = CreateObject("java", "java.io.FileOutputStream");	
			</cfscript>
			
			<!--- // loop through folders // --->
			
			<cfset tmp = LogMessage('messagecount: ' & ArrayLen(ar_Messages))>
			
			<cfscript>
			for(loop=1; loop LTE ArrayLen(ar_Messages); loop=loop+1)
				{
				// get the message and write it to a file
				msg = obj_Folder.getMessageByUID(obj_Folder.getUID(ar_Messages[loop]));
				
				a_str_uid = obj_Folder.getUID(ar_Messages[loop]);
				// a_str_subject = ar_Messages[loop].getSubject();
				
				daFile.init(JavaCast("string", a_str_current_backup_dir & a_str_uid & '.eml'));
				fileIO.init(daFile);
			
				msg.writeTo(fileIO);	
				
				fileIO.close();
				
				// Get the to addresses
				
				/*
				cls_RecipientType = CreateObject("Java", "javax.mail.Message$RecipientType");
				ar_To = ar_Messages[loop].getRecipients(cls_RecipientType.TO);
				lst_ToAddresses = arrayToList(ar_To);
				str_Subject = ar_Messages[loop].getSubject();
				
				*/
				//writeoutput('<b>'&str_Subject&'</b> '&htmleditformat(lst_ToAddresses)&'<br>');
				}
			</cfscript>
		
		</cfif>
	</cfif>
</cfloop>

<!--- // save archive // --->
<!---<cfset a_str_cmd = 'czf /var/spool/cfmx/' & request.stSecurityContext.myusername & '_email.tar.gz #a_str_backup_dir#'>--->

<!---<cfexecute name="tar" arguments="#a_str_cmd#" timeout="0"></cfexecute>--->