<!--- //

	save the newsticker settings
	
	// --->

<!--- enabled: yes/no --->
<cfparam name="form.frmactive" type="numeric" default="0">

<!--- immediately or delayed? --->
<cfparam name="form.frmviewmode" type="string" default="onload">

<!--- random mode? --->
<cfparam name="form.frmrandommode" type="numeric" default="0">

<!--- how long delayed? --->
<cfparam name="form.frmsecdelayed" type="numeric" default="10">

<!--- feed sources --->
<cfparam name="form.frmsourceids" type="string" default="">

<!--- scroll speed --->
<cfparam name="form.frmscrollspeed" type="numeric" default="6">

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "newsticker"
	entryname = "active"
	entryvalue1 = #form.frmactive#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "newsticker"
	entryname = "viewmode"
	entryvalue1 = #form.frmviewmode#>
		
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "newsticker"
	entryname = "randommode"
	entryvalue1 = #form.frmrandommode#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "newsticker"
	entryname = "secdelay"
	entryvalue1 = #form.frmsecdelayed#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "newsticker"
	entryname = "scrollspeed"
	entryvalue1 = #form.frmscrollspeed#>
	
<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "newsticker"
	entryname = "sourceids"
	entryvalue1 = #form.frmsourceids#>
	
<cflocation addtoken="no" url="index.cfm?action=newsticker">