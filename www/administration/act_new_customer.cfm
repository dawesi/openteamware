<!--- //

	create a customer ...
	
	// --->
	
<!--- check entered data ... --->
<cfparam name="form.frmcompanyemail" type="string" default="">
<cfparam name="form.frmshortname" type="string" default="">

<cfif Len(ExtractEmailAdr(form.frmcompanyemail)) IS 0>
	<b><cfoutput>#GetLangVal('adm_ph_error_enter_valid_email')#</cfoutput></b>
	<cfabort>
</cfif>

<cfif len(form.frmcompanyname) is 0>
	<cfoutput>#GetLangVal('adm_ph_error_enter_companyname')#</cfoutput>
	<cfabort>
</cfif>
	
<cfset a_str_customer_key = CreateUUID()>

<cfif form.frmdomain is 'own'>
	<cfset form.frmdomain = form.frmowndomain>
</cfif>

<!--- trial phase end --->
<cfset a_dt_trialphase_end = LSParseDateTime(form.frmdt_trialphase_end)>

<cfif DateDiff('d', now(),a_dt_trialphase_end) GT 30>
	<cfset a_dt_trialphase_end = DateAdd('d', 30, Now())>
</cfif> 

<!--- call component now instead of simple query --->


<cfinvoke component="#application.components.cmp_customer#" method="CreateCustomer" returnvariable="a_bol_return">
	<cfinvokeargument name="resellerkey" value="#form.frmresellerkey#">
	<cfinvokeargument name="entrykey" value="#a_str_customer_key#">
	<cfinvokeargument name="assignedtoreseller" value="1">
	<cfinvokeargument name="status" value="#val(form.frmradiostatus)#">
	<cfinvokeargument name="companyname" value="#form.frmcompanyname#">
	<cfinvokeargument name="shortname" value="#form.frmshortname#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
	<cfinvokeargument name="contactperson" value="#form.frmcontactperson#">
	<cfinvokeargument name="customertype" value="#form.frmtype#">
	<cfinvokeargument name="domains" value="#form.frmdomain#">
	<cfinvokeargument name="telephone" value="#form.frmcompanytelephone#">
	<cfinvokeargument name="street" value="#form.frmcompanystreet#">
	<cfinvokeargument name="zipcode" value="#form.frmcompanyzipcode#">
	<cfinvokeargument name="city" value="#form.frmcompanycity#">
	<cfinvokeargument name="countryisocode" value="#form.frmcompanycountry#">
	<cfinvokeargument name="email" value="#form.frmcompanyemail#">
	<cfinvokeargument name="industry" value="#form.frmindustry#">
	<cfinvokeargument name="language" value="#form.frmlanguage#">
	<cfinvokeargument name="dt_trialphase_end" value="#CreateODBCDateTime(a_dt_trialphase_end)#">
	<cfinvokeargument name="billingcontact" value="#form.frmbillingcontact#">
	<cfinvokeargument name="uidnumber" value="#form.frmcompanyuidnumber#">
	<cfinvokeargument name="settlement_type" value="#form.frm_settlement_type#">
	
	<cfif form.frm_settlement_type IS 0>
		<!--- standard settlement ... abrechnen �ber openTeamware.com --->
		<cfinvokeargument name="generaltermsandconditions_accepted" value="0">,
	<cfelse>
		<!--- wenn die verrechnung indirekt verl�uft, keine AGB zustimmung erforderlich --->
		<cfinvokeargument name="generaltermsandconditions_accepted" value="1">,
	</cfif>	
	
</cfinvoke>

<!---<cfinclude template="queries/q_insert_customer.cfm">--->

<cflocation addtoken="no" url="default.cfm?action=customerproperties&companykey=#urlencodedformat(a_str_customer_key)#&resellerkey=#urlencodedformat(form.frmresellerkey)#">