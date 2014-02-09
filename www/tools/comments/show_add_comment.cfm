

<cfif NOT CheckSimpleLoggedIn()>

	<cfabort>

</cfif>



<cfparam name="url.servicekey" type="string" default="">

<cfparam name="url.objectkey" type="string" default="">

<html>

<head>

<cfinclude template="../../style_sheet.cfm">

<title>Kommentar hinzu&uuml;gen</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

</head>



<body>

<table width="100%" border="0" cellspacing="0" cellpadding="8">

<form action="act_add_comment.cfm" method="post">

<input type="hidden" name="frmservicekey" value="<cfoutput>#htmleditformat(url.servicekey)#</cfoutput>">

<input type="hidden" name="frmobjectkey" value="<cfoutput>#htmleditformat(url.objectkey)#</cfoutput>">

  <tr class="mischeader"> 

    <td colspan="2" class="bb"><b>Kommentar hinzuf&uuml;gen ...</b></td>

  </tr>

  <tr>

    <td align="right" width="70" valign="top">Text:</td>

    <td valign="top">

	<textarea name="frmcomment" rows="9" cols="40" style="width:100%;"></textarea>

	</td>

  </tr>

  <tr>

    <td>&nbsp;</td>

    <td><input type="submit" name="frmsubmit" value="Hinzuf&uuml;gen ..."></td>

  </tr>

</form>

</table>



</body>

</html>

