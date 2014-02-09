<!--- //

	Module:		Storage
	Description:Create/Edit a folder
	

// --->
<cfparam name="form.CreateNew" default="" type="string">
<cfparam name="form.frm_currentdir" default="" type="string">
<cfparam name="form.frmcommunity_entrykey" default="" type="string">

<cftry>
	<cfif len(form.CreateNew) gt 0 >
		<cfinvoke
		component = "#application.components.cmp_storage#"   
		method = "CreateDirectory"   
		returnVariable = "stReturn"   
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
		directoryname="#form.frm_Directoryname#"
		description="#form.frm_description#"
		displaytype="#form.frm_displaytype#"
		versioning="#form.frm_versioning#"
		parentdirectorykey="#form.frm_parentdirectorykey#"
		entrykey="#form.frm_entrykey#"
		 >
		</cfinvoke>
	<cfelse>
		<cfinvoke
		component = "#application.components.cmp_storage#"
		method = "EditDirectory"
		returnVariable = "stReturn"   
		directorykey = "#form.frm_entrykey#"
		securitycontext="#request.stSecurityContext#"
		usersettings="#request.stUserSettings#"
	
		directoryname="#form.frm_Directoryname#"
		description="#form.frm_description#"
		displaytype="#form.frm_displaytype#"
		versioning="#form.frm_versioning#"
		entrykey="#form.frm_entrykey#"
		 >  
		</cfinvoke>
	</cfif> 
	<cfcatch>
		<cfif cfcatch.errorcode eq 110>
			<cfoutput>
				#getlangval('sto_ph_dontrenameshared')#
			</cfoutput>
		<cfelseif cfcatch.Errorcode eq 111>
			<cfoutput>
				#getlangval('sto_ph_invalidcharacters')#
			</cfoutput>
		<cfelse>
			<cfrethrow>
		</cfif>
		<cfabort>
	</cfcatch>
</cftry>


<cfif not stReturn.result>
	<cfoutput>#GetLangVal('sto_ph_error_save_directory')#</cfoutput>
<cfelse>
	<!--- Send to the Parent Directory Listing --->
	<cflocation url="default.cfm?action=showfiles&directorykey=#form.frm_currentdir#">
</cfif>



