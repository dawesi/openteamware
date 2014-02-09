<!--- <div class="bb" style="padding:4px; "><cfoutput>#GetLangVal('cal_ph_newedit_set_reminders')#</cfoutput></div>
 --->
<!--- are we in an edit or create operation? --->
<cfif Variables.NewOrEditEvent.action is 'edit'>
	<!--- load possible reminders ... --->
	
	<cfinvoke component="#application.components.cmp_calendar#" method="GetReminders" returnvariable="q_select_reminders">
		<cfinvokeargument name="eventkey" value="#Variables.NewOrEditEvent.query.entrykey#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>
	
	<!--- ok, we've loaded the reminders ... --->
	<cfquery name="q_select_email_remind" dbtype="query">
	SELECT
		*
	FROM
		q_select_reminders
	WHERE
		type = 0
		AND
		status = 0		
	;
	</cfquery>
	
	<!--- has there been a reminder set? --->
	<cfif isDate(q_select_email_remind.dt_remind)>
		<cfset a_int_min_remind_email = DateDiff('n', q_select_email_remind.dt_remind_local, Variables.NewOrEditEvent.query.date_start)>
		
		<cfset a_str_remind_email_adr = q_select_email_remind.remind_email_adr>	
	<cfelse>
		<cfset a_int_min_remind_email = 0>
		<cfset a_str_remind_email_adr = request.stSecurityContext.myusername />
	</cfif>	
		
	<cfquery name="q_select_sms_remind" dbtype="query">
	SELECT
		*
	FROM
		q_select_reminders
	WHERE
		type = 1
		AND
		status = 0
	;
	</cfquery>
	
	<!--- has there been a reminder set? --->
	<cfif isDate(q_select_sms_remind.dt_remind)>
		<cfset a_int_min_remind_sms = DateDiff('n', q_select_sms_remind.dt_remind_local, Variables.NewOrEditEvent.query.date_start)>	
	<cfelse>
		<cfset a_int_min_remind_sms = 0>
	</cfif>
	
	<cfquery name="q_select_ib_reminder_remind" dbtype="query">
	SELECT
		*
	FROM
		q_select_reminders
	WHERE
		type = 0
		AND
		status = 0		
	;
	</cfquery>
	
	<!--- has there been a reminder set? --->
	<cfif isDate(q_select_ib_reminder_remind.dt_remind)>
		<cfset a_int_min_remind_reminder = DateDiff('n', q_select_ib_reminder_remind.dt_remind_local, Variables.NewOrEditEvent.query.date_start)>	
	<cfelse>
		<cfset a_int_min_remind_reminder = 0>
	</cfif>		

<cfelse>
	<!--- create dummy values ... --->
	<cfset q_select_sms_remind = QueryNew('dummy')>
	<cfset a_int_min_remind_sms = 0>
	
	<cfset q_select_ib_reminder_remind = QueryNew('dummy')>
	<cfset a_int_min_remind_reminder = 0>
	
	<cfset q_select_email_remind = QueryNew('dummy')>
	<cfset a_int_min_remind_email = 0>
	<cfset a_str_remind_email_adr = request.stSecurityContext.myusername>	
</cfif>

<table border="0" cellspacing="0" cellpadding="6">
<tr>
	<td>
	
	<table border="0" cellspacing="0" cellpadding="6">
	  <tr>
		<td align="right">
		<input type="checkbox" name="frmcbreminderemail" <cfoutput>#WriteCheckedElement(q_select_email_remind.recordcount, 1)#</cfoutput>  value="1" class="noborder">
		</td>
		<td>
		<cfoutput>#GetLangVal('cal_ph_newedit_reminders_by_email_to')#</cfoutput>
		
		<input type="text" name="frmreminderemailaddress" size="30" maxlength="255" value="<cfoutput>#htmleditformat(a_str_remind_email_adr)#</cfoutput>">
		
		<select name="frmemailremindminutes">
			<cfloop from="5" to="160" step="5" index="a_int_minutes">
			<cfoutput>
			<option value="#a_int_minutes#" #writeselectedelement(a_int_min_remind_email,a_int_minutes)# >#a_int_minutes# #GetLangVal('cm_wd_minutes')#</option>
			</cfoutput>
			</cfloop>
			
			<cfloop from="180" to="300" step="30" index="a_int_hours">
			<cfoutput>
			<cfset a_int_hours = a_int_hours / 60>
			<option value="#a_int_hours#" #writeselectedelement(a_int_min_remind_email,a_int_minutes)#>#a_int_hours# #GetLangVal('cm_wd_hours')#</option>
			</cfoutput>
			</cfloop>
			
			<cfloop from="1440" to="7200" step="1440" index="a_int_day">
			<cfoutput>
			<cfset a_int_day = a_int_day / 1440>
			<option value="#a_int_day#" #writeselectedelement(a_int_min_remind_email,a_int_minutes)#>#a_int_day# #GetLangVal('cm_wd_days')#</option>
			</cfoutput>
			</cfloop>			
		</select>
		
		<cfoutput>#GetLangVal('cal_ph_newedit_reminders_before')#</cfoutput>		
		
		</td>
	  </tr>	
	  <tr>
		<td align="right">
		<input type="checkbox" name="frmcbremindersms" <cfoutput>#WriteCheckedElement(q_select_sms_remind.recordcount, 1)#</cfoutput> value="1" class="noborder">
		</td>
		<td>
		<cfoutput>#GetLangVal('cal_ph_newedit_reminders_by_sms')#</cfoutput> 
		
		<select name="frmsmsremindminutes">
			<cfloop from="5" to="90" step="5" index="a_int_minutes">
			<cfoutput>
			<option value="#a_int_minutes#" #writeselectedelement(a_int_min_remind_sms, a_int_minutes)#>#a_int_minutes#</option>
			</cfoutput>
			</cfloop>
		</select>
		
		<cfoutput>#GetLangVal('cal_ph_newedit_reminders_minutes_before')#</cfoutput>
		</td>
	  </tr>
	  <tr style="display:none;">
		<td align="right">
		<input type="checkbox" name="frmcbreminderreminder" <cfoutput>#WriteCheckedElement(q_select_ib_reminder_remind.recordcount, 1)#</cfoutput> value="1" class="noborder">
		</td>
		<td>
		<cfoutput>#GetLangVal('cal_ph_reminder_ib_reminder')#</cfoutput>
		
		<select name="frmreminderremindminutes">
			<cfloop from="5" to="180" step="5" index="a_int_minutes">
			<cfoutput>
			<option value="#a_int_minutes#" #writecheckedelement(a_int_min_remind_reminder, a_int_minutes)#>#a_int_minutes#</option>
			</cfoutput>
			</cfloop>
		</select>
		
		<cfoutput>#GetLangVal('cal_ph_newedit_reminders_minutes_before')#</cfoutput>
		</td>
	  </tr>
	</table>

	
	
	
	</td>
</tr>
</table>

