<cfparam name="url.confirmed" default="0" type="numeric">
<cfparam name="url.entrykey" default="" type="string">
<cfif url.confirmed eq 1 and url.entrykey neq "">


	<cfinvoke   
		component = "#application.components.cmp_storage#"   
		method = "DeleteDirectory"
		entrykey = "#url.entrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		returnVariable="a_bool_success"
		 >  
	</cfinvoke>
	<cfif a_bool_success>
		<cflocation url="default.cfm?action=ShowFiles&directorykey=#url.parentdirectorykey#">
	<cfelse>
		<cfoutput>
			#getlangval("sto_ph_error_folder_delete")#
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>

<cfinclude template="dsp_deletefolder.cfm">

