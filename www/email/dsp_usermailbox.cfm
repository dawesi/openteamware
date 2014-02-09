<!--- //

	mailbox of a certain user ...
	
	// --->
	
<cfparam name="url.userkey" type="string" default="">

	
<cfinvoke component="#application.components.cmp_customer#" method="IsUserCompanyAdmin" returnvariable="a_bol_return_is_admin">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfif NOT a_bol_return_is_admin>
	Access not allowed
	<cfexit method="exittemplate">
</cfif>


<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>



<cfif Len(url.userkey) IS 0>
	<!--- load users ... --->
	<cfinclude template="shareddata/dsp_show_usermailboxes.cfm">
	<cfexit method="exittemplate">
</cfif>


<cfif ListFind(ValueList(q_select_users.entrykey), url.userkey) IS 0>
	<h4>User is not listed in company directory</h4>
	<cfexit method="exittemplate">
</cfif>
	
<!--- load userdata ... --->
<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.userkey#">
</cfinvoke>

<!--- display folders ... --->
<cfinvoke component="/components/email/cmp_accounts" method="GetIMAPAccessdata" returnvariable="a_struct_imap_access_data">
	<cfinvokeargument name="userkey" value="#url.userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_email#" method="loadfolders" returnvariable="struct_result">
<cfinvokeargument name="accessdata" value="#a_struct_imap_access_data#">
</cfinvoke>

<cfset request.q_select_folders = struct_result.query>

<cfinclude template="dsp_all_folders.cfm">