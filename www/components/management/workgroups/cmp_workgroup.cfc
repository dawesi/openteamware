<!--- //

	Description:Workgroup routines
	
	Header:		

// --->

<cfcomponent displayname="WG" output='false'>

	<cfinclude template="/common/app/app_global.cfm">

	<cffunction access="public" name="GetWorkgroupProperties" output="false" returntype="query"
			hint="Return the properties of the given workgroup">
		<cfargument name="entrykey" type="string" default="">
		
		<cfset var q_select_workgroup_properties = 0 />
		
		<cfinclude template="queries/q_select_workgroup_properties.cfm">
		
		<cfreturn q_select_workgroup_properties />
	</cffunction>
		
	<cffunction access="public" name="GetWorkgroupNameByEntryKey" output="false" returntype="string">
		<!--- entry key ... --->
		<cfargument name="entrykey" type="string" default="">
		
		<cfset SelectWorkgroupnamebyKeyRequest.entrykey = arguments.entrykey>
		
		<cfinclude template="queries/q_select_workgroup_name_by_key.cfm">
		
		<cfreturn q_select_workgroup_name_by_key.groupname>		
		
	</cffunction>
	
	<!--- return the shortname of a group ... 
		if not present, than return full name --->
	<cffunction access="public" name="GetWorkgroupShortNameByEntryKey" output="false" returntype="string">
		<!--- entry key ... --->
		<cfargument name="entrykey" type="string" default="">
		
		<cfset SelectWorkgroupnamebyKeyRequest.entrykey = arguments.entrykey>
		
		<cfinclude template="queries/q_select_workgroup_name_by_key.cfm">
		
		<cfif Len(q_select_workgroup_name_by_key.shortname) GT 0>
			<cfreturn q_select_workgroup_name_by_key.shortname>		
		<cfelse>
			<cfreturn q_select_workgroup_name_by_key.groupname>		
		</cfif>		
		
	</cffunction>	
	
	<!--- create a new workgroup ...
	
		return a structure ...
		
		result = true/false
		entrykey = entrykey of the new workgroup
		
		--->
	<cffunction access="public" name="CreateWorkgroup" output="false" returntype="struct">
		<!--- name --->
		<cfargument name="groupname" type="string" required="true">
		<!--- the shortname --->
		<cfargument name="shortname" type="string" required="true">
		<!--- description --->
		<cfargument name="description" type="string" default="" required="true">
		<!--- created by? --->
		<cfargument name="createdbyuserkey" type="string" default="" required="true">
		<!--- companykey --->
		<cfargument name="companykey" type="string" default="" required="true">
		<!--- parent workgroup --->
		<cfargument name="parentgroupkey" type="string" default="" required="false">
		<!--- create the standard roles?
		
			main user, user, guest?
			
			--->
		<cfargument name="createstandardroles" type="boolean" default="true" required="false">
		<cfargument name="colour" type="string" default="white" required="false">
		
		<cfset CreateWorkgroupRequest.Createdbyuserkey = arguments.createdbyuserkey>
		<cfset CreateWorkgroupRequest.companykey = arguments.companykey>
		<cfset CreateWorkgroupRequest.groupname = arguments.groupname>
		<cfset CreateWorkgroupRequest.shortgroupname = arguments.shortname>
		<cfset CreateWorkgroupRequest.description = arguments.description>
		<cfset CreateWorkgroupRequest.parentkey = arguments.parentgroupkey>
		<cfset CreateWorkgroupRequest.colour = arguments.colour>
		<cfset CreateWorkgroupRequest.entrykey = CreateUUID()>
		
		<cfinclude template="queries/q_insert_workgroup.cfm">
		
		<!--- create now the standard roles
		
			(admin/member/guest)
			
			--->
		<cfif arguments.createstandardroles is true>
			<!--- create the role ... --->
			
			<cfinvoke component="cmp_workgroup" method="CreateWorkgroupRole" returnvariable="a_struct_create_role_return">
				<cfinvokeargument name="workgroupkey" value="#CreateWorkgroupRequest.entrykey#">
				<cfinvokeargument name="rolename" value="mainuser">
				<cfinvokeargument name="standardtype" value="10">
			</cfinvoke>

			<cfinvoke component="cmp_workgroup" method="CreateWorkgroupRole" returnvariable="a_struct_create_role_return">
				<cfinvokeargument name="workgroupkey" value="#CreateWorkgroupRequest.entrykey#">
				<cfinvokeargument name="rolename" value="user">
				<cfinvokeargument name="standardtype" value="5">
			</cfinvoke>

			<cfinvoke component="cmp_workgroup" method="CreateWorkgroupRole" returnvariable="a_struct_create_role_return">
				<cfinvokeargument name="workgroupkey" value="#CreateWorkgroupRequest.entrykey#">
				<cfinvokeargument name="rolename" value="guest">
				<cfinvokeargument name="standardtype" value="1">
			</cfinvoke>
			
		</cfif>
		
		<cfset stReturn = StructNew()>
		<cfset stReturn["result"] = true>
		<cfset stReturn["entrykey"] = CreateWorkgroupRequest.entrykey>
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<!--- create a new role for a company ... --->
	<cffunction access="public" name="CreateWorkgroupRole" output="false" returntype="struct">
		<!--- name of the role (english - will be translated on output ...) --->
		<cfargument name="rolename" type="string" default="" required="true">
		<!--- role description ... --->
		<cfargument name="description" type="string" default="" required="true">
		<!--- entrykey of workgroup --->
		<cfargument name="workgroupkey" type="string" default="" required="true">
		<!--- created by whom? --->
		<cfargument name="createdbyuserkey" type="string" default="" required="true">
		<!--- a standardtype? 
			
			10 = main user
			5 = user
			1 = guest
			
			--->
		<cfargument name="standardtype" type="numeric" default="0" required="false">
		<!---
			standard allowed actions ...
			
			--->
		<cfargument name="standardallowedactions" type="string" default="read" required="true">
		
		<cfif arguments.standardtype gt 0>
			<!--- no allowed actions for this type ... defined by system!! 
			
				otherwise we might have problems if a new feature occurs ...
				
				--->
			<cfset arguments.standardallowedactions = "">
		</cfif>
		
		<cfset CreateRoleRequest = StructCopy(arguments)>
		<cfset CreateRoleRequest.entrykey = CreateUUID()>
		
		<cfinclude template="queries/q_insert_role.cfm">
		
		<!--- return a structure ... --->
		<cfset stReturn = StructNew()>
		<cfset stReturn["result"] = true>
		<cfset stReturn["entrykey"] = CreateRoleRequest.entrykey>		
		
		<cfreturn stReturn>

	</cffunction>
	
	<!--- get the role name by it's entry key ... --->
	<cffunction access="public" name="getrolenamebyentrykey" output="false" returntype="string">
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset GetRoleNameByEntrykeyrequest.entrykey = arguments.entrykey>
		
		<cfinclude template="queries/q_select_rolename_by_entrykey.cfm">
		
		<cfreturn q_select_rolename_by_entrykey.rolename>
	</cffunction>
	
	<cffunction access="public" name="RemoveWorkgroupMember" output="false" returntype="boolean">
		<cfargument name="workgroupkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_delete_workgroup_member.cfm">
		
		<!--- this user has to reload it's settings by now ... set the appropriate setting ... --->
		<cfinvoke component="#application.components.cmp_user#" method="ForceSettingsReloadForUser" returnvariable="a_bol_return">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
		</cfinvoke>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="UpdateWorkgroupRolesForUser" output="false" returntype="boolean">
		<cfargument name="userkey" type="string" required="true">
		<cfargument name="workgroupkey" type="string" required="true">
		<cfargument name="rolekeys" type="string" required="true">
		
		<cfif Len(arguments.rolekeys) IS 0>
			<cfreturn false>
		</cfif>
		
		<cfinclude template="queries/q_update_user_roles.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<!--- add someone to a workgroup ... --->
	<cffunction access="public" name="AddWorkgroupMember" output="false" returntype="struct">
		<!--- workgroup key ... --->
		<cfargument name="workgroupkey" type="string" default="" required="true">
		<!--- created by? --->
		<cfargument name="createdbyuserkey" type="string" default="" required="true">
		<!--- userkey ... --->
		<cfargument name="userkey" type="string" default="" required="true">
		<!--- roles ... delimeter: comma --->
		<cfargument name="roles" type="string" required="true"  default="">
		
		
		<cfset AddWorkgroupMemberRequest.entrykey = CreateUUID()>
		<cfset AddWorkgroupMemberRequest.userkey = arguments.userkey>
		<cfset AddWorkgroupMemberRequest.workgroupkey = arguments.workgroupkey>
		<cfset AddWorkgroupMemberRequest.roles = arguments.roles>
		<cfset AddWorkgroupMemberRequest.createdbyuserkey = arguments.createdbyuserkey>
		
		<cfinclude template="queries/q_insert_workgroup_member.cfm">
		
		<!--- return a structure ... --->
		<cfset stReturn = StructNew()>
		<cfset stReturn["result"] = true>
		<cfset stReturn["entrykey"] = AddWorkgroupMemberRequest.entrykey>
		
		<!--- this user has to reload it's settings by now ... set the appropriate setting ... --->
		<cfinvoke component="#application.components.cmp_user#" method="ForceSettingsReloadForUser" returnvariable="a_bol_return">
			<cfinvokeargument name="userkey" value="#arguments.userkey#">
		</cfinvoke>				
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<cffunction access="public" name="DeleteSavedRoleSettings" output="false" returntype="boolean">
		<!--- rolekey ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset DeleteSavedRoleRequest.entrykey = arguments.entrykey>
		
		<cfinclude template="queries/q_delete_saved_role_permissions.cfm">
		
		<cfreturn true>	
	</cffunction>
	
	<!--- get all workgroup members ... --->
	<cffunction access="public" name="GetWorkgroupMembers" output="false" returntype="query">
		<!--- the workgroup key ... --->
		<cfargument name="workgroupkey" type="string" default="" required="true">
		<!--- return only real members (not members which are members of a upper group
			  and therefore automatically members ... --->
		<cfargument name="getrealmembersonly" type="boolean" default="true" required="false">
		
		<cfset SelectWorkgroupMembersRequest.entrykey = arguments.workgroupkey>
		
		<cfinclude template="queries/q_select_workgroup_members.cfm">
	
		<cfset q_select_users = QueryNew('userkey,workgroupkey,firstname,surname,fullname,roles,username')>
		
		<cfif q_select_workgroup_members.recordcount is 0>
			<!--- no users avaliable ... exit ... --->
			<cfreturn q_select_users>
		</cfif>
		
		<!--- add now all users with some information ... --->
		<cfset tmp = QueryAddRow(q_Select_users, q_select_workgroup_members.recordcount)>
		
		<cfset variables.a_cmp_load_user_data = CreateObject('component', '/components/management/users/cmp_load_userdata')>
		
		<cfloop query="q_select_workgroup_members">
			<cfset tmp = QuerySetCell(q_Select_users, 'userkey', q_select_workgroup_members.userkey, q_select_workgroup_members.currentrow)>
			<cfset tmp = QuerySetCell(q_Select_users, 'workgroupkey', arguments.workgroupkey, q_select_workgroup_members.currentrow)>
			
			<cfinvoke component="#variables.a_cmp_load_user_data#" method="LoadUserData" returnvariable="a_struct_userdata">
				<cfinvokeargument name="entrykey" value="#q_select_workgroup_members.userkey#">
			</cfinvoke>
			
			<cfif a_struct_userdata.result is "OK">
				<cfset q_select_user_data = a_struct_userdata.query>
				
				<cfset tmp = QuerySetCell(q_Select_users, 'username', q_select_user_data.username, q_select_workgroup_members.currentrow)>
				<cfset tmp = QuerySetCell(q_Select_users, 'firstname', q_select_user_data.firstname, q_select_workgroup_members.currentrow)>
				<cfset tmp = QuerySetCell(q_Select_users, 'surname', q_select_user_data.surname, q_select_workgroup_members.currentrow)>
				<cfset tmp = QuerySetCell(q_Select_users, 'fullname', q_select_user_data.surname&", "&q_select_user_data.firstname, q_select_workgroup_members.currentrow)>
			</cfif>
			
			<!--- load roles ... --->
			
		</cfloop>
		
		<cfreturn q_select_users>		
		
	</cffunction>
	
	<cffunction access="public" name="UserIsMemberOfWorkgroup" output="false" returntype="boolean">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteWorkgroup" output="false" returntype="boolean">
		<cfargument name="deletedbyuserkey" type="string" required="true">
		<cfargument name="workgroupkey" type="string" required="true">
		<cfargument name="companykey" type="string" required="true">
		
		<cfinclude template="utils/inc_delete_workgroup.cfm">
		
		<cfreturn true>
	</cffunction>
		
	<cffunction access="public" name="GetWorkgroupRoles" output="false" returntype="query"
			hint="return all workgroup roles of a given workgroup">
		<cfargument name="workgroupkey" type="string" required="true"
			hint="entrykey of workgroup">
			
		<cfset q_select_roles = 0 />
		
		<cfinclude template="queries/q_select_roles.cfm">
		
		<cfreturn q_select_roles />
	</cffunction>
	
	<cffunction access="public" name="ReturnWorkgroupNameByKeyUsingSecurityContext" output="false" returntype="string"
			hint="Return the information by a QoQ against the data in the given securitycontext">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="workgroupkey" type="string" required="true">
		
		<cfset q_select_name = 0 />
		
		<cfquery name="q_select_name" dbtype="query">
		SELECT
			workgroup_name
		FROM
			arguments.securitycontext.q_select_workgroup_permissions
		WHERE
			workgroup_key = '#arguments.workgroupkey#'
		;
		</cfquery>
		
		<cfreturn q_select_name.workgroup_name />
	
	</cffunction>
	
</cfcomponent>

