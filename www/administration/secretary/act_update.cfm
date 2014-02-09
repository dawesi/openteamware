<cfinvoke component="#request.a_str_component_secretary#" method="UpdateSecretaryEntry" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="permission" value="#form.frmcb_permission#">
</cfinvoke>

<cflocation addtoken="no" url="../default.cfm?action=workgroups#writeurltagsfromform()#">