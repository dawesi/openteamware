

<cfparam name="url.productgroupkey" type="string" default="">

<cfparam name="url.productkey" type="string" default="">



<cfinclude template="../queries/q_select_product_groups.cfm">

<cfinclude template="../queries/q_select_products.cfm">



<cfif len(url.productgroupkey) is 0>

	<!--- show product groups ... --->

	<b>Waehlen Sie bitte die gewuensche Produktgruppe:</b><br>

	<br>

	<form action="index.cfm" method="get">

	<input type="hidden" name="action" value="prices">

	<select name="productgroupkey">

		<cfoutput query="q_select_product_groups">

		<option value="#q_select_product_groups.entrykey#">#htmleditformat(q_select_product_groups.groupname)#</option>

		</cfoutput>

	</select>

	<input type="submit" value="Anzeigen ...">

	</form>

	<cfexit method="exittemplate">

</cfif>



<cfquery name="q_Select_groupname" dbtype="query">

SELECT groupname FROM q_select_product_groups

WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.productgroupkey#">;

</cfquery>



Gruppe: <cfoutput>#htmleditformat(q_Select_groupname.groupname)#</cfoutput><br><br>



<cfif len(url.productkey) is 0>

	<!--- show products ... --->	

	

	

	<cfquery name="q_select_products" dbtype="query">

	SELECT * FROM q_select_products

	WHERE productgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.productgroupkey#">;

	</cfquery>

	

	<form action="index.cfm" method="get">

	<input type="hidden" name="action" value="prices">

	<input type="hidden" name="productgroupkey" value="<cfoutput>#htmleditformat(url.productgroupkey)#</cfoutput>">

	

	<select name="productkey">

		<cfoutput query="q_select_products">

		<option value="#q_select_products.entrykey#">#htmleditformat(q_select_products.productname)#</option>

		</cfoutput>

	</select>

	

	<input type="submit" value="Anzeigen ... ">

	

	</form>

	<cfexit method="exittemplate">

</cfif>



<cfquery name="q_select_product" dbtype="query">

SELECT * FROM q_select_products

WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.productkey#">

</cfquery>



<table border="0" cellspacing="0" cellpadding="4">

<cfoutput query="q_select_product">

  <tr>

    <td align="right">Name:</td>

    <td>#htmleditformat(q_select_product.productname)#</td>

  </tr>

  <tr>

    <td align="right">Beschreibung:</td>

    <td>#htmleditformat(q_select_product.description)#</td>

  </tr>

  <tr>

    <td align="right">fortlaufend:</td>

    <td>

	#q_select_product.ongoing#

	</td>

  </tr>

</cfoutput>

</table>



<cfset SelectPricesRequest.Entrykey = url.productkey>

<cfinclude template="../queries/q_select_prices.cfm">



<br>

<br>

<b>Preise editeren - alle Preise pro Monat netto</b>

<table border="0" cellspacing="0" cellpadding="4">

  <tr>

    <td>&nbsp;</td>

    <td>Menge</td>

    <td>Preis</td>

	<td></td>

  </tr>

  <cfoutput query="q_select_prices">

  <form action="act_edit_price.cfm" method="post">

  <input type="hidden" name="frmpricekey" value="#htmleditformat(q_select_prices.entrykey)#">

  <tr>

    <td>&nbsp;</td>

    <td>

	<input type="text" name="frmquantity" size="4" maxlength="4" value="#q_select_prices.quantity#">

	</td>

    <td>

	<input type="text" name="frmprice" size="6" maxlength="10" value="#q_select_prices.price1#">

	</td>

	<td>

	<input type="submit" name="frmsubmitsave" value="Speichern">
	&nbsp;&nbsp;
	<input type="submit" name="frmsubmitdelete" value="Loeschen">

	</td>

  </tr>

  </form>

  </cfoutput>

  <tr>

  	<td colspan="4"><b>Neue Einheit ...</b></td>

  </tr>

  <form action="act_new_price.cfm" method="post">

  <input type="hidden" name="frmproductkey" value="<cfoutput>#htmleditformat(url.productkey)#</cfoutput>">

  <tr>

  	<td>&nbsp;</td>

	<td>

	<input type="text" name="frmquantity" size="4" maxlength="4">

	</td>

	<td>

	<input type="text" name="frmprice" size="6" maxlength="10">

	</td>

	<td>

	<input type="submit" name="frmsubmit" value="Anlegen">

	</td>

  </tr>

  </form>  

</table>



