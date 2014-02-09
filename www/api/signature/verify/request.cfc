<cfcomponent>

	<cffunction access="public" name="DoXMLVerifyRequest" output="false" returntype="string">
		<cfargument name="xmlrequest" type="string" required="yes">
		<cfargument name="jobkey" type="string" required="yes">
		
		<cfinvoke webservice="http://toolbox.openTeamWare.com:8080/services/signature/cmp_signature.cfc?WSDL" method="DoTrustDeskVerify" returnvariable="ab">
			<cfinvokeargument name="xmlrequest" value="#arguments.xmlrequest#">
			<cfinvokeargument name="jobkey" value="#arguments.jobkey#">
		</cfinvoke>
		
		<cfreturn ab>
		
	</cffunction>

</cfcomponent>