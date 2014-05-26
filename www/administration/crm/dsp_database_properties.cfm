<!--- //

	Module:		Edit CRMSales properties
	Description: 
	
// --->

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<!--- if no binding exists, forward to set binding page ... --->
<cfif Len(a_struct_crmsales_bindings.databasekey) IS 0>
	<cflocation addtoken="no" url="index.cfm?action=crm&subaction=bindDatabase#writeurltags()#&reason=empty_databasekey">
</cfif>

<!--- load databases of company --->

<cfset q_select_databases = CreateObject('component', request.a_str_component_database).GetDatabasesCreatedByAdmins(companykey = url.companykey)>

<cfquery name="q_select_crm_db_name" dbtype="query">
SELECT
	name,userid AS userkey
FROM
	q_select_databases
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_crmsales_bindings.databasekey#">
;
</cfquery>

<cfif q_select_crm_db_name.recordcount IS 0>
	<h1>Invalid. Please contact feedback@openTeamWare.com</h1>
	<cfexit method="exittemplate">
</cfif>

<!--- load tables of this database ... use the securitycontext of the database owner ... --->
<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_securitycontext">
	<cfinvokeargument name="userkey" value="#q_select_crm_db_name.userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stReturn_usersettings">
	<cfinvokeargument name="userkey" value="#q_select_crm_db_name.userkey#">
</cfinvoke>

<cfinvoke component="#request.a_str_component_database#" method="ListTables" returnvariable="q_select_tables">
	<cfinvokeargument name="securitycontext" value="#stReturn_securitycontext#">
	<cfinvokeargument name="usersettings" value="#stReturn_usersettings#">
	<cfinvokeargument name="database_entrykey" value="#a_struct_crmsales_bindings.databasekey#">
</cfinvoke>

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="../queries/q_select_company_users.cfm">

<br>

<fieldset class="default_fieldset">
	<legend>Datenbank Eigenschaften</legend>
	
	<div>
		<form action="crm/act_save_table_mappings.cfm" style="margin:0px; " method="post">
		<input type="hidden" name="frmdatabasekey" value="<cfoutput>#a_struct_crmsales_bindings.databasekey#</cfoutput>">
		<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
		<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
		<table border="0" cellspacing="0" cellpadding="6">
		  <tr>
			<td align="right">
				<cfoutput>#GetLangVal('cm_wd_database')#</cfoutput>:
			</td>
			<td>
				<b><cfoutput>#q_select_crm_db_name.name#</cfoutput></b>
				&nbsp;&nbsp;
				<a href="index.cfm?action=crm&subaction=bindDatabase<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#si_img('pencil')# #GetLangVal('cm_wd_edit')#</cfoutput></a>
			</td>
		  </tr>
		  <tr>
			<td align="right">
				Additional data:
			</td>
			<td>
				<select name="frm_additional_data">
					<option value=""><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
					<cfoutput query="q_select_tables">
						<option #writeselectedelement(q_select_tables.entrykey, a_struct_crmsales_bindings.additionaldata_tablekey)# value="#q_select_tables.entrykey#">#q_select_tables.tablename#</option>
					</cfoutput>
				</select>
			</td>
		  </tr>
		  <!--- <tr>
			<td align="right">
				Activities:
			</td>
			<td>
				<select name="frm_activities">
					<option value=""><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
					<cfoutput query="q_select_tables">
						<option #writeselectedelement(q_select_tables.entrykey, a_struct_crmsales_bindings.activities_tablekey)# value="#q_select_tables.entrykey#">#q_select_tables.tablename#</option>
					</cfoutput>
				</select>
			</td>
		  </tr>	 --->
		  
		  <cfif Len(a_struct_crmsales_bindings.additionaldata_tablekey)>
		  
		  <cfinvoke
					component = "#request.a_str_component_database#"   
					method = "GetTableFields"   
					returnVariable = "q_table_fields"   
					securitycontext="#stReturn_securitycontext#"
					usersettings="#stReturn_usersettings#"
					table_entrykey="#a_struct_crmsales_bindings.additionaldata_tablekey#"
					 >
			</cfinvoke>
			
			<cfinvoke component="#request.a_str_component_crm_sales#" method="GetVariousCRMSetting" returnvariable="a_str_setting_name">
				<cfinvokeargument name="companykey" value="#url.companykey#">
				<cfinvokeargument name="key" value="salutation_field">
			</cfinvoke>
		  <tr>
		  	<td align="right">
				Feld mit Anrede:
			</td>
			<td>
				<select name="frmsalutation_field">
					<option value="">keines</option>
					<cfoutput query="q_table_fields">
						<option #WriteSelectedElement(a_str_setting_name, q_table_fields.fieldname)# value="#q_table_fields.fieldname#">#q_table_fields.showname#</option>
					</cfoutput>
				</select>
			</td>
		  </tr>
		  </cfif>
		  <tr>
		  	<td align="right">
				User holding file data:
			</td>
			<td>
				<select name="frmuserkey_data">
					<option value="">select no user</option>
					<cfoutput query="q_select_company_users">
					<option #WriteSelectedElement(q_select_company_users.entrykey, a_struct_crmsales_bindings.userkey_data)# value="#q_select_company_users.entrykey#">#q_select_company_users.username#</option>
					</cfoutput>
				</select>
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>
				<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>">
			</td>
		  </tr>
		</table>
		</form>
		
	</div>
</fieldset>


