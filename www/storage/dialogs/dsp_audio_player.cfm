<!--- //

	Module:		Storage
	Action:		ShowPlayAudioFile
	Description: 
	

// --->

<cfparam name="url.entrykey" type="string">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>	 

<cfif NOT a_struct_file_info.result>
	<cfexit method="exittemplate">
</cfif>

<cfset q_query_file = a_struct_file_info.q_select_file_info />

<cfoutput><b>#(q_query_file.filename)#</b></cfoutput>

<cfset sEntrykey_dl = CreateUUID() />
<cfset a_str_newfilename = CreateUUID() />
		
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
		
<cfset a_str_location = '/tools/download/dl.cfm?dl_entrykey=#sEntrykey_dl#&source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(q_query_file.contenttype)#&filename=#urlencodedformat(q_query_file.filename)#&app=#urlencodedformat(application.applicationname)#' />

<embed src="/content/flash/mp3player.swf" width="320" height="20" allowfullscreen="true" flashvars="&file=<cfoutput>#urlencodedformat(a_str_location)#</cfoutput>&height=20&width=320&autostart=false" />

