<!--- 

	redirect to a certain URL

 --->

<cfparam name="url.url" default="about:blank">

<!--- local server? hard redirect without notification --->
<cfif (FindNoCase("http://www.openTeamWare.com/", url.url, 1) gt 0) OR
	  (FindNoCase("https://www.openTeamWare.com/", url.url, 1) gt 0)>
	<cflocation addtoken="no" url="#url.url#">
</cfif>


<cfinclude template="/common/scripts/script_utils.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<cfinclude template="style_sheet.cfm">
	<meta http-equiv="refresh" content="2;URL=<cfoutput>#url.url#</cfoutput>" />

	<title>... Redirect ...</title>
</head>
<body>

	<br /><br /><br /><br /><br /><br />
	<div align="center">
	<div style="width:300px;padding:4px;" class="mischeader bl br bt">Hint</div>
	<div style="width:300px;padding:10px;" class="b_all" align="center">
		<img src="/images/img_attention.png" align="left" vspace="3" hspace="3"> Sie werden nun zur Seite <a href="<cfoutput>#url.url#</cfoutput>"><cfoutput>#htmleditformat(Shortenstring(url.url, 30))#</cfoutput></a> weitergeleitet und verlassen damit <cfoutput>#request.appsettings.description#</cfoutput>.
		<br><br>
		Sie koennen dieses Fenster spaeter schliessen und damit zurueckkehren.
	</div>
	</div>

</body>

</html>

