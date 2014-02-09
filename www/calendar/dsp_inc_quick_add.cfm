
	<table style="padding:5px;" border="0" cellpadding="3" cellspacing="0">
	<form action="act_add_quick_entry.cfm" method="POST" name="formquickentry">
	<input type="Hidden" name="frmDateDay" value="<cfoutput>#Day(request.a_dt_current_date)#</cfoutput>">
	<input type="Hidden" name="frmDateMonth" value="<cfoutput>#Month(request.a_dt_current_date)#</cfoutput>">
	<input type="Hidden" name="frmDateYear" value="<cfoutput>#Year(request.a_dt_current_date)#</cfoutput>">
	<tr id="idtrquickentryheader" style="display:none;">
		<td colspan="4" class="mischeader contrasttext bl br bt">
		<b><cfoutput>#GetLangVal('cal_ph_quickadd_add_event')#</cfoutput></b>
		</td>
	</tr>
	<tr id="idtrquickentry" style="display:none;">
		<td class="bt bb bl"><cfoutput>#GetLangVal('cal_wd_title')#</cfoutput>: <input type="Text" name="frmTitle" required="No" size="25" maxlength="50"></td>
	
		<td class="bdashedleft bb bt"><cfoutput>#GetLangVal('cal_wd_start')#</cfoutput>:&nbsp;
		<select name="frmbegin_hour">
		<cfloop from="1" to="23" index="a_int_hour">
			<cfoutput>
			<option value="#a_int_hour#" #writeselectedelement(a_int_hour, hour(dateadd('h', -request.stUserSettings.utcdiff, now())))#>#a_int_hour#</option>
			</cfoutput>
		</cfloop>
		</select>
	
		
		<select name="Frmbegin_minutes">
		<option value="0">00
		<option value="15">15
		<option value="30">30
		<option value="45">45
		</select>
		</td>
		<td class="bdashedleft bb bt"><cfoutput>#GetLangVal('cal_wd_duration')#</cfoutput>:&nbsp;
		<select name="frmDuration">
		<option value="1">1
		<option value="2">2
		<option value="3">3
		<option value="4">4
		<option value="5">5
		</select> <cfoutput>#GetLangVal('cal_wd_quickadd_hours')#</cfoutput>
		</td>
	
		<td class="bdashedleft bt bb br">&nbsp;&nbsp;<input type="submit" value="<cfoutput>#GetLangVal('cal_wd_quick_add_add')#</cfoutput>">
		</td>
	</tr>
	</form>
	</table>