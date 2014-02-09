<!--- redirect to privacy polity ... --->

<cfset a_str_used_Style = application.components.cmp_customize.GetUsedStyle(request_scope = request, cgi_variables = cgi)>


<cfset a_str_priv_policy_link = application.components.cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'links').privacypolicy>

<cflocation addtoken="no" url="#a_str_priv_policy_link#">