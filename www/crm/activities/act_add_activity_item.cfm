

<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfinvoke
			component = "#request.a_str_component_database#"   
			method = "SaveTableData"   
			returnVariable = "a_struct_info"   
			securitycontext="#request.stSecurityContext#"
			usersettings="#request.stUserSettings#"
			table_entrykey="#a_struct_crmsales_bindings.ACTIVITIES_TABLEKEY#"
			record_entrykey="#form.FRMRECORD_ENTRYKEY#"
			record_data="#form#">
</cfinvoke>