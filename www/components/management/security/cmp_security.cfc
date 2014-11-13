<!--- //

	Component:	Security
	Description:Security component with various functions


// --->

<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="private" name="GetAvailableActionsOfService" output="false" returntype="struct"
			hint="Return available actions for a service, by default all are *not* permitted">
		<cfargument name="servicekey" type="string" required="true">

		<cfset var stReturn = StructNew() />
		<cfset var q_select_available_service_actions = 0 />

		<cfinclude template="queries/q_select_available_service_actions.cfm">

		<!--- any distinct service actions or use default values ... ? --->
		<cfif q_select_available_service_actions.recordcount GT 0>
			<cfloop query="q_select_available_service_actions">
				<cfset stReturn[q_select_available_service_actions.actionname] = false />
			</cfloop>
		<cfelse>

			<!--- default ... --->
			<cfset stReturn.read = false />
			<cfset stReturn.edit = false />
			<cfset stReturn.delete = false />

		</cfif>

		<cfreturn stReturn />

	</cffunction>

	<cffunction access="private" name="GetOwnerUserkeyOfObject" returntype="string" output="false"
			hint="return the entrykey of the owner user of an object">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of the service">
		<cfargument name="object_entrykey" type="string" required="true"
			hint="entrykey of the object">
		<cfargument name="object_type" type="string" required="false" default=""
			hint="optional: the object type">

		<cfset var a_str_owner_userkey = '' />

		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<!--- calendar ... --->
			<cfset a_str_owner_userkey = application.components.cmp_calendar.GetOwnerUserkey(arguments.object_entrykey) />
			</cfcase>

			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<!--- addressbook --->
			<cfset a_str_owner_userkey = application.components.cmp_addressbook.GetOwnerUserkey(arguments.object_entrykey) />
			</cfcase>

			<!--- <cfcase value="5084CF0A-0DAE-09E6-3C5171B204B4B26E">
			<!--- own databases --->
			<cfset a_str_owner_userkey = application.components.cmp_own_db.GetOwnerUserkey(entrykey = arguments.object_entrykey, object_type=arguments.object_type) />
			</cfcase> --->

			<cfcase value="5137784B-C09F-24D5-396734F6193D879D">
			<!--- projects ... --->
			<cfset a_str_owner_userkey = application.components.cmp_projects.GetOwnerUserkey(entrykey = arguments.object_entrykey) />
			</cfcase>

			<!--- email --->

			<!--- bookmarks --->

			<cfdefaultcase>
				<cfset a_str_owner_userkey = '' />
			</cfdefaultcase>
			</cfswitch>

		<cfreturn a_str_owner_userkey />

	</cffunction>

	<!---

		get the permissions of this user for a certain object

		returned is a structure containg the rights of this user

		rights

		read
		write
		delete
		editstructure (only were this property applies, otherwise "false")

		Important: check for locks ...

		--->

	<cffunction access="public" name="GetPermissionsForObject" output="false" returntype="struct"
			hint="return a structure with the actions the service/section/object allows ...">
		<cfargument name="servicekey" type="string" default="5220B02E-0133-5B37-F5E6B92CC3B3FC47" required="true"
			hint="service: see entry ids">
		<cfargument name="sectionkey" type="string" default="" required="true"
			hint="section ... the entrykey of the section (might be empty!)">
		<cfargument name="object_entrykey" type="string" default="" required="true"
			hint="object: the object description">
		<cfargument name="object_type" type="string" default="" required="false"
			hint="object type ... (f.e. important in the storage area (file/dir)">
		<cfargument name="securitycontext" type="struct" required="true"
			hint="the security context holding all roles and so on">

		<cfset var stReturn = GetAvailableActionsOfService(arguments.servicekey) />
		<cfset var a_str_owner_userkey = GetOwnerUserkeyOfObject(servicekey = arguments.servicekey,
												object_entrykey = arguments.object_entrykey,
												object_type = arguments.object_type) />
		<cfset var a_struct_lock = StructNew() />
		<cfset var a_bol_lock_exists = false />
		<cfset var sDirectorykey = '' />
		<cfset var a_struct_directory_security = StructNew() />
		<cfset var a_str_database_key = '' />
		<cfset var a_str_workgroup_keys_of_object = '' />
		<cfset var a_struct_database_security = StructNew() />
		<cfset var q_select_shares = 0 />
		<cfset var a_bol_read_allowed = false />
		<cfset var a_bol_is_secretary = false />
		<cfset var a_str_secretary_permission = '' />
		<cfset var a_str_secretary_key_of_object = '' />
		<cfset var a_str_parent_directorykey = '' />
		<cfset var a_str_companykey_of_owner_of_object = '' />
		<cfset var a_str_item = '' />
		<cfset var a_str_permission = '' />
		<cfset var q_select_is_virtual_workgroup_folder = 0 />
		<cfset var q_select_is_wg_shared_object = 0 />

		<!--- check for locks ... only if wg member --->
		<cfif (arguments.securitycontext.q_select_workgroup_permissions.recordcount GT 0)>
			<cfset a_struct_lock = application.components.cmp_locks.ExclusiveLockExistsForObject(servicekey = arguments.servicekey, objectkey = arguments.object_entrykey) />

			<!--- lock must exist and userkey of locker must be different if we should take a look at it ... --->
			<cfset a_bol_lock_exists = (a_struct_lock.lock_exists) AND (a_struct_lock.userkey NEQ arguments.securitycontext.myuserkey) />
		</cfif>

		<!--- private, own item ... --->
		<cfif (Compare(a_str_owner_userkey, arguments.securitycontext.myuserkey) IS 0)>

			<!--- a lock exists ... allow read only and that's it --->
			<cfif a_bol_lock_exists>
				<cfset stReturn.read = true />
				<cfreturn stReturn />
			</cfif>

			<!--- allow everything ... --->
			<cfloop collection="#stReturn#" item="a_str_item">
				<cfset stReturn[a_str_item] = true />
			</cfloop>

			<cfreturn stReturn />
		</cfif>

		<cfif Len(a_str_owner_userkey) IS 0>

			<!--- this object does not exist ... return false and exit --->
			<cfif (Compare(arguments.servicekey, '5222ECD3-06C4-3804-E92ED804C82B68A2') IS 0) AND
			  	  (CompareNoCase(arguments.object_type, 'dir') IS 0) AND
				  (arguments.securitycontext.q_select_workgroup_permissions.recordcount GT 0) AND
				  (Len(arguments.object_entrykey) GT 0)>

					<!--- check if this is a storage directory and a "virtual" workgroup folder ... --->
					<cfquery maxrows="1" name="q_select_is_virtual_workgroup_folder" dbtype="query">
					SELECT
						permissions
					FROM
						arguments.securitycontext.q_select_workgroup_permissions
					WHERE
						workgroup_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object_entrykey#">
					;
					</cfquery>

					<cfif q_select_is_virtual_workgroup_folder.recordcount IS 1>
						<!--- yes, it's a workgroup folder ... --->
						<cfloop list="#StructKeyList(stReturn)#" index="a_str_item">

							<!--- set the permission ... --->
							<cfif ListFindNoCase(q_select_is_virtual_workgroup_folder.permissions, a_str_item) GT 0>
								<cfset stReturn[a_str_item] = true />
							</cfif>

						</cfloop>

						<!--- is virtual folder ... return now!! --->
						<cfreturn stReturn />
					</cfif>

			</cfif>

			<cfset stReturn.error = 'object does not exist' />
			<cfreturn stReturn />
		</cfif>

		<!--- especially for the storage component ... --->
		<cfif (Compare(arguments.servicekey, '5222ECD3-06C4-3804-E92ED804C82B68A2') IS 0) AND
			  (CompareNoCase(arguments.object_type, 'file') IS 0)>
			  <!--- we've got a file ... check if the permissions for the directory are ok ... --->

			  <!--- get the directory of this file ... --->
			  <cfset sDirectorykey = application.components.cmp_storage.GetDirectoryKeyOfFile(arguments.object_entrykey) />

			  <cfif Len(sDirectorykey) IS 0>
			  		<!--- this directory does not exist ... return false and exit --->
					<cfreturn stReturn />
			  </cfif>

			  <!--- check the security of this directory ... --->
			  <cfset a_struct_directory_security = GetPermissionsForObject(servicekey = arguments.servicekey, object_entrykey= sDirectorykey, object_type='dir', securitycontext=arguments.securitycontext) />

			  <!--- return the permissions of the directory ... we can only do that if we're checking files

			  	if a lock exists created by a different user, return read only --->
			  <cfif a_bol_lock_exists>
					<cfset a_struct_directory_security.read = true />
					<cfreturn stReturn />
			  <cfelse>
					<cfreturn a_struct_directory_security />
			  </cfif>

		</cfif>



		<!--- especially for the database component ...  check if the type is a table ... in this case check the database security --->
		<!--- <cfif (Compare(arguments.servicekey, '5084CF0A-0DAE-09E6-3C5171B204B4B26E') IS 0) AND
			  (CompareNoCase(arguments.object_type, 'table') IS 0)>

			    <!--- get the parent database key --->
			    <cfset a_str_database_key = CreateObject('component', request.a_str_component_database).GetDatabaseKeyOfTable(entrykey=arguments.object_entrykey) />

				<cfif Len(a_str_database_key) IS 0>
					<cfreturn stReturn>
				</cfif>

				<!--- load security of database ... --->
				<cfset a_struct_database_security = GetPermissionsForObject(servicekey=arguments.servicekey, object_entrykey=a_str_database_key, object_type='database', securitycontext=arguments.securitycontext)>

			  	<cfif NOT a_struct_database_security.read>
					<!--- return the structure ... we do not have at least read properties --->
					<cfreturn stReturn>
				</cfif>

		</cfif> --->

		<cfset a_str_workgroup_keys_of_object = '' />

		<!--- load workgroup shares of this object --->
		<cfset q_select_shares = GetWorkgroupSharesForObject(entrykey = arguments.object_entrykey,
									securitycontext = arguments.securitycontext,
									servicekey = arguments.servicekey) />

		<!--- do we have wg shares to check? ... --->
		<cfif q_select_shares.recordcount GT 0>

			<cfset a_str_workgroup_keys_of_object = ListAppend('thisitemdoesnotexist', ValueList(q_select_shares.workgroupkey)) />

			<!--- check workgroup shares ... --->
			<cfquery name="q_select_is_wg_shared_object" dbtype="query">
			SELECT
				permissions
			FROM
				arguments.securitycontext.q_select_workgroup_permissions
			WHERE
				workgroup_key IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_workgroup_keys_of_object#" list="true">)
			;
			</cfquery>

			<!--- if found, set all found rights to true and that's it ... --->
			<cfif q_select_is_wg_shared_object.recordcount GT 0>
				<cfloop query="q_select_is_wg_shared_object">
					<cfloop list="#q_select_is_wg_shared_object.permissions#" index="a_str_permission">
						<cfif StructKeyExists(stReturn, a_str_permission)>
							<cfset stReturn[a_str_permission] = true />
						</cfif>
					</cfloop>
				</cfloop>

				<cfreturn stReturn />
			</cfif>

		</cfif>

		<cfif (Len(a_str_workgroup_keys_of_object) is 0) AND (Compare(a_str_owner_userkey, arguments.securitycontext.myuserkey) NEQ 0)>
			<!--- user is NOT owner and NO workgroup items exists ... --->

			<cfset a_bol_read_allowed = false />

			<!--- last possibility: some services provider 'External' access --->
			<cfswitch expression="#arguments.servicekey#">
				<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
				<!--- secretary? --->
				<cfset a_bol_is_secretary = CreateObject('component', request.a_str_component_secretary).IsUserSecretaryOfOtherUser(secretary_userkey = #arguments.securitycontext.myuserkey#, otheruser_userkey = #a_str_owner_userkey#)>

				<cfif a_bol_is_secretary>

					<!--- check permissions of the secretary ... --->
					<cfset a_str_secretary_permission = CreateObject('component', request.a_str_component_secretary).GetSecretaryPermission(secretary_userkey = arguments.securitycontext.myuserkey, otheruser_userkey = a_str_owner_userkey)>

					<!--- check if we're the owner of this item ... --->
					<cfset a_str_secretary_key_of_object = application.components.cmp_calendar.GetSecretarykeyofevent(entrykey = #arguments.object_entrykey#) />

					<cfswitch expression="#a_str_secretary_permission#">
						<cfcase value="changecreatedbysecretary">
							<!--- allow edit if created by this secreatary --->
							<cfif (Compare(arguments.securitycontext.myuserkey, a_str_secretary_key_of_object) IS 0)>
								<cfset stReturn.read = true>
								<cfset stReturn.edit = true>
							</cfif>
						</cfcase>
						<cfcase value="changeall">
							<!--- allow change no matter of who created the item ... --->
							<cfset stReturn.read = true>
							<cfset stReturn.edit = true>
						</cfcase>
						<cfcase value="deletecreatedbysecretary">
							<!--- allow delete if the user has created this item ... --->
							<cfif (Compare(arguments.securitycontext.myuserkey, a_str_secretary_key_of_object) IS 0)>
								<cfset stReturn.read = true>
								<cfset stReturn.edit = true>
								<cfset stReturn.delete = true>
							</cfif>
						</cfcase>
						<cfcase value="deleteall">
							<!--- allow to delete every item ... --->
							<cfset stReturn.read = true>
							<cfset stReturn.edit = true>
							<cfset stReturn.delete = true>
						</cfcase>
						<cfdefaultcase>
							<!--- no right ... just read --->
							<cfset a_bol_read_allowed = true>
						</cfdefaultcase>
					</cfswitch>

				<cfelse>
					<!--- meeting member ? --->
					<cfset a_bol_read_allowed = application.components.cmp_calendar.IsAttendeeOfEvent(eventkey = arguments.object_entrykey, userkey = arguments.securitycontext.myuserkey) />
				</cfif>

				</cfcase>
			</cfswitch>

			<cfif NOT a_bol_read_allowed>
				<!--- also READ is not allowed --- exit --->

				<!--- especially for directories ... sub directories have the same permissions as parent directories ... --->
				<cfif (Compare(arguments.servicekey, '5222ECD3-06C4-3804-E92ED804C82B68A2') IS 0) AND
				  	  (CompareNoCase(arguments.object_type, 'dir') IS 0) AND
					  (Len(arguments.object_entrykey) GT 0)>

					  <cfset a_str_parent_directorykey = application.components.cmp_storage.ReturnParentDirectorykeyOfDirectory(directorykey = arguments.object_entrykey) />

					  <cfif Len(a_str_parent_directorykey) GT 0>
					  	<!--- check security of this directory ... return permissions of parent directory ... --->
						<cfreturn GetPermissionsForObject(servicekey = arguments.servicekey,
								object_entrykey = a_str_parent_directorykey,
								object_type='dir',
								securitycontext = arguments.securitycontext) />
					  </cfif>

				</cfif>

				<!--- last chance: user is an administrator of the company of the owner of the element ... --->
				<cfset a_str_companykey_of_owner_of_object = application.components.cmp_user.GetCompanyKeyOfuser(userkey = a_str_owner_userkey) />

				<!--- is company admin of THIS company? --->
				<cfif arguments.securitycontext.iscompanyadmin AND (CompareNoCase(a_str_companykey_of_owner_of_object, arguments.securitycontext.mycompanykey) IS 0)>
					<cfset stReturn.read = true />
				</cfif>

				<cfreturn stReturn />
			<cfelse>
				<!--- set read to true and remove the other parts ... --->
				<cfset stReturn.read = true />
				<cfreturn stReturn />
			</cfif>

		</cfif>

		<cfreturn stReturn />
	</cffunction>

	<cffunction access="public" name="GetWorkgroupStandardPermissionsForService" output="false" returntype="string"
			hint="return a comma-seperated list of allowed actions (standard)">
		<cfargument name="workgroupkey" type="string" required="true"
			hint="entrykey of workgroup">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of user">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of service">

		<cfset var sReturn = '' />
		<cfset var SelectRoleRequest = StructNew() />
		<cfset var a_str_permissions = '' />
		<cfset var SelectCustomRolePermissions = StructNew() />
		<cfset var q_select_custom_role_permissions = 0 />
		<cfset var q_select_roles = 0 />
		<cfset var a_str_rolekey = '' />
		<cfset var a_str_permission =  '' />

		<!--- TODO! check if this user is a member of this workgroup or just inherited? --->

		<!--- load role ... --->
		<cfinclude template="queries/q_select_roles.cfm">

		<cfloop list="#q_select_roles.roles#" delimiters="," index="a_str_rolekey">
			<!--- load now role properties ... --->
			<cfset SelectRoleRequest.entrykey = a_str_rolekey>
			<cfinclude template="queries/q_select_role.cfm">

			<cfif q_select_role.standardtype GT 0>
				<!--- this is a standardtype ... --->

				<cfset a_str_permissions = GetAllowedStandardActionsForStandardType(q_select_role.standardtype)>

			<cfelse>
				<!---
				load custom permissions
				--->
				<cfset SelectCustomRolePermissions.entrykey = a_str_rolekey>
				<cfset SelectCustomRolePermissions.servicekey = arguments.servicekey>

				<cfinclude template="queries/q_select_custom_role_permissions.cfm">

				<cfset a_str_permissions = q_select_custom_role_permissions.allowedactions>
			</cfif>

			<cfloop list="#a_str_permissions#" delimiters="," index="a_str_permission">
				<cfif ListFindNoCase(sReturn, a_str_permission) IS 0>
					<cfset sReturn = ListPrepend(sReturn, a_str_permission)>
				</cfif>
			</cfloop>

		</cfloop>

		<!--- return data ... --->
		<cfreturn sReturn />
	</cffunction>

	<!--- //
		**************************************************************************************************************

		load the entire security context for a specified user ...

		containting all rights, membersships and so on

		// --->
	<cffunction access="public" name="LoadUserWorkgroupStandardPermissions" output="false" returntype="query">
		<!--- entrykey of the user ... --->
		<cfargument name="entrykey" type="string" default="" required="true">

		<!--- the query holding the security data ... --->
		<cfset var a_str_wg_fieldnames = 'workgroup_key,workgroup_name,workgroup_shortname,roles,description,parent_workgroup_key,inherited_membership,permissions,workgrouplevel,standardtypes,colour'>
		<cfset var a_str_wg_columntypes = 'VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,Integer,VarChar,Integer,Integer,VarChar'>
		<!--- use the fieldtypes we provide ... let cfmx do NO auto-guess --->
		<cfset var q_select_security = QueryNew(a_str_wg_fieldnames, a_str_wg_columntypes)>
		<cfset var q_select_first_workgroup_level = 0 />

		<!--- get the userkey ... --->
		<cfset var a_str_userkey = arguments.entrykey>
		<cfinclude template="queries/q_select_first_workgroup_level.cfm">

		<!--- loop through the groups ... --->
		<cfloop query="q_select_first_workgroup_level">

			<!--- load and add group/subgroups --->
			<cfmodule template="utils/mod_add_group.cfm"
				entrykey = #q_select_first_workgroup_level.workgroupkey#
				q_select_security = #q_select_security#
				inherited_membership = 0
				level = 0
				parent_entrykey = ""
				parent_roles = ""
				userkey = #a_str_userkey#>

		</cfloop>

		<!---<cfquery name="q_select_security" dbtype="query">
		SELECT * FROM q_select_security
		ORDER BY parent_workgroup_key,level;
		</cfquery>--->

		<cfreturn q_select_security>

	</cffunction>

	<!--- return a structure out of the security context full with the key/values pair
		key = workgroup_key
		value = workgorup_name

		this function is used for quicker lookups --->
	<cffunction access="public" name="GetSimpleStructOfWorkgroups" output="false" returntype="struct">
		<cfargument name="q_select_security" required="true" type="query">

		<cfset var stReturn = StructNew()>

		<cfloop query="arguments.q_select_security">
			<cfset stReturn[q_select_security.workgroup_key] = q_select_security.workgroup_name>
		</cfloop>

		<cfreturn stReturn />
	</cffunction>


	<cffunction access="public" name="GetSimpleStructOfWorkgroupsShortNames" output="false" returntype="struct">
		<cfargument name="q_select_security" required="true" type="query">

		<cfset var stReturn = StructNew() />

		<cfloop query="arguments.q_select_security">
			<cfset stReturn[q_select_security.workgroup_key] = q_select_security.workgroup_shortname />
		</cfloop>

		<cfreturn stReturn />
	</cffunction>

	<cffunction access="public" name="GetWorkgroupColoursStructure" output="false" returntype="struct">
		<cfargument name="q_select_security" required="true" type="query">

		<cfset var stReturn = StructNew() />

		<cfloop query="arguments.q_select_security">
			<cfset stReturn[q_select_security.workgroup_key] = q_select_security.colour />
		</cfloop>

		<cfreturn stReturn />
	</cffunction>


	<!---

		**************************************************************************************************************

		load the possible workgroups for a desired action ...

		**************************************************************************************************************

	--->
	<cffunction access="public" name="LoadPossibleWorkgroupsForAction" output="false" returntype="query">
		<cfargument name="q_workgroup_permissions" type="query" required="true"
			hint="the query holding all data about the subscribed workgroups ...">
		<cfargument name="desiredactions" type="string" default="read"
			hint="the desired actions ... can be multiple entries delimeterd by a comma entry must match ALL actions!!">

		<!--- create the return query ... --->
		<cfset var q_select_possible_workgroups = QueryNew(arguments.q_workgroup_permissions.columnlist) />
		<cfset var a_bol_match = false />
		<cfset var a_str_hash_value = '' />

		<cfset var a_str_action = '' />
		<cfset var a_str_colname = '' />

		<!--- private account? --->
		<cfif arguments.q_workgroup_permissions.recordcount IS 0>
			<cfreturn QueryNew(arguments.q_workgroup_permissions.columnlist) />
		</cfif>

		<cfset a_str_hash_value = Hash(ValueList(q_workgroup_permissions.workgroup_key) & ValueList(q_workgroup_permissions.roles) & ValueList(q_workgroup_permissions.permissions) & arguments.desiredactions) />

		<cfif StructKeyExists(request, 'q_select_possible_workgroups_for_action'&a_str_hash_value)>
			<cfreturn request['q_select_possible_workgroups_for_action'&a_str_hash_value] />
		</cfif>

		<cfloop query="arguments.q_workgroup_permissions">

			<cfset a_bol_match = false />

			<!--- check if all actions are matched ... --->
			<cfloop list="#arguments.desiredactions#" index="a_str_action">

				<cfif ListFindNoCase(arguments.q_workgroup_permissions.permissions, a_str_action) GT 0>
					<cfset a_bol_match = true />
				<cfelse>
					<cfset a_bol_match = false />
				</cfif>
			</cfloop>


			<!--- if the entry is ok, add now to the return query ... --->
			<cfif a_bol_match>
				<cfset QueryAddRow(q_select_possible_workgroups, 1) />

				<cfloop list="#arguments.q_workgroup_permissions.columnlist#" delimiters="," index="a_str_colname">
					<cfset QuerySetCell(q_select_possible_workgroups, a_str_colname, arguments.q_workgroup_permissions[a_str_colname][arguments.q_workgroup_permissions.currentrow], q_select_possible_workgroups.recordcount) />
				</cfloop>
			</cfif>
		</cfloop>

		<cfset request['q_select_possible_workgroups_for_action' & a_str_hash_value] = q_select_possible_workgroups />

		<cfreturn q_select_possible_workgroups />
	</cffunction>

	<!--- return allowes standard actions for certain standard types ... --->
	<cffunction access="public" name="GetAllowedStandardActionsForStandardType" output="false" returntype="string">
		<!--- standard type ... --->
		<cfargument name="standardtype" type="numeric" default="0" required="true">

		<cfset var a_str_allowed_actions = '' />

		<cfswitch expression="#arguments.standardtype#">
			<cfcase value="1">
			<!--- guest ... --->
			<cfset a_str_allowed_actions = "read">
			</cfcase>
			<cfcase value="5">
			<!--- user ... --->
			<cfset a_str_allowed_actions = "read,write,edit">
			</cfcase>
			<cfcase value="10">
			<!--- main user ... --->
			<cfset a_str_allowed_actions = "read,write,delete,edit,delegate,managepermissions,reports">
			</cfcase>
		</cfswitch>

		<cfreturn a_str_allowed_actions />
	</cffunction>

	<!--- take a query, load all entry-keys and
		remove all keys without read permissions ... --->
	<cffunction access="public" name="RemoveItemsWithoutReadPermission" output="false" returntype="query">
		<!--- input query ... --->
		<cfargument name="q_select" type="query" required="true">

		<cfset var SelectRemoveReadObjectsRequest = StructNew() />
		<cfset SelectRemoveReadObjectsRequest = arguments>


		<cfreturn SelectRemoveReadObjectsRequest.query>

	</cffunction>

	<cffunction access="public" name="RemoveAllWorkgroupShares" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of object">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of the service">
		<cfargument name="securitycontext" type="struct" required="true">


		<cfset var q_select_wg_shares = GetWorkgroupSharesForObject(securitycontext = arguments.securitycontext,
													servicekey = arguments.servicekey,
													entrykey = arguments.entrykey) />

		<cfloop query="q_select_wg_shares">
			<cfset RemoveWorkgroupShare(securitycontext = arguments.securitycontext,
											servicekey = arguments.servicekey,
											entrykey = arguments.entrykey,
											workgroupkey = q_select_wg_shares.workgroupkey) />
		</cfloop>

		<cfreturn true />

	</cffunction>

	<cffunction access="public" name="RemoveWorkgroupShare" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of object">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of the service">
		<cfargument name="workgroupkey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">

		<cfswitch expression="#arguments.servicekey#">
			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			<cfinclude template="queries/q_delete_shareddata_tasks.cfm">
			</cfcase>

			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<cfinclude template="queries/q_delete_shareddata_calendar.cfm">
			</cfcase>

			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<cfinclude template="queries/q_delete_shareddata_addressbook.cfm">
			</cfcase>

			<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
			<cfinclude template="queries/q_delete_shareddata_email.cfm">
			</cfcase>

			<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
			<cfinclude template="queries/q_delete_shareddata_storage.cfm">
			</cfcase>

			<cfcase value="5084CF0A-0DAE-09E6-3C5171B204B4B26E">
			<cfinclude template="queries/q_delete_shareddata_database.cfm">
			</cfcase>
		</cfswitch>

		<cfreturn true />
	</cffunction>

	<cffunction access="public" name="CreateWorkgroupShare" output="false" returntype="struct"
			hint="Create a workgroup share for a certain object">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of object ...">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of service">
		<cfargument name="workgroupkey" type="string" required="true"
			hint="entrykey of workgroup">
		<cfargument name="securitycontext" type="struct" required="true"
			hint="security context of user">

		<cfset var stReturn = GenerateReturnStruct() />

		<cftry>

		<cfswitch expression="#arguments.servicekey#">

			<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
			<cfinclude template="queries/q_insert_shareddata_tasks.cfm">
			</cfcase>

			<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
			<cfinclude template="queries/q_insert_shareddata_calendar.cfm">
			</cfcase>

			<cfcase value="52227624-9DAA-05E9-0892A27198268072">
			<cfinclude template="queries/q_insert_shareddata_addressbook.cfm">
			</cfcase>

			<cfcase value="52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5">
			<cfinclude template="queries/q_insert_shareddata_email.cfm">
			</cfcase>

			<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
			<cfinclude template="queries/q_insert_shareddata_storage.cfm">
			</cfcase>

			<cfcase value="5084CF0A-0DAE-09E6-3C5171B204B4B26E">
			<cfinclude template="queries/q_insert_shareddata_database.cfm">
			</cfcase>

		</cfswitch>

		<cfcatch type="any">
			<!--- maybe duplicate entry ... --->
			<cfreturn SetReturnStructErrorCode(stReturn, 999) />
		</cfcatch>
		</cftry>

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<!--- // load workgroups which shares this object // --->
	<cffunction access="public" name="GetWorkgroupSharesForObject" output="false" returntype="query"
			hint="load workgroups which shares this object">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="servicekey" type="string" required="true"
			hint="entrykey of the service">
		<cfargument name="entrykey" type="string" required="true">

		<cfset var q_select_shares = 0 />

		<cfset var q_select_task_shares = 0 />

		<cfif arguments.securitycontext.q_select_workgroup_permissions.recordcount IS 0>
			<cfset q_select_shares = QueryNew('workgroupkey,workgroupname', 'VarChar,VarChar') />
		<cfelse>

		<cfif Len(arguments.entrykey) IS 0>
			<cfreturn QueryNew('workgroupkey,workgroupname', 'VarChar,VarChar') />
		</cfif>

			<!--- return shares that apply to this user ... --->
			<cfswitch expression="#arguments.servicekey#">
				<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
				<cfinclude template="queries/workgroups/q_select_task_shares.cfm">
				</cfcase>

				<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
				<cfinclude template="queries/workgroups/q_select_calendar_shares.cfm">
				</cfcase>

				<cfcase value="52227624-9DAA-05E9-0892A27198268072">
				<cfinclude template="queries/workgroups/q_select_addressbook_shares.cfm">
				</cfcase>

				<cfcase value="5222ECD3-06C4-3804-E92ED804C82B68A2">
				<cfinclude template="queries/workgroups/q_select_storage_shares.cfm">
				</cfcase>

				<cfcase value="5137784B-C09F-24D5-396734F6193D879D">
				<cfinclude template="queries/workgroups/q_select_project_shares.cfm" />
				</cfcase>

			</cfswitch>

			<cfloop query="q_select_shares">

				<cfset QuerySetCell(q_select_shares, 'workgroupname', arguments.securitycontext.a_struct_workgroups[q_select_shares.workgroupkey], q_select_shares.currentrow) />

			</cfloop>

		</cfif>

		<cfreturn q_select_shares />

	</cffunction>

	<!--- // return the security context of a user // --->
	<cffunction access="public" name="GetSecurityContextStructure" output="false" returntype="struct"
			hint="return the security context of a user">
		<cfargument name="userkey" type="string" required="true" hint="entrykey of user">

		<cfset var stReturn = StructNew() />
		<cfset var a_int_crm_enabled = 0 />
		<cfset var q_select_productkey_of_user = 0 />

		<!--- fill the structure now ... --->
		<cfset stReturn.myuserkey = arguments.userkey />

		<!--- the productkey --->
		<cfinclude template="queries/q_select_productkey_of_user.cfm">

		<cfset stReturn.productkey = q_select_productkey_of_user.productkey />

		<!--- set the companykey ... --->
		<cfset stReturn.mycompanykey = application.components.cmp_user.GetCompanyKeyOfuser(arguments.userkey) />
		<cfset stReturn.myusername = application.components.cmp_user.GetUsernamebyentrykey(arguments.userkey) />
		<cfset stReturn.myuserid = q_select_productkey_of_user.userid />

		<!--- company admin? --->
		<cfset stReturn.iscompanyadmin = application.components.cmp_customer.IsUserCompanyAdmin(userkey = arguments.userkey) />

		<!--- set company admin permissions ... --->
		<cfset stReturn.companyadminrights = application.components.cmp_customer.GetCompanyAdminRights(userkey = arguments.userkey,
															companykey = stReturn.mycompanykey) />

		<!--- crm profile ... --->
		<cfset stReturn.crmsales_bindings = application.components.cmp_crmsales.GetCRMSalesBinding(companykey = stReturn.mycompanykey) />

		<!--- load standard workgroup permissions ... --->
		<cfset stReturn.q_select_workgroup_permissions = LoadUserWorkgroupStandardPermissions(entrykey = arguments.userkey) />

		<!--- get workgroup names in a structure (for a MUCH FASTER lookup) ... --->
		<cfset stReturn.a_struct_workgroups = GetSimpleStructOfWorkgroups(q_select_security = stReturn.q_select_workgroup_permissions) />

		<!--- logging enabled? .... --->
		<cfset stReturn.logging_enabled = false />

		<!--- force to set personal preferences ... --->
		<cfinclude template="utils/inc_force_set_personal_preferences.cfm">

		<cfreturn stReturn />

	</cffunction>

	<cffunction access="public" name="GetAllSecurityRolesOfCompany" output="false" returntype="query">
		<cfargument name="companykey" type="string" required="true">

		<cfset var q_select_security_roles = 0 />
		<cfinclude template="queries/q_select_security_roles.cfm">

		<cfreturn q_select_security_roles />
	</cffunction>

	<cffunction access="public" name="LoadSwitchUsersData" output="false" returntype="query"
			hint="return an array of switch data">
		<cfargument name="userkey" type="string" required="true" hint="entrykey of user for data to load">

		<cfset var q_select_switch_user_relations = 0 />
		<cfinclude template="queries/q_select_switch_user_relations.cfm">

		<cfreturn q_select_switch_user_relations>
	</cffunction>

	<cffunction access="public" name="DeleteSwitchUserRelation" output="false" returntype="struct"
			hint="remote a saved binding">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of home user">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of binding">
		<cfargument name="otheruserkey" type="string" required="true"
			hint="entrykey of other user">

		<cfset var stReturn = GenerateReturnStruct() />

		<!--- delete binding ... --->
		<cfinclude template="queries/q_delete_sso_binding.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="AddSwitchUserRelation" output="false" returntype="struct"
			hint="add a switch user relation record in the database">
		<cfargument name="userkey" type="string" required="true"
			hint="entrykey of base user">
		<cfargument name="otheruserkey" type="string" required="true"
			hint="entrykey of other user">
		<cfargument name="otherpassword_md5" type="string" required="true"
			hint="other password">
		<cfargument name="createdbyuserkey" type="string" required="true"
			hint="created by whom?">
		<cfargument name="comment" type="string" required="false" default=""
			hint="optional comment">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_otherusername = '' />
		<cfset var a_bol_check_login = false />
		<cfset var q_insert_switch_user_relation = 0 />

		<!--- user exists? --->
		<cfif NOT application.components.cmp_user.UserkeyExists(arguments.otheruserkey)>
			<cfreturn SetReturnStructErrorCode(stReturn, 12001)>
		</cfif>

		<cfif CompareNoCase(arguments.userkey, arguments.otheruserkey) IS 0>
			<!--- same user ... --->
			<cfreturn SetReturnStructErrorCode(stReturn, 12003)>
		</cfif>

		<cfset a_str_otherusername = application.components.cmp_user.GetUsernamebyentrykey(arguments.otheruserkey) />

		<!--- TODO check password ... --->
		<cfset a_bol_check_login = CheckSimpleLogin(username = a_str_otherusername, password = '', password_md5 = arguments.otherpassword_md5)>

		<cfif NOT a_bol_check_login>
			<cfreturn SetReturnStructErrorCode(stReturn, 12002)>
		</cfif>

		<!--- insert into database --->
		<cfinclude template="queries/q_insert_switch_user_relation.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn)>
	</cffunction>

	<cffunction access="public" name="CreateSecurityRole" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="createdbyuserkey" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="rolename" type="string" required="true">
		<cfargument name="protocol_depth" type="numeric" default="5" required="false">
		<cfargument name="allow_pda_login" type="numeric" default="1" required="false">
		<cfargument name="allow_wap_login" type="numeric" default="1" required="false">
		<cfargument name="allow_ftp_access" type="numeric" default="1" required="false">
		<cfargument name="allow_outlooksync" type="numeric" default="1" required="false">
		<cfargument name="allow_www_ssl_only" type="numeric" default="0" required="false">
		<cfargument name="allow_maildataacceessdata_access" type="numeric" default="1" required="false">
		<cfargument name="allow_ip" type="string" default="" required="false">

		<cfinclude template="queries/q_insert_security_role.cfm">

		<cfif Len(arguments.allow_ip) GT 0>
			<!--- insert IP restiction ... --->
		</cfif>

		<cfreturn true>
	</cffunction>

	<!--- apply a role to an user ... --->
	<cffunction access="public" name="ApplyRoleToUser" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="rolekey" type="string" required="true">

		<cfinclude template="queries/q_update_user_role.cfm">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="GetUsersUsingRole" output="false" returntype="query">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">

		<cfset var q_select_users_using_role = 0 />
		<cfinclude template="queries/q_select_users_using_role.cfm">

		<cfreturn q_select_users_using_role />
	</cffunction>

	<!--- return the security role an user is using ...

		if a role is found, load the role properties

		...

		--->
	<cffunction access="public" name="GetSecurityRoleOfUser" output="false" returntype="struct">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="loadroleiffound" type="boolean" default="true" required="false">

		<cfset var stReturn = StructNew()>
		<cfset var q_select_securityrolekey_of_user = 0 />
		<cfset var stReturn_role = 0 />

		<cfinclude template="queries/q_select_securityrolekey_of_user.cfm">

		<cfset stReturn.a_str_rolekey = q_select_securityrolekey_of_user.securityrolekey>

		<cfset stReturn.a_bol_found = (Len(q_select_securityrolekey_of_user.securityrolekey) GT 0)>

		<cfif (Len(stReturn.a_str_rolekey) GT 0) AND (arguments.loadroleiffound IS TRUE)>

			<!--- load role ... --->
			<cfinvoke component="cmp_security" method="GetSecurityRole" returnvariable="stReturn_role">
				<cfinvokeargument name="entrykey" value="#stReturn.a_str_rolekey#">
				<cfinvokeargument name="companykey" value="#arguments.companykey#">
			</cfinvoke>

			<!--- add to the return structure ... --->
			<cfset stReturn.a_struct_role = stReturn_role>
		</cfif>
		<cfreturn stReturn />
	</cffunction>

	<cffunction access="public" name="DeleteSecurityRole" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="entrykey" type="string" required="true">

		<cfinclude template="queries/q_delete_security_role.cfm">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="GetSecurityRole" output="false" returntype="struct">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="entrykey" type="string" required="true">

		<cfset var stReturn = StructNew()>
		<cfset var q_select_security_role = 0 />
		<cfset var q_select_securityroles_ip_restrictions = 0 />

		<cfinclude template="queries/q_select_security_role.cfm">

		<cfset stReturn.q_select_security_role = q_select_security_role>

		<!--- load ip restrictions ... --->
		<cfinclude template="queries/q_select_securityroles_ip_restrictions.cfm">

		<cfset stReturn.q_select_securityroles_ip_restrictions = q_select_securityroles_ip_restrictions>

		<cfreturn stReturn>
	</cffunction>

	<!--- check if a certain action is allowed ... --->
	<cffunction access="public" name="CheckIfActionIsAllowed" output="false" returntype="struct">
		<cfargument name="servicekey" type="string" required="yes" hint="key of the service">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="object_entrykey" type="string" default="" required="yes">
		<cfargument name="object_type" type="string" default="" required="no" hint="f.e. database/table/report (only if needed)">
		<cfargument name="neededaction" type="string" required="yes" hint="the requested action">

		<!--- cache value ... --->
		<cfset var sEntrykey_request = Hash(arguments.servicekey & arguments.securitycontext.myuserkey & arguments.object_entrykey & arguments.object_type & arguments.neededaction) />
		<cfset var stReturn = StructNew() />

		<!--- log this operation? --->
		<cfif arguments.securitycontext.logging_enabled>

			<cfinvoke component="#application.components.cmp_log#" method="CreateLogEntry">
				<cfinvokeargument name="servicekey" value="#arguments.servicekey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="entrykey" value="#arguments.object_entrykey#">
				<cfinvokeargument name="performedaction" value="#arguments.neededaction#">
			</cfinvoke>

		</cfif>


		<!--- cached version? --->
		<cfif StructKeyExists(request, sEntrykey_request)>
			<cfreturn request[sEntrykey_request] />
		</cfif>

		<!--- return common property ... --->
		<cfset stReturn.result = false />

		<!--- ok, still in the game ... check now workgroup permissions ... --->
		<cfset stReturn = GetPermissionsForObject(securitycontext = arguments.securitycontext,
											servicekey = arguments.servicekey,
											object_entrykey = arguments.object_entrykey,
											object_type = arguments.object_type) />

		<!--- return the struct with the rights and the actionAllowed property --->
		<cfset stReturn.result = StructKeyExists(stReturn, arguments.neededaction) AND
													   (stReturn[arguments.neededaction]) />


		<!--- set cached version ... --->
		<cfset request[sEntrykey_request] = stReturn />

		<cfreturn stReturn />
	</cffunction>

	<cffunction access="public" name="CheckSimpleLogin" output="false" returntype="boolean">
		<cfargument name="username" type="string" required="yes" hint="username">
		<cfargument name="password" type="string" required="yes" hint="plain text password">
		<cfargument name="password_md5" type="string" required="no" default="" hint="password in md5 hash format">

		<cfinclude template="queries/q_select_check_simple_login.cfm">

		<cfreturn (q_select_check_simple_login.count_id IS 1)>
	</cffunction>

	<cffunction access="public" name="CheckLoginData" output="false" returntype="struct"
			hint="check login and return the default structure">
		<cfargument name="username" type="string" required="yes"
			hint="the full username (john@doe.com)">
		<cfargument name="password" type="string" required="yes"
			hint="plain text password">
		<cfargument name="password_md5" type="string" required="no" default=""
			hint="password in md5 hash format ... will be used if provided">
		<cfargument name="check_restrictions" type="boolean" default="true"
			hint="check various restrictions as well, e.g. trial phase or forbidden IP?">
		<cfargument name="remote_ip" type="string" required="false" default="#cgi.REMOTE_ADDR#"
			hint="ip of requesting device">
		<cfargument name="log_login" type="boolean" default="false" required="false"
			hint="update last login?">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var sEntrykey = '' />
		<cfset var q_select_check_simple_login = 0 />


		<!--- check simple login ... --->
		<cfinclude template="queries/q_select_check_simple_login.cfm">

		<!--- error, return error #99 --->
		<cfif (q_select_check_simple_login.count_id NEQ 1)>
			<cfreturn SetReturnStructErrorCode(stReturn, 99) />
		</cfif>

		<!--- load userdata --->
		<cfset sEntrykey = application.components.cmp_user.GetEntrykeyFromUsername(arguments.username) />
		<cfset stReturn.q_userdata = application.components.cmp_user.GetUserData(sEntrykey) />

		<!--- perform several checks ... --->
		<cfif arguments.check_restrictions>

			<!--- IP restrictions? ... --->
			<cfif NOT CreateObject('component', '/components/management/users/cmp_check_login').CheckLoginRestrictions(userid = stReturn.q_userdata.userid,
							remoteaddress = arguments.remote_ip)>
				<cfreturn SetReturnStructErrorCode(stReturn, 202) />
			</cfif>

		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

</cfcomponent>
