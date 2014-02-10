<!--- //

	Component:	Signature
	Description:Do some signature parts ...
	

// --->

<cfcomponent output="false">

	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="TransformSignatureReponseToVerifyRequest" output="false" returntype="struct"
			hint="transform to valid verify request">
		<cfargument name="a_str_create_response_xml" type="string" required="true"
			hint="XML object represented as string ...">
		<cfargument name="signature_type" type="string" required="true" default="default"
			hint="type ... default = trustdesk, a1 = a1 signature ... maybe needed if there are differences between the two formats">
			
		<cfset var stReturn = GenerateReturnStruct()>
		<cftry>
            
		    <cfscript>
		            responseXmlDoc = XmlParse(arguments.a_str_create_response_xml);
		
		            //get the signature response
		            responseContent = XmlSearch(responseXmlDoc, "//*[local-name()='CreateXMLSignatureResponse']");
		            
		            //create verify
		            responseContentStr = toString(responseContent[1].XmlChildren[1]);
		            responseContentStr = Right(responseContentStr, Len(responseContentStr) - Len('<?xml version="1.0" encoding="UTF-8"?>'));
		            verifyRequest = '<?xml version="1.0" encoding="UTF-8"?>' & Chr(13) & Chr(10) & '<sl11:VerifyXMLSignatureRequest xmlns:sl11="http://www.buergerkarte.at/namespaces/securitylayer/20020831##" xmlns:dsig="http://www.w3.org/2000/09/xmldsig##" xmlns:sl10="http://www.buergerkarte.at/namespaces/securitylayer/20020225##"><sl11:SignatureInfo><sl11:SignatureEnvironment><sl10:XMLContent>' 
		                            & responseContentStr & '</sl10:XMLContent></sl11:SignatureEnvironment><sl11:SignatureLocation xmlns:dsig="http://www.w3.org/2000/09/xmldsig##">/dsig:Signature</sl11:SignatureLocation></sl11:SignatureInfo></sl11:VerifyXMLSignatureRequest>';

		    </cfscript>
            
            <cfset stReturn.a_xml_verify_request = verifyRequest >
    		<cfreturn SetReturnStructSuccessCode(stReturn)>		
    		
	        <cfcatch type="any">
                <cfset stReturn.catch_exception = cfcatch>
	    		<cfreturn SetReturnStructErrorCode(stReturn, 999)>
		    </cfcatch>
        </cftry>
	</cffunction>

</cfcomponent>

