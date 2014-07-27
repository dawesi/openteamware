<!--- //

	add a product to the basket ...
	
	// --->
	
<!--- maybe entered by the reseller ... --->
<cfparam name="form.frmdiscount" default="">

<!--- the pricelist entrykey --->
<cfparam name="form.frmproductkey" type="string" default="">

<cfif Len(form.frmproductkey) IS 0>
	<b>Please select a quantity</b>
	<cfabort>
</cfif>

<!--- the price ... --->
<cfparam name="form.frmpriceentrykey" type="string" default="">

<!--- load the company data ... --->
<cfset LoadCompanyData.entrykey = form.frmcompanykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfif (q_select_company_data.settlement_type IS 1)>
	<fieldset>
		<legend><cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput></legend>
		<div>
			<cfoutput>#GetLangVal('adm_ph_transparent_reseller_hint_shop')#</cfoutput> 
		</div>
	</fieldset>
	<br>
</cfif>		

<cfinvoke component="/components/management/customers/cmp_customer" method="GetContractEnd" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#form.frmcompanykey#">
</cfinvoke>

<!--- load the price data --->
<cfset SelectProductRequest.entrykey = form.frmproductkey>
<cfinclude template="queries/q_select_product.cfm">


<cfif form.frmpriceentrykey is 'own'>
	<!--- own amount ... --->
	
	<cfset q_select_price = QueryNew('quantity,price1')>
	
	<cfset QueryAddRow(q_select_price, 1)>
	
	<cfset QuerySetCell(q_select_price, 'quantity', form.frmownquantity, 1)>
	<cfset QuerySetCell(q_select_price, 'price1', form.frmpriceown, 1)>
	
	<!--- check if OK --->

<cfelse>
	<cfset SelectPriceRequest.Entrykey = form.frmpriceentrykey>
	<cfinclude template="queries/q_select_price.cfm">
</cfif>

<!--- load all prices --->
<cfset SelectPricesRequest.Entrykey = form.frmproductkey>
<cfinclude template="queries/q_select_prices.cfm">

<!--- select now better price if the user has already bought a licence ... --->

<cfset a_int_quantity_already_bought = 0>

<cfswitch expression="#form.frmproductkey#">
	<!--- check if a licence already has been bought ... --->
	<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
		<!--- groupware --->
		<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
			<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
			<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
		</cfinvoke>
		
		<cfset a_int_quantity_already_bought = q_select_licence_status.totalseats>
		
		</cfcase>
	
	<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
	
		<!--- einzelplatz --->
		<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
			<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
			<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
		</cfinvoke>
		
		<cfset a_int_quantity_already_bought = q_select_licence_status.totalseats>
	</cfcase>	
</cfswitch>

<!--- calculate the best price ... --->
<cfif a_int_quantity_already_bought GT 0>
	<cfquery name="q_select_best_price" dbtype="query" maxrows="1">
	SELECT
		MIN(price1) AS price1
	FROM
		q_select_prices
	WHERE
		quantity <= #val(q_select_licence_status.totalseats + q_select_price.quantity)#
	;
	</cfquery>
	
	<cfif Val(q_select_best_price.price1) GT 0>
		<!--- set now all rows to this value if higher ... --->
		<cfset a_max_price = q_select_best_price.price1>
		
		<cfif q_select_price.price1 GT a_max_price>
			<cfset QuerySetCell(q_select_price, 'price1', DecimalFormat(a_max_price), 1)>
		</cfif>
		
	</cfif>
</cfif>


<cfif q_select_product.ongoing is 1>
	<!--- ongoing product ... --->
	
	<cfif isDate(q_select_company_data.dt_contractend) is true>
		<!---<cfoutput>#dateformat(q_select_company_data.dt_contractend, "dd.mm.yy")#</cfoutput>--->
		
		<cfset a_int_contract_months_duration = DateDiff("m", now(), q_select_company_data.dt_contractend)>
		
		<cfif a_int_contract_months_duration is 0>
			<cfset a_int_contract_months_duration = 1>
		</cfif>	
		
	<cfelse>
		<cfset a_int_contract_months_duration = 12>
		<!---(1 Jahr ab Abschluss)--->
	</cfif>
<cfelse>
	<!--- a one-time-product --->
	
	<cfset a_int_contract_months_duration = 1>
	
</cfif>

<cfset a_int_original_price = DecimalFormat(a_int_contract_months_duration * q_select_price.price1 * q_select_price.quantity)>
<cfset a_int_price = DecimalFormat(a_int_contract_months_duration * q_select_price.price1 * q_select_price.quantity)>

<cfif len(form.frmdiscount) gt 0 AND isNumeric(form.frmdiscount) is true>
	<!--- subtract special discount ... --->
	<cfset a_int_price = form.frmdiscount>
	
	<!--- insert a special product ... the discount order ... --->
	
	
</cfif>

<cfset a_int_price = ReplaceNoCase(a_int_price, ',', '', 'ALL')>
<!---<cfoutput>#a_int_price#</cfoutput>..--->


<cfset InsertOrderRequest.productkey = form.frmproductkey>
<cfset InsertOrderRequest.entrykey = CreateUUID()>
<cfset InsertOrderRequest.companykey = form.frmcompanykey>
<cfset InsertOrderRequest.paid = 0>
<cfset InsertOrderRequest.durationinmonths = form.frmcontractdurationinmonths>
<cfset InsertOrderRequest.quantity = q_select_price.quantity>

<!--- new price calculated  ... --->
<cfset InsertOrderRequest.totalamount = a_int_price>

<!--- original price ... --->
<cfset InsertOrderRequest.OriginalTotalAmount = a_int_original_price>

<cfset InsertOrderRequest.specialdiscount = form.frmdiscount>

<cfif isDate(stReturn.dt_contractend) is true>
	<cfset InsertOrderRequest.contractend = stReturn.dt_contractend>
<cfelse>
	<!--- one year and next day ... --->
	<cfset InsertOrderRequest.contractend = DateAdd("m", 12, now())+1>
</cfif>

<cfset InsertOrderRequest.createdbyuserkey = request.stSecurityContext.myuserkey>

<!---<cfdump var="#InsertOrderRequest#">--->
<cfinclude template="queries/q_insert_order.cfm">

<b><cfoutput>#GetLangVal('adm_ph_shop_product_has_been_put_into_basket')#</cfoutput></b>
<hr size="1" noshade>
<form method="post" action="index.cfm?action=shop<cfoutput>#WriteURLTagsfromForm()#</cfoutput>">
<cfoutput>#GetLangVal('adm_ph_shop_continue_shopping')#</cfoutput><br>
<input type="submit" value="<cfoutput>#GetLangVal('adm_ph_shop_continue_shopping_btn')#</cfoutput>" style="font-weight:bold;">
</form>
<br><br>
<form action="index.cfm?action=accounting<cfoutput>#WriteURLTagsfromForm()#</cfoutput>" method="post">
<cfoutput>#GetLangVal('adm_ph_shop_checkout')#</cfoutput><br>
<input type="submit" name="frmsubmit" style="font-weight:bold;" value="<cfoutput>#GetLangVal('adm_ph_shop_checkout_btn')#</cfoutput>">
</form>
<br>
<br>
