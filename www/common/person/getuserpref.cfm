<!--- //

	Module:		Framework
	Description: get the default value for something ...
	
				Store personal values and preferences this way
	

	
	

	this file should be changed to a CFC in future times ...

	

	scope: request, attributes

	<io>
		<in>
			<param name="entrysection" scope="attributes" required="true" type="string" length=160 default="">
				<description>
				the section
				<description>			
			</param>
			<param name="entryname" scope="attributes" required="true" type="string" length=255 default="">
				<description>
				the entry name
				<description>			
			</param>
			<param name="defaultvalue1" scope="attributes" required="true" type="string" length=255 default="">
				<description>
				the default value 1
				<description>			
			</param>
			<param name="userparameter" scope="attributes" required="false" type="string" length=255 default="">
				<description>
				maybe the user has specified his own value ... f.e. using a select box that
				maps a value to the URL scope
				in this case we have to take this value
				<description>			
			</param>
			<param name="validuserparameters" scope="attributes" required="false" type="string" length=5000 default="">
				<description>
				list of valid userparameter entry values
				<description>			
			</param>			
			<param name="savesttings" scope="attributes" required="false" type="boolean" default="false">
				<description>
				save the settings				
				important feature
				<description>			
			</param>												
			<param name="setcallervariable1" scope="attributes" required="false" type="string" default="">
				<description>
				set a caller variable directly with the right name (not the default name ...)
				<description>			
			</param>		
		</in>	
		<out>
			<param name="entryvalue1" scope="caller" default="" type="string">
				<description>
				the entry value 1
				<description>			
			</param>		
			<param name="entryvalue2" scope="caller" default="" type="string">
				<description>
				the entry value 2
				<description>			
			</param>
		</out>
	</io>	
	// --->
<cfparam name="attributes.entrysection" default="" type="string">
<cfparam name="attributes.entryname" default="" type="string">
<cfparam name="attributes.defaultvalue1" default="" type="string">
<cfparam name="attributes.userid" type="numeric" default="0">
<cfparam name="attributes.userkey" type="string" default="">
<cfparam name="attributes.userparameter" type="string" default="">
<cfparam name="attributes.validuserparameters" type="string" default="">
<cfparam name="attributes.savesettings" type="boolean" default="false">
<cfparam name="attributes.setcallervariable1" type="string" default="">
<cfparam name="attributes.forceloadfromdatabase" type="boolean" default="false">

<cfif attributes.userid gt 0>
  <!--- userid is set by the custom tag ... --->
  <cfset a_int_userid = attributes.userid />
<cfelse>
  <!--- take the default value (stored in the request scope ... ) --->
  <cfset a_int_userid = request.stSecurityContext.myuserid />
</cfif>

<!--- are we getting the properties for the current user without any special handling? 
	usersettings also must exist for storing / accessing cached values --->
<cfset a_bol_using_current_user = (attributes.userid IS 0) AND
	 							  StructKeyExists(request, 'stUserSettings') />

<!--- hash id for cached values in various scopes ... --->
<cfset a_str_hash_id = Hash(a_int_userid & attributes.entrysection & attributes.entryname) />

<!--- force to load value from database or use cached value? ... --->
<cfif a_bol_using_current_user AND NOT attributes.forceloadfromdatabase>

	<!--- try to load the value from a stored property in usersettings scope --->
	<cfif StructKeyExists(request.stUserSettings.cached_personal_properties, a_str_hash_id)>

		<!--- cached version exists ... --->
		<cfset caller.a_str_person_entryvalue1 = request.stUserSettings.cached_personal_properties[a_str_hash_id] />
		
		<cfset variables.a_bol_userpref_item_exists = true />
		<cfset caller.a_bol_personentry_exists = true />
		
		<cfif len(attributes.setcallervariable1) gt 0>
			<!--- set a user defined variable in the caller scope ... --->
			<cfset caller[attributes.setcallervariable1] = caller.a_str_person_entryvalue1 />
		</cfif>
		
		<cfexit method="exittemplate">		
	
	</cfif>

</cfif>
		  
<cfset variables.a_bol_userpref_item_exists = false />

<cfif (len(attributes.userparameter) gt 0) AND (IsDefined(attributes.userparameter))>
	
	<!--- f.e. an URL parameter &pageview=2 --->	
	<cfset caller.a_bol_personentry_exists = true />
	<cfset caller.a_str_person_entryvalue1 = Evaluate(attributes.userparameter) />
	<cfset caller.a_str_person_entryvalue2 = '' />
	
<cfelse>
	
	<!--- lookup database ... --->
	<cfquery name="q_select_entry" datasource="#request.a_str_db_tools#">
	SELECT
		entryvalue1
	FROM
		userpreferences
	WHERE
		(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">)
		AND
		(entrysection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrysection#">)
		AND
		(entryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryname#">)
	; 
	</cfquery>
	
	<!--- use value or default value? --->
	<cfif q_select_entry.recordcount is 1>
		  <!--- item exists! --->	
		  <cfset caller.a_bol_personentry_exists = true />
		  <cfset caller.a_str_person_entryvalue1 = q_select_entry.entryvalue1 />
		  
		  <cfset variables.a_bol_userpref_item_exists = true />
		  		  
		  <!--- store values also in request.stUserSettings.personal_properties? --->
		  <cfif a_bol_using_current_user>
			  
			  <cflock scope="session" type="exclusive" timeout="3">
		  		<cfset session.stUserSettings.cached_personal_properties[a_str_hash_id] = q_select_entry.entryvalue1 />
		  		<cfset request.stUserSettings.cached_personal_properties[a_str_hash_id] = q_select_entry.entryvalue1 />
		   	  </cflock>
		  </cfif>
		
	  <cfelse>
	  
		  <cfset caller.a_bol_personentry_exists = false />
		  <cfset caller.a_str_person_entryvalue1 = attributes.defaultvalue1 />
		  
		  <!--- store values also in request.stUserSettings.personal_properties? --->
		  <cfif a_bol_using_current_user>
			 <cflock scope="session" type="exclusive" timeout="3">
		  		<cfset session.stUserSettings.cached_personal_properties[a_str_hash_id] = attributes.defaultvalue1 />
		  		<cfset request.stUserSettings.cached_personal_properties[a_str_hash_id] = attributes.defaultvalue1 />
		  	 </cflock>
		   </cfif>
	</cfif>

</cfif>

<cfif attributes.savesettings>
	<!--- save settings now ... --->
	<cfmodule template="saveuserpref.cfm"
		entrysection = #attributes.entrysection#
		entryname = #attributes.entryname#
		entryvalue1 = #caller.a_str_person_entryvalue1#
		userid = #val(a_int_userid)#
		userpref_item_exists = #variables.a_bol_userpref_item_exists#>
</cfif>

<cfif len(attributes.setcallervariable1) gt 0>
	<!--- set a user defined variable in the caller scope ... --->
	<cfset "caller.#attributes.setcallervariable1#" = caller.a_str_person_entryvalue1 />
</cfif>


