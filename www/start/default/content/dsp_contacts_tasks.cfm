<cfsavecontent variable="a_str_content">
<table border="0" cellspacing="0" cellpadding="4" width="100%">
  <tr>
    <td width="50%" valign="top">
	
	<cfset a_struct_load_options = StructNew()>
	<cfset a_struct_load_options.loadworkgroupmetainformation = false>
	<cfset a_struct_load_options.maxrows = 5>
	
	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
		<cfinvokeargument name="loaddistinctcategories" value="false">
		<cfinvokeargument name="loadoptions" value="#a_struct_load_options#">
		<cfinvokeargument name="orderby" value="surname">
	</cfinvoke>

	<cfset q_select_contacts = stReturn.q_select_contacts>	

		<ul class="ul_nopoints">
		  <cfoutput query="q_select_contacts">
			<li>
			<img src="/images/si/vcard.png" class="si_img" alt="" />
			
			<a href="/addressbook/?action=ShowItem&entrykey=#urlencodedformat(q_select_contacts.entrykey)#">#htmleditformat(q_select_contacts.surname)#, #htmleditformat(q_select_contacts.firstname)#
			
			<cfif Len(q_select_contacts.company) GT 0>
				(#htmleditformat(shortenstring(q_select_contacts.company, 30))#)
			</cfif>
			
			</a>
			
			</li>
		  </cfoutput>
		 </ul>			
	
	</td>

    <td width="50%" valign="top">
	
	
			<cfset a_struct_filter = StructNew()>
			<cfset a_struct_filter.statusexclude = 0>
			<cfset a_struct_filter.excludenoduedateitems = true>
			
			<cfinvoke component="#application.components.cmp_tasks#" method="GetTasks" returnvariable="stReturn">
			  <cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
			  <cfinvokeargument name="usersettings" value="#request.stUserSettings#">
			  <cfinvokeargument name="filter" value="#a_struct_filter#">
			  <cfinvokeargument name="loadnotice" value="false">
			</cfinvoke>
			
			<cfset a_int_dt_today = DateFormat(GetLocalTime(Now()), 'yyyymmdd')&'0000'>
			<cfset a_int_dt_tommorrow = DateFormat(DateAdd('d', 1, GetLocalTime(Now())), 'yyyymmdd')&'0000'>
			
			<cfquery name="q_select_tasks" dbtype="query">
			SELECT
				*
			FROM
				stReturn.q_select_tasks
			WHERE
				(
					(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">)
					OR
					(assignedtouserkeys LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#request.stSecurityContext.myuserkey#%">)
				)	
			ORDER BY
				int_dt_due
			;
			</cfquery>
			
			<cfif q_select_tasks.recordcount IS 0>
				<cfoutput>#GetLangVal('tsk_ph_no_due_tasks_found')#</cfoutput>
			<cfelse>
			
				<table class="table_details">
				<tr>
					<td colspan="2">
						<cfoutput>
						#GetLangVal('tsk_ph_due_tasks')# (#q_select_tasks.recordcount#)
						</cfoutput>
					</td>
				</tr>	
				<cfoutput query="q_select_tasks" startrow="1" maxrows="10">
					<tr>
						<td style="width:66%; ">
							<a href="/tasks/?action=ShowTask&entrykey=#q_select_tasks.entrykey#">#htmleditformat(CheckZerostring(q_select_tasks.title))#</a>
							
							<cfif val(q_select_tasks.percentdone) GT 0>
								(#q_select_tasks.percentdone# %)
							</cfif>
						</td>
						<td style="width:33%<cfif q_select_tasks.status GT 0 AND IsDate(q_select_tasks.dt_due) AND q_select_tasks.dt_due LTE Now()>;color:##CC0000;</cfif>">
							<cfif IsDate(q_select_tasks.dt_due)>
								#LsDateFormat(q_select_tasks.dt_due, 'dd.mm.yy')#
							<cfelse>
								&nbsp;
							</cfif>		
						</td>
					</tr>
				</cfoutput>	
				<cfif q_select_tasks.recordcount GT 10>
				<tr>
					<td colspan="2">
						<a href="/tasks/"><cfoutput>#GetLangVal('crm_ph_show_further_tasks')#</cfoutput></a>
					</td>
				</tr>	
				</cfif>	
				</table>
				
			</cfif>
	
	</td>
  </tr>
</table>	
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_contacts') & '/' & GetLangVal('cm_wd_tasks'), '', a_str_content)#</cfoutput>