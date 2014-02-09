<!--- //

	display popup for creating a pdf
	
	// --->
<cfinclude template="../login/check_logged_in.cfm">	

<cfparam name="url.mailbox" default="" type="string">
<cfparam name="url.account" default="#request.stSecurityContext.myusername#" type="string">
<cfparam name="url.id" default="0" type="numeric">


<html>
<head>
<cfinclude template="../style_sheet.cfm">
<script type="text/javascript">
	function StartCloseTimer()
		{
		setTimeout("ClosePage();", 100);
		}
	function ClosePage()
		{
		window.close();
		}
</script>
<title><cfoutput>#GetLangVal('mail_ph_pdf_create')#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<form action="show_do_create_pdf.cfm" method="post" target="_blank" onSubmit="StartCloseTimer();">
<input type="hidden" name="mailbox" value="<cfoutput>#htmleditformat(url.mailbox)#</cfoutput>">
<input type="hidden" name="id" value="<cfoutput>#htmleditformat(url.id)#</cfoutput>">

<table width="100%" border="0" cellspacing="0" cellpadding="3">
<tr class="mischeader">
	<td colspan="2" valign="bottom" class="bb">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td style="font-size:14px;font-weight:bold;line-height:17px;"><cfoutput>#si_img('page_white_acrobat')# #GetLangVal('mail_ph_pdf_create')#</cfoutput>
			</td>
		  </tr>
		</table>

	</td>
</tr>
<tr>
	<td colspan="2">PDF (Portable Document Format) stellt ein praktisches Austauschformat dar - mit diesem Feature k&ouml;nnen Sie eine solche Datei bequem aus Ihrer E-Mail erstellen.</td>
</tr>
  <tr class="mischeader">
  	<td colspan="2"><b>Parameter</b></td>
  </tr>
  <tr>
    <td align="right">
	Browser-Operation:
	</td>
    <td>
	<select name="frmdispotion">
		<option value="attachment">speichern</option>
		<option value="inline">anzeigen</option>
	</select>
	</td>
  </tr>
  <tr>
  	<td align="right">Lese-Passwort:
	</td>
	<td><input type="text" name="frmpassword" size="20"></td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td>(Leer = Kein Passwort notwendig)</td>
  </tr>
  <tr class="mischeader">
  	<td colspan="2"><b>Aktion</b></td>
  </tr>  
  <tr>
    <td align="center" style="padding:20px;" class="bt" colspan="2"><input style="font-weight:bold;" type="submit" name="frmSubmit" value="PDF-Datei jetzt erstellen ..."></td>
  </tr>
</table>
</form><br /><br />
</body>
</html>
