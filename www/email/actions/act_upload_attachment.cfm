<!--- //

	Module:		E-Mail
	Description:upload an attachment now
	

// --->

<!--- <cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="upload operation ..." type="html">
<cfdump var="#cookie#" label="cookies">
<cfdump var="#client#" label="client">
<cfdump var="#form#" label="form">
<cfdump var="#session#" label="session">
<cfdump var="#cgi#" label="cgi">
<cfdump var="#url#" label="url">
</cfmail> --->

<cfinclude template="../../login/check_logged_in.cfm">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="default.cfm?action=ComposeMail">
</cfif>

<cfinclude template="../utils/inc_load_imap_access_data.cfm">

<!--- the uid of the email --->
<cfparam name="form.frmid" type="numeric" default="0">

<!--- the foldername --->
<cfparam name="form.frmmailbox" type="string" default="INBOX.Drafts">

<!--- the sub action ... --->
<cfparam name="url.subaction" type="string" default="">
<!--- properties in case of multiple file upload operations --->
<cfparam name="url.uid" type="string" default="">
<cfparam name="url.foldername" type="string" default="INBOX.Drafts">

<!--- create the new query holding our files to add to the message ... --->
<cfset q_add_attachments = QueryNew("afilename,contenttype,location,clientfile", 'VarChar,VarChar,VarChar,VarChar') />

<!--- check for a certain sub action ... a single file of a multiple file upload operation has been uploaded --->
<cfif url.subaction IS 'uploadsinglefile'>


	<!--- insert new temp item --->
	<cfset a_new_item = application.components.cmp_dao_office.new( 'Messaging.EmailAttachment' ) />
	
	<cffile action="upload" filefield="filedata" nameconflict="makeunique" destination="#request.a_str_temp_directory_local#">

	<!--- the uploaded file --->
	<cfset a_str_uploaded_file = request.a_str_temp_directory_local & request.a_str_dir_separator & file.ServerFile />
	
	<cfinvoke component="/components/tools/cmp_vc" method="checkfileforvirus" returnvariable="a_struct">
		<cfinvokeargument name="filename" value="#a_str_uploaded_file#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	</cfinvoke>

	<!--- is the file clean? --->
	<cfif a_struct.clean>
	
		<cfset a_new_item.setUsername( request.stSecurityContext.myusername ) />
		<cfset a_new_item.setfoldername ( url.foldername ) />
		<cfset a_new_item.setUID ( url.uid ) />
		<cfset a_new_item.setFilename ( form.filename ) />
		<cfset a_new_item.setcontenttype ( application.components.cmp_tools.GetContentTypeByFilename( a_str_uploaded_file ) ) />
		<cfset a_new_item.setfilepath ( cffile.ServerDirectory &  '/' & cffile.ServerFile ) />
		
		<cfset application.components.cmp_dao_office.save( a_new_item ) />
	
	</cfif>

	<cfexit method="exittemplate">
</cfif>

<!--- multiple upload has been done --->
<cfif url.subaction IS 'multiuploaddone'>
	
	<!--- get the uploaded attachments ... --->
	<cfquery name="q_select_uploaded_attachments" datasource="#request.a_str_db_tools#">
	SELECT
		*
	FROM
		emailattachments
	WHERE
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
		AND
		uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.uid#">
		AND
		foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.foldername#">
	;
	</cfquery>
	
	<cfif q_select_uploaded_attachments.recordcount IS 0>
		<!--- no attachments have been added ... return to original message ... --->
		<cflocation addtoken="no" url="../default.cfm?action=ComposeMail&type=0&draftid=#urlencodedformat(url.uid)#&mailbox=#urlencodedformat(url.foldername)#">
	</cfif>
	
	<cfdump var="#q_select_uploaded_attachments#">
		
	<!--- add to virtual query --->
	<cfloop query="q_select_uploaded_attachments">
		
		<cfset tmp = QueryAddRow(q_add_attachments, 1) />
		<cfset tmp = QuerySetCell(q_add_attachments, "afilename", q_select_uploaded_attachments.filename, q_add_attachments.recordcount) />
		<cfset tmp = QuerySetCell(q_add_attachments, "contenttype", q_select_uploaded_attachments.ContentType, q_add_attachments.recordcount) />
		<cfset tmp = QuerySetCell(q_add_attachments, "location", q_select_uploaded_attachments.filepath, q_add_attachments.recordcount) />
		
	</cfloop>
	
	<!--- we have to preserve the content-types ... --->
	<cfinvoke component="/components/email/cmp_message" method="addattachment" returnvariable="stReturn">
		<cfinvokeargument name="uid" value="#url.uid#">
		<cfinvokeargument name="foldername" value="#url.foldername#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory_local#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="attachments" value="#q_add_attachments#">
	</cfinvoke>
	
	<!--- add now the new attachment ... --->
	<cfset a_int_new_uid = stReturn.uid />
	
	<!--- delete now the old drafts message ... --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_msg">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="uids" value="#url.uid#">
		<cfinvokeargument name="foldername" value="#url.foldername#">
	</cfinvoke>
		
	<!--- delete old attachment meta info --->
	<cfquery name="q_delete_uploaded_attachments" datasource="#request.a_str_db_tools#">
	DELETE FROM
		emailattachments
	WHERE
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
		AND
		uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_uid#">
		AND
		foldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.foldername#">
	;
	</cfquery>
	
	<!--- forward ... --->
	<cflocation addtoken="no" url="../default.cfm?action=ComposeMail&type=0&draftid=#a_int_new_uid#&mailbox=#urlencodedformat(url.foldername)#">


</cfif>

<!--- old way follows ... only executed if new one does not work ... --->

<cfloop index="ii" from="1" to="5">

	<cfset a_Str_form_field_name = "form.frmfileupload" & ii />

	<cfif isDefined(a_str_form_field_name)>

		<cfset a_str_att_filename_val = evaluate("#a_str_form_field_name#") />

		<cfif Len(a_str_att_filename_val) GT 0>

			<!--- create a virtual directory ... --->
			<cfset a_str_destination_filename = request.a_str_temp_directory_local & request.a_str_dir_separator & 'emailatt_' & CreateUUID() />
			
			<cftry>
			<cffile action="UPLOAD"
				filefield="#a_str_form_field_name#"
				destination="#a_str_destination_filename#"
				nameconflict="MAKEUNIQUE">
			<cfcatch type="any">
				
				<font style="color:red;font-weight:bold;">
				<cfoutput>
					#cfcatch.Message#
				</cfoutput>
				</font>
				<br /><br />
				<a href="javascript:history.go(-1);">zurueck zur letzten Seite ...</a>
				
				<cfabort>
				
			</cfcatch>
			</cftry>
			
			<cfset a_str_client_file = GetDirectoryFromPath(file.ClientDirectory) & file.ClientFile />
			
			<cfset sFilename = file.ClientFile />
			<cfset a_str_uploaded_file = file.ServerDirectory&request.a_str_dir_separator&file.ServerFile />
			
			<!--- check now for viruses ... --->
			<cfinvoke component="/components/tools/cmp_vc" method="checkfileforvirus" returnvariable="a_struct">
				<cfinvokeargument name="filename" value="#a_str_uploaded_file#">
				<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
			</cfinvoke>

			<cfset a_bol_clean = a_struct.clean />


			<cfif a_bol_clean>
				<!--- ok, add now ... --->
				<cfset tmp = QueryAddRow(q_add_attachments, 1) />
				<cfset tmp = QuerySetCell(q_add_attachments, "afilename", sFilename, q_add_attachments.recordcount) />
				<cfset tmp = QuerySetCell(q_add_attachments, "contenttype", file.ContentType&"/"&file.ContentSubType, q_add_attachments.recordcount) />
				<cfset tmp = QuerySetCell(q_add_attachments, "location", a_str_uploaded_file, q_add_attachments.recordcount) />
				<cfset tmp = QuerySetCell(q_add_attachments, 'clientfile', a_str_client_file, q_add_attachments.recordcount) /> 

			<cfelse>
			
				<h4>Die von Ihnen gewaehlte Datei ist mit einem Virus infiziert.</h4>
				<a href="javascript:history.back();">zurueck</a>
				
				<cfdump var="#a_struct#">
				
				<cfexit method="exittemplate">

			</cfif>

		</cfif>

	</cfif>

</cfloop>

<!--- do we have any new attachments? --->
<cfif q_add_attachments.recordcount GT 0>

	<!--- we have to preserve the content-types ... --->
	<cfinvoke component="/components/email/cmp_message" method="addattachment" returnvariable="stReturn">
		<cfinvokeargument name="uid" value="#form.frmid#">
		<cfinvokeargument name="foldername" value="#form.frmmailbox#">
		<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="attachments" value="#q_add_attachments#">
		
		<!--- add virtual headers ... --->
	</cfinvoke>

	<!--- add now the new attachment ... --->
	<cfset a_int_uid = stReturn.uid />
	<cfset a_str_mailbox = form.frmmailbox />
	
	
	<cfoutput query="q_add_attachments">
		<cfquery name="q_insert_att" datasource="#request.a_str_db_tools#">
		INSERT INTO
			emailattachments
			(
			username,
			foldername,
			uid,
			filename,
			filepath,
			contenttype,
			messageid
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_mailbox#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_uid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GetFileFromPath(q_add_attachments.clientfile)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_add_attachments.clientfile#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_add_attachments.contenttype#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#stReturn.message_id#">
			)
		;
		</cfquery>
	</cfoutput>
	
	<cfquery name="q_update_uid_attachments" datasource="#request.a_str_db_tools#">
	UPDATE
		emailattachments
	SET
		uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_uid#">
	WHERE
		uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmid#">
		AND
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
	;
	</cfquery>
	
	<!--- delete now the old drafts message ... --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_struct_delete_msg">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="uids" value="#form.frmid#">
		<cfinvokeargument name="foldername" value="#form.frmmailbox#">
	</cfinvoke>

	<!--- forward ... --->
	<cflocation addtoken="no" url="../default.cfm?action=ComposeMail&type=0&draftid=#a_int_uid#&mailbox=#urlencodedformat(a_str_mailbox)#">
<cfelse>

	<!--- no attachments have been added ... return to original message ... --->
	<cflocation addtoken="no" url="../default.cfm?action=ComposeMail&type=0&draftid=#form.frmid#&mailbox=#urlencodedformat(form.frmmailbox)#">

</cfif>


