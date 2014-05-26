<!--- //

	Module:		Settings
	Action:		DeleteSSOBinding
	Description:Delete SSO binding ...
	

// --->

<!--- entrykey of binding ... --->
<cfparam name="url.entrykey" type="string">

<!--- userkey of other user ... --->
<cfparam name="url.otheruserkey" type="string">

<cfinvoke component="#application.components.cmp_security#" method="DeleteSwitchUserRelation" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="otheruserkey" value="#url.otheruserkey#">
</cfinvoke>

<cflocation addtoken="false" url="index.cfm?action=managesso&ibxerrorno=#stReturn.error#">

