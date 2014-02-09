<!--- //

	Module:		Switch
	Description:Offer user to switch to other user ...
	

// --->

<cfset a_cmp_users = application.components.cmp_user>
<cfset q_select_sso_settings = application.components.cmp_security.LoadSwitchUsersData(userkey = request.stSecurityContext.myuserkey)>

<cfif q_select_sso_settings.recordcount IS 0>
	No other users available.
	<cfexit method="exittemplate">
</cfif>

<div style="padding-bottom:12px;" class="bb">
<b><cfoutput>#si_img('user_go')#</cfoutput> Please select the user you want to switch to.</b>
<br /> <br /> 
Keep in mind that all unsaved data is lost when logging on with a new user!
</div>

<cfset a_str_content = application.components.cmp_content.DisplayUserSwitchDialog(securitycontext = request.stSecurityContext)>

<cfoutput>#a_str_content#</cfoutput>

<div style="padding:12px;" class="bt">
	<a href="javascript:CloseSimpleModalDialog();"><cfoutput>#si_img('cross')#</cfoutput> Cancel and close this window</a>
	|
	<a href="/settings/default.cfm?Action=ManageSSO"><cfoutput>#si_img('pencil')#</cfoutput> Manage SSO preferences</a>
</div>


