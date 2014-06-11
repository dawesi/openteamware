<!--- //

	Component:	Person
	Description:Get/Set user preferences
	

// --->

<cfcomponent output="false">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="GetUserPreference" output="false" returntype="string"
			hint="component wrapper for getting user preference value">
		<cfargument name="userid" type="numeric" required="false" default="#request.stSecurityContext.myuserid#"
			hint="userid of user">
		<cfargument name="section" type="string" required="true"
			hint="name of section">
		<cfargument name="name" type="string" required="true"
			hint="entry name">
		<cfargument name="defaultvalue" type="string" required="true"
			hint="default value if no item exists">
		<cfargument name="savesetting" type="boolean" required="false" default="false"
			hint="Save setting to database">
			
		<cfset var sReturn = arguments.defaultvalue />
		
		<cfset var a_str_hash_id = Hash(UCase(arguments.userid & arguments.section & arguments.name)) />
		
		<!--- are we quering a value for the currently logged in user? --->
		<cfset var a_bol_using_current_user = ((StructKeyExists(request, 'stSecurityContext'))
											   	AND
											   (request.stSecurityContext.myuserid IS arguments.userid)) />

		<cfinclude template="queries/person/q_select_person_entry.cfm">
		
		<cfif q_select_person_entry.recordcount IS 1>
			<!--- return loaded value ... --->
			<cfif a_bol_using_current_user>
			  
			  <cflock name="lck_set_sess_vars_cache_prop" type="exclusive" timeout="3">
		  		<cfset session.stUserSettings.cached_personal_properties[a_str_hash_id] = q_select_person_entry.entryvalue1 />
		   	  </cflock>
		  	</cfif>
		  	
		  	<!--- set return value ... --->
		  	<cfset sReturn = q_select_person_entry.entryvalue1 />
		<cfelse>
			<!--- return default value ... --->
			
			<cfif a_bol_using_current_user>
			  
			  <cflock name="lck_set_sess_vars_cache_prop" type="exclusive" timeout="3">
		  		<cfset session.stUserSettings.cached_personal_properties[a_str_hash_id] = arguments.defaultvalue />
		   	  </cflock>
		  </cfif>
		</cfif>
		
		<!--- should we save the setting to database? --->
		<cfif arguments.savesetting>
			<cfset SaveUserPreference(userid = arguments.userid, section = arguments.section, name = arguments.name, value = sReturn) />
		</cfif>
	
		<cfreturn sReturn />
		
	</cffunction>
	
	<cffunction access="public" name="GetMultipleUserPreferences" output="false" returntype="struct"
			hint="return multiple user preferences at once ...">
		<cfargument name="userid" type="numeric" default="#request.stSecurityContext.myuserid#" required="false"
			hint="id of user">
			
		<cfset var stReturn = StructNew() />
		
		<cfreturn stReturn />
	</cffunction>

	<cffunction access="public" name="SaveUserPreference" output="false" returntype="boolean"
			hint="Save a user preference">
		<cfargument name="userid" type="numeric" default="#request.stSecurityContext.myuserid#" required="false"
			hint="id of user">
		<cfargument name="section" type="string" required="true"
			hint="name of section">
		<cfargument name="name" type="string" required="true"
			hint="name of entry">
		<cfargument name="value" type="string" required="true"
			hint="value to save to database ...">
			
		<!--- generate hash ID ... --->
		<cfset var a_str_hash_id = Hash(UCase(arguments.userid & arguments.section & arguments.name)) />
		<cfset var a_bol_exists_in_session = false />
		
		
		<cflock scope="session" timeout="3" type="readonly">
			<cfset a_bol_exists_in_session = StructKeyExists(session, 'stUserSettings') AND 
							StructKeyExists(session.stUserSettings.cached_personal_properties, a_str_hash_id) />
		</cflock>
		
		<!--- if it exists in cached version, delete it from cache ... --->
		<cfif a_bol_exists_in_session>
			<cflock scope="session" timeout="30" type="exclusive">
				<cfset StructDelete(session.stUserSettings.cached_personal_properties, a_str_hash_id) />
			</cflock>	
		</cfif>
		
		<cfinclude template="queries/person/q_select_insert_update_user_preference.cfm">
		
			
		<cfreturn true />

	</cffunction>

</cfcomponent>


