<cfset a_arr_filter_search = ArrayNew(1)>


<cfloop from="1" to="#ArrayLen(arguments.crmfilter.crm)#" index="ii">

	<cfset a_arr_filter_search[ii] = StructNew()>
	<cfset a_arr_filter_search[ii].fieldname = arguments.crmfilter.crm[ii].internalfieldname>
	<cfset a_arr_filter_search[ii].op = application.components.cmp_own_db.GetODBOperatorFromCRMFilter(arguments.crmfilter.crm[ii].operator)>
	<cfset a_arr_filter_search[ii].value = arguments.crmfilter.crm[ii].comparevalue>
	<cfset a_arr_filter_search[ii].cfqueryparam = GetCFDataTypeFromInternalType(arguments.crmfilter.crm[ii].internaldatatype)>
	<cfset a_arr_filter_search[ii].andor = application.components.cmp_own_db.GetODBConnectorFromCRMFilter(arguments.crmfilter.crm[ii].connector)>
	<cfset a_arr_filter_search[ii].internaldatatype = arguments.crmfilter.crm[ii].internaldatatype>
	
</cfloop>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<!--- load table info ... --->
<cfinvoke component="#application.components.cmp_own_db#" method="GetTableFields" returnvariable="q_select_table_fields">
	<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
	<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
	<cfinvokeargument name="table_entrykey" value="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#">
</cfinvoke>

<cfquery name="q_select_addressbookkey_fieldname" dbtype="query">
SELECT
	fieldname
FROM
	q_select_table_fields
WHERE
	showname = 'addressbookkey'
;
</cfquery>


<cfinvoke
		component = "#application.components.cmp_own_db#"   
		method = "GetTableData"   
		returnVariable = "a_struct_tabledata"   
		securitycontext="#arguments.securitycontext#"
		usersettings="#arguments.usersettings#"
		table_entrykey="#a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY#"
		filterfieldname=""
		filtervalue=""
		orderbyFilterValues=""		
		searchfilter="#a_arr_filter_search#"
		fieldnames = "#q_select_addressbookkey_fieldname.fieldname#"
		calc_dt_created_int = false
		options = "ignoreorderby">
</cfinvoke>

<cfset a_str_crm_filter_entrykeys_database = ArrayToList(a_struct_tabledata.ORIGQUERY[q_select_addressbookkey_fieldname.fieldname])>

<!---<cfloop query="a_struct_tabledata.ORIGQUERY">
	<cfset a_str_crm_filter_entrykeys = ListAppend(a_str_crm_filter_entrykeys, a_struct_tabledata.ORIGQUERY[q_select_addressbookkey_fieldname.fieldname][a_struct_tabledata.ORIGQUERY.currentrow])>
</cfloop>--->