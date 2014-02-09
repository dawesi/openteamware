<cfif NOT StructKeyExists(session, 'q_select_companies_csv_download')>
	wrong parameter
	<cfabort>
</cfif>

<cfquery name="q_select_companies" datasource="#request.a_str_db_users#">
SELECT
	assignedtoreseller,
	billingcontact,
	city,
	commentsonregistration,
	companyname,
	contactperson,
	country,
	countryisocode,
	customerid,
	customertype,
	description,
	disabled,
	disabled_reason,
	domains,
	dt_contractend,
	dt_contractstart,
	dt_created,
	dt_datachecked_alert_set,
	dt_disabled,
	dt_nextcontact,
	dt_trialphase_end,
	email,
	fax,
	fbnumber,
	rating,
	reasonforregistration,
	resellerkey,
	shortname,
	status,
	street,
	telephone,
	trialexpired,
	uidnumber,
	zipcode 
FROM
	companies
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(session.q_select_companies_csv_download.entrykey)#" list="yes">)
;
</cfquery>


<cfscript>
/**
 * Converts a query to excel-ready format.
 * 
 * @param query 	 The query to use. (Required)
 * @param headers 	 A list of headers. Defaults to col. (Optional)
 * @param cols 	 The columns of the query. Defaults to all columns. (Optional)
 * @param alternateColor 	 The color to use for every other row. Defaults to white. (Optional)
 * @return Returns a string. 
 * @author Jesse Monson (jesse@ixstudios.com) 
 * @version 1, June 26, 2002 
 */
function Query2Excel (query) {
	var InputColumnList = query.columnList;
	var Headers = query.columnList;

	var AlternateColor = "FFFFFF";
	var header = "";
	var headerLen = 0;
	var col = "";
	var colValue = "";
	var colLen = 0;
	var i = 1;
	var j = 1;
	var k = 1;
	
	if (arrayLen(arguments) gte 2) {
		Headers = arguments[2];
	}
	if (arrayLen(arguments) gte 3) {
		InputColumnList = arguments[3];
	}

	if (arrayLen(arguments) gte 4) {
		AlternateColor = arguments[4];
	}
	if (listLen(InputColumnList) neq listLen(Headers)) {
		return "Input Column list and Header list are not of equal length";
	}
	
	writeOutput("<table border=1><tr bgcolor=""C0C0C0"">");
	for (i=1;i lte ListLen(Headers);i=i+1){
		header=listGetAt(Headers,i);
		headerLen=Len(header)*10;
		writeOutput("<th width=""#headerLen#""><b>#header#</b></th>");
	}
	writeOutput("</tr>");
	for (j=1;j lte query.recordcount;j=j+1){
		if (j mod 2) {
			writeOutput("<tr bgcolor=""FFFFFF"">");
		} else {
			writeOutput("<tr bgcolor=""#alternatecolor#"">");
		}
		for (k=1;k lte ListLen(InputColumnList);k=k+1) {
			col=ListGetAt(InputColumnList,k);
			colValue=query[trim(col)][j];
			colLength=Len(colValue)*10;
			if (NOT Len(colValue)) {
				colValue="&nbsp;";
			} 
			if (isNumeric(colValue) and Len(colValue) gt 10) {
				colValue="'#colValue#";
			} 
			writeOutput("<td width=""#colLength#"">#colValue#</td>");
		}
	writeOutput("</tr>");
	}
	writeOutput("</table>");
	return "";
}
</cfscript>


<CFHEADER NAME="Content-Disposition" VALUE="inline; filename=kundenliste.xls">
<cfcontent type="application/msexcel"><cfoutput>#Query2Excel(q_select_companies)#</cfoutput>

<cfset tmp = StructDelete(session, 'q_select_companies_csv_download')>