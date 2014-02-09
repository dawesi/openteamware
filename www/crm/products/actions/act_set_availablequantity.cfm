<!--- //
	Module:            CRM / Products
	Action:            setAvailableQuantityOfProduct
	Description:       update available quantity for product
// --->
<cfparam name="form.frmproductkey" type="string" />
<cfparam name="form.frmproducttitle" type="string" />
<cfparam name="form.frmproduct_q" type="string" />
<cfparam name="form.frmproductquantitykey" type="string" />
<!--- Output from FORM:		form.frmcompanykey		invisible
							form.frmproductkey  	invisible
							product_q				Changed quantity
							productquantitykey      entrykey in productquantity table
 --->

<!--- definition of structure for changed data --->
<cfset a_struct_available_quantity_of_product = StructNew() />
<cfset a_struct_available_quantity_of_product.quantity = form.frmproduct_q />

<!--- filter which specifies if product has record at the table productquantity --->
<cfset filter_for_quantity = StructNew() />
<cfset filter_for_quantity.productkey = form.frmproductquantitykey />

<cfset actual_action =  ''/>

<!--- if productquantitykey is submitted, updates, else insert --->								
<cfif Len(form.frmproductquantitykey) IS 0>
	<cfset actual_action = 'INSERT'/>
	<cfset a_struct_available_quantity_of_product.entrykey = CreateUUID() />
	<cfset a_struct_available_quantity_of_product.userkey = request.stSecurityContext.myuserkey />
	<cfset a_struct_available_quantity_of_product.productkey = form.frmproductkey />
<cfelse>
	<cfset actual_action = 'UPDATE'/>
	<cfset a_struct_available_quantity_of_product.entrykey = form.frmproductquantitykey />
</cfif>


<!--- invoke INSERT or UPDATE function for creating or updating available quantity of product --->
<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_db">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="database" value="#request.a_str_db_crm#">
	<cfinvokeargument name="table" value="productquantity">
	<cfinvokeargument name="primary_field" value="entrykey">
	<cfinvokeargument name="data" value="#a_struct_available_quantity_of_product#">
	<cfinvokeargument name="action" value="#actual_action#">
</cfinvoke>


<cfif NOT stReturn_db.result>
	<cflocation url="/addressbook/default.cfm?action=setAvailableQuantity&productquantitykey=#stReturn.q_select_productquantity.productquantitykey#&productkey=#a_struct_available_quantity_of_product.productkey#&quantity=#a_struct_available_quantity_of_product.quantity#&title=#form.frmproducttitle#&ibxerrorno=#stReturn_db.error#"/>
</cfif>
<cflocation url="/crm/default.cfm?action=productadmin"/>