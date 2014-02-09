<cfinclude template="/login/check_logged_in.cfm">
<cfinclude template="/email/utils/inc_load_imap_access_data.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="form.FRMDIRECTORYKEY" type="string" default="">


<cfif Len(form.FRMDIRECTORYKEY) IS 0>
	<h4>Please select a directory</h4>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<!--- load attachment --->
<cfinvoke component="/components/email/cmp_tools" method="loadattachment" returnvariable="a_struct_result">
  <cfinvokeargument name="server" value="#request.a_str_imap_host#">
  <cfinvokeargument name="username" value="#request.a_str_imap_username#">
  <cfinvokeargument name="password" value="#request.a_str_imap_password#">
  <cfinvokeargument name="foldername" value="#form.frmmailbox#">
  <cfinvokeargument name="uid" value="#form.frmid#">
  <cfinvokeargument name="partid" value="#form.frmpartid#">
  <cfinvokeargument name="savepath" value="#request.a_str_temp_directory_local#">
</cfinvoke>

<cfif a_struct_result.result NEQ 'OK'>
	<h4>ERROR - E-Mail already deleted?</h4>
	<cfabort>
</cfif>

<!--- save file --->
<cfinvoke component="#application.components.cmp_storage#"
	method="AddFile"
	returnVariable = "a_bool_addfile">
	<cfinvokeargument name="filename" value="#CheckZeroString(form.frmfilename)#">
	<cfinvokeargument name="location" value="#a_struct_result.savepath#">
	<cfinvokeargument name="description" value="E-Mail Attachment">
	<cfinvokeargument name="contenttype" value="#form.frmcontenttype#">
	<cfinvokeargument name="directorykey" value="#form.frmdirectorykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="filesize" value="#FileSize(a_struct_result.savepath)#">
	<cfinvokeargument name="forceoverwrite" value="true">
</cfinvoke>

<!--- close window --->

<html>
	<head>
		<script type="text/javascript">
			function CloseWindow()
				{
				alert('<cfoutput>#GetLangValJS('sto_ph_save_attachment_to_storage_success')#</cfoutput>');
				window.close();
				}
		</script>
	</head>
<body onLoad="CloseWindow();">

</body>
</html>