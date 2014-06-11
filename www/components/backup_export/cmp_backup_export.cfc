<!--- //

	Module:		Backup/Export feature	
	Action:		
	Description:	
	

// --->

<cfcomponent hint="Backup Export">
	
	<cfsetting requesttimeout="60000">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">	
	
	<cfset request.a_backup_tc_start = GetTickCount()>
		
	<cffunction access="public" name="SetLogDataVariables" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="userkey" type="string" required="no" default="">
		<cfargument name="jobkey" type="string" required="yes">
		
		<cfset request.a_str_datarep_log_companykey = arguments.companykey />
		<cfset request.a_str_datarep_log_userkey = arguments.userkey />
		<cfset request.a_str_datarep_log_jobkey = arguments.jobkey />
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="LogMessage" output="false" returntype="boolean">
		<cfargument name="msg" type="string" required="yes">
		
		<cfinclude template="queries/q_insert_log.cfm">
		
		<cfreturn true />
	</cffunction>
	
	<cffunction access="public" name="CheckCompanyBackupAccount" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfset var q_select_backup_account_exists = 0 />
		
		<!--- check if the company has an account, if there's enough free space ... --->
		<cfset var a_str_company_path = request.a_str_data_replication_path & request.a_str_dir_separator & arguments.companykey />
		
		<!--- check if a backup account exists --->
		<cfinclude template="queries/q_select_backup_account_exists.cfm">
		
		<cfif q_select_backup_account_exists.count_id IS 0>
			<cfreturn false />
		</cfif>
		
		<cfif NOT DirectoryExists(a_str_company_path)>
			<cfdirectory action="create" directory="#a_str_company_path#">
		</cfif>
				
		<cfreturn true />
	</cffunction>
	
	<!---////////////////////////////////////////////////////////////////////////////////////////////////
	
		 return the global backup directory
		 
		 //////////////////////////////////////////////////////////////////////////////////////////////// --->
	<cffunction access="public" name="GetGlobalDataReplicationDirectory" returntype="string" output="false">
		
		<cfset var a_str_global_backup_dir = request.a_str_data_replication_path & request.a_str_dir_separator>
		
		<cfif Not DirectoryExists(a_str_global_backup_dir)>
			<cfdirectory action="create" directory="#a_str_global_backup_dir#">
		</cfif>	
		
		<cfreturn a_str_global_backup_dir />
	</cffunction>
	
	<!--- ////////////////////////////////////////////////////////////////////////////////////////////////
	
		  load all users and backup them
		
		  //////////////////////////////////////////////////////////////////////////////////////////////// --->
	<cffunction access="public" name="BackupWholeCompany" output="false" returntype="struct">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_int_begin = GetTickCount() />
		<cfset var a_str_jobkey = CreateUUID() />
		<cfset var a_bol_ok = false />
		<cfset var a_str_backup_directory = '' />
		<cfset var a_str_replication_file = '' />
		<cfset var q_select_users = 0 />
		<cfset var tmp = false />
		<cfset var a_struct_backup_user = 0 />
		<cfset var a_int_datasize = 0 />
		<cfset var a_str_description = '' />
		<cfset var a_str_sh_script = '' />
		<cfset var a_str_sh_file = '' />
		<cfset var a_str_userkey = '' />
		<cfset var a_str_current_user_dir = '' />
		<cfset var a_str_tar_output = '' />
		
		<cfset stReturn.jobkey = a_str_jobkey />
		<cfset stReturn.result = false />
		<cfset stReturn.errorMessage = '' />		
		
		<!--- check if permission to backup and so on ... --->
		<cfset a_bol_ok = CheckCompanyBackupAccount(companykey = arguments.companykey) />
		
		<cfif NOT a_bol_ok>
			<cfset stReturn.errorMessage = 'No Data Replication Account found.' />
			<cfreturn stReturn />
		</cfif>

		<!--- the tmp directory --->		
		<cfset a_str_backup_directory = request.a_str_temp_directory_local & request.a_str_dir_separator & createuuid() & request.a_str_dir_separator />
		
		<cfset a_str_replication_file = GetGlobalDataReplicationDirectory() & request.a_str_dir_separator & arguments.companykey & request.a_str_dir_separator & a_str_jobkey & '.tar.gz' />
		<cfset stReturn.replicationfile = a_str_replication_file />
		
		<!--- create this directory --->
		<cfdirectory action="create" directory="#a_str_backup_directory#">

		<cfset stReturn.directory = a_str_backup_directory />

		<cfset stReturn.start = Now() />
		<cfset stReturn.users = StructNew() />
		
		<!--- load all users of this company ... --->
		<cfset q_select_users = application.components.cmp_customer.GetAllCompanyUsers(companykey = arguments.companykey) />
		
		<cfif q_select_users.recordcount IS 0>
			<cfset stReturn.errorMessage = 'No users exist.' />
			<cfreturn stReturn />
		</cfif>
		
		<cfset SetLogDataVariables(companykey = arguments.companykey, jobkey = a_str_jobkey) />
		
		<cfinclude template="queries/q_insert_running_job.cfm">
		
		<!--- backup now one by one ... --->
		<cfoutput query="q_select_users">
			<!--- set the logging context --->
			<cfset SetLogDataVariables(companykey = arguments.companykey, jobkey = a_str_jobkey, userkey = q_select_users.entrykey) />
			
			<!--- backup user data --->
			<cfset a_struct_backup_user = BackupUserAccountData(userkey = q_select_users['entrykey'][q_select_users.currentrow], companybackup = true, basedirectory = a_str_backup_directory) />
			
			<cfset stReturn.users[q_select_users.entrykey] = a_struct_backup_user />
		</cfoutput>		
		
		<!--- additional data ... e.g. followups ... --->
				
		<!--- execute script ... --->
		<cfinclude template="utils/inc_execute_big_script.cfm">
		
		<cfset a_int_datasize = FileSize(a_str_replication_file) />
		<cfset a_str_description = '' />
		
		<!--- insert query --->
		<cfinclude template="queries/q_insert_job_done.cfm">
		<cfinclude template="queries/q_delete_running_job.cfm">
		
		<cfset stReturn.duration = GetTickCount() - a_int_begin />
		<cfset stReturn.result = true />
		<cfreturn stReturn />
	</cffunction>
	
	<cffunction access="public" name="BackupUserAccountData" output="false" returntype="struct" hint="backup whole user data">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="options" type="string" default="" required="no" hint="">
		<cfargument name="companybackup" type="boolean" default="false" required="no" hint="Backing up the whole company">
		<cfargument name="backup_elements" type="string" default="" required="no" hint="email,calendar,tasks,contacts,bookmarks,notices,files">
		<cfargument name="basedirectory" type="string" default="" required="no" hint="The backup directory (temp directory)">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_int_begin = GetTickCount()>
		<cfset var a_str_jobkey = CreateUUID()>
		<cfset var a_str_backup_directory = ''>
		<cfset var tmp = false />
		<cfset var a_struct_load_userdata = 0 />
		<cfset var a_struct_filter = 0 />
		<cfset var a_struct_loadoptions = 0 />
		<cfset var stReturn_securitycontext = 0 />
		<cfset var a_struct_settings = 0 />
		<cfset var stSecurityContext = StructNew() />
		<cfset var stUserSettings = StructNew() />
		<cfset var q_select_contacts = 0 />
		<cfset var stReturn_accounts = 0 />
		<cfset var stReturn_contacts = 0 />
		<cfset var a_struct_history = 0 />
		<cfset var a_str_list_history_item_entrykeys =  '' />
		<cfset var q_select_history_items = 0 />
		<cfset var a_csv_history = '' />
		
		<cfset stReturn.jobkey = a_str_jobkey>
		<cfset stReturn.result = false>
		<cfset stReturn.errorMessage = ''>
		<cfset stReturn.start = Now()>
		<cfset stReturn.basedirectory = arguments.basedirectory>
		
			
		<!--- load user data ... --->
		<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
			<cfinvokeargument name="entrykey" value="#arguments.userkey#">
		</cfinvoke>
		
		<cfif NOT StructKeyExists(a_struct_load_userdata, 'query')>
			<cfset stReturn = 'User not found' />
			<cfreturn stReturn>
		</cfif>
		
		<cfset LogMessage('username: ' & a_struct_load_userdata.query.username)>
		
		<cfset CheckCompanyBackupAccount(companykey = a_struct_load_userdata.query.companykey) />
		
		<!--- if company backup and no account exists, cancel! --->
		<cfif arguments.companybackup AND NOT tmp>
			<!--- no company account exists --->
			<cfset stReturn.errorMessage = 'No company account exists' />
			<cfreturn stReturn>
		</cfif>
		
		<cfif NOT DirectoryExists(request.a_str_temp_directory_local & 'backup')>
			<cfdirectory action="create" directory="#request.a_str_temp_directory_local#backup">
		</cfif>
		
		<!--- create temp dirs --->
		<cfif Len(arguments.basedirectory) GT 0 AND DirectoryExists(arguments.basedirectory)>
			<!--- use the base path + username --->
			<cfset a_str_backup_directory = arguments.basedirectory & request.a_str_dir_separator & a_struct_load_userdata.query.username & request.a_str_dir_separator />
		<cfelse>
			<!--- use an uuid path --->
			<cfset a_str_backup_directory = request.a_str_temp_directory_local & request.a_str_dir_separator & createuuid() & request.a_str_dir_separator />
		</cfif>
		
		<cfset LogMessage('a_str_backup_directory: ' & a_str_backup_directory) />
		
		<cfset stReturn.directory = a_str_backup_directory>
		
		<cfdirectory action="create" directory="#a_str_backup_directory#">		
		
		<cfset stReturn.username = a_struct_load_userdata.query.username />
		
		<!--- create the global backup directory --->
		<cfset variables.a_str_global_backup_dir = request.a_str_temp_directory_local & request.a_str_dir_separator & 'backup' & request.a_str_dir_separator />
		
		<cfif Not DirectoryExists(a_str_global_backup_dir)>
			<cfdirectory action="create" directory="#a_str_global_backup_dir#">
		</cfif>
		
		<cfif Not DirectoryExists(a_str_global_backup_dir & request.a_str_dir_separator & a_struct_load_userdata.query.companykey)>
			<cfdirectory action="create" directory="#a_str_global_backup_dir##request.a_str_dir_separator##a_struct_load_userdata.query.companykey#">
		</cfif>
		
		<!--- get security context --->		
		<cfset variables.stSecurityContext = application.components.cmp_security.GetSecurityContextStructure(userkey = arguments.userkey) />
		
		<!--- get user settings --->
		<cfset variables.stUserSettings = application.components.cmp_user.GetUsersettings(userkey = arguments.userkey) />
		
		<!--- emails? --->
		<cftry>
			<cfinclude template="utils/inc_backup_email.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on email: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup email" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		<!--- contacts --->
		<cftry>
			<cfinclude template="utils/inc_backup_contacts.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on contacts: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup contacts" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		<!--- accounts --->
		<cftry>
			<cfinclude template="utils/inc_backup_accounts.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on contacts: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup contacts" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>		
		
		<!--- history --->
		<cftry>
			<cfinclude template="utils/inc_backup_history.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on history: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup contacts" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>			
		
		<!--- calendar --->
		<cftry>
		<cfinclude template="utils/inc_backup_events.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on events: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup events" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		<!--- tasks --->
		<cftry>
			<cfinclude template="utils/inc_backup_tasks.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on tasks: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup tasks" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		
		<!--- bookmarks --->
		<cftry>
			<cfinclude template="utils/inc_backup_bookmarks.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on bookmarks: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup bookmarks" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		<!--- files (storage) ---->
		<cftry>
			<cfinclude template="utils/inc_backup_storage.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on storage: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup storage" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		<!--- database --->
		<!--- <cftry>
			<cfinclude template="utils/inc_backup_database.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on database: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup database" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry> --->
		
		<!--- followups? --->
		<cftry>
			<cfinclude template="utils/inc_backup_followups.cfm">
		<cfcatch type="any">
			<cfset LogMessage('error on followups: ' & cfcatch.Message)>
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfcatch backup followups" type="html"><cfdump var="#arguments#"><cfdump var="#cfcatch#"></cfmail>
		</cfcatch>
		</cftry>
		
		<!--- shorturl? --->
				
		<!--- create sh file now ... --->
		<cfinclude template="utils/inc_execute_script.cfm">
		
		<cfset stReturn.duration = GetTickCount() - a_int_begin />
		
		<cfset LogMessage('duration: ' & stReturn.duration) />
		
		<cfset stReturn.result = true />
		<cfreturn stReturn />
	
	</cffunction>
	
	<cffunction name="queryRemoveColumns" output="false" returntype="query">
		<cfargument name="theQuery" type="query" required="yes">
		<cfargument name="columnsToRemove" type="string" required="yes">
		<cfset var columnList=theQuery.columnList>
		<cfset var columnPosition="">
		<cfset var c="">
		<cfset var newQuery="">
		<cfloop list="#arguments.columnsToRemove#" index="c">
			<cfset columnPosition=ListFindNoCase(columnList,c)>
			<cfif columnPosition NEQ 0>
				<cfset columnList=ListDeleteAt(columnList,columnPosition)>
			</cfif>
		</cfloop>
		<cfquery name="newQuery" dbtype="query">
			SELECT #columnList# FROM theQuery
		</cfquery>
		<cfreturn newQuery>
	</cffunction>	

</cfcomponent>

