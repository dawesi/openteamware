<!--- //

	Module:		Settings
	Action:		DoSaveDisplayPreferences
	Description:Save display preferences




	TODO: Save calendar startview the new way ...

// --->

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="index.cfm">
</cfif>

<cfparam name="form.frmcbasksemailendconfirmation" type="numeric" default="0">
<cfparam name="form.frmCBAutoClearTrashCanOnLogout" type="numeric" default="0">
<cfparam name="form.frmselectdefaultemailformat" type="string" default="plain">
<cfparam name="form.frmcbemailinsertsignaturebydefault" type="numeric" default="0">
<cfparam name="form.frmradioemailfolderviewleft" type="string" default="box">
<cfparam name="form.frmcbcalshowduetasks" type="numeric" default="0">
<cfparam name="form.frmleftnavtype" type="string" default="full">
<cfparam name="form.frmcbemailmessagepreview" type="numeric" default="0">
<cfparam name="form.frmcbemailautoloadfirstemail" type="numeric" default="0">
<cfparam name="form.frmforwardformat" type="string" default="attachment">
<cfparam name="form.frmcbsurpresssenderonexternalsend" type="numeric" default="0">
<cfparam name="form.frmdisplaytodaybydefault" type="numeric" default="0">
<cfparam name="form.frm_default_encoding_if_unknown_encoding" type="string" default="UTF-8">
<cfparam name="form.frm_mail_surpress_external_elements_by_default" type="numeric" default="0">
<cfparam name="form.frm_surpress_external_elements_exception_domains" type="string" default="">
<cfparam name="form.frmExtensionsSkypeEnabled" type="numeric" default="0">
<cfparam name="form.frmaddressbookviewmode" type="string" default="list">

<cfinclude template="queries/q_update_display_settings.cfm">

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "extensions.skype"
	entryname = "enabled"
	entryvalue1 = #val(form.frmExtensionsSkypeEnabled)#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "defaultencoding_if_unknown_encoding"
	entryvalue1 = #form.frm_default_encoding_if_unknown_encoding#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "surpress_external_elements_by_default"
	entryvalue1 = #form.frm_mail_surpress_external_elements_by_default#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "surpress_external_elements_exception_domains"
	entryvalue1 = #form.frm_surpress_external_elements_exception_domains#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "common"
	entryname = "show.today.bydefault"
	entryvalue1 = #form.frmdisplaytodaybydefault#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "addressbook"
	entryname = "adressbook.maxrowsperpage"
	entryvalue1 = #form.frmAddressbookEntriesPerPage#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "addressbook"
	entryname = "display.viewmode"
	entryvalue1 = #form.frmaddressbookviewmode#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "confirmsend"
	entryvalue1 = #form.frmcbasksemailendconfirmation#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "insertsignaturebydefault"
	entryvalue1 = #form.frmcbemailinsertsignaturebydefault#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "emptytrashonlogout"
	entryvalue1 = #form.frmCBAutoClearTrashCanOnLogout#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "surpresssender.onexternaladdress"
	entryvalue1 = #val(form.frmcbsurpresssenderonexternalsend)#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "display.foldersleft"
	entryvalue1 = #form.frmradioemailfolderviewleft#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "defaultformat"
	entryvalue1 = #form.frmselectdefaultemailformat#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "forward.format"
	entryvalue1 = #form.frmforwardformat#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "defaultview"
	entryvalue1 = #form.frmemailstandarview#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.viewmode"
	entryvalue1 = #form.frmemailfolderviewmode#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.msgpreview"
	entryvalue1 = #form.frmcbemailmessagepreview#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.autoloadfirstmsg"
	entryvalue1 = #form.frmcbemailautoloadfirstemail#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "calendar.daystarthour"
	entryvalue1 = #val(form.frmCalendarStartHour)#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "calendar.dayendhour"
	entryvalue1 = #val(form.frmCalendarEndHour)#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.day.opentasks"
	entryvalue1 = #val(form.frmcbcalshowduetasks)#>

<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "startpage"
	entryname = "display.leftnav.type"
	entryvalue1 = #form.frmleftnavtype#>

<!--- session variablen setzen! --->
<cflock timeout="3" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
	<cfset session.utcDiff = val(form.frmtimeZone)+val(form.frmDaylightsavinghours)>
	<cfset session.DisplayContactsPerPage = val(form.frmAddressbookEntriesPerPage)>

</cflock>

<!--- reload display settings ... --->
<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfset session.stUserSettings = a_struct_settings>

<cflocation addtoken="No" url="../index.cfm?action=DisplayPreferences">

