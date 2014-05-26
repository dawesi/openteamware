<!--- //

	Module:		Storage
	Action:		Showfiles
	Description:Display files
	

// --->

<cfparam name="url.directorykey" default="" type="string">

<cfset request.sOrderBy = GetUserPrefPerson('storage', 'orderby', 'name', 'url.orderby', false) />

<cfset url.orderby = request.sOrderBy />
<cfset url.ordertype = 'ASC' />
	
<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryInformation"   
	returnVariable = "a_struct_dir"   
	directorykey = "#url.directorykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>

<cfif NOT a_struct_dir.result>
	Directory does not exist/is not accessable.
	<cfexit method="exittemplate">
</cfif>

<cfset q_query_dir = a_struct_dir.q_select_directory />

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "ListFilesAndDirectories"   
	returnVariable = "a_struct_files"   
	directorykey = "#url.directorykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>  


<cfif len(url.orderby ) GT 0>
	<cfset url.orderby = REReplaceNoCase(url.orderby,"[^a-z]","","all") />
	<cfset url.ordertype = REReplaceNoCase(url.ordertype,"[^a-z]","","all") />
	
	<cfif url.orderby eq "">
		<cfset url.orderby="name">
	</cfif>
	<cfif listcontainsnocase('name,type,contenttype,typ',url.orderby)>
		<cfset url.orderby="upper(#url.orderby#)">
	</cfif>

	<cftry>
		<cfquery dbtype="query" name="a_struct_files.files">
			SELECT 
				*,#url.orderby# as sortcol
			FROM 
				a_struct_files.files
			ORDER BY
				filetype,
				sortcol #url.ordertype#
		</cfquery>
		<cfcatch>
			<cfquery dbtype="query" name="a_struct_files.files">
				SELECT 
					*,#url.orderby# as sortcol
				FROM 
					a_struct_files.files
				ORDER BY
					filetype
			</cfquery>
		</cfcatch>
	</cftry>
</cfif>


<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetParentDirectories"   
	returnVariable = "a_struct_parentdirectories"   
	directorykey = "#url.directorykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>

<cfset a_str_currentkey = a_struct_parentdirectories[''].subdirectorykey />

<cfset request.a_str_current_page_title = q_query_dir.directoryname />
<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_wd_directory') & ' ' & q_query_dir.directoryname) />

<cfif (Len(q_query_dir.description) GT 0) AND (q_query_dir.description NEQ 'root')>
	
	<div style="padding:4px; ">
	<cfoutput>#htmleditformat(q_query_dir.description)#</cfoutput>
	</div>
	
</cfif>

<cfset a_str_subdir_info = '' />
	
<cfif StructCount(a_struct_parentdirectories) GT 2>

	<div style="padding:4px;line-height:20px;">
	<cfoutput>
		<font class="addinfotext" style="font-weight:bold;"><img src="/images/si/folder_go.png" class="si_img" /> #getlangval('sto_wd_path')#</font>:
	</cfoutput>
	<cfif not a_str_currentkey eq url.directorykey>
		<cfloop index="a_int_counter" from="0" to="99">
			<cfoutput>
				<cfif Arraylen(structFindKey(a_struct_parentdirectories,a_str_currentkey) ) gt 0 >
				
					<cfset a_str_subdir_info = ListPrepend(a_str_subdir_info, a_struct_parentdirectories[a_str_currentkey].name, '/')>
					
			  		<a href="index.cfm?action=showfiles&directorykey=#a_str_currentkey#">
					[ #htmleditformat(a_struct_parentdirectories[a_str_currentkey].name)# ] </a><cfif a_int_counter gte 1>&nbsp;</cfif> <img src="/images/si/arrow_right.png" class="si_img" />
					<cfset a_str_currentkey=a_struct_parentdirectories[a_str_currentkey].subdirectorykey>
				<cfelse>
					#getlangval('sto_ph_errmsg_missingdir',request.a_int_langno)#
					<cfbreak>
				</cfif>
			</cfoutput>
			<cfif a_str_currentkey eq url.directorykey>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
	
	</div>
	
</cfif>

	<cfif len(q_query_dir.shared_workgroupkey) gt 0>
		[ <cfoutput>#getlangval('sto_ph_directoryisshared')# (#GetLangVal('cm_wd_workgroup')#)</cfoutput> ]
	</cfif> 
	
	<cfif len(q_query_dir.publicshare_directorykey) gt 0 >
		<img src="/images/menu/img_world_19x16.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <cfoutput>#getlangval('sto_ph_directoryisshared')# (#GetLangVal('sto_wd_public')#)
		
		<cfset a_str_domain = ListGetAt(request.stSecurityContext.myusername, 2, '@') />
		<cfset a_str_username = ListGetAt(request.stSecurityContext.myusername, 1, '@') />
		
		<cfset a_str_link = 'http://www.openTeamWare.com/storage/public.cfm/'&a_str_domain&'/'&a_str_username&'/'&q_query_dir.directoryname&'/'>
		
		
		<br>
		<img src="/images/hyperlink.gif" align="absmiddle" vspace="4" hspace="4" border="0"> URL zum Verzeichnis: <a target="_blank" href="#a_str_link#">#a_str_link#</a><br>
		<img src="/images/email/img_email_19x16.gif" align="absmiddle" vspace="2" hspace="2" border="0"> <a href="act_mail_public_dir_info.cfm?entrykey=#a_struct_files.directorykey#&currentdir=#url.directorykey#">#GetLangVal('sto_ph_forward_information_by_email')#</a>
		</cfoutput>
	</cfif>

<!--- what to display? ... --->
<cfswitch expression="#q_query_dir.displaytype#">
	<cfcase value="1">
		<cfinclude template="dsp_showfiles_thumbnails.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfset a_query_displayfiles=a_struct_files.files>
		<cfinclude template="dsp_display_files.cfm">
	</cfdefaultcase>
</cfswitch>

