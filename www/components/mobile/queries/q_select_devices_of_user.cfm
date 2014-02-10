<cfif Len(a_str_virtual_usernames) GT 0>
	<cfset a_str_username = ListAppend(a_str_virtual_usernames, a_str_username)>
</cfif>

<cfquery name="q_select_principal_of_user" datasource="#request.a_str_db_syncml#">
SELECT
	device,id
FROM
	sync4j_principal
WHERE
	username IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_username#" list="yes">)
;
</cfquery>

<cfset a_str_device_list = ValueList(q_select_principal_of_user.device)>

<cfif ListLen(a_str_device_list) IS 0>
	<cfset a_str_device_list = 'doesnotexist'>
</cfif>

<cfquery name="q_select_devices_of_user" datasource="#request.a_str_db_syncml#">
SELECT
	sync4j_device.timezone,
	sync4j_device.type,
	sync4j_device.description,
	sync4j_device.id,
	sync4j_device.charset,
	sync4j_device.manufactor_model
FROM
	sync4j_device
WHERE
	sync4j_device.id IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_device_list#" list="yes">)
;
</cfquery>

<!--- add virtual columns ... --->
<cfset tmp = QueryAddColumn(q_select_devices_of_user, 'virtual_username', 'VarChar', ArrayNew(1))>
<cfset tmp = QueryAddColumn(q_select_devices_of_user, 'dt_lastsync', 'Date', ArrayNew(1))>
<cfset tmp = QueryAddColumn(q_select_devices_of_user, 'dt_lastsync_duration_sec', 'Integer', ArrayNew(1))>
<cfset tmp = QueryAddColumn(q_select_devices_of_user, 'principal_id', 'Integer', ArrayNew(1))>

<cfoutput query="q_select_devices_of_user">
	<!--- get id of principal ... --->
	<cfquery name="q_select_principle_id" dbtype="query">
	SELECT
		id
	FROM
		q_select_principal_of_user
	WHERE
		device = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_devices_of_user.id#">
	;
	</cfquery>
	
	<cfset tmp = querySetCell(q_select_devices_of_user, 'principal_id', q_select_principle_id.id, q_select_devices_of_user.currentrow)>
	
	<!--- get lastsync date ... --->
	<cfquery name="q_select_lastsync" datasource="#request.a_str_db_syncml#">
	SELECT
		start_sync,end_sync
	FROM
		sync4j_last_sync
	WHERE
		principal = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_principle_id.id#">
	ORDER BY
		start_sync DESC
	LIMIT
		1
	;
	</cfquery>

	<cfif isDate(q_select_lastsync.start_sync)>
		<cfset tmp = QuerySetCell(q_select_devices_of_user, 'dt_lastsync', q_select_lastsync.start_sync, q_select_devices_of_user.currentrow)>
		<cfset tmp = QuerySetCell(q_select_devices_of_user, 'dt_lastsync_duration_sec', DateDiff('s', q_select_lastsync.start_sync, q_select_lastsync.end_sync), q_select_devices_of_user.currentrow)>
	</cfif>	
	
	<cfquery name="q_select_virtual_username" datasource="#request.a_str_db_users#">
	SELECT
		username
	FROM
		virtual_mobilesync_users
	WHERE
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
		AND
		principal_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_principle_id.id#">
	;
	</cfquery>

	<!--- set virtual username ... --->	
	<cfset tmp = QuerySetCell(q_select_devices_of_user, 'virtual_username', q_select_virtual_username.username, q_select_devices_of_user.currentrow)>
</cfoutput>