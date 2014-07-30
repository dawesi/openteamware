<!--- //

	Module:		Administration / God
	Action:		editlicencestatus
	Description:Edit licence status of customer
	
// --->

<cfparam name="url.frmcustomerid" type="string" default="">


<cfif Len(url.frmcustomerid) IS 0>

<form action="index.cfm" method="get">
	<input type="hidden" name="action" value="editlicencestatus">
	
	Customer-ID: <input type="text" name="frmcustomerid">
	
	
	<input type="submit" value="Proceed ...">
</form>

<cfexit method="exittemplate">

</cfif>


<cfquery name="q_select_company">
SELECT
	companyname,entrykey,status,language,email
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.frmcustomerid#">
;
</cfquery>

<cfif q_select_company.recordcount IS 0>
	company not found
	<cfabort>
</cfif>

<h4><cfoutput>#q_select_company.companyname# (#url.frmcustomerid#)</cfoutput></h4>

<cfquery name="q_select_licences">
SELECT
	*
FROM
	licencing   
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_company.entrykey#">
;
</cfquery>


<table width="100%"  border="0" cellspacing="0" cellpadding="8">
	<cfoutput query="q_select_licences">
	
	<cfquery name="q_select_product_name">
	SELECT
		productname
	FROM
		products
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_licences.productkey#">
	;
	</cfquery>
	
	<form action="licence/act_update_licence_status.cfm" method="post">
	<input type="hidden" name="frmcompanykey" value="#q_select_company.entrykey#">
	<input type="hidden" name="frmproductkey" value="#q_select_licences.productkey#">
	  <tr <cfif q_select_licences.currentrow mod 2 NEQ 0>style="background-color:##EEEEEE;"</cfif>>
		<td style="font-weight:bold; ">
			#htmleditformat(q_select_product_name.productname)#
		</td>
		<td>
			Total: <input size="4" type="text" name="frmtotalseats" value="#q_select_licences.totalseats#">
		</td>
		<td>
			In use / in Gebrauch: <input size="4" type="text" name="frminuse" value="#q_select_licences.inuse#">
		</td>
		<td>
			Available / Verfuegbar: <input size="4" type="text" name="frmavailable" value="#q_select_licences.availableseats#">
		</td>
		<td>
			<input type="submit" value="Save">
		</td>
	  </tr>
  	</form>
  </cfoutput>
</table>

<cfquery name="q_select_products">
SELECT
	productname,entrykey
FROM
	products
;
</cfquery>

<form action="licence/act_add_new_licence_type.cfm" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#q_select_company.entrykey#</cfoutput>">
<select name="frmproductkey">
<cfoutput query="q_select_products">
<option value="#q_select_products.entrykey#">#htmleditformat(q_select_products.productname)#</option>
</cfoutput>
</select>
<input type="submit" value="Add licences (0)">
</form>

