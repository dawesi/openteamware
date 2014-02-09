<cfinclude template="/login/check_logged_in.cfm">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfparam name="url.entrykey" type="string" default="">


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	
	<cfinclude template="/common/js/inc_js.cfm">
	<script language="JavaScript" type="text/javascript" src="/common/js/addressbook.js"></script>
	<script language="JavaScript" type="text/javascript" src="/common/js/crm_ext.js"></script>
	
	<cfinclude template="../../../render/inc_html_header.cfm">
	<title><cfoutput>#GetLangVal('cm_wd_files')#</cfoutput></title>
</head>

<body class="body_popup">


<fieldset class="bg_fieldset">
	<legend>
		<cfoutput>#GetLangVal('cm_wd_files')#</cfoutput>
	</legend>
	<div>
	
	<cfinvoke component="#application.components.cmp_crmsales#" method="DisplayFilesAttachedToUser" returnvariable="a_str_output_files">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="contactkey" value="#url.entrykey#">
		<cfinvokeargument name="directorykey" value="">
		<cfinvokeargument name="divname" value="testdiv">
		<cfinvokeargument name="managemode" value="true">
	</cfinvoke>
	
	<cfoutput>#a_str_output_files#</cfoutput>

	</div>
</fieldset>
</body>
</html>
