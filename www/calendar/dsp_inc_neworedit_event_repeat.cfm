<!--- //

	Module:		Calendar
	Action:		Create / Edit an event
	Description:Management recurring events
	

// --->

<!--- 
<div class="bb" style="padding:4px; "><cfoutput>#GetLangVal('cal_ph_newedit_set_recurrences')#</cfoutput></div>
 --->
<!--- load data? --->

<table class="table_overview">
<tr>
	<td class="field_name">
			<input type="Radio" checked name="frmrepeat_type" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_type, 0)#</cfoutput> value="0" class="noborder" />
	</td>
	<td><cfoutput>#GetLangVal("cal_ph_recur_no_recur")#</cfoutput></td>
	<td></td>
</tr>
<tr>
	<td></td>
	<td><cfoutput>#GetLangVal("cal_ph_recur_recur")#</cfoutput></td>
	<td></td>
</tr>
<tr>
	<td class="field_name">
		<input type="Radio"  name="frmrepeat_type" value="1" class="noborder" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_type, 1)#</cfoutput> />
	</td>
	<td colspan="2">
	
		<cfoutput>#GetLangVal("cal_wd_recur_daily")#</cfoutput>&nbsp;&nbsp;&nbsp;
		
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_2, 1)#</cfoutput> name="frmcal_repeat_daily_day2" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_mon")#</cfoutput>&nbsp;
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_3, 1)#</cfoutput> name="frmcal_repeat_daily_day3" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_tue")#</cfoutput>&nbsp;
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_4, 1)#</cfoutput> name="frmcal_repeat_daily_day4" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_wed")#</cfoutput>&nbsp;
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_5, 1)#</cfoutput> name="frmcal_repeat_daily_day5" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_thu")#</cfoutput>&nbsp;
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_6, 1)#</cfoutput> name="frmcal_repeat_daily_day6" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_fri")#</cfoutput>&nbsp;
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_7, 1)#</cfoutput> name="frmcal_repeat_daily_day7" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_sat")#</cfoutput>&nbsp;
		<input type="Checkbox" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_day_1, 1)#</cfoutput> name="frmcal_repeat_daily_day1" value="1" class="noborder"><cfoutput>#GetLangval("cal_wd_short_sun")#</cfoutput>
	
	</td>

</tr>
<tr>
	<td></td>
	<td colspan="2" class="addinfotext"><cfoutput>#GetLangVal("cal_ph_recur_daily_hint")#</cfoutput></td>
</tr>	
<tr>
	<td class="field_name">
		<input type="Radio"  name="frmrepeat_type" value="2" class="noborder" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_type, 2)#</cfoutput>></td>
	<td><cfoutput>#GetLangVal("cal_wd_recur_weekly")#</cfoutput></td>
	<td></td>

</tr>		
<tr>
	<td class="field_name">
		<input type="Radio"  name="frmrepeat_type" value="3" class="noborder" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_type, 3)#</cfoutput>></td>
	<td><cfoutput>#GetLangVal("cal_wd_recur_monthly")#</cfoutput></td>
	<td></td>
</tr>		
<tr>
	<td class="field_name">
		<input  type="Radio" name="frmrepeat_type" value="4" class="noborder" <cfoutput>#WriteCheckedElement(Variables.NewOrEditEvent.query.repeat_type, 4)#</cfoutput>></td>

	<td><cfoutput>#GetLangVal("cal_wd_recur_yearly")#</cfoutput></td>
	<td></td>
</tr>	

<cfset a_bol_recur_end_date_avaliable = Len(Variables.NewOrEditEvent.query.repeat_until) GT 0 AND isDate(Variables.NewOrEditEvent.query.repeat_until)>
				
<tr>
	<td class="field_name">
		<input  type="Checkbox" name="frmrepeat_use_end" <cfif a_bol_recur_end_date_avaliable>checked</cfif> value="1" class="noborder"></td>
	<td colspan="2">
		<cfoutput>#GetLangVal('cal_ph_set_end_date')#</cfoutput>:
	&nbsp;
	<a onClick="cal4.select(document.formneworeditevent.frm_dt_repeat_end, 'anchor_dt_repeat_end','<cfoutput>#request.a_str_default_js_dt_format#</cfoutput>'); return false;" href="#" id="anchor_dt_repeat_end"><img src="/images/si/calendar.png" alt="" class="si_img" /></a>
	<input type="text" name="frm_dt_repeat_end" size="8" readonly="1" value="<cfoutput>#lsDateFormat(Variables.NewOrEditEvent.Query.repeat_until, request.a_str_default_dt_format)#</cfoutput>">
	
	</td>

</tr>	
</table>

