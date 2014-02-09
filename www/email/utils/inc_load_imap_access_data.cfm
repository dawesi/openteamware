<!--- //

	Module:		EMail
	Description:load imap access data for this user
	
// --->

<cfparam name="request.stUserSettings.mailusertype" type="numeric" default="0">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="request.a_str_requestkey" type="string" default="#CreateUUID()#">
<cfparam name="request.a_tick_template_begin" type="numeric" default="0">

<!--- default case ... take information stored in request scope ... --->
<cfset request.a_str_imap_username = request.stSecurityContext.A_STRUCT_IMAP_ACCESS_DATA.A_STR_IMAP_USERNAME />
<cfset request.a_str_imap_password = request.stSecurityContext.A_STRUCT_IMAP_ACCESS_DATA.a_str_imap_password />
<cfset request.a_str_imap_host = request.stSecurityContext.A_STRUCT_IMAP_ACCESS_DATA.a_str_imap_host />