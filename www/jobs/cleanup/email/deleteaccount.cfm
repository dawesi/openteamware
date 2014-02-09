<cfparam name="url.name" type="string">
<cfset a_str_file = '/tmp/deleteaccounts.sh' />
<cfif FileExists( a_str_file )>
	<cffile action="read" file="#a_str_file#" variable="a_str_content">
<cfelse>
	<cfset a_str_content = '' />
</cfif>

<cfset a_str_content = Trim( a_str_content & chr(13) & chr(10) & 'rm "' & url.name & '/" -R' ) />

<cffile action="write" file="#a_str_file#" output="#a_str_content#" addnewline="false">


<html>
	<head>
	</head>
<body onload="window.close()">

<h4>Done!</h4>
</body>
</html>