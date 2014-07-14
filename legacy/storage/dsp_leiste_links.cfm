<!--- //

	Module:		Storage
	Description:Left page include
	

// --->


<cfparam name="url.directorykey" default="" type="string">

<div class="divleftnavigation_center">
	
	<div class="divleftnavpanelactions">
	
	<cfswitch expression="#url.action#">
	<cfcase value="ShowFiles,ShowWelcome">		
			<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('sto_wd_directory')#</cfoutput></div>

			<cfoutput>
			<ul class="divleftpanelactions">
			<li><a target="_blank" onclick="window.open('/storage/index.cfm?action=AddFile&parentdirectorykey=#url.directorykey#','_blank','toolbar=no,location=no,directories=no,status=no,copyhistory=no,scrollbars=yes,resizable=yes,height=400,width=600');return false;" href="##"><b>#getlangval('sto_ph_addfiles')#</b></a></li>
			<li><a href="index.cfm?action=createNewFile&entrykey=#url.directorykey#&currentdir=#url.directorykey#">#GetLangVal('sto_ph_create_new_file')#</a></li>
			<li><a href="/storage/index.cfm?action=NewFolder&parentdirectorykey=<cfoutput>#url.directorykey#</cfoutput>&currentdir=<cfoutput>#url.directorykey#</cfoutput>"><cfoutput>#getlangval('sto_ph_createdirectory')#</cfoutput></a></li>
			<li><a href="index.cfm?action=EditFolder&entrykey=#url.directorykey#&currentdir=#url.directorykey#">#MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#</a></li>
			<li><a href="index.cfm?action=EditFolder&entrykey=#url.directorykey#&currentdir=#url.directorykey#">#GetLangVal('sto_wd_share')#</a></li>
			
			<li>					
				<cfset a_struct_stat = application.components.cmp_storage.GetDirectoryInformationStatistics(directorykey = url.directorykey, securitycontext = request.stSecurityContext, usersettings = request.stUserSettings) />
				
				<div>
				<cfif StructCount(a_struct_stat) GT 0>
					#GetLangVal('cm_wd_information')#
					<br>
					#GetLangVal('cm_wd_size')#: #ByteConvert(a_struct_stat.folder_size)#
					<br>
					#GetLangVal('cm_wd_objects')#: #Val(a_struct_stat.count_elements)#
				</cfif>				
				</div>
				
			</li>
			</ul>
			</cfoutput>
			
		<!---</div>	
		<br>--->
	</cfcase>
	</cfswitch>
		
	
		<div class="divleftnavpanelheader"><cfoutput>#GetLangVal('cm_wd_global')#</cfoutput></div>

			<ul class="divleftpanelactions">
			<li><a href="index.cfm"><cfoutput>#GetLangVal("cm_wd_overview")#</cfoutput></a></li>
			<!---<li><a href="index.cfm?action=showfiles"><cfoutput>#GetLangVal("sto_ph_showfiles")#</cfoutput></a></li>--->
			<li>
				<div>
				<cfoutput>
				<form action="index.cfm" method="get" style="margin:0px; ">
				#getlangval('cm_wd_search')#<br>
				<input type="hidden" name="action" value="search">
				<input style="width:100px;" name="frm_searchstring" value="" size="10">
				</form>
				</cfoutput>
				</div>
			</li>
			<li><a href="index.cfm?action=shares"><cfoutput>#GetLangVal('sto_ph_sharedfiles')#</cfoutput></a></li>
			<li><a href="/blog/" target="_blank"><cfoutput>#GetLangVal('sto_ph_webdav')#</cfoutput></a></li>
			<!--- <li><a href="/rd/shop/" target="_blank"><cfoutput>#GetLangVal('cm_ph_shop_increase_space')#</cfoutput></a></li> --->
			<li><a href="index.cfm?action=usageinfo"><cfoutput>#GetLangVal('sto_wd_usage')#</cfoutput></a></li>
			<li><a href="javascript:location.reload();"><cfoutput>#GetLangVal('cm_wd_reload')#</cfoutput></a></li>
			</ul>
	</div>	

</div>

