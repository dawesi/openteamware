<!--- //

	Component:	Render
	Function:	GenerateServiceDefaultFile
	Description:Modify request if needed ...
	
// --->

<!--- modify page type of request ... (e.g. force inpage type) --->
<cfif StructKeyExists(url, 'forcepagetype')>
	<cfset request.a_struct_current_service_action.type = url.forcepagetype>
</cfif>

<!--- 
	
	extract a certain portion of the page?

 --->
<cfif !IsNull( url.extractcontentid ) AND Len( url.extractcontentid )>
	<cfset request.a_struct_current_service_action.sExtractContentID = url.extractcontentid />
<cfelse>
	<cfset request.a_struct_current_service_action.sExtractContentID = '' />
</cfif>


<!--- which format? --->
<cfif !ISNull( url.format ) AND Len( url.format )>
	<cfset request.a_struct_current_service_action.sFormat = url.format />	
<cfelse>
	<cfset request.a_struct_current_service_action.sFormat = 'html' />
</cfif>