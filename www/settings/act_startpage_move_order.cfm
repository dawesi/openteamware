
<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.side" type="string" default="left">
<cfparam name="url.direction" type="string" default="up">
<cfparam name="url.index" type="numeric" default="1">

<cfif url.direction IS 'up'>
	<cfset a_int_next_id = url.index -1>
<cfelse>
	<cfset a_int_next_id = url.index + 1>
</cfif>

<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "start"
	entryname = "display.#url.side#column"
	defaultvalue1 = "email,calendar,tasks"
	setcallervariable1 = "a_str_display_services"
	savesettings = true>
	
<cfoutput>#a_str_display_services#</cfoutput>



<cfscript>
/**
 * Swaps two elements in a list.
 * 
 * @param list 	 The list to modify. (Required)
 * @param positionA 	 The first position to swap. (Required)
 * @param positionB 	 The second position to swap. (Required)
 * @param delims 	 The delimiter to use. Defaults to a comma. (Optional)
 * @return Returns a string. 
 * @author Rob Baxter (rob@microjuris.com) 
 * @version 1, June 21, 2002 
 */
function ListSwap(list, PositionA, PositionB)
{
	var elementA = "";
	var elementB = "";
	var Delims = ",";

	if (ArrayLen(Arguments) gt 3)
		Delims = Arguments[4];
			
	if (PositionA gt ListLen(list) Or PositionB gt ListLen(list) Or PositionA lt 1 or PositionB lt 1)
		return list;	
	
	elementA = ListGetAt(list, PositionA, Delims);
	elementB = ListGetAt(list, PositionB, Delims);
	
	//do the swap
	list = ListSetAt(list, PositionA, elementB, Delims);
	list = ListSetAt(list, PositionB, elementA, Delims); 

	return list;
}
</cfscript>


<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "start"
	entryname = "display.#url.side#column"
	entryvalue1 = #ListSwap(a_str_display_services, url.index, a_int_next_id)#>
	
<cflocation addtoken="no" url="default.cfm?action=startpage">