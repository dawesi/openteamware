<cfinclude template="../../login/check_logged_in.cfm">

<cfparam name="url.action" type="string" default="ShowWelcome">

<cfinclude template="../../common/scripts/script_utils.cfm">

<cfset request.sCurrentServiceKey = '7E6CF838-BD38-9CAD-157DC26B79773915'>
<cfinclude template="../../render/ibfw/inc_check_switches.cfm">


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfinclude template="../../style_sheet.cfm">
	<cfinclude template="../../common/js/inc_js.cfm">
	<cfinclude template="../../render/inc_html_header.cfm">
	
	<script type="text/javascript" src="/include/js/NonIECalendarPopup.js"></script>

<title>Nachverfolgung</title>
</head>

<!--- generate the body --->
<cfinclude template="../../render/dsp_inc_body.cfm">

<cfinclude template="../../render/ibfw/inc_include_switch_file.cfm">

</body>
</html>
