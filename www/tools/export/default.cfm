<!---

	Keywords

--->

<cfinclude template="/login/check_logged_in.cfm">

<html>

	<head>
		<title>Export</title>
		<cfinclude template="/style_sheet.cfm">
		<cfinclude template="/common/js/inc_js.cfm">
	</head>
	
<body style="background-color:#EEEEEE;padding:80px">


<div class="b_all" style="background-color:white;padding:20px">
<h4>Datenexport fuer <cfoutput>#request.stSecurityContext.myusername#</cfoutput></h4>

<form action="export.cfm" style="margin:0px">
<input type="submit" value="Export jetzt starten ..." class="btn" onclick="$('#id_waiting').slideDown();$(this).hide()" />
</form>

<div style="display:none;padding-top:20px;" id="id_waiting">
<img alt="" border="0" src="/images/status/img_circle_loading.gif" width="32" height="32" border="0" align="absmiddle" />&nbsp;&nbsp;&nbsp;Der Datenexport wird nun erstellt.
<br /><br /><br />
<font style="color:red;">Warten Sie nun bitte auf den "Speichern unter" Dialog! Dies kann je nach Datenmenge auch einige Minuten dauern!</font>
<br /><br /><br />
Speichern Sie das generierte Archiv auf Ihrem Rechner ab und entpacken Sie es mit WinZip.
</div>
</div>



</body>
</html>

<!---


	--->