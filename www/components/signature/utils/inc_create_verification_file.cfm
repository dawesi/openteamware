<!--- //

	create the verification file
	
	html form containing the base64 version of the signed message
	
	// --->
	
<cfquery name="q_select_sig_response" datasource="#request.a_str_db_tools#">
SELECT
	sig_response
FROM
	mobile_signature_jobinfo
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">
;
</cfquery>
	
<cfsavecontent variable="sReturn">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		
		<title>&Uuml;berpr&uuml;fung der Echtheit einer Nachricht</title>
		
		<script type="text/javascript">
			function DoPostVerificationContent() {
				document.forms.formdoVerify.submit();
				}
		</script>
		
		<style type="text/css" media="all">
			body,p,a,div,td {
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size:12px;
				}
		</style>
		
	</head>
<body onLoad="DoPostVerificationContent();">
	
	<h4>Online-&Uuml;berpr&uuml;fung der Nachricht</h4>
	<p>
		Wenn Sie nicht automatisch weitergeleitet werden, klicken Sie bitte auf "Jetzt Echtheit / G&uuml;ltigkeit nun &uuml;berpr&uuml;fen ..."
	</p>
	
	<!--- http://localhost:3495/http-security-layer-request --->

<form name="formdoVerify" action="https://www.openTeamWare.com/external/security-layer-request/verify/" method="Post" enctype="application/x-www-form-urlencoded">
	<input type="hidden" name="jobkey" value="<cfoutput>#arguments.jobkey#</cfoutput>">
	<input type="hidden" name="sig_type" value="a1">
	<input type="hidden" name="XMLRequest" value="<cfoutput>#ToBase64(q_select_sig_response.sig_response)#</cfoutput>"/>
	<input type="hidden" name="StyleSheetURL" value=""/>
	<input type="hidden" name="DataURL" value=""/>
	<input type="submit" value="Jetzt Echtheit / G&uuml;ltigkeit nun &uuml;berpr&uuml;fen ...">
</form>

</body>
</html>
</cfsavecontent>