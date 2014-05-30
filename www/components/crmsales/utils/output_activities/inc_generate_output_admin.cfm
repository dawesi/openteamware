<cfquery name="q_select_history" datasource="#request.a_str_db_log#">
SELECT
	editedfields,usercomment,
	new_data_wddx,old_data_wddx,
	userkey,datakey,dt_edited
FROM
	editeddata
WHERE
	datakey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykeys#">
	AND
	LENGTH(editedfields) > 0
	AND NOT
	(editedfields = 'dt_lastcontact')
ORDER BY
	dt_edited DESC
;
</cfquery>

<cfset a_cmp_users = application.components.cmp_user>


<cfsavecontent variable="a_str_content">
<table class="table table-hover" cellspacing="0">
	<tr class="tbl_overview_header">
		<td>date</td>
		<td>user</td>
		<td>field</td>
		<td>new</td>
		<td>old</td>
	</tr>
	
	<cfoutput query="q_select_history">
	
	<cfset a_str_new_wddx = q_select_history.new_data_wddx>
	<cfset a_str_old_wddx = q_select_history.old_data_wddx>
	
	<cfwddx action="wddx2cfml" input="#a_str_new_wddx#" output="q_select_new">
	<cfwddx action="wddx2cfml" input="#a_str_old_wddx#" output="q_select_old">
		
		<tr>
			<td>
				#LsDateFormat(q_select_history.dt_edited, request.stUserSettings.default_dateformat)#
				#TimeFormat(q_select_history.dt_edited, request.stUserSettings.default_timeformat)#
			</td>
			<td>
				#a_cmp_users.getusernamebyentrykey(q_select_history.userkey)#
			</td>
			
			<cfloop list="#q_select_history.editedfields#" index="a_str_col_name">
				<td>
					#htmleditformat(lcase(a_str_col_name))#
				</td>
				<td>			
					#htmleditformat(q_select_new[a_str_col_name])#
				</td>
				<td class="addinfotext">
					#htmleditformat(q_select_old[a_str_col_name])#
				</td>
			
			<cfif a_str_col_name NEQ ListLast(q_select_history.editedfields, a_str_col_name) AND a_str_col_name NEQ ListFirst(q_select_history.editedfields, a_str_col_name)>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
			</cfif>
			</cfloop>
				
		</tr>
	</cfoutput>
</table>
</cfsavecontent>

<cfset stReturn.recordcount = q_select_history.recordcount>
<cfset stReturn.output = a_str_content>