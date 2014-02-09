<cfinclude template="../../login/check_logged_in.cfm">
<cfinclude template="/common/scripts/script_utils.cfm">


<cfparam name="url.servicekey" type="string" default="">
<cfparam name="url.objectkey" type="string" default="">
<cfparam name="url.title" type="string" default="">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="url.salesprojectkey" type="string" default="">

<cfinclude template="../browser/inc_check_browser.cfm">



<html>
<head>
	<script type="text/javascript" src="/include/js/NonIECalendarPopup.js"></script>
	<cfinclude template="../../style_sheet.cfm">
	<cfinclude template="../../render/inc_html_header.cfm">
	<title><cfoutput>#GetLangVal('crm_ph_enable_follow_up')#</cfoutput></title>
</head>

<body>

<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('crm_ph_enable_follow_up'))#</cfoutput>

<!---
<cfoutput>#htmleditformat(CheckZerostring(url.title))#
--->
<cfinclude template="dsp_inc_edit_create_job.cfm">


</body>
</html>