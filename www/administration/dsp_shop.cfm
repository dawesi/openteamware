<!--- //

	openTeamWare.com Shop

	// --->

<cfinclude template="dsp_inc_select_company.cfm">

<!--- load products ... --->
<cfinclude template="queries/q_select_products.cfm">
<cfinclude template="queries/q_select_product_groups.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<!--- get style of company ... --->
<cfset a_str_customer_style = application.components.cmp_customer.GetCompanyCustomStyle(companykey = url.companykey)>

<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_customer_style, entryname = 'main').Productname>


<cfif (q_select_company_data.settlement_type NEQ 0)>

	<cfif request.a_bol_is_reseller>
		<!--- is reseller ... allow to shop but do NOT generate an invoice ... --->
		
		<br>
		<fieldset>
			<legend><cfoutput>#GetLangVal('cm_wd_hint')#</cfoutput></legend>
			<div>
				<cfoutput>#GetLangVal('adm_ph_transparent_reseller_hint_shop')#</cfoutput> 
			</div>
		</fieldset>
		<br>
	<cfelse>
		<!--- this customer is not allwed to order in the shop, has to order at the reseller --->
		
		<!--- check if shop url has been provided ... --->
		<cfset a_struct_links = application.components.cmp_customize.GetCustomStyleData(entryname = 'links', usersettings = session.stUserSettings)>
	
		<cfset a_str_shop_url = a_struct_links.shop>
		
		<cfif Len(a_str_shop_url) IS 0>
			<!--- forward to feedback form ... --->
			<cflocation addtoken="no" url="index.cfm?action=partnerfeedbackform&reason=shop">		
		<cfelse>
			<h4><a target="_blank" href="<cfoutput>#a_str_shop_url#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_shop_open_click')#</cfoutput>.</a></h4>
		</cfif>
		
		<cfexit method="exittemplate">
	</cfif>
</cfif>

<cfif q_select_company_data.status IS 1>
	<br>
	
	<fieldset class="default_fieldset">
		<legend><b><cfoutput>#GetLangVal('adm_ph_hint_nothing_ordered_yet_title')#</cfoutput></b></legend>
		
		<div>
			<cfoutput>#GetLangVal('adm_ph_use_this_form_for_first_order')#</cfoutput>
			<br><br>
			
			<div style="background-color:lightyellow;border:orange solid 1px;padding6px;">
			<a href="index.cfm?action=shop.trialphaseend&<cfoutput>#WriteURLTags()#</cfoutput>"><b>&gt; <cfoutput>#GetLangVal('cm_ph_please_click_here_to_proceed')#</cfoutput></b></a>
			<br><br>
			<cfoutput>#GetLangVal('adm_ph_full_shop_demo')#</cfoutput>
			</div>
		</div>
	</fieldset>
	
	
	
	
	<!---<br>
	<img src="/images/shop/img_shop_demo.png">--->
	<cfexit method="exittemplate">
</cfif>

<cfset SelectBookedServices.companykey = url.companykey>
<cfinclude template="queries/q_select_booked_services.cfm">


<!--- select unpaid booked services ... --->
<cfquery name="q_select_basket" dbtype="query">
SELECT
	*
FROM
	q_select_booked_services
WHERE
	settled = 0
;
</cfquery>



<!--- select the customer --->

	

<h4><img src="/images/img_shop_package.png" width="32" height="32" hspace="2" vspace="2" border="0" align="absmiddle">&nbsp;<cfoutput>#GetLangVal('cm_wd_shop')#</cfoutput> (<cfoutput>#htmleditformat(q_select_company_data.companyname)#</cfoutput>)</h4>



<cfif q_select_basket.recordcount gt 0>

	<b><cfoutput>#GetLangVal('adm_wd_basket')#</cfoutput></b> - <cfoutput>#GetLangVal('adm_wd_basket_selected_products')#</cfoutput><br>

	<table border="0" cellspacing="0" cellpadding="3" width="550" class="b_all">

	<form method="post" action="index.cfm?action=accounting<cfoutput>#WriteURLTags()#</cfoutput>">

	  <tr class="lightbg">

		<td align="center"><cfoutput>#GetLangVal('adm_wd_quantity')#</cfoutput></td>

		<td>&nbsp;</td>

		<td><cfoutput>#GetLangVal('cm_wd_product')#</cfoutput></td>

		<td><cfoutput>#GetLangVal('cm_wd_price')#</cfoutput></td>

		<td>&nbsp;</td>

	  </tr>

	<cfoutput query="q_select_basket">

	  <tr>

		<td align="center">#q_select_basket.quantity#</td>

		<td>#q_select_basket.unit#</td>

		<td>#htmleditformat(q_select_basket.productname)#</td>

		<td>#q_select_basket.totalamount#</td>

		<td>

		<img src="/images/editicon_disabled.gif">&nbsp;

		<a href="javascript:DeleteItem('#jsstringformat(q_select_basket.entrykey)#');"><img src="/images/del.gif" width="12" height="12" hspace="2" vspace="2" border="0" align="absmiddle"></a></td>

	  </tr>

	</cfoutput>

	<tr>

		<td colspan="4" align="right">

		<!--- do we have a reseller? This type of user is able to create an offert ... --->
		<!---<cfif request.a_bol_is_reseller>
		<input type="submit" name="frmsubmit" value="Bestellung/Anbot abschliessen ...">		
		<cfelse>--->
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_finish_order')#</cfoutput>">
		<!---</cfif>--->
		</td>

	</tr>

	</form>

	</table>

	

	<script type="text/javascript">

		function DeleteItem(i)

			{

			if (confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>') == true)

				{

				location.href = 'act_delete_from_basket.cfm?<cfoutput>#WriteURLTags()#</cfoutput>&entrykey='+escape(i);

				}			

			}	

	</script>



<br><br>

</cfif>





<b><cfoutput>#GetLangVal('adm_ph_shop_please_select_products')#</cfoutput>:</b>

<br>

<!---<cfdump var="#q_select_products#">--->

<cfoutput>#GetLangVal('adm_wd_duration')#</cfoutput>: <cfoutput>#GetLangVal('adm_wd_duration_auto')#</cfoutput>&nbsp;



<cfif isDate(q_select_company_data.dt_contractend) is true>

	<cfoutput>#dateformat(q_select_company_data.dt_contractend, "dd.mm.yy")#</cfoutput>

<cfelse>

	<cfoutput>#GetLangVal('adm_ph_duration_one_year')#</cfoutput>

</cfif>



<table border="0" cellspacing="0" cellpadding="4" width="550">

  <tr>

    <td>&nbsp;</td>

    <td>&nbsp;</td>

    <td>&nbsp;</td>	

    <td><cfoutput>#GetLangVal('adm_ph_price_per_month')#</cfoutput></td>

	<td>&nbsp;</td>	

  </tr>

  <cfoutput query="q_select_product_groups">

	  

	  <cfquery name="q_select_products_of_this_group" dbtype="query">
	  SELECT
	  	*
	  FROM
	  	q_select_products

	  WHERE productgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_product_groups.entrykey#">

	  ORDER BY itemindex;

	  </cfquery>

	  

	  <cfif q_select_product_groups.currentrow gt 1>

	  <tr>

	  	<td colspan="5">&nbsp;</td>

	  </tr>

	  </cfif>

	  

	  <tr>

		<td colspan="5" class="lightbg" style="color:gray;">#GetLangVal('adm_wd_shop_group')# <b>#q_select_product_groups.groupname#</b></td>

	  </tr>

	  

	  

	  <cfloop query="q_select_products_of_this_group">

	  <form action="index.cfm" method="get">

	  <input type="hidden" name="action" value="AddToBasket">

	  <input type="hidden" name="frmentrykey" value="#q_select_products_of_this_group.entrykey#">

	  <input type="hidden" name="frmcompanykey" value="#htmleditformat(url.companykey)#">
	  
	  <input type="hidden" name="frmresellerkey" value="#htmleditformat(url.resellerkey)#">

		  <tr>

			<td>

			

			<!---<select name="frmamount">

				<option value=""></option>

				<cfloop from="1" to="20" index="ii">

				<option value="#ii#">#ii#</option>

				</cfloop>

			</select>--->

			</td>

			<td>
				<b>#htmleditformat(ReplaceNoCase(q_select_products_of_this_group.productname, 'openTeamWare.com', a_str_product_name, 'ALL'))#</b>
			</td>

			<td>&nbsp;</td>

			

			<!--- select the lowest price ... --->

			<cfquery name="q_select_lowest_price" datasource="#request.a_str_db_users#">
			SELECT
				MIN(price1) AS min_price
			FROM
				prices
			WHERE
				productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_products_of_this_group.entrykey#">
			
			<!--- wenn eigene abrechnung, dann hole auch eigenen preis! --->
			<cfif (q_select_company_data.settlement_type NEQ 0)>
				AND
				resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_company_data.resellerkey#">
			</cfif>
			;
			</cfquery>

				

			<td align="right">
				<cfif q_select_lowest_price.min_price IS ''>
				#GetLangVal('adm_ph_shop_on_request')#
				<cfelse>
				#GetLangVal('adm_wd_shop_beginning_with')# #DecimalFormat(q_select_lowest_price.min_price)# &euro;
				</cfif>
				
			</td>

			<td><input type="submit" name="frmsubmit" value="#GetLangVal('adm_wd_shop_add')#"></td>	

		  </tr>

		  

		  <cfif len(trim(q_select_products_of_this_group.description)) gt 0>

			  <tr>

				<td>&nbsp;</td>

				<td colspan="4" style="padding:2px;padding-left:15px;font-size:10px;">

					#htmleditformat(ReplaceNoCase(q_select_products_of_this_group.description, 'openTeamWare.com', a_str_product_name, 'ALL'))#

				</td>

			  </tr>

		  </cfif>

	  </form>

	  </cfloop>

  </cfoutput>



</table>

<br>

<br>

<cfoutput>#GetLangVal('adm_ph_shop_all_prices_netto')#</cfoutput>
<br><br>
<img src="/images/shop/card_logos.gif" align="absmiddle"/>&nbsp;<cfoutput>#GetLangVal('adm_ph_payment_forms')#</cfoutput>