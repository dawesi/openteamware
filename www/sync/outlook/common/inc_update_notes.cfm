<!--- update notes --->



<cfloop from="1" to="#arraylen(a_array_return)#" index="ii">



	<cfset a_struct_element = a_array_return[ii]>

	

	<!--- parse lastmod date --->

	<cfset a_dt_lastmod = LsParseDateTime(a_struct_element.lastmodificationtime)>

	

	<!--- get out openTeamWare --->

	<cfset sEntrykey = Val(a_struct_element.inboxcc_entrykey)>

	

	<!--- select permissions ... --->

	<cfquery name="q_select_owner_userkey" datasource="#request.a_Str_db_office#">
	SELECT
		userkey
	FROM
		scratchpad
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
	;
	</cfquery>

	<cfset a_str_userkey = q_select_owner_userkey.userkey>

	<cfif a_str_userkey is session.securitycontext.myuserkey>

		<!--- update data --->
	

		<cfquery name="q_update_scratchpad" datasource="#request.a_Str_db_office#">
		UPDATE
			scratchpad
		SET
			subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(a_struct_element.subject, 1, 250)#" maxlength="250">,
			notice = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_element.body#">,
			dt_lastmodified = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_lastmod)#">
		WHERE
			userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">
			AND
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
		;
		</cfquery>

		<!--- update all meta data --->
		<cfquery name="q_update_notes_meta_data" datasource="#request.a_Str_db_office#">
		UPDATE
			scratchpad_outlook_id
		SET
			lastupdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_lastmod)#">
		WHERE
			scratchpad_entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">
		;
		</cfquery>

	</cfif>

</cfloop>