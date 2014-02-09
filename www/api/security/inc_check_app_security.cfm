<!--- app key ... --->


<!---

	Do NOTHING NOW

<cfset a_bol_app_enabled = CreateObject('component', 'cmp_security').IsAppAllowedToOperate(applicationkey = arguments.applicationkey)>


<cfif NOT a_bol_app_enabled>
	<cfset stReturn.error = 520>
	<cfset stReturn.errormessage = 'App is not allowed to use DirectAccess'>
	<cfreturn stReturn>
</cfif>

--->