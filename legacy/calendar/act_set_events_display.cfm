<!---//

	save hide/display settings for special event types
	
	// --->
	
<cfinclude template="../login/check_logged_in.cfm">

<!---

	types
	
	privateevents
	
	vcal<key>
	
	workgroup<key>
	
	--->	
	
	
<cfparam name="url.type" type="string" default="">
<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.display" type="boolean" default="true">
<cfparam name="url.return" type="string" default="#ReturnRedirectURL()#">

<!--- save --->
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.includeview.#url.type#.#url.entrykey#"
	entryvalue1 = #url.display#>
	
<!--- redirect --->
<cflocation addtoken="no" url="#url.return#">