<!--- //

	Module:		Email
	Description:Main controller file
	
// --->

<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.mailbox" type="string" default="INBOX">
<cfparam name="url.isframed" type="boolean" default="false">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">

<cfif NOT request.stSecurityContext.A_STRUCT_IMAP_ACCESS_DATA.enabled>
	
	<cfif StructKeyExists(url, 'action') AND url.action IS 'DisplayBottomShortInfo'>
		<cfexit method="exittemplate">
	</cfif>
	
	<cflocation addtoken="false" url="/settings/?action=AddEmailAccount">
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_display_folders_left = GetUserPrefPerson('email', 'showfoldersleft', '0', '', false) />

<cfif NOT StructKeyExists(url, 'action')>
	
	<cfset a_str_email_default_view = GetUserPrefPerson('email', 'defaultview', 'overview', 'url.action', false) />
	
	<cfswitch expression="#a_str_email_default_view#">
		<cfcase value="inbox">
			<cfset url.action = 'ShowMailbox' />
			<cfset url.mailbox = 'inbox' />
		</cfcase>
		<cfdefaultcase>
			<cfset url.action = 'overview' />
		</cfdefaultcase>
	</cfswitch>
</cfif>

<!--- load imap access data ... --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">

<!--- use always the cached version in case of these actions ... --->
<cfset variables.a_use_cached_folder_structure = (ListFindNoCase('folders,ShowWelcome,ShowOverview,Overview,DisplayBottomShortInfo', url.action) IS 0) />

<!--- load the folders ... --->
<cfinclude template="utils/inc_load_folders.cfm">
<cfinclude template="queries/q_select_all_pop3_data.cfm">

<cfoutput>#GetRenderCmp().GenerateServiceDefaultFile(servicekey = '52228B55-B4D7-DFDF-4AC7CFB5BDA95AC5',
										pagetitle = GetLangVal('cm_wd_email'))#</cfoutput>

<!--- display folders on left nav if needed ... --->
<cfif (a_int_display_folders_left IS 1) AND NOT
		request.a_bol_simple_page_request AND
	  (ListFindNoCase('ShowMailbox', url.action) GT 0)>
	<cfsavecontent variable="a_str_js_folder">
	<cfinclude template="dialogs/dsp_show_folder_overview_left.cfm">
	</cfsavecontent>
	
	<script type="text/javascript">
		DspFolderSmallOV('<cfoutput>#JsStringFormat(a_str_js_folder)#</cfoutput>');
	</script>
</cfif>

