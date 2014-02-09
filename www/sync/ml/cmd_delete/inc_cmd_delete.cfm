<cfcontent type="text/xml"> 
<cfset request.a_struct_response_headers.type = 'text/xml'>
<cfheader statuscode="200">
<cfset request.a_struct_response_headers.statuscode = 200>

<!--- check if user wants to delete elements really --->
<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "delete_data_online"
	defaultvalue1 = "0"
	savesettings = true
	userid = #request.a_struct_security_context.myuserid#	
	setcallervariable1 = "a_int_delete_data_online">	


<cfif a_int_delete_data_online IS 0>
	<!--- use does NOT want that the data is really deleted.
	
		therefore add the data to a so called ignore list so that it is ignored on
		further sync processes --->
		
	<cfquery name="q_insert_ignore_items" datasource="#request.a_str_db_tools#">
	INSERT INTO
		mobilesync_deleted_items_ignore
		(
		dt_created,
		userkey,
		entrykey,
		itemtype
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_security_context.myuserkey#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_action.a_str_item_entry_key#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_action.a_str_itemtype#">
		)
	;
	</cfquery>
	
	<!--- exit the template! --->
	<cfexit method="exittemplate">
</cfif>

<cfset a_bool_result = false>

<!--- deleting contacts --->
<cfif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_contacts) IS 0>
	<cfset a_bool_result = request.a_ws_contacts.DeleteContact(entrykey = request.a_struct_action.a_str_item_entry_key,
				securitycontext = request.a_struct_security_context,
				usersettings = request.stUserSettings,
				clearoutlooksyncmetadata = true,
				sender = 'syncml')>

<!--- deleting calendar --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_calendar) IS 0>
	<cfset a_bool_result = request.a_ws_calendar.DeleteEvent(entrykey = request.a_struct_action.a_str_item_entry_key,
				securitycontext = request.a_struct_security_context,
				usersettings = request.stUserSettings,
				clearoutlooksyncmetadata = true)>

<!--- deleting tasks --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_tasks) IS 0>
	<cfset a_bool_result = request.a_ws_tasks.DeleteTask(entrykey = request.a_struct_action.a_str_item_entry_key,
				securitycontext = request.a_struct_security_context,
				usersettings = request.stUserSettings,
				clearoutlooksyncmetadata = true)>

<!--- deleting notes --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_notes) IS 0>
	<cfheader statuscode="404">
	<cfset request.a_struct_response_headers.statuscode = 404>
<cfelse>
	<cfthrow message="Invalid request" detail="Requested type '#request.a_struct_action.a_str_itemtype#' is not supported."/>
</cfif>


<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="mobilesync DELETE request" type="html">
	a_bool_result: #a_bool_result#
	
	<cfdump var="#request#" label="request">
	
	
</cfmail>