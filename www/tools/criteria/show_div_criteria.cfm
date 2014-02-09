<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCriteriaTree" returnvariable="sReturn">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
	<cfinvokeargument name="selected_ids" value="#url.ids#">
	<cfinvokeargument name="options" value="display_selected">
</cfinvoke>

<cfoutput>#sReturn#</cfoutput>