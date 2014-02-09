<!--- //

	Module:		Admintool
	Description:Create customer stylehseet
	
// --->

<cfinclude template="../dsp_inc_select_company.cfm">

<h4><cfoutput>#GetLangVal('adm_ph_create_datasheet')#</cfoutput></h4>

<cfinvoke component="#application.components.cmp_customer#" method="GetCompanyCustomStyle" returnvariable="a_str_used_style">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').Productname>
<cfset a_struct_medium_logo = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'medium_logo')>

<!--- create datasheet of all users ... --->
<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfset SelectAccounts.CompanyKey = url.companykey>
<cfinclude template="../queries/q_select_accounts.cfm">

<cfsavecontent variable="a_str_pagecontent">
<cfoutput>
<!-- HEADER LEFT "   " -->

<!-- FOOTER CENTER "$PAGE / $PAGES" -->

<!-- HEADER CENTER "Datenblatt fuer #htmleditformat(q_select_company_data.companyname)#" -->

<!-- FOOTER RIGHT "powered by #htmleditformat(a_str_product_name)#" -->

<!-- FOOTER LEFT "#lsDateFormat(now(), "ddd, dd.mm.yy")# #TimeFormat(now(), "HH:mm")#" -->
<html>
	<head>



		<META NAME="AUTHOR" CONTENT="#htmleditformat(request.stSecurityContext.myusername)#">

		<META NAME="GENERATOR" CONTENT="#htmleditformat(a_str_product_name)# AdminTool"> 

		<META NAME="SUBJECT" CONTENT="#htmleditformat(GetLangVal('adm_ph_datasheet'))# (#htmleditformat(q_select_company_data.companyname)#)">

		<title>#htmleditformat(GetLangVal('adm_ph_datasheet'))#</title>
	</head>
<body>

<div align="right">

<img src="http://localhost/#a_struct_medium_logo.path#">
</div>
<br><br><br><br><br><br><br><br><br>
<h2>#GetLangVal('adm_ph_datasheet_for')# #htmleditformat(q_select_company_data.companyname)#</h2>
<b>#GetLangVal('adm_ph_customerid')#: #q_select_company_data.customerid#</b>
<br><br><br><br>
<br><br><br><br><br>
<b>powered by #a_str_product_name#</b>
<!-- NEW PAGE --> 
<cfloop query="q_select_accounts">
<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#q_select_accounts.entrykey#">
</cfinvoke>

<cfset q_select_user = stReturn.query>
<cfmodule template="../utils/mod_create_datasheet_content.cfm" query=#q_select_user#>
<!-- NEW PAGE --> 
</cfloop>
<!---<hr size="1" noshade>
<i>erstellt am #dateformat(now(), 'dd.mm.yyyy')# #TimeFormat(now(), 'HH:mm')# von #request.stSecurityContext.myusername# (#cgi.REMOTE_ADDR#)</i>--->
</body>
</html>
</cfoutput>
</cfsavecontent>

<cfinvoke component="/components/tools/cmp_pdf" method="CreatePDFofHTMLContent" returnvariable="sFilename">
	<cfinvokeargument name="htmlcontent" value="#a_str_pagecontent#">
</cfinvoke>

<a target="_blank" href="../tools/download/dl.cfm?filename=datenblatt.pdf&source=<cfoutput>#GetFileFromPath(sFilename)#</cfoutput>&app=<cfoutput>#urlencodedformat(application.applicationname)#&cfid=#client.CFID#&cftoken=#client.CFToken#</cfoutput>"><cfoutput>#GetLangVal('cm_ph_show_pdf_now')#</cfoutput></a>

<br><br><br>
<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput> ...</a>


