<!--- //

	Component:	Mailspeed (Email)
	Description:Add folders of an user to mailspeed table
				Or remove them
	

// --->

<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	
	<!--- true = yes, false = unsync --->
	<cffunction access="public" name="GetFolderSyncStatus" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="foldername" type="string" required="yes">
		
		<cfset var q_select_speedmail_folder_sync_status = 0 />
		
		<cfinclude template="queries/q_select_speedmail_folder_sync_status.cfm">
		
		<cfreturn (q_select_speedmail_folder_sync_status.recordcount IS 1) AND (q_select_speedmail_folder_sync_status.syncstatus IS 1) />
	</cffunction>

	<cffunction access="public" name="AddFolderToWatch" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="foldername" type="string" required="yes">
		<cfargument name="userid" type="numeric" required="yes">
		<!--- force this folder to add ... --->
		<cfargument name="forceadd" type="boolean" required="no" default="false">
		
		<cfset var a_str_userkey = '' />
		<cfset var q_select_speedmail_folders_count = 0 />
		<cfset var q_select_speedmail_folder_exists = 0 />
		<cfset var q_select_speedmail_userdata = 0 />
		<cfset var a_bol_return = false />
		
		<!--- select total folder count ... if no folder exists yet in the database, add all folders and exit --->
		<cfinclude template="queries/q_select_speedmail_folders_count.cfm">
		
		<cfif (q_select_speedmail_folders_count.count_id IS 0) AND (forceadd IS false)>
			<!--- abort and add all folders ... --->
			<cfset a_str_userkey = application.components.cmp_user.GetEntrykeyFromUsername(arguments.username) />
			
			<!--- add all folders --->
			<cfset a_bol_return =  AddAllFoldersOfUserToWatch(userkey = a_str_userkey) />
			
			<cfreturn a_bol_return />
		</cfif>
		
		<!--- check if entry exists --->
		<cfinclude template="queries/q_select_speedmail_folder_exists.cfm">
		
		<cfif q_select_speedmail_folder_exists.count_id IS 1>
			<!--- already exists --->
			<cfreturn false />
		</cfif>
		
		<!--- select user data --->
		<cfinclude template="queries/q_select_speedmail_userdata.cfm">
		
		<cfif q_select_speedmail_userdata.recordcount IS 0>
			<cfreturn false />
		</cfif>
		
		<!--- insert --->
		<cfinclude template="queries/q_insert_speedmail_folder_data.cfm">
		
		<cfreturn true />
	
	</cffunction>
	
	<cffunction access="public" name="AddAllFoldersOfUserToWatch" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="yes">
		
		<cfset var a_int_userid = 0 />
		<cfset var q_select_folders = 0 />
		
		<cfset var stReturn = 0 />
		<cfset var a_struct_settings = 0 />
		<cfset var a_struct_imap_access_data = 0 />
		<cfset var a_struct_load_userdata = 0 />
		<cfset var a_struct_load_folders = 0 />
		
		<cfif Len(arguments.userkey) IS 0>
			<cfreturn false />
		</cfif>
		
		<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
		<cfinvokeargument name="userkey" value="#arguments.userkey#">
		</cfinvoke>
	
		<cfset variables.a_struct_ms_securitycontext = stReturn>
	
		<cfinvoke component="#request.a_str_component_users#" method="GetUsersettings" returnvariable="a_struct_settings">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
		</cfinvoke>
	
		<cfset variables.a_struct_ms_usersettings = a_struct_settings>
	
		
		<!--- load all folders of this user ... --->
		<cfinvoke component="#application.components.cmp_email_accounts#" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
		</cfinvoke>
				
		<cfif StructCount(a_struct_imap_access_data) IS 0>
			<cfreturn false />
		</cfif>
		
		<!--- load user data ... --->
		<cfinvoke component="#application.components.cmp_load_user_data#" method="LoadUserData" returnvariable="a_struct_load_userdata">
			<cfinvokeargument name="entrykey" value="#arguments.userkey#">
		</cfinvoke>
		
		<cfif NOT StructKeyExists(a_struct_load_userdata, 'query')>
			<cfreturn false />
		</cfif>
		
		<cfset a_int_userid = a_struct_load_userdata.query.userid>
		
		<!--- load all foldes ... --->				
		<cfinvoke component="#application.components.cmp_email#" method="loadfolders" returnvariable="a_struct_load_folders">
			<cfinvokeargument name="securitycontext" value="#a_struct_ms_securitycontext#">
			<cfinvokeargument name="usersettings" value="#a_struct_ms_usersettings#">
			<cfinvokeargument name="accessdata" value="#a_struct_ms_securitycontext.a_struct_imap_access_data#">
			<cfinvokeargument name="forceimap" value="true">
			<!--- we need to delete all OLD folders ... --->
		</cfinvoke>
		
		
		<cfif NOT StructKeyExists(a_struct_load_folders, 'query')>
			<cfreturn false />
		</cfif>
		
		<cfset q_select_folders = a_struct_load_folders.query>	
			
		<!--- call the AddFolderToWatch method ... --->
		<cfloop query="q_select_folders">

			<cfset AddFolderToWatch(username = lcase(a_struct_imap_access_data.a_str_imap_username), foldername = q_select_folders.fullfoldername, userid = a_int_userid, forceadd = true)>

		</cfloop>
		
		
		<cfreturn true />	
	</cffunction>

</cfcomponent>

