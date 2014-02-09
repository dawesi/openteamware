<cfset tmp = SetHeaderTopInfoString(GetLangVal('adrb_wd_telephonelist'))>

<br>
	<div class="b_all mischeader" style="padding:4px;" align="center">
		<a href="utils/show_print_version_telephonelist.cfm" target="_blank"><b><cfoutput>#GetLangVal('adrb_ph_telephonelist_open_print_version')#</cfoutput></b></a>
	</div>
<br>

<cfinclude template="telephonelist/dsp_inc_telephonelist.cfm">