
<cfparam name="url.entrykey" type="string" default="">

<cfquery name="q_select_invoices" datasource="#request.a_str_db_users#">
SELECT
	pdffile
FROM
	invoices
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfset a_bin_pdf = ToBinary(q_select_invoices.pdffile)>

<cfset a_str_file = request.a_str_temp_directory & request.a_str_dir_separator & CreateUUID() & '.pdf'>

<cffile action="write" addnewline="no" file="#a_str_file#" output="#a_bin_pdf#">

<cfcontent type="application/pdf" file="#a_str_file#" deletefile="no">