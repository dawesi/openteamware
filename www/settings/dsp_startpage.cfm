<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "startpage_content"
	entryname = "display.leftcolumn"
	defaultvalue1 = "email,calendar,tasks"
	setcallervariable1 = "a_str_display_left"
	savesettings = true>
	
<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "startpage_content"
	entryname = "display.rightcolumn"
	defaultvalue1 = "forum,im,news,lastvisited"
	setcallervariable1 = "a_str_display_right"
	savesettings = true>



<cfset tmp = SetHeaderTopInfoString( GetLangVal('start_ph_customize_page') ) />
<a href="/" target="_blank"><b><cfoutput>#GetLangVal('prf_ph_startpage_show_new_window')#</cfoutput></b></a>
<br>
<br>
<b><cfoutput>#GetLangVal('prf_ph_startpage_select_items')#</cfoutput></b>
<br><br>

<table border="0" cellspacing="0" cellpadding="6">
<form action="act_save_startpage_settings.cfm" method="post">
  <tr>
  	<td colspan="2" align="right" class="mischeader bb">
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput> ...">
	</td>
  </tr>
  <tr>
    <td valign="top" class="br">
	<b><cfoutput>#GetLangVal('prf_ph_startpage_left_col')#</cfoutput></b>
	
	<table width="250" border="0" cellspacing="0" cellpadding="8">
	  <cfloop from="1" to="10" index="ii">
	  
	  <cfif ii LTE ListLen(a_str_display_left)>
	  		<cfset a_str_servicename = ListGetAt(a_str_display_left, ii)>
	  <cfelse>
	  		<cfset a_str_servicename = ''>
	  </cfif>
	  
	  <tr>
		<td align="center">
		
		<cfif Len(a_str_servicename) GT 0>
			<cfif ii NEQ 1>
			<a href="act_startpage_move_order.cfm?side=left&direction=up&index=<cfoutput>#ii#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_move_up')#</cfoutput></a>
			</cfif>
			| 
			<cfif ii LTE ListLen(a_str_display_left)>
			<a href="act_startpage_move_order.cfm?side=left&direction=down&index=<cfoutput>#ii#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_move_down')#</cfoutput></a>
			</cfif>
			
		<br>
		
		</cfif>
		
		<select name="frmleft" style="width:100%;">
			
			<cfoutput>
			<option value="" <cfif Len(a_str_servicename) IS 0>selected</cfif>></option>			
			<option #WriteSelectedElement(a_str_servicename, 'email')# value="email">#GetLangVal('cm_Wd_email')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'calendar')# value="calendar">#GetLangVal('cm_wd_calendar')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'tasks')# value="tasks">#GetLangVal('cm_wd_tasks')#</option>
			<!---<option #WriteSelectedElement(a_str_servicename, 'storage')# value="storage">#GetLangVal('cm_Wd_storage')#</option>--->
			<option #WriteSelectedElement(a_str_servicename, 'forum')# value="forum">#GetLangVal('cm_Wd_forum')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'bookmarks')# value="bookmarks">#GetLangVal('cm_wd_bookmarks')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'addressbook')# value="addressbook">#GetLangVal('cm_wd_addressbook')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'News')# value="News">#GetLangVal('cm_wd_newsticker')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'stat')# value="stat">#GetLangVal('start_ph_statistics_settings')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'im')# value="im">#GetLangVal('cm_ph_instant_messenger')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'routeplanner')# value="routeplanner">#GetLangVal('start_wd_routeplanner')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'lastvisited')# value="lastvisited">#GetLangVal('cm_ph_last_used')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'websearch')# value="websearch">#GetLangVal('cm_wd_search')#</option>
			<!---<option #WriteSelectedElement(a_str_servicename, 'notices')# value="notices">#GetLangVal('cm_wd_notes')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'help')# value="help">#GetLangVal('cm_wd_help')#</option>--->
			</cfoutput>
									
		</select>
		</td>
	  </tr>
	  </cfloop>
	</table>
	
	</td>
    <td valign="top">
	<b><cfoutput>#GetLangVal('prf_ph_startpage_right_col')#</cfoutput></b>
	
	<table width="250" border="0" cellspacing="0" cellpadding="8">
	  <cfloop from="1" to="10" index="ii">
	  
	  <cfif ii LTE ListLen(a_str_display_right)>
	  		<cfset a_str_servicename = ListGetAt(a_str_display_right, ii)>
	  <cfelse>
	  		<cfset a_str_servicename = ''>
	  </cfif>
	  
	  <tr>
		<td align="center">
		
		<cfif Len(a_str_servicename) GT 0>
			<cfif ii NEQ 1>
			<a href="act_startpage_move_order.cfm?side=right&direction=up&index=<cfoutput>#ii#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_move_up')#</cfoutput></a>
			</cfif>
			| 
			<cfif ii LTE ListLen(a_str_display_right)>
			<a href="act_startpage_move_order.cfm?side=right&direction=down&index=<cfoutput>#ii#</cfoutput>"><cfoutput>#GetLangVal('cm_wd_move_down')#</cfoutput></a>
			</cfif>
			
			<br>
		
		</cfif>		
		
		<select name="frmright" style="width:100%;">
			
			<cfoutput>
			<option value="" <cfif Len(a_str_servicename) IS 0>selected</cfif>></option>			
			<option #WriteSelectedElement(a_str_servicename, 'email')# value="email">#GetLangVal('cm_Wd_email')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'calendar')# value="calendar">#GetLangVal('cm_wd_calendar')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'tasks')# value="tasks">#GetLangVal('cm_wd_tasks')#</option>
			<!---<option #WriteSelectedElement(a_str_servicename, 'storage')# value="storage">#GetLangVal('cm_Wd_storage')#</option>--->
			<option #WriteSelectedElement(a_str_servicename, 'forum')# value="forum">#GetLangVal('cm_Wd_forum')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'bookmarks')# value="bookmarks">#GetLangVal('cm_wd_bookmarks')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'addressbook')# value="addressbook">#GetLangVal('cm_wd_addressbook')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'News')# value="News">#GetLangVal('cm_wd_newsticker')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'stat')# value="stat">#GetLangVal('start_ph_statistics_settings')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'im')# value="im">#GetLangVal('cm_ph_instant_messenger')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'routeplanner')# value="routeplanner">#GetLangVal('start_wd_routeplanner')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'lastvisited')# value="lastvisited">#GetLangVal('cm_ph_last_used')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'websearch')# value="websearch">#GetLangVal('cm_wd_search')#</option>
			<!---<option #WriteSelectedElement(a_str_servicename, 'notices')# value="notices">#GetLangVal('cm_wd_notes')#</option>
			<option #WriteSelectedElement(a_str_servicename, 'help')# value="help">#GetLangVal('cm_wd_help')#</option>--->
			</cfoutput>
									
		</select>
		</td>
	  </tr>
	  </cfloop>
	</table>	
	</td>
  </tr>
  <tr>
  	<td colspan="2" class="mischeader bt" align="right">
		<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput> ...">
	</td>
  </tr>
</form>
</table>