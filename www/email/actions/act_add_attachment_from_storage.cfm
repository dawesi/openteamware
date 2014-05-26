<!--- //

	Module:		Email
	Description:add an attachment from the storage ... 
	

// --->

<cfinclude template="/login/check_logged_in.cfm">

<!--- load IMAP access data --->
<cfinclude template="../utils/inc_load_imap_access_data.cfm">

<!--- the IDs of the storage files ... --->
<cfparam name="form.frmFilesentrykeys" type="string" default="">

<!--- id of the draft message ... --->
<cfparam name="form.frmid" type="numeric" default="0">

<!--- the foldername --->
<cfparam name="form.frmmailbox" type="string" default="INBOX.Drafts">


<!--- create the new query for our files ... --->
<cfset q_add_attachments = QueryNew("afilename,contenttype,location") />

<cfloop index="sEntrykey" list="#form.frmFilesentrykeys#" delimiters=",">
	<!--- load file ... --->
	
		<!--- get information ... --->
	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetFileInformation"   
		returnVariable = "a_struct_file_info"   
		entrykey = "#sEntrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		version="-1"
		download=true>
	</cfinvoke>
	
	<cfif NOT a_struct_file_info.result>
		Invalid file selected. Please contact the support.
		<cfexit method="exittemplate">
	</cfif>
		 
		 <cfset q_query_file = a_struct_file_info.q_select_file_info />
		
		<cfset a_str_temp_filename = request.a_str_temp_directory_local & CreateUUID()>
		<cfset sFilename = q_query_file.storagepath&request.a_str_dir_separator&q_query_file.storagefilename>

		<cffile action="copy" source="#sFilename#" destination="#a_str_temp_filename#">
			
		<cfset a_str_location = a_str_temp_filename>

		<cfif fileexists(a_str_location)>
		
			<!--- add a row ... --->
			<cfset tmp = QueryAddRow(q_add_attachments, 1)>
			<cfset tmp = QuerySetCell(q_add_attachments, "afilename", q_query_file.filename, q_add_attachments.recordcount)>
			<cfset tmp = QuerySetCell(q_add_attachments, "contenttype", q_query_file.contenttype, q_add_attachments.recordcount)>
			<cfset tmp = QuerySetCell(q_add_attachments, "location", a_str_location, q_add_attachments.recordcount)>
	
		</cfif>

</cfloop>



<cfif q_add_attachments.recordcount gt 0>


	<!--- we have to preserve the content-types ... --->
	<cfinvoke component="/components/email/cmp_message" method="addattachment" returnvariable="stReturn">
		<cfinvokeargument name="uid" value="#form.frmid#">
		<cfinvokeargument name="foldername" value="#form.frmmailbox#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">			
		<cfinvokeargument name="attachments" value="#q_add_attachments#">
	</cfinvoke>
	
	<!--- add now the new attachment ... --->	
	<cfset a_int_uid = stReturn["uid"]>
	<cfset a_str_mailbox = form.frmmailbox>
	
	<!--- forward ... --->
	<cflocation addtoken="no" url="../index.cfm?action=ComposeMail&type=0&draftid=#a_int_uid#&mailbox=#urlencodedformat(a_str_mailbox)#">
<cfelse>

	<!--- no attachments have been added ... return to original message ... --->
	<cflocation addtoken="no" url="../index.cfm?action=ComposeMail&type=0&draftid=#form.frmid#&mailbox=#urlencodedformat(form.frmmailbox)#">
</cfif>


