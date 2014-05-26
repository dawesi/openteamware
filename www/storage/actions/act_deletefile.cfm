<!--- //

	Module:		Storage
	Action:		DeleteFile
	Description: 
	

// --->

<cfparam name="url.confirmed" default="0" type="numeric">
<cfparam name="url.frm_entrykey" type="string" default="">
<cfparam name="url.frm_parentdirectorykey" type="string" default="">

<cfif Len(url.frm_entrykey) IS 0>
	<cflocation addtoken="no" url="index.cfm?action=showfiles&directorykey=#url.frm_parentdirectorykey#">
</cfif>

<cfif url.confirmed IS 1>

	<cfloop index="sEntrykey" list="#url.frm_entrykey#" >
		
		<cfinvoke   
			component = "#application.components.cmp_storage#"   
			method = "DeleteFile"
			entrykey = "#sEntrykey#"
			securitycontext="#request.stSecurityContext#"
			usersettings="#request.stUserSettings#">  
		</cfinvoke>
	
	</cfloop>

	<cfif Len(url.frm_parentdirectorykey) GT 0>
		<cflocation url="index.cfm?action=ShowFiles&directorykey=#url.frm_parentdirectorykey#">
	<cfelse>
		<script type="text/javascript">
			history.go(-1);
		</script>
	</cfif>
	
	<cflocation addtoken="false" url="#ReturnRedirectURL()#">
	
<cfelse>

	<cfinclude template="../dsp_deletefile.cfm">
</cfif>





