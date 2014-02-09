<cfquery name="q_select" datasource="#request.a_str_db_tools#">
SELECT
	objectkey,servicekey,entrykey
FROM
	followups
;
</cfquery>

<cfoutput query="q_select">
	<cfset a_bol_delete = false>
	
	#q_select.currentrow# : #q_select.objectkey# :
	
	<cfswitch expression="#q_select.servicekey#">
		<cfcase value="52227624-9DAA-05E9-0892A27198268072">
		<!--- address book --->
		
		<cfquery name="q_select_contact_exists" datasource="#request.a_str_db_tools#">
		SELECT
			COUNT(id) AS count_id
		FROM
			addressbook
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.objectkey#">
		;
		</cfquery>
		
		#q_select_contact_exists.count_id#
		
		<cfif q_select_contact_exists.count_id IS 0>
			<!--- delete entry --->
			<cfset a_bol_delete = true>
		</cfif>
		
		</cfcase>
	</cfswitch>
	
	<br>
	
	<cfif a_bol_delete>
		<!--- delete --->
		delete
		<cfquery name="q_delete_followup" datasource="#request.a_str_db_tools#">
		DELETE FROM
			followups
		WHERE
			servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.servicekey#">
			AND
			objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.objectkey#">
			AND
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.entrykey#">
		;
		</cfquery>
		<br>
	</cfif>
</cfoutput>