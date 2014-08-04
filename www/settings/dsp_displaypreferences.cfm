<!--- // display preferences // --->

<!--- TODO: move to new way of loading preferences

	and load certain settings from userpref and not session scope ... --->
<cfinclude template="queries/q_select_display_settings.cfm">

<cfset a_cmp_tools = application.components.cmp_tools>

<cfset a_int_max_rows_per_page = GetUserPrefPerson('addressbook', 'adressbook.maxrowsperpage', '50', '', false)>
<!--- confirm each sending of an email? --->
<cfset a_int_confirmsend = GetUserPrefPerson('email', 'confirmsend', '0', '', false)>
<cfset a_str_viewmode_contacts = GetUserPrefPerson('addressbook', 'display.viewmode', 'list', '', false) />
<!--- emails per page ... --->
<cfset a_int_mails_per_page = GetUserPrefPerson('email', 'emailsperpage', '50', '', false) />
<!--- session timeout? --->
<cfset a_int_timeout = GetUserPrefPerson('session', 'timeout', '30', '', false) />
<!--- default email format --->
<cfset a_str_email_default_format = GetUserPrefPerson('email', 'defaultformat', 'plain', '', false) />
<!--- default encoding ... --->
<cfset a_str_email_default_encoding_if_unknown_encoding = GetUserPrefPerson('email', 'defaultencoding_if_unknown_encoding', 'UTF-8', '', false) />
<!--- default view ... --->
<cfset a_str_email_default_view = GetUserPrefPerson('email', 'defaultview', 'overview', '', false) />


<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "surpress_external_elements_by_default"
	defaultvalue1 = "1"
	savesettings = true
	setcallervariable1 = "a_int_surpress_external_elements_by_default">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "surpress_external_elements_exception_domains"
	defaultvalue1 = ""
	savesettings = true
	setcallervariable1 = "a_str_surpress_external_elements_exception_domains">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "surpresssender.onexternaladdress"
	defaultvalue1 = "0"
	savesettings = true
	setcallervariable1 = "a_int_surpress_sender_on_external_address">

<!--- default email folder display --->
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "display.foldersleft"
	defaultvalue1 = "box"
	savesettings = true
	setcallervariable1 = "a_str_email_default_folder_display_left">

<!--- insert signature by default? --->
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "insertsignaturebydefault"
	defaultvalue1 = "0"
	savesettings = true
	setcallervariable1 = "a_str_insert_signature_by_default">

<!--- empty trash by default --->
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "emptytrashonlogout"
	defaultvalue1 = "0"
	savesettings = true
	setcallervariable1 = "a_str_email_empty_trash_on_logout">

<!--- forward format --->
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "forward.format"
	defaultvalue1 = "easy"
	savesettings = true
	setcallervariable1 = "a_str_email_forward_format">

<!--- // calendar // --->
<cfset a_str_startview_calendar = GetUserPrefPerson('calendar', 'calstartview_action', 'ViewWeek', '', false)>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "calendar"
	entryname = "calendar.daystarthour"
	defaultvalue1 = "8"
	setcallervariable1 = "a_int_day_starthour"
	savesettings = true>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "calendar"
	entryname = "calendar.dayendhour"
	defaultvalue1 = "18"
	setcallervariable1 = "a_int_day_endhour"
	savesettings = true>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.day.opentasks"
	defaultvalue1 = "0"
	setcallervariable1 = "a_int_show_open_tasks"
	savesettings = true>

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "startpage"
	entryname = "display.leftnav.type"
	defaultvalue1 = "full"
	setcallervariable1 = "a_str_show_leftnav_type"
	savesettings = true>


<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.viewmode"
	defaultvalue1 = "cols"
	savesettings = true
	setcallervariable1 = "a_str_mbox_display_style">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.msgpreview"
	defaultvalue1 = "1"
	savesettings = true
	setcallervariable1 = "a_int_display_mbox_msg_preview">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "email"
	entryname = "mbox.display.autoloadfirstmsg"
	defaultvalue1 = "0"
	savesettings = true
	setcallervariable1 = "a_int_display_mbox_autoload_first_msg">

<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "common"
	entryname = "show.today.bydefault"
	defaultvalue1 = "0"
	setcallervariable1 = "a_int_display_inboxcc_today_by_default">

<!--- skype extension enabled? --->
<cfmodule template="../common/person/getuserpref.cfm"
	entrysection = "extensions.skype"
	entryname = "enabled"
	defaultvalue1 = "1"
	setcallervariable1 = "a_int_skype_enabled">

<cfset SetHeaderTopInfoString(GetLangVal('prf_ph_display_view')) />

<form action="actions/act_save_display_preferences.cfm" method="post" enctype="multipart/form-data" enablecab="no">


<cfoutput>
<div class="b_all">
	<table class="table table_details table_edit_form">

	<cfset a_arr_options = ArrayNew(1)>
	<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('cm_wd_yes'), '1')>
	<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('cm_wd_no'), '0')>

	#a_cmp_tools.GenerateEditingTableRow(datatype = 'options', field_name = GetLangVal('cm_ph_extensions_skype_enabled'), input_name = 'frmExtensionsSkypeEnabled', input_value = a_int_skype_enabled, options = a_arr_options)#


	</table>
</div>
</cfoutput>

<div class="b_all">

<table class="table table_details table_edit_form">
<cfoutput>
<cfset a_arr_options = ArrayNew(1)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('prf_ph_display_left_nav_full'), 'full')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, GetLangVal('prf_ph_display_left_nav_small'), 'small')>

#a_cmp_tools.GenerateEditingTableRow(datatype = 'options', field_name = GetLangVal('prf_ph_left_column'), input_name = 'frmleftnavtype', input_value = a_str_show_leftnav_type, options = a_arr_options)#

<!--- timezone --->
<cfset a_arr_options = ArrayNew(1)>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -12:00 Dateline : Eniwetok, Kwajalein, Fiji, New Zealand', '12')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -11:00 Samoa : Midway Island, Samoa', '11')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -10:00 Hawaiian : Hawaii', '10')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -09:00 Alaskan : Alaska', '9')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -08:00 Pacific Time (U.S. & Canada)', '8')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -07:00 Mountain : Mountain Time (US & Can.)', '7')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -07:00 Arizona : Mountain Time (US & Can.)', '7')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -06:00 Central Time (U.S. & Canada), Mexico City', '6')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -05:00 Eastern Time (U.S & Can.), Bogota, Lima', '5')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -04:00 Atlantic Time (Canada), Caracas, La Paz', '4')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -03:00 Brasilia, Buenos Aires', '3')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -02:00 Mid-Atlantic', '2')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT -01:00 Azores : Azores, Cape Verde Is.', '1')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT 0 Greenwich Mean Time : Dublin, Lisbon, London', '0')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +01:00 Western &amp; Central Europe', '-1')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +02:00 East. Europe, Egypt, Finland, Israel, S. Africa', '-2')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +03:00 Russia, Saudi Arabia, Nairobi', '-3')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +04:00 Arabian : Abu Dhabi, Muscat', '-4')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +05:00 West Asia : Islamabad, Karachi', '-5')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +07:00 Bangkok, Hanoi, Jakarta', '-7')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +08:00 China, Singapore, Taiwan, W. Australia', '-8')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +09:00 Korea, Japan', '-9')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +10:00 E. Australia : Brisbane, Vladivostok, Guam', '-10')>
<cfset a_arr_options = a_cmp_tools.AddOptionToInputElementOptions(a_arr_options, 'GMT +11:00 Central Pacific : Magadan, Sol. Is.', '-11')>

#a_cmp_tools.GenerateEditingTableRow(datatype = 'options', field_name = GetLangVal('prf_wd_timezone'), input_name = 'frmtimeZone', input_value = q_select_display_settings.utcdiff, options = a_arr_options)#

</cfoutput>

<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('prf_ph_daylightsaving')#</cfoutput>:
	</td>
	<td>
	<select name="frmDaylightsavinghours">
		<option value="0"><cfoutput>#GetLangVal('cm_wd_no')#</cfoutput></option>
		<option value="-1" <cfif q_select_display_settings.daylightsavinghours is -1>selected</cfif>><cfoutput>#GetLangVal('cm_wd_yes')#</cfoutput></option>
	</select>
	</td>
</tr>

<tr>
	<td class="field_name">
		<input class="noborder" style="width:auto; " type="checkbox" name="frmdisplaytodaybydefault" value="1" <cfoutput>#WriteCheckedElement(a_int_display_inboxcc_today_by_default, 1)#</cfoutput>>
	</td>
	<td>
		<cfoutput>#GetLangVal('prf_ph_show_inboxcc_today_by_default')#</cfoutput>
	</td>
</tr>
</table>
</div>



<div class="b_all">

<table class="table table_details table_edit">
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('cal_ph_set_standard_view')#</cfoutput>:</td>
	<td>

	<select name="frmCalendarDefaultView">
		<option value="Overview" #WriteSelectedElement(a_str_startview_calendar, 'Overview')#><cfoutput>#GetLangVal('cm_wd_overview')#</cfoutput>
		<option value="ViewDay" #WriteSelectedElement(a_str_startview_calendar, 'ViewDay')#><cfoutput>#GetLangVal('cal_wd_day')#</cfoutput>
		<option value="View2Days" #WriteSelectedElement(a_str_startview_calendar, 'View2Days')#><cfoutput>#GetLangVal('cal_wd_2days')#</cfoutput>
		<option value="ViewWeek" #WriteSelectedElement(a_str_startview_calendar, 'ViewWeek')#><cfoutput>#GetLangVal('cal_wd_week')#</cfoutput>
		<option value="ViewMonth" #WriteSelectedElement(a_str_startview_calendar, 'ViewMonth')#><cfoutput>#GetLangVal('cal_Wd_month')#</cfoutput>
	</select>

	</td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_cal_day_duration')#</cfoutput></td>
	<td>
	<select name="frmCalendarStartHour">
		<cfloop from="2" to="10" index="ii">
			<cfoutput>
			<option value="#ii#" #WriteSelectedElement(ii, a_int_day_starthour)#>#ii#</option>
			</cfoutput>
		</cfloop>
	</select>&nbsp;h <cfoutput>#GetLangVal('cm_wd_to')#</cfoutput>
	<select name="frmCalendarEndHour">
		<cfloop from="17" to="23" index="ii">
			<cfoutput>
			<option value="#ii#" #WriteSelectedElement(ii, a_int_day_endhour)#>#ii#</option>
			</cfoutput>
		</cfloop>
	</select>&nbsp;h
	</td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_cal_include_due_tasks')#</cfoutput></td>
	<td>
	<input style="width:auto; "  type="checkbox" name="frmcbcalshowduetasks" value="1" class="noborder" <cfoutput>#WriteCheckedElement(a_int_show_open_tasks, 1)#</cfoutput>>
	&nbsp;
	(<cfoutput>#GetLangVal('prf_ph_cal_include_due_tasks_in_day_view')#</cfoutput>)
	</td>
</tr>
</table>
</div>

<div class="b_all">

<table class="table table_details table_edit">
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_items_per_page')#</cfoutput>:</td>
	<td>
		<select name="frmAddressbookEntriesPerPage">
			<cfoutput>
			<option value="20" #WriteSelectedElement(a_int_max_rows_per_page, 20)#>20
			<option value="30" #WriteSelectedElement(a_int_max_rows_per_page, 30)#>30
			<option value="50" #WriteSelectedElement(a_int_max_rows_per_page, 50)#>50
			<option value="100" #WriteSelectedElement(a_int_max_rows_per_page, 100)#>100
			<option value="250" #WriteSelectedElement(a_int_max_rows_per_page, 250)#>250
			<option value="500" #WriteSelectedElement(a_int_max_rows_per_page, 500)#>500
			<option value="1000" #WriteSelectedElement(a_int_max_rows_per_page, 1000)#>1000
			</cfoutput>
		</select>
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_view')#</cfoutput>
	</td>
	<td>
		<cfoutput>
		<select name="frmaddressbookviewmode">
			<option value="list" #WriteSelectedElement(a_str_viewmode_contacts, 'list')#>#GetLangVal('adrb_wd_viewmode_list')#</option>
			<option value="box" #WriteSelectedElement(a_str_viewmode_contacts, 'box')#>#GetLangVal('adrb_wd_viewmode_boxes')#</option>
		</select>
		</cfoutput>
	</td>
</tr>
</table>
</div>

<div class="b_all">

<table class="table table_details table_edit">
<tr>
	<td class="field_name"><input style="width:auto; " type="checkbox" name="frmCBConfirmLogout" value="1" class="noborder" <cfif q_select_display_settings.confirmlogout is 1>checked</cfif>></td>
	<td><cfoutput>#GetLangVal('prf_ph_logout_confirmation')#</cfoutput></td>
</tr>
</table>
</div>
<div style="padding:10px; ">
	<input class="btn btn-primary" type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" name="submit">
</div>
</form>