
<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="#application.components.cmp_customer#" method="RemoveCustomerContact" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.userkey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">