<cfdump var="#form#">

<cfinvoke component="#application.components.cmp_security#" method="ApplyRoleToUser" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="rolekey" value="#form.frmrolekey#">
</cfinvoke>

<cflocation addtoken="no" url="../index.cfm?action=securityrole.display&entrykey=#urlencodedformat(form.frmrolekey)##WriteURLTagsFromForm()#">