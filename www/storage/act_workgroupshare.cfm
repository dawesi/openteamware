<cfparam name="form.frm_entrykey" type="string">
<cfparam name="form.frm_parentdirectorykey" type="string" default="">
<cfparam name="form.frm_workgroupkey" type="string" default="">
<cfparam name="form.subaction" type="string" default="add">
<cfparam name="form.frm_currentdir" type="string" default="">

<cfinvoke
	component = "#application.components.cmp_storage#"
	method = "EditWorkgroupShare"
	action="#form.subaction#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	entrykey="#form.frm_entrykey#"
	workgroupkey="#form.frm_workgroupkey#"
	 >  
</cfinvoke>

<!--- Send to the Parent Directory Listing --->
<cflocation url="index.cfm?action=showfiles&directorykey=#form.frm_currentdir#">
