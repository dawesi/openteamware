<!--- //

	save the storage files to attach!!
	
	// --->
	
<cfset q_add_virtual_attachments = QueryNew("afilename,contenttype,location,asize")>
		
<cfloop index="a_int_id" list="#url.attachfiles#" delimiters=",">


	<!--- save now to temp dir ... --->
	<cfmodule template="../../common/savestoragefile.cfm"
		userid=#request.stSecurityContext.myuserid#
		id=#a_int_id#>
		
	<cfset a_str_location = request.a_str_temp_directory&atmpLocalFilenameOnly>

	<!--- add a new row ... --->
	
	<cfif fileexists(a_str_location)>
		<cfset tmp = QueryAddRow(q_add_virtual_attachments, 1)>
		<cfset a_int_recordcount = q_add_virtual_attachments.recordcount>
		<cfset tmp = QuerySetCell(q_add_virtual_attachments, "afilename", attachmentfilename, a_int_recordcount)>
		<cfset tmp = QuerySetCell(q_add_virtual_attachments, "contenttype", AttachmentContentType, a_int_recordcount)>
		<cfset tmp = QuerySetCell(q_add_virtual_attachments, "location", a_str_location, a_int_recordcount)>
		<cfset tmp = QuerySetCell(q_add_virtual_attachments, "asize", AttachmentFilesize, a_int_recordcount)>
	</cfif>

</cfloop>

<cfwddx action="cfml2wddx" input="#q_add_virtual_attachments#" output="a_str_output" usetimezoneinfo="yes">
<input type="hidden" name="frmq_virtual_attachments" value="<cfoutput>#htmleditformat(a_str_output)#</cfoutput>">