<cfcomponent output='false'>

	<cfinclude template="/common/scripts/script_utils.cfm">
	<cfinclude template="/common/app/app_global.cfm">
	
	<cffunction access="public" name="CreateXMLSignatureRequest" output="false" returntype="string" hint="
		returns a full CreateXMLSignatureRequest xml request">
		<cfargument name="mimetype" type="string" default="text/html" required="no">
		<cfargument name="attachments" type="array" default="#ArrayNew(1)#" required="no" hint="array of attachments">
		<cfargument name="bodycontent" type="string" required="yes" hint="body of the message (will be signed)">
		
		<cfset var a_str_xml = ''>
		
		<cfinclude template="utils/inc_create_xml_sig_req.cfm">
		
		<cfset a_str_xml = ToString(a_str_xml)>

		<!--- bug of cfmx: % will not stay escaped ... --->
		<cfset a_str_xml = ReplaceNoCase(a_str_xml, '%', '&##37;', 'ALL')>
		
		<cfreturn a_str_xml>	
	</cffunction>
	
	<cffunction access="public" name="GenerateXMLHTMLContentBody" output="false" returntype="string" hint="
		return the body in xml format (build, formatted and so on)">
		<cfargument name="jobkey" type="string" required="yes" hint="the entrykey of the job (will be included for reference)">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="to" type="string" required="yes">
		<cfargument name="text_body" type="string" required="yes">
		<cfargument name="attachments" type="array" default="#ArrayNew(1)#" required="no" hint="array of attachments">
		<cfargument name="use_fixed_font" type="boolean" default="false" required="no" hint="proportional or fixed">
		
		<cfset sReturn = ''>
		
		<cfinclude template="utils/inc_build_html_body.cfm">
		
		<cfreturn sReturn>
	</cffunction>
	
	<cffunction access="public" name="CheckA1SignatureStatus" output="false" returntype="query" hint="
		return the status (check if the a1 application has returned something)">
		<cfargument name="jobkey" type="string" required="yes">
		
		
	
	</cffunction>
	
	<cffunction access="public" name="CreateVerificationAttachment" output="false" returntype="string"
		hint="Create a html file that acts as attachment and verification file">
		<cfargument name="jobkey" type="string" required="yes">
		
		<cfset var sReturn = ''>
		
		<cfinclude template="utils/inc_create_verification_file.cfm">
		
		<cfreturn sReturn>		
	</cffunction>
	
	<cffunction access="public" name="ContactA1SignatureService" output="false" returntype="numeric" hint="
		0 = ok, other values == error ...">
		
	
	
	</cffunction>

</cfcomponent>