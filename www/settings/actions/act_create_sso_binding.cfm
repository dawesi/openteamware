<!--- //

	Module:		Preferences
	Action:		CreateSSOBinding
	Description:Create a new single sign on binding
	

// --->

<cfset a_str_otheruserkey = application.components.cmp_user.GetEntrykeyFromUsername(username = form.frmusername)>

<cfinvoke component="#application.components.cmp_security#" method="AddSwitchUserRelation" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="otheruserkey" value="#a_str_otheruserkey#">
	<cfinvokeargument name="otherpassword_md5" value="#Hash(form.frmpassword)#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="comment" value="#form.frmcomment#">
</cfinvoke>

<cflocation addtoken="false" url="default.cfm?action=managesso&ibxerrorno=#stReturn.error#">

