<!--- //

	Module:		Storage
	Action:		DeleteFile
	Description:Delete a file
	

// --->
<cfparam name="url.frm_entrykey" type="string">
<cfparam name="url.frm_parentdirectorykey" type="string" default="">

<cfif len(url.frm_entrykey ) lte 0 >
	<cflocation addtoken="no" url="default.cfm?action=showfiles&directorykey=#url.frm_parentdirectorykey#">
	<cfabort>
</cfif>

<cfset sFilenames= "" />

<cfloop index="sEntrykey" list="#url.frm_entrykey#" >
	
	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "GetFileInformation"   
		returnVariable = "a_struct_file_info"   
		entrykey = "#sEntrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#" >
	</cfinvoke>
	
	<cfset q_query_file = a_struct_file_info.q_select_file_info />
	
	<cfif len(q_query_file.entrykey) GT 0>
		<cfset sFilenames = ListAppend(sFilenames, q_query_file.filename & ' ') />
	</cfif>
</cfloop>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_deletefile'))>

<cfoutput>
	<b>
	#replace(getlangval('sto_ph_deletefiles'),"%filenames%",sFilenames)#</b>
	<br />
	<br />
	<a href="default.cfm?action=DeleteFile&frm_entrykey=#urlencodedformat(url.frm_entrykey)#&confirmed=1&redirectdir=0&frm_parentdirectorykey=#url.frm_parentdirectorykey#"><img src="/images/si/accept.png" class="si_img" /> #getlangval('sto_ph_reallydelete')#</a>
	<br />
	<br />
	<a href="javascript:history.go(-1);"><img src="/images/si/cross.png" class="si_img" /> #getlangval('sto_ph_noabort')#</a>
	
</cfoutput>




