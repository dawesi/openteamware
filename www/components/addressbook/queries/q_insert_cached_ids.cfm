<cfset a_str_data_1 = ''>
<cfset a_str_data_2 = ''>

<!--- workgroup information ... --->
<cfwddx action="cfml2wddx" input="#stWGInfo#" output="a_str_data_1">

<!--- use hash version of params ... --->
<cfset a_str_debug_params = a_str_param_string>
<cfset a_str_param_string = Hash(a_str_param_string)>

<cfset a_str_list_with_ids_to_save = valuelist(q_select_ids_sorted.id)>

<!--- categories ... --->
<cfwddx action="cfml2wddx" input="#a_struct_categories#" output="a_str_data_2">

<cfquery name="q_delete_cached_ids">
DELETE FROM
	cached_ids
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sServiceKey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	parameters = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_param_string#">
;
</cfquery>

<cfquery name="q_insert_cached_ids">
INSERT INTO
	cached_ids
	(
	servicekey,
	userkey,
	parameters,
	ids,
	data1,
	data2,
	dt_created,
	debug_params,
	companykey,
	items_count
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sServiceKey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_param_string#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_list_with_ids_to_save#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_data_1#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_data_2#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCdatetime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_debug_params#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#ListLen(a_str_list_with_ids_to_save)#">
	)
;
</cfquery>