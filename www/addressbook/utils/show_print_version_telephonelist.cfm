
<cfinclude template="../../login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfinclude template="../../style_sheet.cfm">
<title><cfoutput>#GetLangVal('adrb_wd_telephonelist')#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="window.print();">

<h2 style="margin-bottom:0px;"><cfoutput>#GetLangVal('adrb_wd_telephonelist')#</cfoutput> (<cfoutput>#request.a_struct_personal_properties.myfirstname# #request.a_struct_personal_properties.mysurname#</cfoutput>)</h2>
<hr size="1" noshade>
<cfinclude template="../telephonelist/dsp_inc_telephonelist.cfm">

</body>
</html>
