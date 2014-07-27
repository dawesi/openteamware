<!---
	TODO hp: this should be done as dsp_inc_show_select_addressbook
--->    
<!--- //

	Module:		Calendar
	Action:		AssignNewElementToAppointment
	Description:Select employees to assign to an appointment
	

// --->

<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_company_user">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<!--- select all users except the user itself ... --->
<cfquery name="q_select_company_user" dbtype="query">
SELECT
	*
FROM
	q_select_company_user
WHERE
	NOT entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>

<table class="table table-hover">
	<tr class="tbl_overview_header">
		<td>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
		</td>
	</tr>
<cfoutput query="q_select_company_user">
<tr>
	<td>
		<input <cfif ListFindNoCase(a_str_assigned_entrykeys, q_select_company_user.entrykey) GT 0>checked</cfif> type="checkbox" name="assigned_elements" value="#q_select_company_user.entrykey#" />
	</td>
	<td>
		#si_img('user')# #htmleditformat(q_select_company_user.username)#
	</td>
</tr>	
</cfoutput>
</table>

