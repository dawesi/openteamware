<cfparam name="url.action" type="string" default="">


<html>
<head>
<link rel="stylesheet" href="../../standard.css">
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfinclude template="dsp_add.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="dsp_welcome.cfm">
	</cfdefaultcase>
</cfswitch>

</body>
</html>