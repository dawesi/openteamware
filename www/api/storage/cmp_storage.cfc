<cfcomponent output='false'>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfparam name="client.langno" type="numeric" default="0">

	<cffunction access="remote" name="AddFile" returntype="array" output="false" displayname="Add a file">
		<cfargument name="clientkey" required="true" type="string">
		<cfargument name="applicationkey" required="true" type="string">
		<cfargument name="directorykey" type="string" required="true">
		<cfargument name="filename" type="string" required="false" default="">
		<cfargument name="description" type="string" required="yes" default="">
		<cfargument name="contenttype" type="string" required="false" default="binary/unknown">
		<cfargument name="filedata" type="string" required="true" default="">
		<cfargument name="fileuploadkeys" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">		
		
		<cfreturn a_arr_return>
	</cffunction>
	
	
	
	<cffunction access="remote" name="GetFile" returntype="array" output="false">
		<cfargument name="clientkey" type="string" required="true">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="entrykey" type="string" required="yes">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		<cfset var q_query_file = 0 />
		<cfset var a_struct_file_info = 0 />
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">		
		
		<!--- element three contains the base64 version of the file --->
		<cfinvoke   
			component = "#application.componentss.cmp_storage#"   
			method = "GetFileInformation"   
			returnVariable = "a_struct_file_info"   
			entrykey = "#arguments.entrykey#"
			securitycontext="#application.directaccess.securitycontext[arguments.clientkey]#"
			usersettings="#application.directaccess.usersettings[arguments.clientkey]#"
			version="-1"
			download=true></cfinvoke>		
			
		<cfset q_query_file = a_struct_file_info.q_select_file_info />
		
		<cfset sFilename = q_query_file.storagepath&request.a_str_dir_separator&q_query_file.storagefilename>
		
		<cffile action="readbinary" file="#sFilename#" variable="a_bin_file">
		
		<cfset a_arr_return[3] = TOString(Tobase64(a_bin_file))>
		
		<cfreturn a_arr_return>
	</cffunction>
		
	<cffunction access="remote" name="ListFilesAndDirectories" output="false" returntype="array">
		<cfargument name="clientkey" type="string" required="true">
		<cfargument name="applicationkey" type="string" required="yes">
		<cfargument name="directorykey" type="string" required="yes">
		<cfargument name="parameter" type="string" required="no" default="">
		
		<cfset var a_arr_return = GenerateReturnArray()>
		
		<cfinclude template="../security/inc_check_app_security.cfm">
		<cfinclude template="../session/inc_check_session.cfm">		
		
		<cfinvoke   
				component = "#application.components.cmp_storage#"   
				method = "ListFilesAndDirectories"   
				returnVariable = "a_struct_files"   
				directorykey = "#arguments.directorykey#"
				securitycontext="#application.directaccess.securitycontext[arguments.clientkey]#"
				usersettings="#application.directaccess.usersettings[arguments.clientkey]#">
		</cfinvoke> 
		
		<cfset q_select_data = a_struct_files.files>
		
		<cfquery name="q_select_data" dbtype="query">
		SELECT
			*
		FROM
			q_select_data
		ORDER BY
			filetype,name
		;
		</cfquery>
		
		<cfif ListFindNoCase(arguments.parameter, 'directoriesonly')>
			<cfquery name="q_select_data" dbtype="query">
			SELECT
				*
			FROM
				q_select_data
			WHERE
				filetype = 'directory'
			;
			</cfquery>
		</cfif>
		
		<cfif ListFindNoCase(arguments.parameter, 'filesonly')>
			<cfquery name="q_select_data" dbtype="query">
			SELECT
				*
			FROM
				q_select_data
			WHERE
				filetype = 'file'
			;
			</cfquery>
		</cfif>		
		
		<cfset a_arr_return[3] = ToString(QueryToXMLData(q_select_data))>
		
		<cfreturn a_arr_return>
				
	</cffunction>
	

	
</cfcomponent>