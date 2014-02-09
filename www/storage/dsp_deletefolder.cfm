<!--- //

	Module:		Storage
	Action:		DeleteFolder
	Description: 
	

// --->
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.parentdirectorykey" type="string" default="">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryInformation"   
	returnVariable = "a_struct_dir"   
	directorykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#">
</cfinvoke>

<cfif NOT a_struct_dir.result>
	Access denied.
	<cfexit method="exittemplate">
</cfif>

<cfset a_query_directory = a_struct_dir.q_select_directory />
<cfif a_query_directory.recordcount lte 0 or url.entrykey eq "">
	<cflocation url="default.cfm?action=ShowFiles&directorykey=#url.parentdirectorykey#">
</cfif>
		 

<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_deletedirectory2'))>
<cfoutput>
	<b>
		#replace(getlangval('sto_ph_deletedirectory'),"%directory%",a_query_directory.directoryname)#
	</b>
	<br />
	<br />
	<a href="default.cfm?action=DeleteFolder&entrykey=#url.entrykey#&confirmed=1&redirectdir=0&parentdirectorykey=#url.parentdirectorykey#"><img src="/images/si/accept.png" class="si_img" /> #getlangval('sto_ph_reallydelete')#</a>
	<br />
	<br />
	<a href="default.cfm?action=ShowFiles&directorykey=#url.parentdirectorykey#"><img src="/images/si/cancel.png" class="si_img" /> #getlangval('sto_ph_noabort')#</a>
</cfoutput>


