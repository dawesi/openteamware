<!--- //

	Component:	 Product Development Reporting output
	Description: Generate report in PDF format, shows products assignment history
	
	Header:	

// --->

<cfparam name="url.format" type="string" default="PDF">

<cfset sFilename = application.a_struct_appsettings.properties.CONFIGURATIONDIRECTORY & ReturnDirSeparatorOfCurrentOS() & 'reports' & ReturnDirSeparatorOfCurrentOS() & 'ProductDevelopment.cfr' />

<cfif NOT request.stSecurityContext.iscompanyadmin>
	No permission to execute this report.
	<cfexit method="exittemplate">
</cfif>

<cfset a_struct_filter = StructNew()/>

<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfset a_struct_filter.createdbyuserkeys = ValueList(q_select_users.entrykey) />

<cfinvoke component="#application.components.cmp_products#" method="FindProductAssignmentHistory" returnvariable="a_struct_report">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="by_customer_username" value="true">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_productassignment_history = a_struct_report.q_select_productassignment_history />

<cfloop query="q_select_productassignment_history">
	<cfset q_select_productassignment_history.username = application.components.cmp_user.GetUsernamebyentrykey(entrykey = q_select_productassignment_history.createdbyuserkey) />
	<cfset q_select_productassignment_history.customer = application.components.cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_productassignment_history.contactkey) />
</cfloop>

<cfset a_str_output_filename = request.a_str_temp_directory & CreateUUID() />

<CFREPORT format="#url.format#" filename="#a_str_output_filename#" template="#sFilename#" query="#q_select_productassignment_history#">
	<cfreportparam NAME="myusername" VALUE="#request.stSecurityContext.myusername#">
	<cfreportparam NAME="reportname" VALUE="#GetLangVal('adrb_wd_reportname_pd')#">	
	<cfreportparam NAME="generby" VALUE="#GetLangVal('adrb_wd_generby')#">
	<cfreportparam NAME="inboxname" VALUE="#GetLangVal('adrb_wd_inboxname')#">
	<cfreportparam NAME="date" VALUE="#GetLangVal('crm_wd_product_date')#">
	<cfreportparam NAME="customer" VALUE="#GetLangVal('adrb_wd_customer')#">
	<cfreportparam NAME="username" VALUE="#GetLangVal('cm_wd_username')#">
	<cfreportparam NAME="productname" VALUE="#GetLangVal('adm_ph_billing_productname')#">
	<cfreportparam NAME="categories" VALUE="#GetLangVal('adrb_wd_categories')#">
	<cfreportparam NAME="productgroup" VALUE="#GetLangVal('crm_wd_product_group')#">
	<cfreportparam NAME="quantity" VALUE="#GetLangVal('crm_wd_product_quantity')#">
	<cfreportparam NAME="retailprice" VALUE="#GetLangVal('crm_wd_product_retail_price')#">
	<cfreportparam NAME="totalretpr" VALUE="#GetLangVal('crm_wd_product_total_retail_price')#">
	<cfreportparam NAME="purchaseprice" VALUE="#GetLangVal('crm_wd_product_purchase_price')#">
	<cfreportparam NAME="totalpurpr" VALUE="#GetLangVal('crm_wd_product_total_purchase_price')#">
	<cfreportparam NAME="pagefooter" VALUE="#GetLangVal('adrb_wd_pagefooter')#">
</CFREPORT>

<cfswitch expression="#url.format#">
	<cfcase value="Excel">
		<cfset a_str_format = 'xls' />
	</cfcase>
	<cfcase value="PDF">
		<cfset a_str_format = 'pdf' />
	</cfcase>
</cfswitch>

<cfheader name="Content-Disposition" value="attachment; filename=report.#a_str_format#">
<cfcontent deletefile="false" file="#a_str_output_filename#" type="application/#a_str_format#">


