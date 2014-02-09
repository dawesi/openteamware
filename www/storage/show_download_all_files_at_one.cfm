<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.directorykey" type="string" default="">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "ListFilesAndDirectories"   
	returnVariable = "a_struct_files"   
	directorykey = "#url.directorykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>  

<cfset q_select_files = a_struct_files.files>

<cfquery name="q_select_files" dbtype="query">
SELECT
	*
FROM
	q_select_files
WHERE
	filetype = 'file'
;
</cfquery>


<cfset a_str_text_file = ''>

<cfif cgi.SERVER_PORT IS '443'>
	<cfset a_str_protocol = 'https://'>
<cfelse>
	<cfset a_str_protocol = 'http://'>
</cfif>

<cfloop query="q_select_files">
 
	<cfset sEntrykey_dl = CreateUUID()>
	<cfset a_str_newfilename = CreateUUID()>

	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetFileInformation"   
		returnVariable = "a_struct_file_info"   
		entrykey = "#q_select_files.entrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		download=true>
	</cfinvoke>
	
	
<cfset q_query_file = a_struct_file_info.q_select_file_info />


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

	<cfset a_str_text_file = a_str_text_file & chr(13) & chr(10) & a_str_protocol & cgi.HTTP_HOST & '/tools/download/dl.cfm?dl_entrykey=' & sEntrykey_dl & '&source=' & urlencodedformat(a_str_newfilename) & '&contenttype=' & urlencodedformat(q_query_file.contenttype) & '&filename=' & urlencodedformat(q_query_file.filename) & '&app=' & urlencodedformat(application.applicationname)>

</cfloop>

<cfset a_str_text_file = trim(a_str_text_file)>

<cfset sFilename = request.a_str_temp_directory & createUUID()>

<cffile action="write" addnewline="yes" file="#sFilename#" output="#a_str_text_file#">

<cfset a_str_newfilename = CreateUUID()>
<cfset sEntrykey_dl = CreateUUID()>

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
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sFilename#">
	)
;
</cfquery>

<!--- redirect ... --->
<cflocation addtoken="yes" url="../tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat('text/plain')#&filename=#urlencodedformat('download.txt')#&app=#urlencodedformat(application.applicationname)#">