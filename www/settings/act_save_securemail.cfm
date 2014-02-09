<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmautostartverification" type="numeric" default="0">
<cfparam name="form.frmexecuteverificationtarget" type="string" default="local">
<cfparam name="form.frmcbsendinfoonfirstmail" type="numeric" default="0">
<cfparam name="form.frmcbdefaultaction" type="string" default="">

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email.sm"
	entryname = "defaultsmaction"
	entryvalue1 = #form.frmcbdefaultaction#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email.sm"
	entryname = "autostartverification"
	entryvalue1 = #form.frmautostartverification#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email.sm"
	entryname = "sendinfomail"
	entryvalue1 = #form.frmcbsendinfoonfirstmail#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "email.sm"
	entryname = "standardverificationmodule"
	entryvalue1 = #form.frmexecuteverificationtarget#>
	
<cflocation addtoken="no" url="#ReturnRedirectURL()#">