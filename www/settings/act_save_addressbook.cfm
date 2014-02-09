<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmsendvcard" type="numeric" default="0">
<cfparam name="form.frmentrykey" type="string" default="">
<cfparam name="form.frmcbremoteedit" type="numeric" default="0">
<cfparam name="form.frmsendvcard_smart" type="numeric" default="0">

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail"
	entryvalue1 = #form.frmsendvcard#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail_smartsend"
	entryvalue1 = #form.frmsendvcard_smart#>	
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.remoteedit.addvcardtomail"
	entryvalue1 = #form.frmcbremoteedit#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email"
	entryname = "addressbook.addvcardtomail.entrykey"
	entryvalue1 = #form.frmentrykey#>		

<cflocation addtoken="no" url="default.cfm?action=Addressbook&saved=1">