﻿<!--- //

	contact to company
	
	// --->
	
<!--- redirect to homepage ... --->

<cfset a_str_used_Style = application.components.cmp_customize.GetUsedStyle(request_scope = request, cgi_variables = cgi)>


<cfset a_str_homepage_link = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'links').company_contact>

<cflocation addtoken="no" url="#a_str_homepage_link#">