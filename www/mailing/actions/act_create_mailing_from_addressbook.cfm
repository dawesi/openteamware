<!--- //

	Module:		Newsletter
	Action:		CreateMailingFromAddressBook
	Description: 
	

	
	
	create a temp mailing for a newsletter mailing
	
	the contactkeys are stored in the session variable 
	
	session.a_struct_temp_data.addressbook_selected_entrykeys
	
// --->
	
<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter) />	
	
<!--- create a dummy list, add the address book items and forward to the window for composing a new mailing --->
<cfset a_str_listkey = CreateUUID()>

<cfinvoke component="#a_cmp_nl#" method="CreateOrUpdateNewsletterProfile" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#a_str_listkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<!--- 2 = select form address book directly --->
	<cfinvokeargument name="type" value="2">
	<!--- name: test --->
	<cfinvokeargument name="name" value="Mailing #LsDateFormat(Now(), request.stUserSettings.default_Dateformat)#">
	<cfinvokeargument name="crm_filter_keys" value="">
	<cfinvokeargument name="description" value="">
	<cfinvokeargument name="manage_subscriptions" value="0">
	<cfinvokeargument name="open_tracking" value="1">
	<cfinvokeargument name="default_format" value="html">
	<cfinvokeargument name="sender_name" value="#request.stSecurityContext.myusername#">
	<cfinvokeargument name="sender_address" value="#request.stSecurityContext.myusername#">
	<cfinvokeargument name="addressbook_mailing" value="1">
	<cfinvokeargument name="delete_profile_after_sending" value="1">
</cfinvoke>
	
<cfloop list="#session.a_struct_temp_data.addressbook_selected_entrykeys#" index="a_str_contactkey">
	<!--- ... --->
	<cfset a_struct_subscribe = a_cmp_nl.SubscribeUser(securitycontext = request.stSecurityContext, usersettings = request.stUserSettings, listkey = a_str_listkey, contactkey = a_str_contactkey)>
</cfloop>
	
<cflocation addtoken="no" url="index.cfm?action=newissue&listkey=#a_str_listkey#">


