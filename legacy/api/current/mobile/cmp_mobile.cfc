<cfcomponent output=false>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="../../scripts/scripts_ws.cfm">
	
	<cffunction access="remote" name="SendSimpleSMS" output="false" returntype="string">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="entrykey of application">
		<cfargument name="sender" type="string" required="yes" hint="sender of sms">
		<cfargument name="recipient" type="string" required="yes" hint="recipient of sms in form +[country code] [network code] [numer]">
		<cfargument name="text" type="string" required="yes" hint="text of sms to send ... max. 160 chars">
		<cfargument name="dt_send" type="date" required="yes" hint="when to send this message">
		
		<cfset var stReturn = GenerateDefaultReturnStructure()>		
		
		<cfinclude template="../../security/inc_check_app_security.cfm">
		<cfinclude template="../../session/inc_check_session.cfm">
					
		<cfif (Len(arguments.text) IS 0) OR (Len(arguments.text) GT 160)>
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(901, stReturn)>
		</cfif>
		
		<!--- punktesystem?? --->
		
		<!--- recipient? --->
		<cfif (Len(arguments.recipient) LT 10)>
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(902, stReturn)>
		</cfif>
		
		<cfinvoke component="/components/mobile/cmp_sms" method="SendSMSEx" returnvariable="stReturn_sms">
			<cfinvokeargument name="securitycontext" value="#application.directaccess.securitycontext[arguments.clientkey]#">
			<cfinvokeargument name="usersettings" value="#application.directaccess.usersettings[arguments.clientkey]#">			
			<cfinvokeargument name="body" value="#arguments.text#">
			<cfinvokeargument name="sender" value="#arguments.sender#">
			<cfinvokeargument name="recipient" value="#arguments.recipient#">
			<cfinvokeargument name="dt_2send" value="#arguments.dt_send#">
		</cfinvoke>
		
		<cfset stReturn.debitpoints = stReturn_sms.debitpoints>
		
		<cfif NOT stReturn_sms.result>
			<!--- an error occured --->
			<cfreturn SetErrorMessageByNumberAndReturnXMLResponse(900, stReturn)>
		</cfif>
		
		<cfreturn GenerateReturnXMLDocumentFromReturnStructure(SetResultOK(stReturn))>
		
	</cffunction>
	
</cfcomponent>