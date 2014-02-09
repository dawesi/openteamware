
<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="/components/email/cmp_accounts" method="RemoveAliasAddress" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.userkey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="emailaddress" value="#url.address#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">