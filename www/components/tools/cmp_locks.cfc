<!--- //

	Component:	Locking
	Description:Handle locking ...
	

// --->

<cfcomponent output="false">
	
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="CreateExclusiveLock" output="false" returntype="struct"
			hint="create an edit lock for an object (exclusive access), reading will be possible but not any other actions">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of service">
		<cfargument name="objectkey" type="string" required="true"
			hint="entrykey of object to lock (e.g. contact, file, ...)">
		<cfargument name="timeout_minutes" type="numeric" default="20"
			hint="default timeout">
		<cfargument name="comment" type="string" default="" required="false"
			hint="comment by user">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var tmp = false />
		<cfset var a_struct_lock_exists = ExclusiveLockExistsForObject(servicekey = arguments.servicekey,
																		objectkey = arguments.objectkey) />
		<cfset var a_str_lock_entrykey = CreateUUID() />
		<cfset var a_dt_timeout = DateAdd('n', arguments.timeout_minutes, GetUTCTime(Now())) />
		
		<!--- check if already an exclusive lock exists ... created by a different user ... --->
		<cfif a_struct_lock_exists.lock_exists>
			
			<cfif (CompareNoCase(arguments.securitycontext.myuserkey, a_struct_lock_exists.userkey) IS 0)>
				<!--- same user requesting lock again ... --->
				<cfset stReturn.entrykey = a_struct_lock_exists.entrykey />
				<cfset stReturn.dt_timeout = a_struct_lock_exists.dt_timeout />
				
			<cfelse>
				<!--- other user ... return error information ... --->
				<cfset stReturn.lock = a_struct_lock_exists />
				
				<cfreturn SetReturnStructErrorCode(stReturn, 5300) />
			</cfif>
		
		<cfelse>
			<!--- insert lock now ... --->
			<cfinclude template="queries/locks/q_delete_old_expired_locks.cfm">
			<cfinclude template="queries/locks/q_insert_lock.cfm">
			<cfset stReturn.entrykey = a_str_lock_entrykey />
			<cfset stReturn.dt_timeout = a_dt_timeout />
		
		</cfif>
		
		<!--- maybe update information in database ... --->
		<cfset UpdateServiceInformation(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings,
												servicekey = arguments.servicekey, objectkey = arguments.objectkey, lock_exists = true) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="ExclusiveLockExistsForObject" returntype="struct" output="false"
			hint="does a lock exist for a certain object?">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of service">
		<cfargument name="objectkey" type="string" required="true"
			hint="entrykey of object">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var tmp = false />
		<cfset var q_select_lock = 0 />
		
		<cfinclude template="queries/locks/q_select_lock.cfm">
		
		<cfset stReturn.lock_exists = (q_select_lock.recordcount GT 0) />
		<cfset stReturn.dt_created = q_select_lock.dt_created />
		<cfset stReturn.dt_timeout = q_select_lock.dt_timeout />
		<cfset stReturn.userkey = q_select_lock.userkey />
		<cfset stReturn.entrykey = q_select_lock.entrykey />
		<cfset stReturn.comment = q_select_lock.comment />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="UpdateServiceInformation" returntype="boolean" output="false"
			hint="update meta data of service if needed">
		<cfargument name="servicekey" type="string" required="true" hint="entrykey of service">
		<cfargument name="objectkey" type="string" required="true" hint="entrykey of object">
		<cfargument name="lock_exists" type="boolean" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var a_struct_sql = StructNew() />
		
		<cfinclude template="utils/inc_update_lock_meta_information.cfm">
		
		<cfreturn true />		
	</cffunction>
	
	<cffunction access="public" name="RemoveExclusiveLock" returntype="struct" output="false"
			hint="remove an exlusive lock (done by update/edit function of components)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">				
		<cfargument name="servicekey" type="string" required="true" hint="entrykey of service">
		<cfargument name="objectkey" type="string" required="true" hint="entrykey of object">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var tmp = false />
		<cfset var a_struct_lock = ExclusiveLockExistsForObject(servicekey = arguments.servicekey, objectkey = arguments.objectkey) />
		<cfset var a_bol_allowed = (a_struct_lock.userkey IS arguments.securitycontext.myuserkey) OR (arguments.securitycontext.iscompanyadmin) />
		
		<!--- no lock exists ... --->
		<cfif NOT a_struct_lock.lock_exists>
			<cfreturn SetReturnStructSuccessCode(stReturn) />
		</cfif>

		<!--- exclusive lock can only be removed the by user itself or an admin ... --->
		<cfif NOT a_bol_allowed>
			<cfreturn SetReturnStructErrorCode(stReturn, 5301) />
		</cfif>
		
		<!--- maybe update information in database ... --->
		<cfset UpdateServiceInformation(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings,
												servicekey = arguments.servicekey, objectkey = arguments.objectkey, lock_exists = false) />
		
		<!--- del now ... --->
		<cfset DeleteLockInternally(entrykey = a_struct_lock.entrykey) />

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="RemoveTimedOutExclusiveLocks" returntype="boolean" output="false"
			hint="remove all locks which have timed out">
			
		<cfset var tmp = false />
		<cfset var q_select_timed_out_locks = 0 />
		
		<cfinclude template="queries/locks/q_select_timed_out_locks.cfm">
		
		<!--- loop through locks and delete timed out ones ... --->
		<cfloop query="q_select_timed_out_locks">
			
			<cfset UpdateServiceInformation(servicekey = q_select_timed_out_locks.servicekey,
							objectkey = q_select_timed_out_locks.objectkey,
							lock_exists = false,
							securitycontext = application.components.cmp_security.GetSecurityContextStructure(userkey = q_select_timed_out_locks.userkey),
							usersettings = application.components.cmp_user.GetUsersettings(userkey = q_select_timed_out_locks.userkey)) />
				
				<cfset DeleteLockInternally(entrykey = q_select_timed_out_locks.entrykey) />
		</cfloop>

		<cfreturn true />

	</cffunction>
	
	<cffunction access="public" name="GenerateLockDefaultInformationString" returntype="string" output="false"
			hint="Generate a string containing information about a possible lock, if no one does exist, return empty string">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of lock">
			
		<cfset var sReturn = '' />
		<cfset var a_str_username = '' />
		
		<cfinclude template="queries/locks/q_select_lock_by_entrykey.cfm">
		
		<cfif q_select_lock_by_entrykey.recordcount IS 0>
			<cfreturn '' />
		</cfif>
		
		<cfset a_str_username = application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_lock_by_entrykey.userkey) />
		
		<cfset sReturn = a_str_username & ' ' & GetLangVal('adm_ph_company_news_valid_until') & ' ' & LSDateFormat(q_select_lock_by_entrykey.dt_timeout, request.stUserSettings.default_dateformat) & ' ' & LSDateFormat(q_select_lock_by_entrykey.dt_timeout, request.stUserSettings.default_timeformat) />
		
		<cfreturn sReturn />

	</cffunction>
	
	<cffunction access="private" name="DeleteLockInternally" output="false" returntype="boolean"
			hint="delete a lock internally without further processing">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of lock">
			
			<cfinclude template="queries/locks/q_delete_lock_internally.cfm">
			
		<cfreturn true />	
	</cffunction>

</cfcomponent>


