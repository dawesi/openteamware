<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<!--- 2do

	check filter criteria for operators !!!!
	
	
	--->
	
<cfquery name="q_select_follow_ups_items">
SELECT
	objectkey,entrykey
FROM
	followups
WHERE
	<!--- address book --->
	(servicekey = '52227624-9DAA-05E9-0892A27198268072')
	AND
	<!--- pre-select items only of this company ... --->
	(userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_users.entrykey)#" list="yes">))
	
	<!--- check what has to be used ... --->
	<cfswitch expression="#a_struct_filter_element.internalfieldname#">
		<cfcase value="followup_userkey">
		
			<cfif Len(a_struct_filter_element.comparevalue) GT 0>
				AND
				(userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_filter_element.comparevalue#" list="yes">))
			</cfif>
			
		</cfcase>

		<cfcase value="followup_type">
			
			<cfif Len(a_struct_filter_element.comparevalue) GT 0>
				AND
				(type IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_struct_filter_element.comparevalue)#" list="yes">))
			</cfif>
			
		</cfcase>
		
		<cfcase value="followup_status">
			<!--- check the status ... --->
			
			<cfif Len(a_struct_filter_element.comparevalue) GT 0>
				AND
				(done IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#val(a_struct_filter_element.comparevalue)#" list="yes">))			
			</cfif>
			
		</cfcase>
		<cfcase value="followup_dt_due">
			<!--- check the due date ... ---><!--- set operator & date ... --->
			AND			
			(dt_due < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
		</cfcase>
	</cfswitch>
;
</cfquery>

<!--- build check return structure ... --->
<cfoutput query="q_Select_follow_ups_items">
	<cfif StructKeyExists(a_struct_crm_filter_entrykeys_followups, q_select_follow_ups_items.entrykey)>
		<cfset a_struct_crm_filter_entrykeys_followups[q_select_follow_ups_items.entrykey] = (a_struct_crm_filter_entrykeys_followups[q_select_follow_ups_items.entrykey] + 1)>	
	<cfelse>
		<cfset a_struct_crm_filter_entrykeys_followups[q_select_follow_ups_items.entrykey] = 1>
	</cfif>
</cfoutput>

<cfset a_str_crm_filter_entrykeys_followups = ListAppend(a_str_crm_filter_entrykeys_followups, valuelist(q_select_follow_ups_items.entrykey))>

<cfset a_int_crm_filter_followup_checks = a_int_crm_filter_followup_checks + 1>