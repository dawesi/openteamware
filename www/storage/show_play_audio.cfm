<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.entrykey" default="" type="string">
<cfparam name="url.version" default="-1" type="numeric">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	version="#url.version#"
	download=true
	 >
</cfinvoke>


<cfset q_query_file = a_struct_file_info.q_select_file_info />

<cfset a_str_newfilename=createUUID()>

<cfset a_str_dest_filename = request.a_str_temp_directory&request.a_str_dir_separator&a_str_newfilename>

<!--- save the file ... --->
<cffile action="COPY" source="#q_query_file.storagepath##request.a_str_dir_separator##q_query_file.storagefilename#" destination="#a_str_dest_filename#">
	

<html>
<head>
<title>Datei abspielen ...</title>
</head>

<body>

<cfoutput>
<embed ShowControls=true width=100% height=45 src="../tools/download/dl.cfm?source=#urlencodedformat(a_str_newfilename)#&contenttype=#urlencodedformat(q_query_file.contenttype)#&filename=#urlencodedformat(q_query_file.filename)#&app=#urlencodedformat(application.applicationname)#" autostart=false>
</cfoutput>

</body>
</html>
