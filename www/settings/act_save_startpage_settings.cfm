
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="form.frmleft" type="string" default="">
<cfparam name="form.frmright" type="string" default="">

<cfif Len(form.frmleft) IS 0 OR Len(form.frmright) IS 0>
	<cflocation addtoken="no" url="default.cfm?action=startpage">
</cfif>

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "startpage_content"
	entryname = "display.leftcolumn"
	entryvalue1 = #form.frmleft#>
	
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "startpage_content"
	entryname = "display.rightcolumn"
	entryvalue1 = #form.frmright#>

<cflocation addtoken="no" url="default.cfm?action=startpage">