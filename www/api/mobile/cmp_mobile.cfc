<cfcomponent>
	<cfinclude template="/common/app/app_global.cfm">
	
	
	<cffunction access="remote" name="CreateSMSJobEdis" output="false" returntype="boolean">
		<cfargument name="sender" type="string" required="yes">
		<cfargument name="arecipient" type="string" required="yes">
		<cfargument name="text" type="string" required="yes">
		<cfargument name="username" type="string" required="yes">
		<cfargument name="ownnumberassender" type="boolean" required="no" default="true">
		
		<!---<cfif cgi.REMOTE_ADDR NEQ '81.223.48.140' OR cgi.REMOTE_ADDR NEQ '62.99.232.51'>
			<cfreturn false>
		</cfif>--->
		
		<cfif FindNoCase('00', arguments.sender) IS 1>
			<cfset arguments.sender = ReplaceNoCAse(arguments.sender, '00', '', 'ONE')>
		</cfif>
		
		<cfif FindNoCase('00', arguments.arecipient) IS 1>
			<cfset arguments.arecipient = ReplaceNoCAse(arguments.arecipient, '00', '', 'ONE')>
		</cfif>		
		
		<cfquery name="q_insert_sms" datasource="#request.a_str_db_mobile#">
		INSERT INTO
			sms2send
			(
			asender,
			arecipient,
			atext,
			ownnumberassender,
			dt_send
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.arecipient#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.text#">,
			1,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
			)
		;
		</cfquery>
		
		<cfreturn true>
		
	</cffunction>

</cfcomponent>