<!---

	the company key ... --->

<cfparam name="url.frmcompanykey"  type="string" default="">

<!--- the reseller key --->
<cfparam name="url.resellerkey" type="string" default="">

<!--- product ... --->
<cfparam name="url.frmentrykey" type="string" default="">

<cfparam name="url.frmcontractdurationinmonths" type="numeric" default="12">

<!--- if possible, let the use enter own quantity --->
<cfparam name="url.ownquantity" type="string" default="">

<cfset url.ownquantity = val(url.ownquantity)>

<cfif ListFind("12,24,36", url.frmcontractdurationinmonths) is 0>
	<!--- no games ... ;-) --->
	<cfset url.frmcontractdurationinmonths = 12>
</cfif>

<cfset a_cmp_shop = CreateObject('component', request.a_str_component_shop)>

<!--- load company data ... --->

<cfset LoadCompanyData.entrykey = url.frmcompanykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfset a_str_customer_style = application.components.cmp_customer.GetCompanyCustomStyle(companykey = url.frmcompanykey)>

<cfset a_cmp_customize = application.components.cmp_customize>
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_customer_style, entryname = 'main').Productname>


<!--- select the product properties ... --->

<!---<cfset SelectProductRequest.entrykey = url.frmentrykey>
<cfinclude template="queries/q_select_product.cfm">--->

<cfinvoke component="#a_cmp_shop#" method="GetProduct" returnvariable="q_select_product">
	<cfinvokeargument name="productkey" value="#url.frmentrykey#">
</cfinvoke>

<cfif (q_select_company_data.settlement_type IS 1)>
	<fieldset>
		<legend><cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput></legend>
		<div>
			<cfoutput>#GetLangVal('adm_ph_transparent_reseller_hint_shop')#</cfoutput> 
		</div>
	</fieldset>
	<br>
</cfif>		


<cfoutput query="q_select_product">

<h4><img src="../images/img_desk.png" width="32" height="32" hspace="2" vspace="2" border="0" align="absmiddle"> #GetLangVal('adm_wd_Add')# "#htmleditformat(ReplaceNoCase(q_select_product.productname, 'openTeamWare.com', a_str_product_name, 'ALL'))#"</h4>

#htmleditformat(ReplaceNoCase(q_select_product.description, 'openTeamWare.com', a_str_product_name, 'ALL'))#<br><br>

</cfoutput>


<cfoutput>
#GetLangVal('adm_ph_contract_duration')#:&nbsp;
</cfoutput>



<cfif isDate(q_select_company_data.dt_contractend) is true>

	<cfoutput>#dateformat(q_select_company_data.dt_contractend, "dd.mm.yy")#</cfoutput>

<cfelse>

	(<cfoutput>#GetLangVal('adm_ph_contract_duration_one_year_after_sale')#</cfoutput>)

</cfif>



<cfif q_select_product.ongoing is 1>



	<!--- a product going on for many months ... not a one-time fee --->

	

	<cfif (q_select_company_data.dt_contractend lt Now())>

		

		

		<cfset a_int_discount = 1>

		<cfset a_int_contract_months_duration = url.frmcontractdurationinmonths>

	<cfelse>

	

		

	

		<cfset a_int_contract_months_duration = DateDiff("m", now(), q_select_company_data.dt_contractend)>

		

		<cfif a_int_contract_months_duration is 0>

			<cfset a_int_contract_months_duration = 1>

		</cfif>

		

		<cfoutput>#GetLangVal('adm_ph_contract_until')#</cfoutput> <cfoutput>#DateFormat(q_select_company_data.dt_contractend, "dd.mm.yy")# (=#a_int_contract_months_duration# #GetLangVal('cm_wd_months')#)</cfoutput>

		

		<cfif a_int_contract_months_duration gt 24>

		

		</cfif>

	

		<cfset a_int_discount = 1>

	

	</cfif>

</cfif>

<br><br>





<cfset SelectPricesRequest.Entrykey = url.frmentrykey>
<cfinclude template="queries/q_select_prices.cfm">

<cfif q_select_prices.recordcount IS 0>
	<b><cfoutput>#GetLangVal('adm_ph_shop_contact_inboxcc_directly')#</cfoutput></b>
	<br><br>
	<cfoutput>#GetLangVal('adm_ph_shop_contact_inboxcc_directly_partner')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_quantity_already_bought = 0>

<cfswitch expression="#url.frmentrykey#">
	<!--- check if a licence already has been bought ... --->
	<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
		<!--- groupware --->
		<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
			<cfinvokeargument name="companykey" value="#url.frmcompanykey#">
			<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
		</cfinvoke>
		
		<cfset a_int_quantity_already_bought = q_select_licence_status.totalseats>
			
		<b><cfoutput>#GetLangVal('adm_ph_shop_seats_bought_until_now')#</cfoutput>: <cfoutput>#q_select_licence_status.totalseats#</cfoutput></b><br><br>
		</cfcase>
	
	<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
	
		<!--- einzelplatz --->
		<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
			<cfinvokeargument name="companykey" value="#url.frmcompanykey#">
			<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
		</cfinvoke>
		
		<cfset a_int_quantity_already_bought = q_select_licence_status.totalseats>
			
		<b><cfoutput>#GetLangVal('adm_ph_shop_seats_bought_until_now')#</cfoutput>: <cfoutput>#q_select_licence_status.totalseats#</cfoutput></b><br><br>
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
		quantity <= #val(q_select_licence_status.totalseats + 1)#
	;
	</cfquery>
	
	<cfif Val(q_select_best_price.price1) GT 0>
		<!--- set now all rows to this value if higher ... --->
		<cfset a_max_price = q_select_best_price.price1>
		
		<cfoutput query="q_select_prices">
			<cfif q_select_prices.price1 GT a_max_price>
				<cfset QuerySetCell(q_select_prices, 'price1', DecimalFormat(a_max_price), q_select_prices.currentrow)>
			</cfif>
		</cfoutput>
		
	</cfif>
</cfif>



<table border="0" cellspacing="0" cellpadding="4">

<form action="default.cfm?action=Addtobasket2" method="post" name="formaddtobasket">

<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.frmcompanykey)#</cfoutput>">

<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.frmresellerkey)#</cfoutput>">

<input type="hidden" name="frmproductkey" value="<cfoutput>#htmleditformat(url.frmentrykey)#</cfoutput>">

<input type="hidden" name="frmcontractdurationinmonths" value="<cfoutput>#htmleditformat(url.frmcontractdurationinmonths)#</cfoutput>">



  <tr class="lightbg">

    <td>&nbsp;</td>

    <td><cfoutput>#GetLangVal('adm_ph_shop_units')#</cfoutput></td>

    <td><cfoutput>#GetLangVal('adm_ph_shop_price_per_unit')#</cfoutput><cfif q_select_product.ongoing is 1>/<cfoutput>#GetLangVal('cal_wd_month')#</cfoutput></cfif></td>

    <td align="right"><cfoutput>#GetLangVal('adm_ph_shop_price_until_end_of_contract')#</cfoutput></td>

  </tr>

  <cfoutput query="q_select_prices">

  <tr>

    <td>

	<input class="noborder" onChange="SetNewPrice(this.value);" type="radio" name="frmpriceentrykey" value="#htmleditformat(q_select_prices.entrykey)#" <cfif q_select_prices.recordcount is 1>checked</cfif>>

	<input type="hidden" name="frmprice#htmleditformat(ReplaceNocase(q_select_prices.entrykey,'-','','ALL'))#" value="#q_select_prices.price1#">

	</td>

    <td align="center">#q_select_prices.quantity#</td>

	<!--- if the user has already ordered X products of this type, give him the better price ... --->
    <td align="right">#q_select_prices.price1# &euro;</td>

    <td align="right">
	<!--- calculate weeks remaining from the end of the contract ... --->

	<cfif q_select_product.ongoing is 1>
	
		<cfset a_int_price = q_select_prices.price1 * q_select_prices.quantity * a_int_contract_months_duration>

		<!--- calculate the discount ... --->

		<cfset a_int_price = a_int_price / a_int_discount>
		#DecimalFormat(a_int_price)# &euro;
		
	<cfelse>

		<!--- fix price ... --->
		#DecimalFormat(q_select_prices.price1 * q_select_prices.quantity)#

	</cfif>
	</td>
  </tr>
  </cfoutput>
  
  <!--- let the user enter own quantities? --->
  <cfif q_select_product.allowownquantities IS 1>
  <tr>
  	<td colspan="4" style="border-bottom:silver solid 1px;">
	<b><cfoutput>#GetLangVal('adm_ph_shop_enter_own_quantity')#</cfoutput></b>
	</td>
  </tr>
  <tr>
  	<td></td>
	<td colspan="3">
	<select name="frmownquantity" onChange="CalcPriceForOwnQuantity();">
		<option value=""> (<cfoutput>#GetLangVal('cm_ph_please_select')#</cfoutput>)</option>
		<cfloop from="1" to="250" index="ii">
		<cfoutput>
		<option #writeselectedelement(url.ownquantity, ii)# value="#ii#">#ii#</option>
		</cfoutput>
		</cfloop>
	</select>

	&nbsp;&nbsp;
	<a href="javascript:CalcPriceForOwnQuantity();"><cfoutput>#GetLangVal('cm_wd_calculate')#</cfoutput> ...</a>
	</td>
  </tr>
  
  <cfif VAL(url.ownquantity) GT 0>
  	<!--- select the appropriate price ... --->
	
	<cfquery name="q_select_price" dbtype="query" maxrows="1">
	SELECT
		MIN(price1) AS price1
	FROM
		q_select_prices
	WHERE
		quantity <= #val(url.ownquantity)#
	;
	</cfquery>
  	<tr>
		 	<td>
			<cfoutput>
		
			<input checked onChange="SetNewPrice(this.value);" type="radio" name="frmpriceentrykey" value="own">
			<input type="hidden" name="frmpriceown" value="#q_select_price.price1#">
		
			</td>
		
			<td align="center">#url.ownquantity#</td>
		
			<!--- if the user has already ordered X products of this type, give him the better price ... --->
			<td align="right">#Decimalformat(q_select_price.price1)# &euro;</td>
		
			<td align="right">
			<!--- calculate weeks remaining from the end of the contract ... --->
		
			<cfif q_select_product.ongoing is 1>
			
				<cfset a_int_price = q_select_price.price1 * url.ownquantity * a_int_contract_months_duration>
		
				<!--- calculate the discount ... --->
		
				<cfset a_int_price = a_int_price / a_int_discount>
				#DecimalFormat(a_int_price)# &euro;
				
			<cfelse>
		
				<!--- fix price ... --->
				<cfset a_int_price = q_select_price.price1 * url.ownquantity>
				#DecimalFormat(a_int_price)#
		
			</cfif>
			
			</td></cfoutput>
					
	
	</tr>  
  </cfif>
  
  </cfif>

	<!--- display rabatt possibility for resellers ... --->

  <cfif request.a_bol_is_reseller is true>

  <tr id="idtrrabatt" style="display:none;">

  	<td colspan="3" align="right">

	<cfoutput>#GetLangVal('adm_wd_shop_rebate')#</cfoutput>: 

	</td>

  	<td colspan="1" align="right">



		<select name="frmdiscountpercent" onChange="CalculateDiscount(this.value);">

			<option value="0">-</option>

			<option value="3">3</option>	

			<option value="5">5</option>

			<option value="7">7</option>

			<option value="10">10</option>

		</select>%

	</td>

  </tr>

  <tr id="idtrrabatt2" style="display:none;">

  	<td colspan="3" align="right">

		<cfoutput>#GetLangVal('adm_ph_shop_rebate_new_price')#</cfoutput>:

	</td>

	<td colspan="1" align="right">

		

		<input type="text" name="frmdiscount" size="4" value=""> &euro;

	

	</td>

  </tr>  

  <script type="text/javascript">

  	function ShowRabatt()

		{

		obj1 = findObj("idtrrabatt");

		obj1.style.display = "";

		obj2 = findObj("idtrrabatt2");

		obj2.style.display = "";		

		}

		

	function CalculateDiscount(i)

		{

		var price,pricekey,newprice;



		pricekey = document.formaddtobasket.frmpriceentrykey.value;

		

		var myNewString = pricekey.split('-').join("");		



		price = eval('document.formaddtobasket.frmprice'+myNewString);

		

		newprice = price.value - (price.value / 100  * i);

		

		document.formaddtobasket.frmdiscount.value = newprice;		

		}

		

	function SetNewPrice(id)

		{



		}

  </script>

  

  <tr>

  	<td colspan="4">

	[ <a href="javascript:ShowRabatt();">R</a> ]

	</td>

  </tr>

  

  </cfif>

  <tr>

  	<td colspan="4" align="right" bgcolor="#EEEEEE">

	<input type="submit" name="frmsubmit" style="font-weight:bold;" value="<cfoutput>#GetLangVal('adm_ph_shop_put_into_basket')#</cfoutput>">

	</td>

  </tr>

  </form>

</table>

<cfset a_str_url = cgi.SCRIPT_NAME&'?'&cgi.QUERY_STRING>

<cfset a_str_url = ReplaceNoCase(a_str_url, 'ownquantity=', 'werewrwerwerg=', 'ALL')>

<script type="text/javascript">
	function CalcPriceForOwnQuantity()
		{
		location.href = '<cfoutput>#a_str_url#</cfoutput>&ownquantity='+document.formaddtobasket.frmownquantity.value;
		}
</script>