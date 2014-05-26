<!--- //

	Module:		Email/Tools
	Function:	MakeHTMLMailSafe
	Description: make the html mail safe ...
	

// --->
	
<!--- replace all SCRIPT blocks --->
<cfset a_str_file = ReplaceNoCase(a_str_file, "<script", 	"<!--<__s_c_r_i_p_t", "ALL") />
<cfset a_str_file = ReplaceNoCase(a_str_file, "</script>", 	"</__s_c_r_t_i_p>-->", "ALL") />	

<cfset ii = FindNoCase('<body', a_str_file) />

<cfif ii IS 0>
	<cfset a_str_file = 'Invalid HTML mail.' />
	<cfexit method="exittemplate">
</cfif>

<!--- copy from "<body>" to end ... --->
<cfset a_str_file = Mid(a_str_file, (ii + 1), len(a_str_file)) />
<cfset ii = FindNoCase('>', a_str_file) />
<cfset a_str_file = Mid(a_str_file, (ii+1), len(a_str_file)) />

<!--- find "</body>" --->
<cfset ii = FindNoCase('</body', a_str_file) />

<cfif ii IS 0>
	<cfset a_Str_file = 'invalid HTML mail.' />
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_file = Mid(a_str_file, 1, (ii - 1)) />

<cfset a_str_file = ReplaceNoCase(a_str_file, "href=""mailto:", "target=""_blank"" href=""index.cfm?action=composemail&type=0&to=", "ALL") />
<cfset a_str_file = ReplaceNoCase(a_str_file, "?subject=", "&subject=", "ALL") />
<cfset a_str_file = ReplaceNoCase(a_str_file, '<a ', '<a target="_blank"', 'ALL') />
<cfset a_str_file = ReplaceNoCase(a_str_file, '<a' & chr(13), '<a target="_blank"', 'ALL') />

	
<!--- surpress images ? --->
<cfif arguments.surpress_images IS 1>

	<!--- are there images in the html file? --->
	<cfset a_bol_images_found_to_surpress = (FindNoCase('src="', a_str_file) GT 0) OR (FindNoCase('background="', a_str_file) GT 0) />
	
	<!--- return if images found ... --->
	<cfset stReturn.images_surpressed = a_bol_images_found_to_surpress />

	<!--- replace now ... --->
	<cfset a_str_file = ReplaceNoCase(a_str_file, 'src="', 'src="/just_a_dummy_link/', "ALL") />
	<cfset a_str_file = ReplaceNoCase(a_str_file, ' background="', 'background="/just_a_dummy_link/', "ALL") />
	
	<!--- display images from public storage --->
	<cfset a_str_file = ReplaceNoCase(a_str_file, '/just_a_dummy_link/http://www.openTeamWare.com//storage/public.cfm', '/storage/public.cfm', 'ALL') />
	<cfset a_str_file = ReplaceNoCase(a_str_file, '/just_a_dummy_link/https://www.openTeamWare.com/', 'https://www.openTeamWare.com/', 'ALL') />
</cfif>

<!--- strip out now various events, tags and so on ... --->
<cfset a_Str_file = safetext(a_str_file, true) />

<cfset stReturn.content = a_str_file />


