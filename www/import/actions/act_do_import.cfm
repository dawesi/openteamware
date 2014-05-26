<!--- //

	Module:        Import
	Description:   Do the real import
	

// --->

<cfsetting requesttimeout="20000">

<!--- check if at least one record was selected to import --->
<cfparam name="form.frm_data_entrykey" default="">

<cfinvoke component="#application.components.cmp_import#" method="DoImportData" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
	<cfinvokeargument name="jobkey" value="#form.frm_jobkey#">
	<cfinvokeargument name="dataentrykeystoimport" value="#form.frm_data_entrykey#">
	<cfinvokeargument name="categories_to_add" value="#form.frm_add_categories#">
	<cfinvokeargument name="criteria_to_set" value="#form.frm_criteria#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="index.cfm?action=PreviewData&jobkey=#form.frm_jobkey#&ibxerrorno=#stReturn.error#">
</cfif>

<!--- success! --->
<cflocation url="index.cfm?action=ShowResult&jobkey=#form.frm_jobkey#">

