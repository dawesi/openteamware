<!--- //

	Module: Address Book
	
// --->


<cfinclude template="/login/check_logged_in.cfm">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cfabort>
</cfif>

<!--- params --->
<cfparam name="form.frmcontactkey" type="string">
<cfparam name="form.frmdirectorykey" type="string" default="">
<cfparam name="form.frmdescription" type="string" default="">

<!--- try to upload the file --->
<cftry>
<cffile action="upload" destination="#request.a_str_temp_directory#" filefield="frmfile" nameconflict="makeunique">

<cfcatch type="any">
	<h4>upload failed.</h4>
	<cfabort>
</cfcatch>
</cftry>

<cfset a_str_contenttype = cffile.contenttype & '/' & cffile.contentSubType>
<cfset sFilename = cffile.clientfile>
<cfset a_int_filesize = cffile.filesize>
<cfset a_str_file_on_disk = cffile.serverdirectory & request.a_str_dir_separator & cffile.serverfile>

<cfset form.frmdescription = form.frmdescription & ' ' & request.stSecurityContext.myusername>

<cfset a_cmp_sales = application.components.cmp_crmsales />

<cfif Len(form.frmdirectorykey) IS 0>
	<!--- get home directory of this contact in the storage ... --->
	<cfset a_cmp_sales.CheckAndCreateDirectoryForContactInStorage(securitycontext = request.stSecurityContext,
					usersettings = request.stUserSettings,
					contactkey = form.frmcontactkey)>
					
	<cfset sDirectorykey = a_cmp_sales.GetStorageDirectoryKeyOfContact(securitycontext = request.stSecurityContext,
					usersettings = request.stUserSettings,
					contactkey = form.frmcontactkey)>
					
	<cfset form.frmdirectorykey = sDirectorykey>	
	
	<cfoutput>#form.frmdirectorykey#</cfoutput>
</cfif>


<cfinvoke component="#a_cmp_sales#" method="AddFileAttachedToUser" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkey" value="#form.frmcontactkey#">
	<cfinvokeargument name="directorykey" value="#form.frmdirectorykey#">
	<cfinvokeargument name="filename" value="#sFilename#">
	<cfinvokeargument name="file_on_disk" value="#a_str_file_on_disk#">
	<cfinvokeargument name="contenttype" value="#a_str_contenttype#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="categories" value="#form.frmcategories#">
	<cfinvokeargument name="filesize" value="#a_int_filesize#">
</cfinvoke>

<cfif stReturn.result>

<html>
	<head>
		<title><cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput></title>
		<script type="text/javascript">
			function DoCloseWindow()
				{
				// opener.DisplayFilesAttachedToContact('<cfoutput>#jsstringformat(form.frmcontactkey)#</cfoutput>', '', 'id_div_storage_files_user_');
				alert('File added.');
				window.close();
				}
		</script>
	</head>
	<body onLoad="DoCloseWindow();" style="padding:40px;text-align:center; ">
		<a href="javascript:DoCloseWindow();"><cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput></a>
	</body>
</html>

<cfelse>

</cfif>
