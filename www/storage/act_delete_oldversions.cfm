<cfparam name="url.confirmed" default="0" type="numeric">
<cfparam name="url.entrykey" type="string" default="-1">
<cfif url.confirmed eq 1>


	<cfloop index="sEntrykey" list="#url.entrykey#" >
		<cfinvoke   
			component = "#application.components.cmp_storage#"   
			method = "Deleteoldversions"
			entrykey = "#sEntrykey#"
			securitycontext="#request.stSecurityContext#"
			usersettings="#request.stUserSettings#"
		
			 >  
		</cfinvoke>	
	</cfloop>

	<cflocation url="index.cfm?action=ShowFiles&directorykey=#url.parentdirectorykey#">
</cfif>

<cfinclude template="dsp_delete_oldversions.cfm">


