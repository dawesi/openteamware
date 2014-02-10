
<cfswitch expression="#arguments.servicekey#">
	<cfcase value="52230718-D5B0-0538-D2D90BB6450697D1">
		
		<cfquery name="q_select_meta_item_exists" datasource="#request.a_str_db_tools#">
		SELECT
			COUNT(id) AS count_id
		FROM
			tasks_outlook_data
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
			AND
			taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
			AND
			ignoreitem = 0
		;
		</cfquery>
		
	</cfcase>
	
	
	
	<cfcase value="5222B55D-B96B-1960-70BF55BD1435D273">
		<!--- calendar --->
		
		<cfquery name="q_select_meta_item_exists" datasource="#request.a_str_db_tools#">
		SELECT
			COUNT(id) AS count_id
		FROM
			calendar_outlook_data
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
			AND
			eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
		;
		</cfquery>
				
	</cfcase>
	
	<cfcase value="52227624-9DAA-05E9-0892A27198268072">
		<!--- address book --->
		
		<cfquery name="q_select_meta_item_exists" datasource="#request.a_str_db_tools#">
		SELECT
			COUNT(id) AS count_id
		FROM
			addressbook_outlook_data
		WHERE
			program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
			AND
			addressbookkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
		;
		</cfquery>
				
	</cfcase>
</cfswitch>