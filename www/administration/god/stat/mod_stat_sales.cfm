<cfparam name="attributes.resellerkeys" type="string" default="">

<cfquery name="q_select_invoices">
SELECT
	invoicetotalsum
FROM
	invoices
;
</cfquery>

<cfquery name="q_select_avg_sum" dbtype="query">
SELECT
	AVG(invoicetotalsum) AS avg_invoicetotalsum
FROM
	q_select_invoices
;
</cfquery>

<h4>Durchschnittliche Rechnungssumme: <cfoutput>#DecimalFormat(q_select_avg_sum.avg_invoicetotalsum)#</cfoutput> &euro; netto</h4>

<cfdump var="#q_select_invoices#">