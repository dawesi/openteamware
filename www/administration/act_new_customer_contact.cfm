<!--- //

	add a new customer contact
	
	// --->
<cfparam name="form.FRMCBPERMISSIONS" type="string" default="">

<cfif Len(form.FRMCBPERMISSIONS) IS 0>
	<h4><cfoutput>#GetLangVal('adm_ph_error_no_rights_selected')#</cfoutput></h4>
	<cfabort>
</cfif>
<cfdump var="#form#">

<cfinvoke component="/components/management/customers/cmp_customer" method="AddCustomerContact" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="type" value="#form.frmtype#">
	<cfinvokeargument name="permissions" value="#form.frmcbpermissions#">
	<cfinvokeargument name="level" value="#form.frmlevel#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">