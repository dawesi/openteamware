<cfinvoke component="#application.components.cmp_crmsales#" method="DeleteCriteria" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="id" value="#url.id#">
</cfinvoke>

<cfif a_bol_return>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
<cfelse>
	<cfoutput>#GetLangVal('adm_ph_criteria_delete_failed_sub_elements')#</cfoutput>
</cfif>