<!---

	--->
<cfparam name="url.entrykey" type="string" default="">

<!--- check security --->
	

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_select_user = stReturn.query>

<h4><cfoutput>#GetLangVal('adm_ph_create_datasheet')#</cfoutput> (<cfoutput>#q_select_user.username#</cfoutput>)</h4>

<cfsavecontent variable="a_str_pagecontent">
<cfoutput>
<!-- HEADER LEFT "   " -->

<!-- FOOTER CENTER "$PAGE / $PAGES" -->

<!-- HEADER CENTER "Datenblatt fuer #q_select_user.username#" -->

<!-- FOOTER LEFT "#lsDateFormat(now(), "ddd, dd.mm.yy")# #TimeFormat(now(), "HH:mm")#" -->
<html>
	<head>



		<META NAME="AUTHOR" CONTENT="#htmleditformat(request.stSecurityContext.myusername)#">

		<META NAME="GENERATOR" CONTENT="AdminTool"> 

		<META NAME="SUBJECT" CONTENT="#GetLangVal('adm_ph_create_datasheet')# #htmleditformat(q_select_user.username)#">


		<title>#GetLangVal('adm_ph_create_datasheet')#</title>
	</head>
<body>
<cfmodule template="../utils/mod_create_datasheet_content.cfm" query=#q_select_user#>
</body>
</html>
</cfoutput>
</cfsavecontent>

<cfinvoke component="/components/tools/cmp_pdf" method="CreatePDFofHTMLContent" returnvariable="sFilename">
	<cfinvokeargument name="htmlcontent" value="#a_str_pagecontent#">
</cfinvoke>

<cfset a_str_new_filename = request.a_str_temp_directory&GetFileFromPath(sFilename)>

<cffile action="move" destination="#a_str_new_filename#" source="#sFilename#">

<a target="_blank" href="../tools/download/dl.cfm?filename=datenblatt.pdf&source=<cfoutput>#GetFileFromPath(a_str_new_filename)#</cfoutput>&app=<cfoutput>#urlencodedformat(application.applicationname)#&cfid=#client.CFID#&cftoken=#client.CFToken#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_show_pdf_now')#</cfoutput></a>

<br><br><br>
<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>