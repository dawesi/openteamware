<!--- //

	TODO: hp: modify and clean up code

//--->

<cfset a_str_userkey = application.components.cmp_user.GetEntrykeyFromUsername(arguments.username)>
<cfset a_cmp_load_msg = CreateObject('component', '/components/email/cmp_loadmsg')>

<!--- schedule a lookup job ... in this case we've got to load the message-id --->

<cfloop list="#arguments.uid#" index="a_int_uid" delimiters=",">

	<!--- delete old reference information ... --->
	<cfquery name="q_update_references_information" datasource="#request.a_str_db_tools#">
	DELETE FROM
		emailmetadata_information
	WHERE
		foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sourcefolder#">
		AND
		uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_uid#">
		AND
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">
	;
	</cfquery>
	
	<!--- try to load data from mailspeed database ... --->
	<cfif (request.appsettings.properties.MailSpeedEnabled IS 1)>
	
		<cfquery name="q_select_mailspeed_item_exists" datasource="#request.a_str_db_email#">
		SELECT
			messageid
		FROM
			folderdata
		WHERE
			(account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">)
			AND
			(uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_uid#">)
			AND
			(foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sourcefolder#">)
		;
		</cfquery>
		
	<cfelse>
	
		<cfset q_select_mailspeed_item_exists = QueryNew('abc') />
	
	</cfif>

	<cfif q_select_mailspeed_item_exists.recordcount IS 1>
		<!--- ok, here we go ... --->
		
		<cfset a_str_message_id = '<' & q_select_mailspeed_item_exists.messageid & '>'>
		
	<cfelse>
		<!--- no information found - load the message and parse ... --->
		<cfset a_str_message_id = ''>
		
		<cftry>
			<cfinvoke component="#a_cmp_load_msg#" method="LoadMessage" returnvariable="stReturn">
				<cfinvokeargument name="server" value="#arguments.server#">
				<cfinvokeargument name="username" value="#arguments.username#">
				<cfinvokeargument name="password" value="#arguments.password#">
				<cfinvokeargument name="foldername" value="#arguments.sourcefolder#">
				<cfinvokeargument name="uid" value="#a_int_uid#">
				<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory_local#">
				<cfinvokeargument name="savecontenttypes" value="dsfiub/sdfiub">
			</cfinvoke>
			
			<cfif StructKeyExists(stReturn, 'query')>
				<cfset a_str_message_id = stReturn.query.messageid>
			</cfif>
			
		<cfcatch type="any">
		</cfcatch>
		</cftry>
		
	</cfif>
	

	
	<cfif Len(a_str_message_id) GT 0>
		<!--- here we go ... --->
		<cfquery name="q_insert_lookup_job" datasource="#request.a_str_db_tools#">
		INSERT INTO
			lookupuidjobs
			(
			username,
			messageid,
			status,
			reference_ids,
			fullfoldername
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_message_id#">,
			0,
			<!--- do not touch the references item ... --->
			'',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.destinationfolder#">
			)
		;
		</cfquery>
	</cfif>
	
	

</cfloop>