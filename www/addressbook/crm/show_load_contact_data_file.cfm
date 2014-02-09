<!--- //

	download file from CRM system ...
	
	TODO hp: UPDATE
	
	// --->
	
<cfinclude template="/login/check_logged_in.cfm">

<cfset a_struct_binding = application.components.cmp_crmsales.GetCRMSalesBinding(companykey = request.stSecurityContext.mycompanykey)>

<cfif Len(a_struct_binding.USERKEY_DATA) IS 0>
	<cfabort>
</cfif>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stSecurityContext_download_file = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stUserSettings_download_file = a_struct_settings>

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file"   
	entrykey = "#url.entrykey#"
	securitycontext="#variables.stSecurityContext_download_file#"
	usersettings="#variables.stUserSettings_download_file#"
	download=true></cfinvoke>
	
<cfset q_query_file = a_struct_file.q_select_file_info />

<cfset sEntrykey_dl = CreateUUID()>
<cfset a_str_newfilename=createUUID()>
	
<cfquery name="q_insert_dl_link" datasource="#request.a_str_db_tools#">
INSERT INTO
	download_links
	(
	entrykey,
	filelocation
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey_dl#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_query_file.storagepath##request.a_str_dir_separator##q_query_file.storagefilename#">
	)
;
</cfquery>

<!--- redirect ... --->
<cflocation addtoken="yes" url="../../tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(q_query_file.contenttype)#&filename=#urlencodedformat(q_query_file.filename)#&app=#urlencodedformat(application.applicationname)#">
