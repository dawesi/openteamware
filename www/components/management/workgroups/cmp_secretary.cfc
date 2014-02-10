<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<!---
	
		list of permissions:
		
			- create
				create new items
			- changecreatedbysecretary
				edit only elements created the the secretary
			- changeall
				edit all items except private ones
			- deletecreatedbysecretary
				delete only elements created by the secretary
			- deleteall
				delete all elements except private ones
	
	--->

	<cffunction access="public" name="GetAllSecretariesOfACompany" output="false" returntype="query">
		<!--- companykey ... --->
		<cfargument name="companykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_secretaries.cfm">
	
		<cfreturn q_select_secretaries>
	</cffunction>
	
	<cffunction access="public" name="UpdateSecretaryEntry" output="false" returntype="boolean" hint="update a definition">
		<cfargument name="entrykey" type="string" required="yes" hint="entrykey of definition">
		<cfargument name="permission" type="string" required="yes" hint="permission level of secretary">
		
		<cfinclude template="queries/q_update_secretary_definition.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="CreateSecretaryEntry" output="false" returntype="boolean" hint="create a new definition">
		<cfargument name="companykey" type="string" required="true" hint="entrykey of company">
		<cfargument name="userkey" type="string" required="true" hint="entrykey of managed user">
		<cfargument name="secretarykey" type="string" required="true" hint="entrykey of user who is secretary">
		<cfargument name="createdbyuserkey" type="string" required="true" hint="who has created this item?">
		<cfargument name="permission" type="string" required="yes" hint="permission level of secretary">
		
		<cfinclude template="queries/q_insert_secretary.cfm">
		
		<cfreturn true>		
	</cffunction>
	
	<cffunction access="public" name="GetSecretariesOfUser" output="false" returntype="query">
	
	</cffunction>
	
	<cffunction access="public" name="DeleteSecretaryEntry" output="false" returntype="boolean">
		<cfargument name="companykey" type="string" required="true">
		<cfargument name="entrykey" type="string"  required="true">
		
		<!--- log ... --->
		<cfinclude template="queries/q_delete_secretary_entry.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetSecretaryPermission" output="false" returntype="string" hint="return the secretary permissions of an user">
		<cfargument name="secretary_userkey" type="string" required="yes">
		<cfargument name="otheruser_userkey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_secretary_permission.cfm">
				
		<cfreturn q_select_secretary_permission.permission>
	</cffunction>	
	
	<cffunction access="public" name="IsUserSecretaryOfOtherUser" output="false" returntype="boolean">
		<cfargument name="secretary_userkey" type="string" required="yes">
		<cfargument name="otheruser_userkey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_is_secretary_of_user.cfm">
		
		<cfreturn (q_select_is_secretary_of_user.count_id IS 1)>
	</cffunction>
	
	<!--- for which users is this user in a secretary role? --->
	<cffunction access="public" name="GetAllAttendedUsers" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="true">
		
		<cfinclude template="queries/q_select_attended_users.cfm">
		
		<cfreturn q_select_attended_users>
	</cffunction>

</cfcomponent>