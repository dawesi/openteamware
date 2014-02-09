<cfcomponent output=false>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="../../scripts/scripts_ws.cfm">
	
	<cffunction access="remote" name="DecodeBase64String" output="false" returntype="string">
		<cfargument name="input" type="string" required="yes">		
		<cfreturn tostring(toBinary(arguments.input))>
	</cffunction>
	
	<cffunction access="remote" name="GetHashValueOfString" output="false" returntype="string" hint="return the MD5 hash of a string">
		<cfargument name="input" type="string" required="yes" hint="string value">
		<cfreturn Hash(arguments.input)>
	</cffunction>
	
	<cffunction access="remote" name="GetInBoxccLinkForElement" output="false" returntype="string" hint="return the URI for a specified element">
		<cfargument name="service" type="string" required="yes" hint="name of service">
		<cfargument name="entrykey" type="string" required="yes" hint="id of element">
		
		<cfif Len(arguments.service) IS 0>
			<cfreturn 'https://www.openTeamWare.com/'>
		</cfif>
		
		<cfif Len(arguments.entrykey) IS 0>
			<cfreturn 'https://www.openTeamWare.com/'>
		</cfif>		
		
		<cfswitch expression="#arguments.service#">
			<cfcase value="contacts">
				<cfreturn 'https://www.openTeamWare.com/addressbook/?action=ShowItem&entrykey=' & urlencodedformat(arguments.entrykey)>
			</cfcase>
			<cfdefaultcase>
				<cfreturn 'https://www.openTeamWare.com/'>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction access="remote" name="GetFieldInformation" returntype="string" output="false" hint="Get information about fields of a specified service">
		<cfargument name="clientkey" type="string" required="true" hint="clientkey in various formats">
		<cfargument name="applicationkey" type="string" required="yes" hint="entrykey of application">
		<cfargument name="service" type="string" required="yes" hint="name of service">
		
		<cfset var stReturn = GenerateDefaultReturnStructure()>		
		
		<cfinclude template="../../security/inc_check_app_security.cfm">
		<cfinclude template="../../session/inc_check_session.cfm">			
		
		<cfinclude template="utils/inc_field_information_contacts.cfm">
		
		<cfreturn GenerateReturnXMLDocumentFromReturnStructure(SetResultOK(stReturn))>
	
	</cffunction>
	
</cfcomponent>	