<!--- //

	Module:		Address Book
	Action:		ShowContactPhoto
	Description: 
	
// --->

<cfparam name="url.entrykey" type="string">

<cfset sFilename = application.components.cmp_addressbook.GetPhotoDefaultFilename(entrykey = url.entrykey) />

<cfif FileExists(sFilename)>
	<cfcontent file="#sFilename#" type="image/jpeg" deletefile="false">
</cfif>
