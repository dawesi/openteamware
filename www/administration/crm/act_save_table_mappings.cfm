<cfdump var="#form#">

<!--- //

	update crm mappings ...
	
	// --->
	
<cfinvoke component="#application.components.cmp_crmsales#" method="SetCRMSalesBinding" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="databasekey" value="#form.frmdatabasekey#">
	<cfinvokeargument name="additionaldata_tablekey" value="#form.frm_additional_data#">
	<cfinvokeargument name="userkey_data" value="#form.frmuserkey_data#">
</cfinvoke>
	
	
<!--- //

	save further settings
	
	// --->
	
	
<!--- salutation field ... --->
<cfinvoke component="#request.a_str_component_crm_sales#" method="UpdateVariousCRMSettings" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="key" value="salutation_field">
	<cfinvokeargument name="value" value="#form.frmsalutation_field#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">