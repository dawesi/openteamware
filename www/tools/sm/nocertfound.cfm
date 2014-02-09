<cfparam name="url.adr" type="string" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<style>
		body,p,a{font-family:Tahoma;font-size:10pt;}
	</style>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#EEEEE;">


Leider wurde fuer die folgende Adresse kein Zertifikat gefunden:
<br><br>
<b><cfoutput>#htmleditformat(url.adr)#</cfoutput></b>
<br><br>
<i>Warum benoetige ich das Zertifikat eines anderen Benutzers um ihm eine verschluesselte Nachricht senden zu koennen?</i><br>
<a href="/signedmail/?action=faq" target="_blank">Klicken Sie bitte hier fuer eine kurze Einfuehrung in das Thema</a>.
<br><br>
<i>Wo finde ich dieses Zertifikat?</i><br>

Versuchen Sie es bitte mit unserer
<a href="https://www.openTeamWare.com/signedmail/" target="_blank">Zertifikats-Suche</a><br>
(Es werden mehr als 10.000 oesterr. Zertifikate durchsucht.)
</body>
</html>
