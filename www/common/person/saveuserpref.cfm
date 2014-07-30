<cfsetting enablecfoutputonly="yes">
<!--- //

	Module:		Framework
	Description:Save personal preference
	

	
	
	<param name="entrysection" scope="attributes" required="true" type="string" length=160 default="" />
	<param name="entryname" scope="attributes" required="true" type="string" length=255 default="" />
	<param name="entryvalue1" scope="caller" default="" type="string" />
	
// --->

<cfparam name="attributes.entrysection" default="" type="string">
<cfparam name="attributes.entryname" default="" type="string">
<cfparam name="attributes.entryvalue1" default="" type="string">
<cfparam name="attributes.entryvalue2" default="" type="string">
<cfparam name="attributes.userid" type="numeric" default="0">
<cfparam name="attributes.userpref_item_exists" type="boolean" default="false">

<cfif attributes.userid GT 0>
  <!--- userid is set by the custom tag ... --->
  <cfset a_int_userid = attributes.userid />
<cfelse>
  <!--- take the default value (stored in the request scope ... ) --->
  <cfset a_int_userid = request.stSecurityContext.myuserid />
</cfif>

<cfset a_str_hash_id = Hash(UCase(a_int_userid & attributes.entrysection & attributes.entryname)) />

<cfset a_bol_value_cached = StructKeyExists(request, 'stUserSettings') AND
						    StructKeyExists(request.stUserSettings, 'cached_personal_properties') AND
							StructKeyExists(request.stUserSettings.cached_personal_properties, a_str_hash_id) />

<!--- if a cached value exist, set it to new value now ... --->	
<cfif a_bol_value_cached>
	
	<!--- in session PLUS in request ... --->
	 <cflock name="lck_set_sess_vars_cache_prop" type="exclusive" timeout="3">
		<cfset session.stUserSettings.cached_personal_properties[a_str_hash_id] = attributes.entryvalue1 />
	 </cflock>
	
	<cfset request.stUserSettings.cached_personal_properties[a_str_hash_id] = attributes.entryvalue1 />
</cfif>

<!--- check if item exists ... --->
<cfif NOT attributes.userpref_item_exists>
	<!--- check database ... otherwise, we've received the paramter about the existance
		from the getuserpref.cfm template --->
	<cfquery name="q_select_userpref_item_exists">
	SELECT
		COUNT(id) AS count_id
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
	
	<cfset attributes.userpref_item_exists = (q_select_userpref_item_exists.count_id IS 1) />
</cfif>

<cfif NOT attributes.userpref_item_exists>
	<!--- new item ... insert --->
	
	  <cfquery name="q_insert_person_entry">
	  INSERT INTO
		userpreferences
		(
		userid,
		entrysection,
		entryname,
		entryvalue1,
		entryvalue2,
		md5_section_entryname
		) 
	  VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrysection#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryname#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryvalue1#">, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryvalue2#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(attributes.entrysection & attributes.entryname)#">
		)
	  ; 
	  </cfquery>
	
<cfelse>
	<!--- existing item ... update! --->
	  <cfquery name="q_update_userpref_item">
	  UPDATE
		userpreferences
		SET
			entryvalue1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryvalue1#">, 
			entryvalue2 =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryvalue2#">
		WHERE
			(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">)
			AND
			(entrysection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entrysection#">)
			AND
			(entryname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.entryname#">)
		;
	  </cfquery>
</cfif>
	
<cfsetting enablecfoutputonly="no">