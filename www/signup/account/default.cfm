<!--- //

	// --->
<cfparam name="url.keyword" type="string" default="">
<cfparam name="url.datakey" type="string" default="">
<cfparam name="session.a_struct_data" type="struct" default="#StructNew()#">

<!--- mobileoffice or mobilecrm ... default: CRM --->
<cfparam name="url.product" type="string" default="mobilecrm">

<cfinclude template="/common/scripts/script_utils.cfm">
<cfinclude template="inc_scripts.cfm">

<cfinclude template="inc_check_custom_style.cfm">

<cfif StructKeyExists(cookie, 'source')>
	<cfset session.a_struct_data.source = cookie.source>
</cfif>

<cfinclude template="inc_check_affiliate_key.cfm">


<!--- pre-saved data? --->
<cfif Len(url.datakey) GT 0>
	<cfinclude template="include/inc_load_data_by_datakey.cfm">
</cfif>

<html>
<head>
	<cfinclude template="../../style_sheet.cfm">
	
	<SCRIPT type="text/javascript" SRC="/common/js/qforms/qforms.js"></SCRIPT>
	
	
	<script type="text/javascript" src="js_signup.js"></script>
	<script type="text/javascript" src="/common/js/display.js"></script>
	
	
		<style type="text/css" media="all">
			
			span.reg_req {
				font-family: verdana,Helvetica,sans-serif;
				font-size: 12px;
				color:#FF9900;
				vertical-align: -2px;
				}
		</style>
	<!--- google analytics --->
	<cfif cgi.SERVER_PORT IS '443'>
		<script src="https://ssl.google-analytics.com/urchin.js" language="javascript" type="text/javascript"></script>
	<cfelse>
		<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
	</cfif>

	
	<title><cfoutput>#request.appsettings.description#</cfoutput> | <cfoutput>#GetLangVal('cm_wd_signup')#</cfoutput></title>
</head>

<body style="padding:10px;text-align:center;overflow:auto;">

	<center>
	<cfinclude template="dsp_signup.cfm">
	</center>

</body>
</html>
