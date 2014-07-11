<!--- //

	Module:		Tasks
	action:		ShowTasks
	Description:Display tasks
	

// --->

<cfset tmp = SetHeaderTopInfoString( GetLangVal('cm_wd_tasks') ) />

<cfset a_arr_get_multi_pref = ArrayNew(1)>

<cfset a_str_filter_timeframe = GetUserPrefPerson('tasks', 'tasks.filtertimeframe', '', 'url.filtertimeframe', false) />

<cfset a_str_filter_workgroup = GetUserPrefPerson('tasks', 'tasks.filterworkgroup', '', 'url.filterworkgroup', false) />

<cfset a_str_filter_assignedto_userkey = GetUserPrefPerson('tasks', 'tasks.filterassignedtouserkey', '', 'url.assignedtouserkey', false) />

<cfset a_str_filter_status = GetUserPrefPerson('tasks', 'tasks.filterstatus', 'open', 'url.filterstatus', false) />

<cfset a_str_filter_priority = GetUserPrefPerson('tasks', 'tasks.filterpriority', '', 'url.filterpriority', false) />

<cfset a_str_filter_projectkey = GetUserPrefPerson('tasks', 'tasks.filterprojectkey', '', 'url.filterprojectkey', false) />

<cfset a_int_displayitemsperpage = GetUserPrefPerson('tasks', 'tasks.displayitemsperpage', '50', '', false) />
	
<cfset a_str_filter_category = GetUserPrefPerson('tasks', 'tasks.filtercategory', '', 'url.filtercategory', false) />
	
<cfset sOrderBy = GetUserPrefPerson('tasks', 'tasks.display.orderby', 'dt_lastmodified', 'url.order', false) />

<cfset a_str_sortorder = GetUserPrefPerson('tasks', 'tasks.display.sortorder', '', 'url.sortorder', false) />
	
<cfparam name="url.startrow" default="1" type="numeric">
<cfparam name="url.search" type="string" default="">

<cfif len(a_str_sortorder) GT 0>
	<cfset a_str_sort = "" />
	<cfset a_str_url_sort = "&sortorder=" />
<cfelse>
	<cfset a_str_sort = "DESC" />
	<cfset a_str_url_sort = "&sortorder=DESC" />
</cfif>

<!--- javascripts for displaying further information ... --->
<cfinclude template="utils/inc_js_show_tasks.cfm">

 <!--- 

	load tasks
	
	--->
	
<cfset a_struct_filter = StructNew()>

<cfinvoke component="#application.components.cmp_tasks#" method="GetTasks" returnvariable="stReturn">
  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
  <cfinvokeargument name="search" value="#url.search#">
  <cfinvokeargument name="orderby" value="#sOrderBy#">
  <cfinvokeargument name="orderbydesc" value="#(a_str_sort is 'DESC')#">
  <cfinvokeargument name="loadnotice" value="false">
  <cfinvokeargument name="filter" value="#a_struct_filter#">
</cfinvoke>

<cfset q_select_tasks = stReturn.q_select_tasks>
<cfset a_struct_distinct_categories = stReturn.struct_categories>

<!--- select distinct assigned to userkeys ... --->
<cfset a_struct_assigned_to_userkeys = StructNew()>
<cfloop query="q_select_tasks">
	<cfif Len(q_select_tasks.assignedtouserkeys) GT 0>
		<cfloop list="#q_select_tasks.assignedtouserkeys#" index="a_str_userkey">
			<cfif NOT StructKeyExists(a_struct_assigned_to_userkeys, a_str_userkey)>
				<cfset a_struct_assigned_to_userkeys[a_str_userkey] = 1>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfset a_int_original_recordcount = q_select_tasks.recordcount>


<!--- do we need to create custom query? --->
<cfset a_bol_create_qoq = (len(a_str_filter_timeframe) gt 0) OR
						  (len(a_str_filter_category) GT 0) OR
						  (len(a_str_filter_workgroup) GT 0) OR
						  (len(a_str_filter_status) GT 0) OR
						  (len(a_str_filter_priority) GT 0) OR
						  (len(url.search) gt 0) OR
						  (Len(a_str_filter_assignedto_userkey) GT 0) OR
						  (Len(a_str_filter_projectkey) GT 0) />

<!--- do internal selecting now ... --->

<cfif a_bol_create_qoq>
	<!--- we need to create out own QPQ!! --->

	
	<cfquery name="q_select_tasks" dbtype="query">
	SELECT
		*
	FROM
		q_select_tasks
	WHERE
	
	<cfif Len(a_str_filter_projectkey) GT 0>
		<cfinvoke component="#request.a_str_component_project#" method="GetAssignedItemsmetaInformation" returnvariable="q_select_connected_items">
			<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			<cfinvokeargument name="projectkey" value="#a_str_filter_projectkey#">
		</cfinvoke> 
		
		<cfquery name="q_select_connected_tasks_meta_information" dbtype="query">
		SELECT
			objectkey
		FROM
			q_select_connected_items
		WHERE
			servicekey = '52230718-D5B0-0538-D2D90BB6450697D1'
		;
		</cfquery>
		
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#valueList(q_select_connected_tasks_meta_information.objectkey)#">)
		AND
	</cfif>
	
	<!--- filter on timeframe ... --->
	<cfif len(a_str_filter_timeframe) gt 0>
	
		<cfswitch expression="#a_str_filter_timeframe#">
			<cfcase value="today">
			
			<cfset a_int_dt_today = DateFormat(GetLocalTime(Now()), 'yyyymmdd')&'0000'>
			<cfset a_int_dt_tommorrow = DateFormat(DateAdd('d', 1, GetLocalTime(Now())), 'yyyymmdd')&'0000'>
			
			int_dt_due IS NOT NULL
			AND
			(int_dt_due >= #a_int_dt_today#)
			AND
			(int_dt_due <= #a_int_dt_tommorrow#)
			<!---	<cfset a_dt_tommorrow = DateAdd("d", 1, now())>
			
				(dt_due_simple IS NOT NULL)
				AND
				(dt_due_simple  IN ('#DateFormat(now(), "yyyy/mm/dd")#','#DateFormat(a_dt_tommorrow, "yyyy/mm/dd")#'))
			--->
			</cfcase>
	
			<cfcase value="month">
				<!--- check month ... --->
				<cfset a_dt_month_start = CreateDate(Year(now()), Month(Now()), 1)>
				<cfset a_dt_month_end = CreateDate(Year(now()), Month(Now()), DaysInMonth(Now()))>
				
				(int_dt_due IS NOT NULL)
				AND
				(int_dt_due >= #dateformat(a_dt_month_start, 'yyyymmdd')#0000)
				AND 
				(int_dt_due <= #dateformat(a_dt_month_end, 'yyyymmdd')#0000)				
			</cfcase>

			<cfcase value="overdue">
			
				<cfset a_str_int_today = DateFormat(now(), 'yyyymmdd')&TimeFormat(now(), 'HHmm')>
			    (int_dt_due IS NOT NULL)
				AND
				(int_dt_due > 0)
				AND
				(int_dt_due < #a_str_int_today#)
			</cfcase>
		<cfdefaultcase>
			<!--- default ... --->
			(1=1)
		</cfdefaultcase>	
		</cfswitch>
		
		AND
	</cfif>
	
	<!--- assigned to xy? --->
	<cfif Len(a_str_filter_assignedto_userkey) GT 0>
	
		<cfif a_str_filter_assignedto_userkey NEQ 'myself'>
		(assignedtouserkeys IS NOT NULL)
		AND
		(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#a_str_filter_assignedto_userkey#%">)
		AND
		<cfelse>
		
		(1=1)
		AND
		(
			(assignedtouserkeys = '')
			OR
			(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
		)
		AND
		</cfif>
	</cfif>
	
	<!--- filter the status ... --->
	<cfif len(a_str_filter_status) gt 0>
	
		(status IS NOT NULL)
		AND
	
		<cfswitch expression="#a_str_filter_status#">
			<cfcase value="done">
			(status = 0)	
			</cfcase>
			
			<cfcase value="inprogress">
			(status = 2)
			</cfcase>
			
			<cfcase value="open">
			(status IN (1,2,4))
			</cfcase>
			
			<cfcase value="deferred">
			(status = 3)
			</cfcase>
			
			<cfdefaultcase>
			(1=1)
			</cfdefaultcase>
		</cfswitch>	
	
	
		AND	
	</cfif>
	
	<!--- filter workgroup ... --->	
	<cfif len(a_str_filter_workgroup) gt 0>
		
		<cfif a_str_filter_workgroup is 'private'>
			(workgroupkeys IS NULL)
			
			AND
		<cfelse>
			<!--- STILL A BUG ... --->
			(workgroupkeys IS NOT NULL)
			
			AND
		
			<!---AND
			
			(workgroupkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#a_str_filter_workgroup#%">)
			
			AND--->
		</cfif>
			
		
	</cfif>
	
	<!--- category filter ... --->
	<cfif len(a_str_filter_category) gt 0>
		
		(categories IS NOT NULL)
		
		AND
		
		(categories LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#a_str_filter_category#%">)	
		
		AND
	</cfif>
	
	
	<!--- priority filter ... --->
	<cfif len(a_str_filter_priority) gt 0>
		(priority IS NOT NULL)
		
		<cfswitch expression="#a_str_filter_priority#">
			<cfcase value="high">
			AND (priority = 3)
			</cfcase>
			<cfcase value="low">
			AND (priority = 1)
			</cfcase>
		</cfswitch>
		
		AND
	</cfif>
		<!--- dummy filter (so that the query is working --->
		(1=1)
	;
	</cfquery>

</cfif>

<cfif url.startrow gt q_select_tasks.recordcount>
	<cfset url.startrow = 1>
</cfif>


<!--- display preferences ... --->
<table border="0" cellspacing="8" cellpadding="0">
  <tr> 
    <td valign="top" class="b_all">
	
		<table class="table table-hover">
        <tr> 
          <td colspan="2" style="padding:3px;"><b><cfoutput>#si_img('calendar')# #GetLangVal('task_wd_due')#</cfoutput></b></td>
        </tr>
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_timeframe, 'overdue')#</cfoutput>> 
          <td>
		  <input onClick="ChangeFilterTimeframe('overdue');" value="overdue" <cfoutput>#writecheckedelement(a_str_filter_timeframe, 'overdue')#</cfoutput>  type="radio" name="frmradiotimeframe" class="noborder"> 
          </td>
          <td>
		  	<cfoutput>#GetLangVal('tsk_wd_view_overdue')#</cfoutput>
		  </td>
        </tr>		
        <tr> 
          <td>
		  <input onClick="ChangeFilterTimeframe('');" <cfoutput>#writecheckedelement(a_str_filter_timeframe, '')#</cfoutput> type="radio" name="frmradiotimeframe" class="noborder" value=""> 
          </td>
          <td>
		  	<cfoutput>#GetLangVal('cm_wd_all')#</cfoutput>
		  </td>
        </tr>
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_timeframe, 'today')#</cfoutput>> 
          <td>
		  <input onClick="ChangeFilterTimeframe('today');" value="today" type="radio" <cfoutput>#writecheckedelement(a_str_filter_timeframe, 'today')#</cfoutput> name="frmradiotimeframe" class="noborder"> 
          </td>
          <td><cfoutput>#GetLangVal('tsk_ph_due_today_tommorrow')#</cfoutput></td>
        </tr>
        <!---<tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_timeframe, 'week')#</cfoutput>> 
          <td>
		  <input onClick="ChangeFilterTimeframe('week');" value="week" <cfoutput>#writecheckedelement(a_str_filter_timeframe, 'week')#</cfoutput>  type="radio" name="frmradiotimeframe" class="noborder"> 
          </td>
          <td>diese Woche</td>
        </tr>--->
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_timeframe, 'month')#</cfoutput>> 
          <td>
		  <input onClick="ChangeFilterTimeframe('month');" value="month" <cfoutput>#writecheckedelement(a_str_filter_timeframe, 'month')#</cfoutput>  type="radio" name="frmradiotimeframe" class="noborder"> 
          </td>
          <td><cfoutput>#GetLangVal('tsk_ph_due_this_month')#</cfoutput></td>
        </tr>
      </table>
	  
	</td>
    <td valign="top" class="b_all">
		
		<table class="table table-hover">
        <tr> 
          <td colspan="2" style="padding:3px;"><b><cfoutput>#si_img('clock')# #GetLangVal('cm_wd_status')#</cfoutput></b></td>
        </tr>
        <tr> 
          <td>
		  <input type="radio" <cfoutput>#writecheckedelement(a_str_filter_status, '')#</cfoutput> onClick="ChangeFilterStatus('');" name="frmradiostatus" class="noborder" value=""> 
          </td>
          <td><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></td>
        </tr>
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_status, 'open')#</cfoutput>> 
          <td>
		  <input  type="radio" <cfoutput>#writecheckedelement(a_str_filter_status, 'open')#</cfoutput> onClick="ChangeFilterStatus('open');" name="frmradiostatus" class="noborder" value="open"> 
          </td>
          <td><cfoutput>#GetLangVal('tsk_ph_status_open')#</cfoutput></td>
        </tr>
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_status, 'inprogress')#</cfoutput>> 
          <td>
		  <input type="radio" <cfoutput>#writecheckedelement(a_str_filter_status, 'inprogress')#</cfoutput> onClick="ChangeFilterStatus('inprogress');" name="frmradiostatus" class="noborder" value="inprogress"> 
          </td>
          <td><cfoutput>#GetLangVal('tsk_ph_status_inprogress')#</cfoutput></td>
        </tr>		
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_status, 'deferred')#</cfoutput>> 
          <td>
		  <input <cfoutput>#writecheckedelement(a_str_filter_status, 'deferred')#</cfoutput> onClick="ChangeFilterStatus('deferred');" type="radio" name="frmradiostatus" class="noborder" value="deferred"> 
          </td>
          <td><cfoutput>#GetLangVal('tsk_wd_status_deferred')#</cfoutput></td>
        </tr>
        <tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_status, 'done')#</cfoutput>> 
          <td>
		  <input <cfoutput>#writecheckedelement(a_str_filter_status, 'done')#</cfoutput> onClick="ChangeFilterStatus('done');" type="radio" name="frmradiostatus" class="noborder" value="done"> 
          </td>
          <td><cfoutput>#GetLangVal('tsk_wd_done')#</cfoutput></td>
        </tr>
      </table>
	  
	  </td>
	  
    <td valign="top" class="b_all">
		
		<table class="table table-hover">
        <tr> 
          <td colspan="2" style="padding:3px;"><b><cfoutput>#si_img('user')# #GetLangVal('cm_wd_concerned')#</cfoutput></b></td>
        </tr>
        <td>&nbsp;</td>
        <td style="padding:5px;">
		   <select name="frmselect" size="6" onChange="ChangeAssignedtoFilter(this.value);">
            <option <cfif len(a_str_filter_assignedto_userkey) is 0>selected</cfif> value=""><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></option>
				<option value="myself" <cfoutput>#writeselectedelement(a_str_filter_assignedto_userkey, 'myself')#</cfoutput> ><cfoutput>#GetLangVal('tsk_wd_concerned_myself')#</cfoutput></option>
			<cfloop list="#StructKeyList(a_struct_assigned_to_userkeys)#" index="a_str_userkey">
				
				<!--- load username --->
				<cfset a_str_username = ShortenString(application.components.cmp_user.GetUsernamebyentrykey(a_str_userkey), 17)>
			
				<cfif Len(a_str_username) GT 0>
					<option <cfoutput>#writeselectedelement(a_str_userkey, a_str_filter_assignedto_userkey)#</cfoutput> value="<cfoutput>#a_str_userkey#</cfoutput>"><cfoutput>#htmleditformat(a_str_username)#</cfoutput></option>
				</cfif>
				
			</cfloop>
          </select>
		  </td>
        </tr>
      </table>
	
	</td>
		
    <td valign="top" class="b_all"> 
	
		<table class="table table-hover">
        <tr> 
          <td colspan="2" style="padding:3px;"><b><cfoutput><span class="glyphicon glyphicon-exclamation-sign"></span> #GetLangVal('cm_wd_priority')#</cfoutput></b></td>
        </tr>
        <tr> 
          <td>
		  
		  <table border="0" cellspacing="0" cellpadding="1">

			<tr> 
			  <td>
			  <input onClick="ChangeFilterPriority('');" type="radio" <cfoutput>#WriteCheckedElement(a_str_filter_priority, '')#</cfoutput> name="frmradiopriority" value="" class="noborder">
			  </td>
			  <td><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></td>
			</tr>
			<tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_priority, 'high')#</cfoutput>> 
			  <td>
			  <input  onClick="ChangeFilterPriority('high');" type="radio" <cfoutput>#WriteCheckedElement(a_str_filter_priority, 'high')#</cfoutput> name="frmradiopriority" class="noborder" value="high"> 
			  </td>
			  <td><cfoutput>#GetLangVal('cm_wd_priority_high')#</cfoutput></td>
			</tr>
			<tr <cfoutput>#WriteBackgroundHighlight(a_str_filter_priority, 'low')#</cfoutput>> 
			  <td>
			  <input onClick="ChangeFilterPriority('low');" type="radio" <cfoutput>#WriteCheckedElement(a_str_filter_priority, 'low')#</cfoutput> name="frmradiopriority" class="noborder" value="low"> 
			  </td>
			  <td><cfoutput>#GetLangVal('cm_wd_priority_low')#</cfoutput></td>
			</tr>
		  </table>
		  
		  
		  </td>
        </tr>
      </table>
	
	</td>
    <td valign="top" class="b_all">
	
		<!--- display distinct categories ... --->
		<table class="table table-hover">
        <tr> 
          <td colspan="2" style="padding:3px;"><b><cfoutput>#si_img('tag_blue')# #GetLangVal('cm_wd_categories')#</cfoutput></b></td>
        </tr>
        <tr> 
          <td style="padding:5px;">
		  	<select name="frmcategories" size="6" onChange="ChangeFilterCategory(this.value);">
				<!--- load distinct categories ... --->
				<option <cfif len(a_str_filter_category) is 0>selected</cfif> value=""><cfoutput>#GetLangVal('cm_wd_all')#</cfoutput></option>
              
			  	<cfloop list="#StructKeyList(a_struct_distinct_categories)#" delimiters="," index="a_str_category">
				<cfoutput><option #writeselectedelement(a_str_filter_category, a_str_category)# value="#htmleditformat(a_str_category)#">#htmleditformat(shortenstring(a_str_category, 17))#</option></cfoutput>
				</cfloop>
            </select> </td>
        </tr>
      </table>
	</td>
	<td valign="top" class="b_all">
		
		<!--- search ... --->
		<table class="table table-hover">
        <tr> 
          <td colspan="2" style="padding:3px;"><b><cfoutput>#si_img('magnifier')# #GetLangVal('cm_Wd_search')#</cfoutput></b></td>
        </tr>
        <tr> 
          <td style="padding:5px;">
		  		<form action="#" onSubmit="DoSearch();return false;" name="formsearch" style="margin:0px;">
	
			<input value="<cfoutput>#htmleditformat(url.search)#</cfoutput>" type="text" name="frmsearch" size="10" />
			<br /><br />
			<input type="submit" name="frmsubmit" value="Start" class="btn" />
		
			</form>
			</td>
        </tr>
      </table>

	</td>
  </tr>
  
 <!---  <cfif a_bol_create_qoq>
  <tr>
  	<td colspan="3" style="spacing:0px;">
	
	<!--- show percentage of applying objects ... --->
	<img src="/images/si/information.png" class="si_img" /> <b><cfoutput>#GetLangVal('tsk_ph_filter_search_active')#</cfoutput></b>
	
	
	</td>
  	<td colspan="2" align="right" style="spacing:0px;">
	<!--- generate default url ... --->
	<a href="index.cfm?filterstatus=open&filtercategory=&filterworkgroup=&filtertimeframe=&filterpriority=&filterprojectkey="><cfoutput>#GetLangVal('tsk_ph_reset_all_filter')#</cfoutput></a>
	</td>
  </tr>
  </cfif> --->
</table>



	

<form action="act_multi_edit.cfm" method="post">
<!--- output now ... --->
<table class="table table-hover">
<cfif len(url.search) gt 0 AND q_select_tasks.recordcount is 0>
<tr>
	<td colspan="8" style="padding:10px;" align="center">
	
	<span class="glyphicon glyphicon-exclamation-sign"></span>&nbsp;<b><cfoutput>#GetLangVal('tsk_ph_search_no_hits')#</cfoutput></b>
	<br><br>
	<a href="index.cfm"><cfoutput>#GetLangVal('cm_wd_back')#</cfoutput></a>
	</td>
</tr>
</table>
<cfexit method="exittemplate">
</cfif>

<cfif a_bol_create_qoq is true AND q_select_tasks.recordcount is 0>
<tr>
	<td colspan="8" style="padding:10px;" align="center">
	
	<span class="glyphicon glyphicon-exclamation-sign"></span>&nbsp;<b><cfoutput>#GetLangVal('tsk_ph_filter_no_hits_1')#</cfoutput></b>
	<br><br>
	<cfoutput>#GetLangVal('tsk_ph_filter_no_hits_2')#</cfoutput>
	<br><br>
	<a href="index.cfm?filterstatus=open&filtercategory=&filterworkgroup=&filtertimeframe=&filterpriority=&filterprojectkey="><cfoutput>#GetLangVal('tsk_ph_reset_all_filter')#</cfoutput></a>	
	</td>
</tr>
</table>
<cfexit method="exittemplate">
</cfif>

  
  <tr>
  	<td colspan="8" align="center" class="bb">
	
	<cfinvoke component="#application.components.cmp_tools#" method="GeneratePageScroller" returnvariable="a_str_page_scroller">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="current_url" value="#cgi.QUERY_STRING#">
		<cfinvokeargument name="url_tag_name" value="startrow">
		<cfinvokeargument name="step" value="#a_int_displayitemsperpage#">
		<cfinvokeargument name="recordcount" value="#q_select_tasks.recordcount#">
		<cfinvokeargument name="current_record" value="#url.startrow#">
	</cfinvoke>
	
	<cfoutput>#a_str_page_scroller#</cfoutput>

	</td>
  </tr>

  <tr class="tbl_overview_header">
  
    <td>&nbsp;</td>
    <td>
		<a <cfif CompareNoCase(sOrderBy, "title") is 0>style="font-weight:bold;"</cfif> href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "order", "title")##a_str_url_sort#</cfoutput>"><cfoutput>#GetLangVal("tsk_wd_subject")#</cfoutput></a>
	</td>
    <td>
		<a <cfif CompareNoCase(sOrderBy, "dt_due") is 0>style="font-weight:bold;"</cfif> href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "order", "dt_due")##a_str_url_sort#</cfoutput>"><cfoutput>#GetLangVal("tsk_ph_due_to")#</cfoutput></a>
	</td>
	<td>
		<cfoutput>#GetLangVal("cm_wd_categories")#</cfoutput>
	</td>
    <td>
		<cfoutput>#GetLangVal("cm_wd_concerned")#</cfoutput>
	</td>	
	<td>
		<a <cfif CompareNoCase(sOrderBy, "dt_lastmodified") is 0>style="font-weight:bold;"</cfif> href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "order", "dt_lastmodified")##a_str_url_sort#</cfoutput>"><cfoutput>#GetLangVal("tsk_wd_modified")#</cfoutput></a>
	</td>
	<td>
		<cfoutput>#GetLangVal("cm_wd_action")#</cfoutput>
	</td>
  </tr>  

  <cfoutput query="q_select_tasks" startrow="#url.startrow#" maxrows="#a_int_displayitemsperpage#">

  <tr <cfif Compare(q_select_tasks.priority, 3) IS 0>style="background-color:##FBDEC4;"</cfif>>
  	<td>
		<input class="noborder" type="Checkbox" name="frmcbtasks" value="#htmleditformat(q_select_tasks.entrykey)#" />
	</td>
    <td>
	<a <cfif Compare(q_select_tasks.status, 0) is 0>class="statusdone"</cfif> <cfif isdate(q_select_tasks.dt_due) and (now() gt q_select_tasks.dt_due and q_select_tasks.status neq 0)>class="statusurg"</cfif> href="index.cfm?action=ShowTask&entrykey=#urlencodedformat(q_select_tasks.entrykey)#" class="simplelink">#shortenstring(CheckZeroString(q_select_tasks.title), 50)#</a>

	<cfif isDate(q_select_tasks.dt_lastmodified) AND DateDiff("d", q_select_tasks.dt_lastmodified, now()) LTE 2>
		<img src="/images/si/new.png" class="si_img" />
	</cfif>

	</td>
    <td>
	<cfif q_select_tasks.priority is 3>
		<!--- high --->
		<span class="glyphicon glyphicon-exclamation-sign"></span>
	</cfif>

	<cfif len(q_select_tasks.dt_due) gt 0>
		<a href="/calendar/index.cfm?action=ViewDay&Date=#urlencodedformat(dateformat(q_select_tasks.dt_due, "mm/dd/yyyy"))#">#lsdateformat(q_select_tasks.dt_due, "ddd, dd.mm.")#</a>
	<cfelse>
		n/a
	</cfif>

	</td>
	<td>
	#shortenstring(q_select_tasks.categories, 15)#
	</td>
	<td>
	
	<cfif len(q_select_tasks.workgroupkeys) GT 0>
		
		<cfset a_int_groups_count = 0>
	
		<cfloop list="#q_select_tasks.workgroupkeys#"index="a_str_workgroupkey">
		
			<cfif StructKeyExists(request.stSecurityContext.a_struct_workgroups, a_str_workgroupkey)>
			
				<cfset a_int_groups_count = a_int_groups_count + 1>
				<a href="index.cfm?action=ShowTasks&filterworkgroup=#urlencodedformat(a_str_workgroupkey)#">#htmleditformat(request.stSecurityContext.a_struct_workgroups[a_str_workgroupkey])#</a>&nbsp;
			</cfif>
			
			<cfif a_int_groups_count gte 3>
				... <cfbreak>
			</cfif>
			
		</cfloop>
		
	</cfif>

	<cfif len(q_select_tasks.projectkey) gt 0>

	</cfif>
	
	<cfif Len(q_select_tasks.assignedtouserkeys) GT 0>
		<cfloop list="#q_select_tasks.assignedtouserkeys#" index="a_str_userkey">
			<cfinvoke component="#application.components.cmp_user#" method="GetUsernamebyentrykey" returnvariable="a_str_username">
				<cfinvokeargument name="entrykey" value="#a_str_userkey#">
			</cfinvoke>
			
			#GetUsernameFromEmailAddress(a_str_username)#
		</cfloop>
	</cfif>
	&nbsp;
	</td>
	<td nowrap class="addinfotext">
	#dateformat(q_select_tasks.dt_lastmodified, "dd.mm.yy")#
	</td>
    <td nowrap>
	<a href="act_set_new_status.cfm?entrykey=#urlencodedformat(q_select_tasks.entrykey)#&status=0"><img src="/images/si/accept.png" alt="Done" width="16" height="16" hspace="0" vspace="0" border="0" align="absmiddle" /></a>
	&nbsp;
	<a href="index.cfm?action=EditTask&entrykey=#urlencodedformat(q_select_tasks.entrykey)#"><img src="/images/si/pencil.png" alt="Edit" width="16" height="16" hspace="0" vspace="0" border="0" align="absmiddle" /></a>
	&nbsp;
	<a target="_self" href="javascript:DeleteTask('#jsstringformat(q_select_tasks.entrykey)#');"><img src="/images/si/delete.png" alt="Delete" width="16" height="16" hspace="0" vspace="0" border="0" align="absmiddle" /></a>
	</td>
  </tr>

  </cfoutput>
  
  <tr>
  	<td colspan="8" align="center" class="bb">
		<cfoutput>#a_str_page_scroller#</cfoutput>
	</td>
  </tr>
<tr>
	<td colspan="6" class="mischeader bb" style="padding:4px;">
	<cfoutput>#GetLangVal('cm_ph_selected_items')#</cfoutput> ... 
	<input onClick="return confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>');" type="submit" name="frmsubmitdelete" value="<cfoutput>#GetLangVal('cm_wd_delete')#</cfoutput>" class="btn" />
	&nbsp;&nbsp;&nbsp;
	<cfoutput>#GetLangVal('tsk_ph_set_status_to')#</cfoutput>
		<select name="frmsetstatus">
			<option value="done"><cfoutput>#GetLangVal('tsk_wd_done')#</cfoutput></option>
			<option value="open"><cfoutput>#GetLangVal('tsk_ph_status_open')#</cfoutput></option>
		</select>
	<input type="submit" name="frmsubmitsetstatus" value="<cfoutput>#GetLangVal('tsk_wd_set')#</cfoutput>" class="btn" />
	&nbsp;&nbsp;&nbsp;
	<input type="submit" name="frmprintversion" value="<cfoutput>#GetLangVal('cm_ph_printversion')#</cfoutput>" class="btn" />
	</td>
	<td colspan="2">
	</td>
</tr>
</form>
</table>
<div style="padding:4px;">
<img class="si_img" src="/images/si/new.png" /> = <cfoutput>#GetLangVal('tsk_ph_hint_added_within_last_24h')#</cfoutput>
</div>
<cfset sReturn = urlencodedformat(cgi.SCRIPT_NAME&'?'&cgi.QUERY_STRING)>

<script type="text/javascript">
	function DeleteTask(entrykey)
		{
		if (confirm('<cfoutput>#GetLangValJS('cm_ph_are_you_sure')#</cfoutput>') == true)
			{
			DisplayStatusInformation('<cfoutput>#GetLangValJS('tsk_ph_status_deleting')#</cfoutput>');
			location.href = 'act_delete_task.cfm?entrykey='+escape(entrykey)+'&return=<cfoutput>#sReturn#</cfoutput>';
			}
		}
</script>

