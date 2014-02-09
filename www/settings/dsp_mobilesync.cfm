<cfprocessingdirective pageencoding="ISO-8859-1">

<cfparam name="url.saved" type="boolean" default="false">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_addressbook"
	defaultvalue1 = "category"
	savesettings = true
	setcallervariable1 = "a_str_restriction_addressbook">
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_calendar"
	defaultvalue1 = "private"
	savesettings = true
	setcallervariable1 = "a_str_restriction_calendar">	
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_calendar_timeframe"
	defaultvalue1 = "futureandlatepast"
	savesettings = true
	setcallervariable1 = "a_str_restriction_calendar_timeframe">		
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_tasks"
	defaultvalue1 = "open"
	savesettings = true
	setcallervariable1 = "a_str_restriction_tasks">		
	
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "delete_data_online"
	defaultvalue1 = "0"
	savesettings = true
	setcallervariable1 = "a_int_delete_data_online">	

<cf_disp_navigation mytextleft="MobileSync">
<br>

<cfif url.saved>
	<fieldset class="default_fieldset">
		<legend><cfoutput>#GetLangVal('cm_wd_information')#</cfoutput></legend>
		<div>
			<cfoutput>#GetLangVal('prf_ph_settings_saved')#</cfoutput>
		</div>
	</fieldset>
	<br>
</cfif>
<form action="act_save_mobilesync.cfm" method="post">

<table border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('sync_ph_restrictions_addressbook')#</cfoutput>:
	</td>
    <td>
		<select name="frm_restrictions_addressbook">
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_addressbook, 'category')#</cfoutput> value="category"><cfoutput>#GetLangVal('sync_ph_restrictions_addressbook_only_with_cat')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_addressbook, 'private')#</cfoutput> value="private"><cfoutput>#GetLangVal('sync_ph_restrictions_addressbook_only_own')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_addressbook, 'all')#</cfoutput>value="all"><cfoutput>#GetLangVal('sync_ph_restrictions_addressbook_all')#</cfoutput></option>
		</select>
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('sync_ph_restrictions_calendar')#</cfoutput>:
	</td>
    <td>
		<select name="frm_restrictions_calendar">
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_calendar, 'private')#</cfoutput> value="private"><cfoutput>#GetLangVal('sync_ph_restrictions_calendar_own')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_calendar, 'all')#</cfoutput> value="all"><cfoutput>#GetLangVal('sync_ph_restrictions_calendar_all')#</cfoutput></option>
		</select>
	</td>
  </tr>
  <tr>
  	<td align="right">
		<cfoutput>#GetLangVal('sync_ph_timeframe_calendar')#</cfoutput>:
	</td>
	<td>
		<select name="frm_restrictions_calendar_timeframe">
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_calendar_timeframe, 'futureonly')#</cfoutput> value="futureonly"><cfoutput>#GetLangVal('sync_ph_restrictions_calendar_timeframe_future')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_calendar_timeframe, 'futureandlatepast')#</cfoutput> value="futureandlatepast"><cfoutput>#GetLangVal('sync_ph_restrictions_calendar_timeframe_future_latepast')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_calendar_timeframe, 'all')#</cfoutput> value="all"><cfoutput>#GetLangVal('sync_ph_restrictions_calendar_timeframe_all')#</cfoutput></option>
		</select>	
	</td>
  </tr>
  <tr style="display:none; ">
    <td align="right">
		<cfoutput>#GetLangVal('sync_ph_restrictions_tasks')#</cfoutput>:
	</td>
    <td>
		<select name="frm_restrictions_tasks">
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_tasks, 'open')#</cfoutput> value="open"><cfoutput>#GetLangVal('sync_ph_restrictions_tasks_open')#</cfoutput></option>
			<option <cfoutput>#WriteSelectedElement(a_str_restriction_tasks, 'all')#</cfoutput> value="all"><cfoutput>#GetLangVal('sync_ph_restrictions_tasks_all')#</cfoutput></option>
		</select>
	</td>
  </tr>  
  <tr>
    <td align="right" valign="top">
		<cfoutput>#GetLangVal('sync_ph_restrictions_more_options')#</cfoutput>:
	</td>
    <td valign="top">
		
		<input value="1" <cfoutput>#WriteCheckedElement(a_int_delete_data_online, 1)#</cfoutput> type="checkbox" name="frm_cb_delete_online" class="noborder"> <cfoutput>#GetLangVal('sync_ph_delete_data_online_too')#</cfoutput>
		
		<!---
		<br>
		<input type="checkbox" name="frm_db_mark_with_category" class="noborder" checked disabled> Daten von mobilen Endger�ten mit Kategorie "mobile" versehen.
		--->
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" class="btn" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
	</td>
  </tr>
</table>

</form>