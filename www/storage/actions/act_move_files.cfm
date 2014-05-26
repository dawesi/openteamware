<!--- //

	Module:		Storage
	Action.		DoMoveFiles
	Description: 
	

// --->


<cfparam name="form.frm_directorykey" type="string">
<cfparam name="form.frmentrykeys" type="string" default="">

<cfif len(form.frmentrykeys ) IS 0>
	<cflocation addtoken="no" url="index.cfm?action=showfiles&directorykey=#form.frm_directorykey#">
</cfif>

<cfloop index="sEntrykey" list="#form.frmentrykeys#" >
	
	<cfinvoke component="#application.components.cmp_storage#" method="MoveFile" returnVariable = "stReturn"   
		entrykey = "#sEntrykey#"
		destination_directorykey="#form.frm_directorykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#">
	</cfinvoke>	
			 
</cfloop>
		
<cflocation url="index.cfm?action=showfiles&directorykey=#form.frm_directorykey#">

