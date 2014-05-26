

<cfinvoke component="/components/management/customers/cmp_customer" method="UpdateCustomerContact" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="permissions" value="#form.frmcbpermissions#">
	<cfinvokeargument name="type" value="#form.frmtype#">
	<cfinvokeargument name="level" value="#form.frmlevel#">
</cfinvoke>

<cflocation addtoken="no" url="../index.cfm?action=customercontacts&#WriteURLTagsFromForm()#">