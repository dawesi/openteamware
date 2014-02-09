
<cfinvoke component="/components/management/workgroups/cmp_secretary" method="DeleteSecretaryEntry" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cflocation addtoken="no" url="../default.cfm?action=workgroups#writeurltags()#">