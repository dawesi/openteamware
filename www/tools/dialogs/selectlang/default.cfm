<cfinclude template="/login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.form_name" type="string" default="">
<cfparam name="url.form_field" type="string" default="">
<cfparam name="url.current_value" type="string" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<cfinclude template="../../../render/inc_html_header.cfm">
	<title><cfoutput>#GetLangVal('cm_wd_language')#</cfoutput></title>
	
	<script type="text/javascript">
		function SetNewLangValue(v)
			{
			opener.document.<cfoutput>#url.form_name#</cfoutput>.<cfoutput>#url.form_field#</cfoutput>.value = v;
			
			window.close();
			}
	</script>
</head>

<body style="padding:20px; ">



<ul style="line-height:20px; ">
	<li><a href="javascript:SetNewLangValue('de');">DE - Deutsch</a></li>
	<li><a href="javascript:SetNewLangValue('en');">EN - English</a></li>
	<li><a href="javascript:SetNewLangValue('pl');">PL</a></li>
	<li><a href="javascript:SetNewLangValue('ro');">RO</a></li>
	<li><a href="javascript:SetNewLangValue('cz');">CZ</a></li>
	<li><a href="javascript:SetNewLangValue('sk');">SL</a></li>
	<li><a href="javascript:SetNewLangValue('fr');">FR</a></li>
</ul>

</body>
</html>
