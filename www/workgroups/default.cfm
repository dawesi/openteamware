<!--- // 

	arbeitsgruppen-verwaltung
	
	// --->
<cfinclude template="../login/check_logged_in.cfm">
<cfinclude template="../common/scripts/script_utils.cfm">

<cfparam name="url.action" default="ShowWelcome" type="string">

<cfset request.sCurrentServiceKey = '7E75866E-BAE3-A2BB-BF0B95E21A216764'>
<cfinclude template="../render/ibfw/inc_check_switches.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfinclude template="../style_sheet.cfm">
	<cfinclude template="../common/js/inc_js.cfm">
	<cfinclude template="../render/inc_html_header.cfm">


	<title><cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput></title>
</head>

<!--- generate the body --->
<cfinclude template="../render/dsp_inc_body.cfm">

<cfinclude template="../render/ibfw/inc_include_switch_file.cfm">

</body>
</html>