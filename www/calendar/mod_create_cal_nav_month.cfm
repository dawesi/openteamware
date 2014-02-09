<cfparam name="DisplayCalendarMonthRequest.dt_display" type="date">

<cfset ACurrentDate = DisplayCalendarMonthRequest.dt_display>
<cfset a_int_month_number = Month(DisplayCalendarMonthRequest.dt_display)>

<div id="id_div_month_<cfoutput>#Month(DisplayCalendarMonthRequest.dt_display)#</cfoutput>"></div>

<!--- translate! --->
<cfsavecontent variable="a_str_js">
var dm = <cfoutput>#Month(DisplayCalendarMonthRequest.dt_display)#</cfoutput>;
var dj = <cfoutput>#Year(DisplayCalendarMonthRequest.dt_display)#</cfoutput>;
if(dj < 999) dj+=1900;

var Monatsname = new Array
("Januar","Februar","M&auml;rz","April","Mai","Juni","Juli",
"August","September","Oktober","November","Dezember");
var Tag = new Array ("Mo","Di","Mi","Do","Fr","Sa","So");
</cfsavecontent>

<cfscript>
	AddJSToExecuteAfterPageLoad('DisplayMonthCalendar(''id_div_month_#Month(DisplayCalendarMonthRequest.dt_display)#'', dm,dj);', a_str_js);
</cfscript>