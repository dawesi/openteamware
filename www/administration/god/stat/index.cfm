<cfparam name="url.action" type="string" default="">



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfinclude template="../../../style_sheet.cfm">
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body style="padding:10px;">

<cfswitch expression="#url.action#">
	<cfcase value="subscriptions">
		<cfinclude template="dsp_subscriptions.cfm">
	</cfcase>
	
	<cfcase value="sources">
		<cfinclude template="dsp_sources.cfm">
	</cfcase>
	
	<cfcase value="misc">
		<cfinclude template="dsp_misc.cfm">
	</cfcase>
	
	<cfcase value="paymethod">
		<cfinclude template="dsp_paymethod.cfm">
	</cfcase>
	
	<cfcase value="sales">
		<cfinclude template="dsp_sales.cfm">
	</cfcase>
	
	<cfcase value="overall">
		<cfinclude template="dsp_overall.cfm">
	</cfcase>
	
	<cfcase value="test">
		<cfinclude template="dsp_test.cfm">
	</cfcase>
	
	<cfdefaultcase>
		<cfinclude template="dsp_welcome.cfm">
	</cfdefaultcase>
</cfswitch>

</body>
</html>
