<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="form.frmlistkey" type="string" default="">
<cfparam name="form.frmcontactkeys" type="string" default="">

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>

<cfif Len(form.frmlistkey) IS 0>
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<cfif Len(form.frmcontactkeys) IS 0>
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<cfdump var="#form#">

<cfloop list="#form.frmcontactkeys#" delimiters="," index="a_str_contactkey">
	<!--- add ... --->
	
	<cfset a_struct_subscribe = a_cmp_nl.SubscribeUser(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, listkey = form.frmlistkey, contactkey = a_str_contactkey)>

</cfloop>

<cflocation addtoken="no" url="index.cfm">