<!--- //
	Module:            CRM / Products
	Action:            removeProductFromContact
	Description:       removes assigned product from contact
// --->

<cfparam name="url.entrykey" type="string" />
<cfparam name="url.contactkey" type="string" />
        
<cfinvoke component="#application.components.cmp_products#" method="RemoveProductFromContact" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="/crm/index.cfm?action=showProductsOfContact&contactkey=#url.contactkey#&editmode=true&ibxerrorno=#stReturn.error#"/>
</cfif>
<cflocation url="/crm/index.cfm?action=showProductsOfContact&contactkey=#url.contactkey#&editmode=true"/>


