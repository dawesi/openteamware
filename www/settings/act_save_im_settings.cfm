<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmcb_enable_alerts" type="numeric" default="0">
<cfparam name="form.frmvisible_mode" type="numeric" default="1">

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "im"
	entryname = "enable_alerts"
	entryvalue1 = #form.frmcb_enable_alerts#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "im"
	entryname = "visibility_modus"
	entryvalue1 = #form.frmvisible_mode#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "im"
	entryname = "visibility_modus_#Hash(request.stSecurityContext.myusername)#"
	userid = 0
	entryvalue1 = #form.frmvisible_mode#>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">