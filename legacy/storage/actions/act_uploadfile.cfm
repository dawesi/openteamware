<!--- //

	Module:		Storage
	Action:		Uploadfile
	Description: 
	

// --->


<!--- input variables --->
<cfparam name="form.frm_parentdirectorykey" default="" type="string">
<cfparam name="form.frm_entrykey" default="" type="string">
<cfparam name="url.force" default="false" type="boolean">

<cfoutput>#WriteSimpleHeaderDiv(getlangval('sto_ph_addfiles'))#</cfoutput>


<!--- could take a little longer ... --->
<cfparam name="url.requesttimeout" type="numeric" default="2000">

<!--- Retrieve the File and place it into a Variable --->
<cfset a_bool_loop_error_occurred = false />

<cfif not url.force>

	<cfset a_arr_fileinfos = ArrayNew(1) />
	
	
	<cfloop index="ii" from="1" to="5">
		<!--- execute upload for possibly five files --->
		<cfset a_str_FormFieldName = "form.frm_File" & ii />
	
		<!--- checken ob die sache definiert ist --->
		<cfif isDefined(a_str_FormFieldName)>
			<cfset AttachmentFileVal = evaluate("#a_str_FormFieldName#") />
	
			<cfif AttachmentFileVal NEQ "">
				
				<!--- ja, existiert --->
				<cfset a_str_newname = createUUID() />
				
				<cfset a_bol_error_occured = false />

				<cffile action="UPLOAD" filefield="#a_str_FormFieldName#" destination="#request.a_str_temp_directory##request.a_str_dir_separator#" nameconflict="MAKEUNIQUE">
				
				<cfif NOT a_bol_error_occured>
					<cfset a_struct_fileinfo = StructNew() />
				
					<!--- no error occured ... --->
					<cfset a_str_uploadedfilename = request.a_str_temp_directory & request.a_str_dir_separator & File.ServerFile />
	
					<!--- <li><img src="/images/si/accept.png" class="si_img" /> <cfoutput><b>#htmleditformat(file.ClientFile)#: OK.</b></cfoutput></li> --->
	
					<!--- execute virus check --->
					<!---
					<cfinvoke component="/components/tools/cmp_vc" method="checkfileforvirus" returnvariable="a_struct">
						<cfinvokeargument name="filename" value="#a_str_uploadedfilename#">
					</cfinvoke>
					--->
					
					<cfset a_struct=structnew() />
					<cfset a_struct["clean"] = TRUE />
					
					<cfset a_bol_clean = a_struct["clean"] />
	
					<cfif NOT a_bol_clean>
						<font style="color:Red;font-weight:bold;"><cfoutput>#GetLangVal('sto_ph_error_message_upload_virus')#</cfoutput></font>
						<cfabort>
					</cfif>
	
					<cfif Len(form.frm_entrykey) IS 0>
						<cfset a_str_newuuid=CreateUUID() />
					<cfelse>
						<cfset a_str_newuuid=form.frm_entrykey />
					</cfif>
					
					<cfset a_struct_fileinfo.file = duplicate(file) />
					<cfset a_struct_fileinfo.location=a_str_uploadedfilename />
					<cfset a_struct_fileinfo.directorykey=form.frm_parentdirectorykey />
					<cfset a_struct_fileinfo.entrykey=a_str_newuuid />
					<cfset temp=ArrayAppend(a_arr_fileinfos,a_struct_fileinfo) />
				</cfif>
	
			</cfif>
	
		</cfif>
	</cfloop>
<cfelse>

	<cfset a_arr_fileinfos=session.a_arr_fileinfos />
</cfif>

<!--- add now ... --->
<cfset a_arr_fileinfos_broken=ArrayNew(1) />

<ul>
<cfloop index="ii" from="1" to="#ArrayLen(a_arr_fileinfos)#">
	
		<cfinvoke component="#application.components.cmp_storage#"
			method="AddFile"
			returnVariable = "a_struct_result_add_file">
			<cfinvokeargument name="filename" value="#a_arr_fileinfos[ii].File.clientFile#">
			<cfinvokeargument name="location" value="#a_arr_fileinfos[ii].location#">
			<cfinvokeargument name="description" value="">
			<cfinvokeargument name="contenttype" value="#a_arr_fileinfos[ii].File.contentType#/#a_arr_fileinfos[ii].File.contentSubType#">
			<cfinvokeargument name="directorykey" value="#a_arr_fileinfos[ii].directorykey#">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="entrykey" value="#a_arr_fileinfos[ii].entrykey#">
			<cfinvokeargument name="filesize" value="#a_arr_fileinfos[ii].File.fileSize#">
			<cfinvokeargument name="forceoverwrite" value="#url.force#">
		</cfinvoke>
			
		<cfif NOT a_struct_result_add_file.result>
			<cfset a_struct_fileinfo.success = false />
			<cfset a_bool_loop_error_occurred = true />
			
			<cfoutput>
			Speichern der Datei #a_arr_fileinfos[ii].File.clientFile# ist fehlgeschlagen. Evt. existiert die Datei bereits.<br />
			</cfoutput>
			<cfset tmp=ArrayAppend (a_arr_fileinfos_broken,a_arr_fileinfos[ii]) />
		<cfelse>
			<cfoutput>
			<li><img src="/images/si/accept.png" class="si_img" /> #htmleditformat(a_arr_fileinfos[ii].File.clientFile)#</li><br>
			</cfoutput>

			<!--- tempor&auml;re datei auch l&ouml;schen --->
			<cftry>
			<cffile action="DELETE" file="#a_arr_fileinfos[ii].File.clientFile#">
			<cfcatch type="Any">&nbsp;</cfcatch>
			</cftry>

		</cfif>
</cfloop>
</ul>

<cfset a_arr_fileinfos=a_arr_fileinfos_broken />
<cfset session.a_arr_fileinfos=a_arr_fileinfos />

<cfinclude template="../dsp_uploadfile.cfm">

