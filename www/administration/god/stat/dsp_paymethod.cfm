<!--- // 

	pay method 
	
	// --->
<cfparam name="url.resellerkey" type="string" default="">
<cfparam name="url.createdbytype" type="numeric" default="-1">
<cfparam name="url.invoicetype" type="numeric" default="-1">

<cfquery name="q_select_reseller" datasource="#request.a_str_db_users#">
SELECT
	entrykey,companyname
FROM
	reseller
ORDER BY
	companyname
;
</cfquery>
	
<table border="0" cellspacing="0" cellpadding="2">
<form action="default.cfm" method="get">
<input type="hidden" name="action" value="paymethod">
  <tr>
    <td>
		Reseller:
	</td>
    <td>
		<select name="resellerkey">
			<option value="">- Alle -</option>
			<cfoutput query="q_select_reseller">
				<option #writeselectedelement(q_select_reseller.entrykey, url.resellerkey)# value="#q_select_reseller.entrykey#">#q_select_reseller.companyname#</option>
			</cfoutput>
		</select>
	</td>
  </tr>
  <tr>
    <td>
		Rechnungs-Ersteller:
	</td>
    <td>
		<select name="createdbytype">
			<option value="-1">- Alle -</option>
			<cfoutput>
			<option #writeselectedelement(0, url.createdbytype)# value="0">Kunde selbst</option>
			<option #writeselectedelement(1, url.createdbytype)# value="1">Systempartner</option>
			<option #writeselectedelement(2, url.createdbytype)#  value="2">System (automatisch)</option>
			</cfoutput>
		</select>
	</td>
  </tr>
  <tr>
    <td>
		Rechnungstype:
	</td>
    <td>
		<select name="invoicetype">
			<option value="-1">- Alle -</option>
			<cfoutput>
			<option #writeselectedelement(0, url.invoicetype)# value="0">Erstrechnung</option>
			<option #writeselectedelement(1, url.invoicetype)# value="1">Verlaengerung</option>
			</cfoutput>
		</select>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="Anzeigen ...">
	</td>
  </tr>
</form>
</table>

	
	

	
<cfquery name="q_select_invoices" datasource="#request.a_str_db_users#">
SELECT
	entrykey,paymethod,dunninglevel,dt_created,dt_paid,paid,invoicetotalsum,
	companykey,0 AS int_days_until_paid,invoicetype,createdbytype
FROM
	invoices
WHERE
	invoicetotalsum > 0
	AND
	customerdisabled = 0
	<cfif url.createdbytype NEQ -1>
	AND createdbytype = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.createdbytype#">
	</cfif>
	<cfif url.invoicetype NEQ -1>
	AND invoicetype = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.invoicetype#">
	</cfif>
;
</cfquery>

<!--- remove disabled customers ... --->
<cfquery name="q_select_companies" datasource="#request.a_Str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_invoices.companykey)#" list="yes">)
	AND
	disabled = 0
	<cfif url.resellerkey NEQ ''>
	AND
		(
			(resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">)
			OR
			(distributorkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">)
		)
	</cfif>
;
</cfquery>

<cfquery name="q_select_invoices" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_companies.entrykey)#" list="yes">)
;
</cfquery>

<!--- datediff does not work in our mysql version, therefore calculate the difference by outselves --->
<cfloop query="q_select_invoices">
	<cfif (q_select_invoices.paid IS 1) AND IsDate(q_select_invoices.dt_paid)>
		<cfset querysetcell(q_select_invoices, 'int_days_until_paid', DateDiff('d', q_select_invoices.dt_created, q_select_invoices.dt_paid), q_select_invoices.currentrow)>
	</cfif>
</cfloop>


<cfquery name="q_select_paid" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	paid = 1
;
</cfquery>

<cfquery name="q_select_unpaid" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	paid = 0
;
</cfquery>

<!--- bezahlmethoden ... --->
<cfquery name="q_select_distinct_paymethods" dbtype="query">
SELECT
	DISTINCT(paymethod),0 AS method_count
FROM
	q_select_paid
;
</cfquery>

<cfloop query="q_select_distinct_paymethods">
	
	<cfquery name="q_select_method_count" dbtype="query">
	SELECT
		COUNT(paymethod) AS method_count
	FROM
		q_select_paid
	WHERE
		paymethod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_paymethods.paymethod#">
	;
	</cfquery>
	
	<cfset querySetCell(q_select_distinct_paymethods, 'method_count', val(q_select_method_count.method_count), q_select_distinct_paymethods.currentrow)>

</cfloop>

<h4>Bezahl-Methoden</h4>
<cfsavecontent variable="graph_data">
<cfchart showlegend="yes">
	<cfchartseries query="q_select_distinct_paymethods" type="pie" valuecolumn="method_count" itemcolumn="paymethod">
</cfchart>
</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>


<!--- au�enst�nde --->
<!---<cfquery name="q_select_unpaid_sum" dbtype="query">
SELECT
	SUM(invoicetotalsum) AS invoicetotalsum
FROM
	q_select_invoices
WHERE
	paid = 0
;
</cfquery>

<h4>Au&szlig;enst&auml;nde <cfoutput>#Decimalformat(q_select_unpaid_sum.invoicetotalsum)#</cfoutput> &euro; netto</h4>--->

<cfquery name="q_select_distinct_dunninglevels" dbtype="query">
SELECT
	DISTINCT(dunninglevel),0 AS dunninglevel_count
FROM
	q_select_unpaid
;
</cfquery>

<cfloop query="q_select_distinct_dunninglevels">
	
	<cfquery name="q_select_dunninglevel_count" dbtype="query">
	SELECT
		COUNT(entrykey) AS dunninglevel_count
	FROM
		q_select_unpaid
	WHERE
		dunninglevel = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_distinct_dunninglevels.dunninglevel#">
	;
	</cfquery>
	
	<cfset querySetCell(q_select_distinct_dunninglevels, 'dunninglevel_count', val(q_select_dunninglevel_count.dunninglevel_count), q_select_distinct_dunninglevels.currentrow)>

</cfloop>


<h4>Mahnstufen der unbezahlten Rechnungen</h4>
<cfsavecontent variable="graph_data">
<cfchart showlegend="yes">
	<cfchartseries query="q_select_distinct_dunninglevels" type="pie" valuecolumn="dunninglevel_count" itemcolumn="dunninglevel">
</cfchart>
</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>

<!--- when do people pay? --->
<cfquery name="q_select_distinct_paydays" dbtype="query">
SELECT
	DISTINCT(int_days_until_paid),0 AS days_count
FROM
	q_select_paid
;
</cfquery>

<cfloop query="q_select_distinct_paydays">
	
	<cfquery name="q_select_dunninglevel_count" dbtype="query">
	SELECT
		COUNT(int_days_until_paid) AS days_count
	FROM
		q_select_paid
	WHERE
		int_days_until_paid = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_distinct_paydays.int_days_until_paid#">
	;
	</cfquery>
	
	<cfset querySetCell(q_select_distinct_paydays, 'days_count', val(q_select_dunninglevel_count.days_count), q_select_distinct_paydays.currentrow)>

</cfloop>


<h4>Zahlung nach n Tagen ...</h4>
<cfsavecontent variable="graph_data">
<cfchart showlegend="yes" chartwidth="600">
	<cfchartseries query="q_select_distinct_paydays" type="curve" valuecolumn="days_count" itemcolumn="int_days_until_paid">
</cfchart>
</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>


<!--- select distinct types ... --->
<cfquery name="q_select_distinct_invoicetypes" dbtype="query">
SELECT
	DISTINCT(invoicetype),0 AS count_this_type
FROM
	q_select_invoices
;
</cfquery>

<cfloop query="q_select_distinct_invoicetypes">

	<cfquery name="q_select_type_count" dbtype="query">
	SELECT
		COUNT(entrykey) AS type_count
	FROM
		q_select_invoices
	WHERE
		invoicetype = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_distinct_invoicetypes.invoicetype#">
	;
	</cfquery>
	
	<cfset querySetCell(q_select_distinct_invoicetypes, 'count_this_type', val(q_select_type_count.type_count), q_select_distinct_invoicetypes.currentrow)>
	
	<cfswitch expression="#q_select_distinct_invoicetypes.invoicetype#">
		<cfcase value="0">
			<cfset tmp = QuerySetCell(q_select_distinct_invoicetypes, 'invoicetype', 'Erstrechnung', q_select_distinct_invoicetypes.currentrow)>
		</cfcase>
		<cfcase value="1">
			<cfset tmp = QuerySetCell(q_select_distinct_invoicetypes, 'invoicetype', 'Verlaengerung', q_select_distinct_invoicetypes.currentrow)>
		</cfcase>
		
	</cfswitch>
	
</cfloop>


<h4>Erstrechnungen vs. Verlaengerungen ...</h4>
<cfsavecontent variable="graph_data">
<cfchart showlegend="yes">
	<cfchartseries query="q_select_distinct_invoicetypes" type="pie" valuecolumn="count_this_type" itemcolumn="invoicetype">
</cfchart>
</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>



<!--- select distinct creation types ... --->
<cfquery name="q_select_distinct_createdbytypes" dbtype="query">
SELECT
	DISTINCT(createdbytype),0 AS count_this_type
FROM
	q_select_invoices
;
</cfquery>

<cfloop query="q_select_distinct_createdbytypes">

	<cfquery name="q_select_type_count" dbtype="query">
	SELECT
		COUNT(entrykey) AS type_count
	FROM
		q_select_invoices
	WHERE
		createdbytype = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_distinct_createdbytypes.createdbytype#">
	;
	</cfquery>
	
	<cfset querySetCell(q_select_distinct_createdbytypes, 'count_this_type', val(q_select_type_count.type_count), q_select_distinct_createdbytypes.currentrow)>
	
	<cfswitch expression="#q_select_distinct_createdbytypes.createdbytype#">
		<cfcase value="0">
			<cfset tmp = QuerySetCell(q_select_distinct_createdbytypes, 'createdbytype', 'Kunde selbst', q_select_distinct_createdbytypes.currentrow)>
		</cfcase>
		<cfcase value="1">
			<cfset tmp = QuerySetCell(q_select_distinct_createdbytypes, 'createdbytype', 'Systempartner', q_select_distinct_createdbytypes.currentrow)>
		</cfcase>
		<cfcase value="2">
			<cfset tmp = QuerySetCell(q_select_distinct_createdbytypes, 'createdbytype', 'Automatisch (System)', q_select_distinct_createdbytypes.currentrow)>
		</cfcase>		
	</cfswitch>
	
</cfloop>


<h4>Ersteller der Rechnung ...</h4>
<cfsavecontent variable="graph_data">
<cfchart showlegend="yes">
	<cfchartseries query="q_select_distinct_createdbytypes" type="pie" valuecolumn="count_this_type" itemcolumn="createdbytype">
</cfchart>
</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>
