<cfif Len(arguments.clientkey) IS 0>
	<cfset stReturn.error = 510>
	<cfset stReturn.errormessage = 'Argument clientkey is empty'>
	<cfreturn stReturn>
</cfif>


<!--- check if structures are created --->
<cfif NOT StructKeyExists(application, 'directaccess')>

	<cflock type="exclusive" name="lck_set_structs" timeout="3">
		<cfset application.directaccess = StructNew()>
		<cfset application.directaccess.securitycontext = StructNew()>
		<cfset application.directaccess.usersettings = StructNew()>	
	</cflock>	
	
</cfif>

<!--- check if we've got created the security context --->
<cfif StructKeyExists(arguments, 'clientkey')>

	<cflog text="arguments.clientkey: #arguments.clientkey#" type="Information" log="Application" file="ib_ws">
	
	<!--- OK, here we go now ...
	
		two possible authentification methods:
		
		a) by clientkey
		b) by username:password
		
		b) is only allowed if it is a direct customer of this user ...
		
		--->
		
	<cfif FindNoCase(':', arguments.clientkey) GT 0>
		<!--- method b) do a hash because of various difficult chars that might be in the username/password --->
		<cfset a_str_hash_clientkey = Hash(arguments.clientkey)>
	<cfelse>
		<!--- method a) --->
		<cfset a_str_hash_clientkey = arguments.clientkey>
	</cfif>
	
	<cflog text="a_str_hash_clientkey: #a_str_hash_clientkey#" type="Information" log="Application" file="ib_ws">
	<cflog text="StructKeyExists(application.directaccess, a_str_hash_clientkey): #StructKeyExists(application.directaccess, a_str_hash_clientkey)#" type="Information" log="Application" file="ib_ws">
	
	<cfif NOT StructKeyExists(application.directaccess, a_str_hash_clientkey)>
	
		<!--- create securitycontext --->
		
		<cfif FindNoCase(':', arguments.clientkey) GT 0>
		
			<!--- authentification by username:password --->
			<cfinclude template="utils/inc_check_session_username_password.cfm">
						
		<cfelse>
		
			<!--- authentification by clientkey --->
			<cfinclude template="utils/inc_check_session_clientkey.cfm">
		
		</cfif>
	
	
	</cfif>


</cfif>