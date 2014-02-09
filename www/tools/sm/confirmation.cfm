<cfparam name="url.userkey" type="string" default="">
<cfparam name="url.jobkey" type="string" default="">

<!--- select the job information ---> 
<cfinclude template="queries/q_select_jobinfo.cfm">


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<style>
		body,td,p,a{font-family:Tahoma;font-size:11px;text-decoration:none;}
	</style>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body style="border:none;" scroll=no bgcolor="#EEEEEE" marginheight="0" marginwidth="0" leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0">

<div style="background-color:white;" align="right">
<img src="/images/img_email_stamp.gif" align="left" hspace="4" vspace="0">
<img src="/images/img_inboxcc_logo_top.png" hspace="6" vspace="6" border="0">
</div>
<div style="padding:4px;background-color:gray;color:white;font-weight:bold;">
Die Nachricht wurde erfolgreich verschickt.
</div>
<br>
<cfoutput query="q_select_jobinfo">
<table border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td align="right">Betreff:</td>
    <td>
		#htmleditformat(q_select_jobinfo.subject)#
	</td>
  </tr>
  <tr>
    <td align="right">Von:</td>
    <td>
		#htmleditformat(q_select_jobinfo.afrom)#
	</td>
  </tr>
  <tr>
    <td align="right">An:</td>
    <td>
		#htmleditformat(q_select_jobinfo.ato)#
	</td>
  </tr>
  <tr>
    <td align="right">Signiert?</td>
    <td>
		#htmleditformat(q_select_jobinfo.asigned)#
	</td>
  </tr>
  <tr>
    <td align="right">Verschluesselt?</td>
    <td>
		#htmleditformat(q_select_jobinfo.aencrypted)#
	</td>
  </tr>
</table>
</cfoutput>
</body>
</html>
