<cfcomponent output=false>
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="GetLastSync" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="yes">
		
		<!--- get username ... --->
		
		
	</cffunction>
	
	<cffunction access="private" name="GetUsernameByUserkey" output="false" returntype="string" hint="internal function">
		<cfargument name="userkey" type="string" required="yes">
		
		<cfreturn application.components.cmp_user.GetUsernameByEntrykey(arguments.userkey)>
	</cffunction>
	
	<cffunction access="private" name="GetVirtualUsernamesOfUser" output="false" returntype="string">
		<cfargument name="userkey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_virtual_usernames_of_user.cfm">
		
		<cfreturn valuelist(q_select_virtual_usernames_of_user.username)>
	</cffunction>
	
	<cffunction access="public" name="GetDevicesOfUser" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="yes">
		
		<!--- get username ... --->
		<cfset var a_str_username = GetUsernameByUserkey(arguments.userkey)>
		<cfset var a_str_virtual_usernames = GetVirtualUsernamesOfUser(arguments.userkey)>
		
		<cfinclude template="queries/q_select_devices_of_user.cfm">
		
		<cfreturn q_select_devices_of_user>
	</cffunction>
	
	<cffunction access="private" name="CheckDeviceExists" returntype="boolean" output="false" hint="check if a device already exists">
		<cfargument name="deviceid" type="string" required="yes">
		
		<cfinclude template="queries/q_select_device_exists.cfm">
		
		<cfreturn (q_select_device_exists.count_id GT 0)>
		
	</cffunction>
	
	<cffunction access="public" name="AddDevice" output="false" returntype="struct" hint="add a device and automatically the principle">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="name" type="string" required="yes" hint="name of device">
		<cfargument name="description" type="string" required="yes" hint="description of device">
		<cfargument name="deviceid" type="string" required="yes" hint="device id (IMEI)">
		<cfargument name="manufactor_model" type="string" required="yes" hint="manufactor & model">
		<cfargument name="encoding" type="string" required="no" default="UTF-8" hint="encoding of data">
		
		<cfset var stReturn = StructNew()>
		<cfset var a_str_username = GetUsernameByUserkey(arguments.userkey)>
		
		<cfset stReturn.error = 999>
		<cfset stReturn.errormessage = ''>
		
		<cfset arguments.deviceid = trim(arguments.deviceid)>
		
		<cfset arguments.deviceid = ReplaceNoCase(arguments.deviceid, '-', '', 'ALL')>
		<cfset arguments.deviceid = ReplaceNoCase(arguments.deviceid, ':', '', 'ALL')>
		<cfset arguments.deviceid = ReplaceNoCase(arguments.deviceid, 'IMEI', '', 'ALL')>
		<cfset arguments.deviceid = trim(arguments.deviceid)>
		
		<cfset stReturn.deviceid = arguments.deviceid>
		
		<cfif Len(a_str_username) IS 0>
			<cfset stReturn.errormessage = 'User does not exist'>
			<cfreturn stReturn>
		</cfif>
		
		<cfif Len(arguments.deviceid) IS 0>
			<cfset stReturn.errormessage = 'Empty IMEI'>
			<cfreturn stReturn>
		</cfif>	
		
		<!--- check for duplicate --->
		<cfset q_select_devices = GetDevicesOfUser(userkey = arguments.userkey)>
		
		<cfquery name="q_select_device_exists" dbtype="query">
		SELECT
			COUNT(id) AS count_id
		FROM
			q_select_devices
		WHERE
			id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceid#">
		;
		</cfquery>
		
		<cfif q_select_device_exists.count_id GT 0>
			<cfset stReturn.errormessage = 'Device already exists for this user'>
			<cfreturn stReturn>
		</cfif>
		
		<cflock name="lck_insert_priciple_device" type="exclusive" timeout="30">
			<!--- get new highest device ID --->
			<cfinclude template="queries/q_select_highest_principal_id.cfm">
			
			<cfset a_int_princial_id = q_select_highest_principal_id.counter + 1>
			
			<!--- insert device ... only if it does not exist yet generally--->
			<cfif NOT CheckDeviceExists(arguments.deviceid)>
				<cfinclude template="queries/q_insert_device.cfm">
			</cfif>
			
			<!--- insert virtual username ... --->
			<cfset a_str_virtual_username = CreateVirtualuser(userkey = arguments.userkey, principal_id = a_int_princial_id)>
			
			<!--- add principal ... --->
			<cfinclude template="queries/q_insert_principal.cfm">
			
			<!--- update highest principal ID --->
			<cfinclude template="queries/q_update_principal_counter.cfm">			
			
		</cflock>
				
		<cfset stReturn.error = 0>
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="CreateVirtualuser" output="false" returntype="string">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="principal_id" type="numeric" required="yes">
		
		<cfset var a_str_virtual_username = ''>
		
		<cfloop from="1" to="12" index="ii">
			<cfset a_str_virtual_username = a_str_virtual_username & RandRange(1,9)>
			<cfif (ii mod 3 IS 0) AND NOT (ii IS 12)>
				<cfset a_str_virtual_username = a_str_virtual_username & '-'>
			</cfif>
		</cfloop>
		
		<cfinclude template="queries/q_insert_virtual_user.cfm">
		
		<cfreturn a_str_virtual_username>
		
	</cffunction>
	
	<cffunction access="public" name="CreateSync4jUser" output="false" returntype="boolean" hint="create the user in the users table">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="UpdateSync4jPassword" output="false" returntype="boolean" hint="update password">
		<cfargument name="userkey" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="DeleteSync4jUser" output="false" returntype="boolean" hint="delete a sync4j user">
		<cfargument name="userkey" type="string" required="yes">
	</cffunction>
	
</cfcomponent>