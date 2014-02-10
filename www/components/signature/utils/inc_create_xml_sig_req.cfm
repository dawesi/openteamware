<!---  xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" --->

<cfxml variable="a_str_xml">
<sl:CreateXMLSignatureRequest xmlns:sl="http://www.buergerkarte.at/namespaces/securitylayer/1.2#">
	
	<!--- use secure keypair --->
	<sl:KeyboxIdentifier>SecureSignatureKeypair</sl:KeyboxIdentifier>
	
	<!--- enveloping ... use all data --->
	<sl:DataObjectInfo Structure="enveloping">
	
		<!--- body --->
		<sl:DataObject>
		
			<sl:XMLContent>
				<cfoutput>#arguments.bodycontent#</cfoutput>
			</sl:XMLContent>
		
		</sl:DataObject>
		
		<!--- contenttype --->
		<sl:TransformsInfo>
		
			<sl:FinalDataMetaInfo>
				<sl:MimeType><cfoutput>#arguments.mimetype#</cfoutput></sl:MimeType>
			</sl:FinalDataMetaInfo>
		
		</sl:TransformsInfo>
		
		<!--- "attachments" --->
		<cfif ArrayLen(arguments.attachments) GT 0>
		<sl:Supplement>
			
			<cfloop from="1" to="#ArrayLen(arguments.attachments)#" index="ii">
			<sl:Content Reference="http://192.168.0.1/att_#ii#.jpg">
				<sl:Base64Content>/9j/4AAQSkZJRgABAQEAAAAAABRRRQB//2Q==</sl:Base64Content>
			</sl:Content>
			</cfloop>
		
		</sl:Supplement>
		</cfif>
	</sl:DataObjectInfo>

</sl:CreateXMLSignatureRequest>
</cfxml>