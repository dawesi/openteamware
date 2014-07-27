

<html>
<head>
<cfinclude template="../style_sheet.cfm">
	<title>openTeamware.com</title>
</head>

<body>

<cfmail to="#form.username#@openTeamware.com" cc="#request.stSecurityContext.myusername#" from="#request.stSecurityContext.myusername#" subject="Feedback von #form.username# zum Termin #form.title#">
Hallo!

<cfif form.answer is 0>
Der Termin #form.title# wurde von #request.stSecurityContext.myusername# best&auml;tigt
<cfelse>
Der Termin #form.title# kann leider von #request.stSecurityContext.myusername# nicht wahrgenommen werden.
</cfif>

Au&szlig;erdem hat #request.stSecurityContext.myusername# noch folgenden Kommentar hinterlassen:
----
#form.comment#
----

Klicke her f&uuml;r Infos &uuml;ber den Termin
http://www.openTeamWare.com/rd.cfm?service=cal&id=#form.id#
</cfmail>

<br>
<br>
<p align="center">Dir wurde ein Best&auml;tigungsemail zugeschickt!
<p align="center"><a href="/" target="_top">Zur Startseite</a>

</body>
</html>
