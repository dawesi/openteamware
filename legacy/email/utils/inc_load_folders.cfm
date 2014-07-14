<!--- //

	Module:		EMail
	Description:Load folders ...
	
	Try to load folders form mailspeed database ... if not enabled,
	use IMAP connection

	
// --->

<!--- use always cached version? --->
<cfparam name="variables.a_use_cached_folder_structure" type="boolean" default="false">

<!--- use default IMAP (no caching ...) --->
<cfinvoke component="#application.components.cmp_email#" method="loadfolders" returnvariable="a_struct_result">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="accessdata" value="#request.stSecurityContext.a_struct_imap_access_data#">
	<cfinvokeargument name="TryToUseCachedVersion" value="#a_use_cached_folder_structure#">
	<cfinvokeargument name="CacheFolderData" value="true">
</cfinvoke>

<cfif NOT a_struct_result.result>
	<cflocation addtoken="false" url="/info/?action=ShowError&errorno=#a_struct_result.error#">
</cfif>
 
<!--- set the request and session vars --->
<cfset request.q_select_folders = a_struct_result.query />

<cfset request.a_int_unread_mail_count = 0 />

<!--- not requested? --->
<cfif NOT StructKeyExists(variables, 'a_bol_load_imap_folders_no_order')>
<cftry>
	
	<cfquery name="request.q_select_folders" dbtype="query">
	SELECT
		*
	FROM
		request.q_select_folders
	ORDER BY
		uffn
	;
	</cfquery>
	
<cfcatch type="any">
</cfcatch>
</cftry>
</cfif>

