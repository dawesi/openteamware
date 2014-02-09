<!--- //

	Description:Delete old outlook meta data
	

// --->

<cfsetting requesttimeout="2000">

<cfquery name="q_select_setups" datasource="#request.a_str_db_tools#">
SELECT
	install_name,userkey,program_id,id
FROM
	install_names
ORDER BY
	id
;
</cfquery>

<cfoutput>#q_select_setups.recordcount#</cfoutput>

<cfoutput query="q_select_setups">
<h4>#q_select_setups.install_name# #q_select_setups.program_id# ukey: #q_select_setups.userkey#</h4>
<cfflush>

<cfquery name="q_select_user_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(userid) AS count_userid
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.userkey#">
;
</cfquery>

user exists: #q_select_user_exists.count_userid#

<cfif q_select_user_exists.count_userid IS 0>
	<font color="red">does not exist</font>

	<!--- no userkey given, delete meta information ... --->
	
	<cfquery name="q_select_other_setup" datasource="#request.a_str_db_tools#">
	SELECT
		count(id) AS count_id
	FROM
		install_names
	WHERE
		program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.program_id#">
		AND
		userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.userkey#">
		AND NOT
		id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_setups.id#">
	;
	</cfquery>
	
	other setups: #q_select_other_setup.count_id#
	
	<cfif q_select_other_setup.count_id IS 0>
	
		<!--- address book --->
		
		<cfquery name="q_select_addressbook_info" datasource="#request.a_str_db_tools#">
		DELETE FROM
			addressbook_outlook_data
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.program_id#">
		;
		</cfquery>
		
		
		<!--- outlook settings --->
		
		<cfquery name="q_select_outlook_settings" datasource="#request.a_str_db_tools#">
		DELETE FROM
			outlooksettings
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.program_id#">
			AND
			userkey = ''
		;
		</cfquery>
		
		
		<!--- calendar --->  
		<cfquery name="q_select_calendar_info" datasource="#request.a_str_db_tools#">
		DELETE FROM
			calendar_outlook_data
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.program_id#">
		;
		</cfquery>
		
		
		<!--- tasks --->
		<cfquery name="q_select_tasks_info" datasource="#request.a_str_db_tools#">
		DELETE FROM
			tasks_outlook_data
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.program_id#">
		;
		</cfquery>
		
		
		<!--- item itself ... --->
		<cfquery name="q_delete_install_name" datasource="#request.a_str_db_tools#">
		DELETE FROM
			install_names
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.program_id#">
			AND
			userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_setups.userkey#">
			AND
			id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_setups.id#">
		;
		</cfquery>		
		deleted.
		
	</cfif>
</cfif>
</cfoutput>


