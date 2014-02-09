<!--- //

	Module:		Storage
	Action:		SaveFileInformation
	Description: 
	

// --->

<cfparam name="form.frm_parentdirectorykey" type="string" default="">
<cfparam name="form.frmfilecontent" type="string" default="">

<!--- try to update ... --->
<cfinvoke returnvariable="stUpdate"
	component = "#application.components.cmp_storage#"   
	method = "UpdateFileInformation"
	entrykey = "#form.frm_entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	description="#form.frm_description#"
	contenttype="#form.frm_contenttype#"
	filename="#form.frm_filename#"
	filecontent="#form.frmfilecontent#">  
</cfinvoke>

<cfif NOT stUpdate.result>
	<cfdump var="#stUpdate#">
	<cfabort>
</cfif>

<!--- Send to the Parent Directory Listing --->
<cflocation url="default.cfm?action=showfiles&directorykey=#form.frm_parentdirectorykey#">

