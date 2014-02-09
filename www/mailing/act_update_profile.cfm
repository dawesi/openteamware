<cfinclude template="../login/check_logged_in.cfm">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="default.cfm">
</cfif>


<cfparam name="form.frm_subscription_management" type="numeric" default="0">
<cfparam name="form.frm_open_tracking" type="numeric" default="0">
<cfparam name="form.frm_customize" type="numeric" default="0">

<!---
<cfdump var="#form#">
--->

<cfinvoke component="#request.a_str_component_newsletter#" method="CreateOrUpdateNewsletterProfile" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="type" value="#form.frm_type#">
	<cfinvokeargument name="name" value="#form.frmname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="manage_subscriptions" value="#form.frm_subscription_management#">
	<cfinvokeargument name="open_tracking" value="#form.frm_open_tracking#">
	<cfinvokeargument name="default_format" value="#form.frmdefaultformat#">
	<cfinvokeargument name="crm_filter_keys" value="#form.frmfilterkey#">
	<cfinvokeargument name="sender_name" value="#form.frm_sender_name#">
	<cfinvokeargument name="sender_address" value="#form.frm_sender_address#">
	<cfinvokeargument name="replyto" value="#form.frmreplyto#">
	<cfinvokeargument name="confirmation_url_unsubscribed" value="#form.frm_confirmationurl_unsubscribe#">
	<cfinvokeargument name="confirmation_url_subscribed" value="#form.frm_confirmationurl_subscribe#">
	<cfinvokeargument name="default_header" value="#form.frmheader#">
	<cfinvokeargument name="default_footer" value="#form.frmfooter#">
	<cfinvokeargument name="langno" value="#form.frmlanguage#">
	<cfinvokeargument name="test_addresses" value="#form.frm_test_addresses#">
</cfinvoke>

<cflocation addtoken="no" url="default.cfm">