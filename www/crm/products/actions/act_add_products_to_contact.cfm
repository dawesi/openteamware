<!--- //
	Module:            CRM / Products
	Action:            doAddMultipleProductsToContact
	Description:       adds multiple products to a contact
// --->

<cfparam name="form.frmcontactkey" type="string" />
<cfparam name="form.frmproductkeys" type="string" />

<cfset a_bool_result = true />

<cfloop index="a_str_productkey" list="#form.frmproductkeys#">
    
    <cfset a_struct_product_of_contact = StructNew() />
    <cfset a_struct_product_of_contact.contactkey = form.frmcontactkey />
    <cfset a_struct_product_of_contact.projectkey = a_str_productkey />
    <cfset a_struct_product_of_contact.dt_added = LSParseDateTime(form.frmdt_added) />
            
    <cfset a_struct_product_of_contact.quantity = form['frm' & a_str_productkey & '.quantity'] />
    <cfset a_struct_product_of_contact.retail_price = form['frm' & a_str_productkey & '.retail_price'] />
    <cfset a_struct_product_of_contact.purchase_price = form['frm' & a_str_productkey & '.purchase_price'] />
    <cfset a_struct_product_of_contact.comment = form['frm' & a_str_productkey & '.comment'] />
    
	<cfinvoke component="#application.components.cmp_products#" method="AddProductToContact" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="action_type" value="create">
		<cfinvokeargument name="database_values" value="#a_struct_product_of_contact#">
		<cfinvokeargument name="all_values" value="#StructNew()#">
	</cfinvoke>
    <cfif NOT stReturn.result>
        <cfset a_bool_result = false />
	</cfif>
</cfloop>

<cfif NOT a_bool_result>
	<cflocation url="/crm/index.cfm?action=showProductsOfContact&contactkey=#form.frmcontactkey#&editmode=true&ibxerrorno=#stReturn.error#"/>
</cfif>
<cflocation url="/crm/index.cfm?action=showProductsOfContact&contactkey=#form.frmcontactkey#&editmode=true"/>
        

