<cfparam name="form.frm_entrykey" type="string">
<cfparam name="form.frm_password" type="string" default="">
<cfparam name="form.frm_parentdirectorykey" type="string" default="">
<cfparam name="form.subaction" type="string" default="add">
<cfparam name="form.frm_subaction_delete" type="string" default="">
<cfparam name="form.frm_subaction_update" type="string" default="">
<cfparam name="form.form.frm_currentdir" type="string" default="">
<!--- Check Input Values ---->
<!--- TODO --->
<cfif len(form.frm_subaction_delete) gt 0 >
	<cfinvoke
		component = "#application.components.cmp_storage#"
		method = "EditPublicShare"
	>
		<cfinvokeargument name="action" value="delete">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="password" value="#form.frm_password#">
		<cfinvokeargument name="entrykey" value="#form.frm_entrykey#">
	</cfinvoke>
<cfelseif len(form.frm_subaction_update) gt 0>
	<cfinvoke
		component = "#request.a_str_component_storage#"
		method = "EditPublicShare"
		 >  
		<cfinvokeargument name="action" value="update">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="password" value="#form.frm_password#">
		<cfinvokeargument name="entrykey" value="#form.frm_entrykey#">
	</cfinvoke>
<cfelse>
	<cfinvoke
		component = "#request.a_str_component_storage#"
		method = "EditPublicShare"
		 >  
		<cfinvokeargument name="action" value="add">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="password" value="#form.frm_password#">
		<cfinvokeargument name="entrykey" value="#form.frm_entrykey#">
	</cfinvoke>		 
</cfif>

<!--- Send to the Parent Directory Listing --->
<cflocation url="default.cfm?action=editfolder&entrykey=#form.frm_entrykey#&currentdir=#form.frm_currentdir#">
