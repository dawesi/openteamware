<cfparam name="session.al_key" type="string" default="">

<html>
<head>
	<cfinclude template="../../style_sheet.cfm">
	<title><cfoutput>#request.appsettings.description#</cfoutput> | <cfoutput>#GetLangVal('cm_wd_signup')#</cfoutput></title>
	
	<!---
	<script type="text/javascript">
		function DoLogin()
			{
			location.href = '/al/?key=<cfoutput>#urlencodedformat(session.al_key)#</cfoutput>';
			}
	</script>
	--->
	
	<!--- google analytics ... track visitor --->
	<cfif cgi.SERVER_PORT IS '443'>
		<script src="https://ssl.google-analytics.com/urchin.js" type="text/javascript"></script>
	<cfelse>
		<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
	</cfif>

	<script type="text/javascript">
	_uacct = "UA-69797-1";
	urchinTracker();
	</script>
	
	<meta http-equiv="refresh" content="1;url=/al/?key=<cfoutput>#urlencodedformat(session.al_key)#</cfoutput>">
</head>

<body style="padding:10px;padding-top:100px;text-align:center;background-color:#EAE7E3;">

<!---
<cfif cgi.SERVER_PORT IS '80'>
	<!-- mymon_form_log -->
	<script language="JavaScript1.1" src="http://inbox.log.checkeffect.at/mymon_form_log.js" type="text/javascript"></script>
	<script language="JavaScript1.1"><!--
	var form_url = "http://inbox.log.checkeffect.at/?u=inbox&js=1&t=1&a=send&r=" + GetCookie('mymon_form_log_1');
	document.write("<img src=\"" + form_url + "\" width=1 height=1 border=0>"); 
	//-->
	</script>
	<NOSCRIPT><IMG SRC="http://inbox.log.checkeffect.at/?u=inbox&t=1&a=send&r=0&js=0" width=1 height=1 BORDER=0></NOSCRIPT>
	<!-- /mymon_form_log -->
<cfelse>
	<script language="JavaScript1.1" src="https://checkeffect.at/mymon_form_log.js" type="text/javascript"></script>
	<script language="JavaScript1.1"><!--
	var form_url = "https://checkeffect.at/?u=inbox&js=1&t=1&a=send&r=" + GetCookie('mymon_form_log_1');
	document.write("<img src=\"" + form_url + "\" width=1 height=1 border=0>"); 
	//-->
	</script>
	<NOSCRIPT><IMG SRC="https://checkeffect.at/?u=inbox&t=1&a=send&r=0&js=0" width=1 height=1 BORDER=0></NOSCRIPT>
</cfif>
--->

<div style="background-color:white;padding:10px;width:240px;" class="b_all">
<a href="#" onClick="DoLogin();" style="font-weight:bold; ">Login now ...</a>
</div>

</body>
</html>