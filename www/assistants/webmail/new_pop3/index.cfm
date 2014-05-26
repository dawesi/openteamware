<cfinclude template="../../../common/scripts/script_utils.cfm">

<cfinclude template="../../../login/check_logged_in.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<style type="text/css">
	td,p,none,body,input{font-family:Verdana;font-size:11px;}
</style>
<script>
	function CancelAssistant()
		{
		window.close();		
		}
</script>
	<title><cfoutput>#GetLangVal('ass_ph_pop3_title')#</cfoutput></title>
</head>
<body bgcolor="#C0C0C0" leftmargin=0 topmargin=0 scroll=no>

<cfparam name="url.action" default="ShowWelcome">

<cfswitch expression="#url.action#">
	<cfcase value="ShowWelcome">
	<cfinclude template="dsp_start.cfm">
	</cfcase>
	
	<cfcase value="Step2">
	<cfinclude template="dsp_step2.cfm">
	</cfcase>
	
	<cfcase value="Step3">
	<cfinclude template="dsp_step3.cfm">
	</cfcase>
	
	<cfcase value="step4">
	<cfinclude template="dsp_Step4.cfm">
	</cfcase>
</cfswitch>

</body>
</html>
