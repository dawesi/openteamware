<cfdump var="#form#">
<cfparam name="form.frmsum" type="numeric">
<cfparam name="form.frmcomment" type="string">
<cfparam name="form.frmtitle" type="string">

<cfquery name="q_select_company">
SELECT
	companyname,entrykey,status,language,email
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcustomerid#">
;
</cfquery>

<cfif q_select_company.recordcount IS 0>
	company not found
	<cfabort>
</cfif>

<cfif q_select_company.status NEQ 0>
	only available for customers, not for interested parties
	<cfabort>
</cfif>

<cfif len(form.frmtitle) IS 0>
	no text entered!
	<cfabort>
</cfif>

<!--- insert product (and delete it afterwards) --->

<cfset a_str_productkey = CreateUUID()>

<cfquery name="q_insert_product">
INSERT INTO
	products
	(
	entrykey,
	productname,
	description,
	dt_created,
	ongoing,
	unit
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_productkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmtitle#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
	current_timestamp,
	0,
	'x'
	)
;
</cfquery>

<cfquery name="q_insert_price">
INSERT INTO
	prices
	(
	productkey,
	unit,
	price1,
	durationinmonths,
	quantity,
	entrykey,
	currency
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_productkey#">,
	1,
	<cfqueryparam cfsqltype="cf_sql_float" value="#form.frmsum#">,
	12,
	1,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#createuuid()#">,
	'EUR'
	)
;
</cfquery>

<cfinvoke component="#request.a_str_component_shop#" method="addtobasket" returnvariable="a_struct_add_to_basket">
	<cfinvokeargument name="companykey" value="#q_select_company.entrykey#">
	<cfinvokeargument name="productkey" value="#a_str_productkey#">,
	<cfinvokeargument name="quantity" value="1">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinvoke component="/components/billing/cmp_billing" method="CreateInvoiceFromOpenRecords" returnvariable="stReturn_billing">
	<cfinvokeargument name="entrykey" value="#q_select_company.entrykey#">
	<cfinvokeargument name="type" value="bill">
	<cfinvokeargument name="renewal" value="false">
	<!--- type = standard, first invoice --->
	<cfinvokeargument name="invoicetype" value="0">
	<!--- created by system --->
	<cfinvokeargument name="createdbytype" value="1">
	
	<cfinvokeargument name="comment" value="#form.frmcomment#">		
</cfinvoke>

<cfdump var="#stReturn_billing#">

<cfset a_str_invoicenumber = stReturn_billing.invoicenumber>
<cfset a_str_invoicekey = stReturn_billing.entrykey>

<cfinvoke component="/components/billing/cmp_billing" method="CreateBillOutput" returnvariable="stReturn_html">
	<cfinvokeargument name="entrykey" value="#stReturn_billing.entrykey#">
</cfinvoke>

<cfinvoke component="/components/tools/cmp_pdf" method="CreatePDFofHTMLContent" returnvariable="sFilename">
	<cfinvokeargument name="htmlcontent" value="#stReturn_html.htmlcontent#">
</cfinvoke>

<!--- save this PDF file online for the user ... --->
<cfinvoke component="/components/billing/cmp_billing" method="SaveInvoicePDF" returnvariable="a_bol_return">
	<cfinvokeargument name="pdffilename" value="#sFilename#">
	<cfinvokeargument name="entrykey" value="#a_str_invoicekey#">
</cfinvoke>

<cfquery name="q_delete_product">
DELETE FROM
	products
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_productkey#">
;
</cfquery>

<cfquery name="q_delete_prices">
DELETE FROM
	prices
WHERE
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_productkey#">
;
</cfquery>

<!--- compose localized mail ... --->
<cfset request.a_cmp_lang = application.components.cmp_lang>

<cfinvoke component="#request.a_cmp_lang#" method="GetLangValExt" returnvariable="a_str_subject">
	<cfinvokeargument name="entryid" value="adm_bill_autoorder_subject">
	<cfinvokeargument name="langno" value="#q_select_company.language#">
</cfinvoke>

<cfset a_str_subject = ReplaceNoCase(a_str_subject, '%INVOICENUMBER%', a_str_invoicenumber)>

<cfinvoke component="#request.a_cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_include_path">
	<cfinvokeargument name="langno" value="#q_select_company.language#">
	<cfinvokeargument name="section" value="emails">
	<cfinvokeargument name="template_name" value="billing_autoorder_text">
</cfinvoke>

<cfset a_str_to = ''>
<cfset a_str_cc = ''>

<cfinvoke component="#application.components.cmp_customer#" method="GetCompanyContacts" returnvariable="q_select_customer_contacts">
	<cfinvokeargument name="companykey" value="#q_select_company.entrykey#">
</cfinvoke>

<cfset a_str_admin_emails = ValueList(q_select_customer_contacts.username)>

<cfif Len(q_select_company.email) GT 0>
	<cfset a_str_to = q_select_company.email>
	<cfset a_str_cc = a_str_admin_emails>
<cfelse>
	<cfset a_str_to = a_str_admin_emails>
</cfif> 

<cfmail charset="utf-8" from="billing@openTeamWare.com" to="#a_str_to#" cc="#a_str_cc#" bcc="#request.appsettings.properties.NotifyEmail#" subject="#a_str_subject#" mimeattach="#sFilename#"><cfinclude template="#a_str_include_path#"></cfmail>

<h1>done.</h1>