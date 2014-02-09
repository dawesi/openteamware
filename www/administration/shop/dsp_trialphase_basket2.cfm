
<!---<cfdump var="#form#">--->

<cfinclude template="queries/q_delete_old_items.cfm">
<cfinclude template="queries/q_insert_trialendaccountaction.cfm">


<!--- start with groupware ... --->
<cfset a_int_groupware_accounts = ListLen(form.frmgroupware)>

<cfif a_int_groupware_accounts GT 0>

	<!--- select product --->
	<cfset SelectProductRequest.entrykey = 'AE79D26D-D86D-E073-B9648D735D84F319'>
	<cfinclude template="../queries/q_select_product.cfm">
	
	<!--- select prices --->
	<cfset SelectPricesRequest.Entrykey =  'AE79D26D-D86D-E073-B9648D735D84F319'>
	<cfinclude template="../queries/q_select_prices.cfm">
	
	<!---<cfdump var="#q_select_prices#">--->
	
	<!--- select right price --->
	<cfquery name="q_select_price" dbtype="query" maxrows="1">
	SELECT
		MIN(price1) AS price1
	FROM
		q_select_prices
	WHERE
		quantity <= #val(a_int_groupware_accounts)#
	;
	</cfquery>
	
	<cfset a_int_price = DecimalFormat(12 * q_select_price.price1 * a_int_groupware_accounts)>
	
	<cfoutput>#a_int_groupware_accounts#: #a_int_price#</cfoutput>
	
		<cfset InsertOrderRequest.productkey = 'AE79D26D-D86D-E073-B9648D735D84F319'>
		<cfset InsertOrderRequest.entrykey = CreateUUID()>
		<cfset InsertOrderRequest.companykey = form.frmcompanykey>
		<cfset InsertOrderRequest.paid = 0>
		<cfset InsertOrderRequest.durationinmonths = 12>
		<cfset InsertOrderRequest.quantity = a_int_groupware_accounts>
		
		<!--- new price calculated  ... --->
		<cfset InsertOrderRequest.totalamount = a_int_price>

		<!--- original price ... --->
		<cfset InsertOrderRequest.OriginalTotalAmount = a_int_price>
		<!--- one year and next day ... --->
		<cfset InsertOrderRequest.contractend = DateAdd("m", 12, now())+1>
		<cfset InsertOrderRequest.createdbyuserkey = request.stSecurityContext.myuserkey>
		
		<cfinclude template="../queries/q_insert_order.cfm">

</cfif>

<!--- professional --->
<cfset a_int_professional_accounts = ListLen(form.frmprofessional)>

<cfif a_int_professional_accounts GT 0>

	<!--- select product --->
	<cfset SelectProductRequest.entrykey = 'AD4262D0-98D5-D611-4763153818C89190'>
	<cfinclude template="../queries/q_select_product.cfm">
	
	<!--- select prices --->
	<cfset SelectPricesRequest.Entrykey =  'AD4262D0-98D5-D611-4763153818C89190'>
	<cfinclude template="../queries/q_select_prices.cfm">
	
	<!---<cfdump var="#q_select_prices#">--->
	
	<!--- select right price --->
	<cfquery name="q_select_price" dbtype="query" maxrows="1">
	SELECT
		MIN(price1) AS price1
	FROM
		q_select_prices
	WHERE
		quantity <= #val(a_int_professional_accounts)#
	;
	</cfquery>
	
	<cfset a_int_price = DecimalFormat(12 * q_select_price.price1 * a_int_professional_accounts)>
	
	<cfoutput>#a_int_professional_accounts#: #a_int_price#</cfoutput>
	
	
		<cfset InsertOrderRequest.productkey = 'AD4262D0-98D5-D611-4763153818C89190'>
		<cfset InsertOrderRequest.entrykey = CreateUUID()>
		<cfset InsertOrderRequest.companykey = form.frmcompanykey>
		<cfset InsertOrderRequest.paid = 0>
		<cfset InsertOrderRequest.durationinmonths = 12>
		<cfset InsertOrderRequest.quantity = a_int_professional_accounts>
		
		<!--- new price calculated  ... --->
		<cfset InsertOrderRequest.totalamount = a_int_price>

		<!--- original price ... --->
		<cfset InsertOrderRequest.OriginalTotalAmount = a_int_price>
		<!--- one year and next day ... --->
		<cfset InsertOrderRequest.contractend = DateAdd("m", 12, now())+1>
		<cfset InsertOrderRequest.createdbyuserkey = request.stSecurityContext.myuserkey>
		
		<cfinclude template="../queries/q_insert_order.cfm">	

</cfif>

<!--- insert into basket and create order --->


<cfset SelectBookedServices.companykey = form.frmcompanykey>
<cfinclude template="../queries/q_select_booked_services.cfm">

<cfquery name="q_select_open_services" dbtype="query">
SELECT
	*
FROM
	q_select_booked_services
WHERE
	paid = 0
;
</cfquery>

<form action="default.cfm" method="get" name="formorder">
<input type="hidden" name="action" value="generatebill">
<input type="hidden" name="resellerkey" value="<cfoutput>#htmleditformat(form.frmresellerkey)#</cfoutput>">
<input type="hidden" name="companykey" value="<cfoutput>#htmleditformat(form.frmcompanykey)#</cfoutput>">

<cfoutput query="q_select_open_services">
<input name="frmorderid" type="hidden" value="#q_select_open_services.entrykey#">
</cfoutput>
<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_shop_trial_finish_order')#</cfoutput>">
</form>

<script type="text/javascript">
	document.formorder.submit();
</script>