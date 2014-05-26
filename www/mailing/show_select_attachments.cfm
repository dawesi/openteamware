<!--- //

	Module:		Add attachment to mailing
	Action:		
	Description:	
	

// --->


<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFullDirectoryStructureOfUser"   
	returnVariable = "a_struct_dirs"   
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	includeshareddirectories=true>
</cfinvoke>

<cfset q_select_directories = a_struct_dirs.q_select_directories />

<cfoutput>#LoopOutput(query = q_select_directories, isroot = true)#</cfoutput>


<cffunction access="private" name="LoopOutput" returntype="void" output="true">
	<cfargument name="parentdirectorykey" type="string" default="" required="false">
	<cfargument name="level" type="numeric" default="0" required="false">
	<cfargument name="isroot" type="boolean" default="false">
	
	<cfset var q_select_current_level = 0 />
	<cfset var q_select_files = 0 />
	<cfset var a_struct_files_of_current_dir = 0 />
	
	<cfif arguments.level GT 5>
		<cfreturn />
	</cfif>
	
	<cfif Len(arguments.parentdirectorykey) IS 0 AND NOT arguments.isroot>
		<cfreturn />
	</cfif>
	
	<cfquery name="q_select_current_level" dbtype="query">
	SELECT
		*
	FROM
		q_select_directories
	WHERE
		parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentdirectorykey#">
	ORDER BY
		directoryname
	;
	</cfquery>
	
	<cfif q_select_current_level.recordcount GT 0>
	
	<ul class="ul_nopoints" <cfif arguments.isroot>id="id_folders_root"</cfif>>
	<cfoutput query="q_select_current_level">
		<li>
			<a href="##" onclick="LoadAddAttFolderContent(this, '#JsStringFormat( q_select_current_level.entrykey )#');return false;">#si_img('folder')# #htmleditformat(q_select_current_level.directoryname)#</a>
			
			#LoopOutput(parentdirectorykey = q_select_current_level.entrykey, level = arguments.level + 1)#
		</li>
	</cfoutput>
	</ul>
	
	</cfif>
	
</cffunction>


<!--- 
<cfinclude template="/common/scripts/script_utils.cfm">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryStructure"   
	returnVariable = "a_struct_dirs"   
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	 >
</cfinvoke>

	<cfset a_arr_dirs=ArrayNew(1)>
	<cfset a_struct_hint=Structnew()>
	
	<cfset sDirectorykey=a_struct_dirs.rootdirectorykey>
	<cfset a_struct_hint.directorykey = sDirectorykey>
	
	<cfset a_struct_hint.counter = 0>
	
	<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
	
	<cfloop  condition="arraylen(a_arr_dirs) gt 0 ">
		<cfset a_current_hint = a_arr_dirs[arraylen(a_arr_dirs)]>
		<cfset sDirectorykey=a_current_hint.directorykey>
		<cfif a_current_hint.counter lte 0>
		
			<cfset a_int_padding_left = arraylen(a_arr_dirs) * 30>
	
			<cfoutput>
			
			<div style="padding-left:#a_int_padding_left#px;padding-top:3px; ">
				<a target="_blank" href="/storage/index.cfm?action=ShowFiles&directorykey=#sDirectorykey#">#si_img( 'folder' )# #htmleditformat(a_struct_dirs.directories[sDirectorykey].name)#</a>
				<div style="padding-left:10px; ">
					<!--- files --->
				<cfinvoke   
					component = "#application.components.cmp_storage#"   
					method = "ListFilesAndDirectories"   
					returnVariable = "a_struct_files_of_current_dir"   
					directorykey = "#sDirectorykey#"
					securitycontext="#request.stSecurityContext#"
					usersettings="#request.stUserSettings#">
				</cfinvoke>  
				
				<cfquery name="q_select_files" dbtype="query">
				SELECT
					filesize,name,entrykey
				FROM
					a_struct_files_of_current_dir.files
				WHERE
					filetype = 'file'
				;
				</cfquery>
				
				
				<cfloop query="q_select_files">
					<input type="checkbox" name="frmattachmentkeys" value="#q_select_files.entrykey#" class="noborder" style="width:auto" /> <a target="_blank" href="../storage/index.cfm?action=ShowFile&entrykey=#q_select_files.entrykey#">#htmleditformat(q_select_files.name)#</a> (#ByteConvert(q_select_files.filesize)#)<br />
				</cfloop>
				
				</div>
			</div>
			

			</cfoutput>

		</cfif>
		<cfif ArrayLen(a_struct_dirs.directories[sDirectorykey].subdirectories) gt a_current_hint.counter >
			<cfset a_current_hint.counter = a_current_hint.counter + 1 >
			<cfset a_struct_hint = StructNew () >
			<cfset sDirectorykey = a_struct_dirs.directories[sDirectorykey].subdirectories[a_current_hint.counter]>
			<cfset a_struct_hint.directorykey = sDirectorykey>
			<cfset a_struct_hint.counter = 0 >
			<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
		<cfelse>
			<cfset tmp=ArrayDeleteAt (a_arr_dirs,ArrayLen(a_arr_dirs))>
		</cfif>
	</cfloop>
 --->