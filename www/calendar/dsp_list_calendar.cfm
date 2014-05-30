<!--- //

	Module:		Calendar
	Action:		ListEvents
	Description:List all events in the given timeframe
	

// --->

<cfparam name="url.startdate" type="string" default="">
<cfparam name="url.enddate" type="string" default="">
<cfparam name="url.search" type="string" default="">
<cfparam name="url.frmsort" type="string" default="DESC">

<cfif isDate(url.startdate)>
	<cfset a_dt_begin = LsParseDateTime(url.startdate)>
<cfelse>
	<cfset a_dt_begin = DateAdd('d', -1, Now())>	
</cfif>

<cfif isDate(url.enddate)>
	<cfset a_dt_end = LsParseDateTime(url.enddate)>
<cfelse>
	<cfset a_dt_end = DateAdd('d', 60, Now())>	
</cfif>

<cfset a_struct_filter = StructNew()>

<cfset a_struct_filter.search = url.search>
<cfset a_struct_filter.virtualcalendars = request.a_str_virtual_calendar_filter>

<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn">
	<cfinvokeargument name="startdate" value="#a_dt_begin#">
	<cfinvokeargument name="enddate" value="#a_dt_end#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="calculaterepeatingevents" value="false">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_events = stReturn.q_select_events>

<cfquery name="q_select_events" dbtype="query">
SELECT
	*
FROM
	q_select_events
ORDER BY
	date_start <cfif url.frmsort IS 'ASC'>DESC</cfif>
;
</cfquery>

<!--- listenweise ausgabe --->
<cfset tmp = SetHeaderTopInfoString(GetLangVal('cal_wd_listview'))>


<br>
<!--- select start/end date on top --->
<script type="text/javascript">
	var cal1 = new CalendarPopup();
</script>



<cfsavecontent variable="a_str_content">

	<form action="index.cfm" method="get" name="form_display_events_list">
	<input type="hidden" name="action" value="listevents">	
	<table class="table_details table_edit_form">
	  <tr>
		<td class="field_name"><cfoutput>#GetLangVal('cal_wd_start')#</cfoutput>:</td>
		<td>
			<input type="text" size="20" readonly="1" name="startdate" value="<cfoutput>#LSDateFormat(request.a_dt_current_date, request.stUserSettings.default_dateformat)#</cfoutput>">
			
			<a onClick="cal1.select(document.form_display_events_list.startdate,'anchor_display_list_1','<cfoutput>#request.a_str_default_js_dt_format#</cfoutput>'); return false;" href="##" id="anchor_display_list_1"><img alt="#GetLangVal('cal_ph_left_nav_select')#" src="/images/si/calendar.png" class="si_img" /></a>
			
			<!---<input size="20" type="text" name="startdate" value="<cfoutput>#dateformat(a_dt_begin, 'dd.mm.yyyy')#</cfoutput>" readonly=1>
			&nbsp;<img src="/images/calendar/menu_neuer_eintrag.gif" vspace="6" hspace="6" id="f_trigger_c" align="absmiddle" title="Datum auswaehlen" style="cursor: pointer;"/>--->
		</td>
	  </tr>
	  <tr>
	  	<td class="field_name"><cfoutput>#GetLangVal('cal_wd_end')#</cfoutput>:</td>
		<td>
			<input type="text" size="20" readonly="1" name="enddate" value="<cfoutput>#LSDateFormat(a_dt_end, request.stUserSettings.default_dateformat)#</cfoutput>">
			
			<a onClick="cal1.select(document.form_display_events_list.enddate,'anchor_display_list_2','<cfoutput>#request.a_str_default_js_dt_format#</cfoutput>'); return false;" href="##" id="anchor_display_list_2"><img alt="#GetLangVal('cal_ph_left_nav_select')#" src="/images/si/calendar.png" class="si_img" /></a>
		</td>
	  </tr>
	  <tr>
	  	<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_sorting')#</cfoutput>:
		</td>
		<td>
			<select name="frmsort">
				<option value="DESC" <cfoutput>#WriteSelectedElement(url.frmsort, 'DESC')#</cfoutput>><cfoutput>#GetLangVal('cm_wd_sort_desc')#</cfoutput></option>
				<option value="ASC" <cfoutput>#WriteSelectedElement(url.frmsort, 'ASC')#</cfoutput>><cfoutput>#GetLangVal('cm_wd_sort_asc')#</cfoutput></option>
			</select>
		</td>
	  </tr>
	  <tr>
	  	<td class="field_name"><cfoutput>#GetLangVal('cm_wd_search')#</cfoutput>:</td>
	  	<td colspan="2">
		<input type="text"  name="search" value="<cfoutput>#htmleditformat(url.search)#</cfoutput>" sizue="20">
		</td>
	  </tr>
	  <tr>
			<td class="field_name"></td>
			<td>
				<input type="submit" class="btn btn-primary" name="frmsubmit" value="<cfoutput>#GetLangVal('cal_wd_list_reload')#</cfoutput>" />
			</td>
	  </tr>
	</table>
	</form>
</cfsavecontent>


<cfoutput>#WriteNewContentBox(GetLangVal('cal_wd_timeframe'), '', a_str_content)#</cfoutput>

<br>

<script>
function AllMessages() 
	 { 
	   for(var x=0;x<document.formcalendarselect.elements.length;x++) 
	     { var y=document.formcalendarselect.elements[x]; 
	       if(y.name!='frmcbselectall') y.checked=document.formcalendarselect.frmcbselectall.checked; 
	     }
	 }
</script>

<form action="act_multi_edit.cfm" method="post" name="formcalendarselect" onSubmit="return confirm('<cfoutput>#GetLangVal('cm_ph_are_you_sure')#</cfoutput>')">

<table class="table table-hover">
  <tr class="tbl_overview_header"> 
    <td><cfoutput>#GetLangVal('cal_wd_month')#</cfoutput></td>
	<td align="center"><cfoutput>#GetLangVal('cal_wd_week')#</cfoutput></td>
    <td colspan="3">
		<cfoutput>#GetLangVal('cal_wd_start')#</cfoutput>
	</td>	
    <td><cfoutput>#GetLangVal('cal_wd_duration')#</cfoutput></td>
    <td>
		<input type="checkbox" onClick="AllMessages()" name="frmcbselectall" class="noborder">
		&nbsp;
		<cfoutput>#GetLangVal('cal_wd_title')#</cfoutput></td>
    <td><cfoutput>#GetLangVal('cm_wd_categories')#</cfoutput></td>
	<td>
		<cfoutput>#GetLangVal('cal_wd_list_additional')#</cfoutput>
	</td>
  </tr>
  <cfset a_int_month = 0>
  <cfset a_int_week = 0>
  
  <cfoutput query="q_select_events">  
  
  <cfset a_str_date = urlencodedformat(DateFormat(q_select_events.date_start, 'mm/dd/yyyy'))>
  
  <tr id="idtr#q_select_events.currentrow#" onMouseOver="hilite(this.id);"  onMouseOut="restore(this.id);"> 
    <td>
	
		<cfif Compare(Month(q_select_events.date_start), a_int_month) NEQ 0>
			<a href="index.cfm?action=ViewMonth&date=#a_str_date#">#LSDateFormat(q_select_events.date_start, 'mmm yy')#</a>
			<cfset a_int_month = Month(q_select_events.date_start)>
		<cfelse>
			&nbsp;			
		</cfif>

	</td>
	<td align="center">
		<cfif Compare(GetISOWeek(q_select_events.date_start), a_int_week) NEQ 0>
			<a href="index.cfm?action=ViewWeek&date=#a_str_date#">#GetISOWeek(q_select_events.date_start)#</a>
			<cfset a_int_week = GetISOWeek(q_select_events.date_start)>
		<cfelse>
			&nbsp;			
		</cfif>
	</td>
	<td>
		#LSDateFormat(q_select_events.date_start, 'ddd')#
	</td>
    <td>
		<a href="index.cfm?action=ViewDay&date=#a_str_date#">#LSDateFormat(q_select_events.date_start, 'ddd, dd.mm.yy')#</a>
	</td>
	<td>
		#TimeFormat(q_select_events.date_start, 'HH:mm')#
	</td>	
	<td>
		<cfset a_int_hours = DateDiff('h', q_select_events.date_start, q_select_events.date_end)>
		<cfset a_int_minutes = DateDiff('n', q_select_events.date_start, q_select_events.date_end)>
		
		<cfif a_int_hours GT 0>
			#a_int_hours# h
		<cfelseif a_int_minutes GT 0>
			#a_int_minutes# min
		<cfelse>
		&nbsp;
		</cfif>
	</td>
    <td>
		<input type="checkbox" name="frmcb_item" value="#q_select_events.entrykey#" class="noborder"> <a href="index.cfm?action=ShowEvent&entrykey=#urlencodedformat(q_select_events.entrykey)#">#htmleditformat(shortenstring(checkzerostring(q_select_events.title), 35))#</a>
	</td>	
    <td>
		#shortenstring(q_select_events.categories, 15)#
	</td>
	<td>
		<cfif q_select_events.privateevent IS 1>
			[#GetLangVal('cal_wd_private')#]
		</cfif>
		
		<cfif Len(q_select_events.workgroupkeys) GT 0>
			<img src="/images/calendar/16kalender_gruppen.gif" align="absmiddle" width="12" height="12" border="0">
		</cfif>
		
		<cfif val(q_select_events.repeat_type) GT 0>
			<img src="/images/si/arrow_rotate_clockwise.png" class="si_img" />
		</cfif>
	</td>
	<td>
	
	</td>
  </tr>
  </cfoutput>
  <tr>
  	<td class="bt">&nbsp;
		
	</td>
	<td class="bt">&nbsp;
		
	</td>
	<td colspan="7" class="bt">
		<cfoutput>#GetLangVal('cal_ph_selected_items')#</cfoutput> ... <input class="btn" type="submit" value="<cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput>">
	</td>
  </tr>
 </form>
</table>


