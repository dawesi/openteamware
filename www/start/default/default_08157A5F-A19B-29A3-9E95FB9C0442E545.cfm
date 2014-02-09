<!--- //

	Module:		Start
	Action:		Action
	Description:Default
	
// --->
<cfinclude template="/login/check_logged_in.cfm">

<cfsetting enablecfoutputonly="true" />

<!--- force disable? --->
<cfset a_struct_misc_settings = application.components.cmp_customize.GetCustomStyleData(usersettings = request.stUserSettings, entryname = 'misc') />

<cfif Len(url.url) GT 0>
	<cfset a_str_content_frame_src = url.url />
<cfelse>
	<cfset a_str_content_frame_src = 'content/' />
</cfif>

<!--- fuck on frames --->
<cflocation addtoken="false" url="#a_str_content_frame_src#">