<!--- //

	load followups data 
	
	// --->

<cfinvoke component="#application.components.cmp_customer#" method="GetAllCompanyUsers" returnvariable="q_select_users">
	<cfinvokeargument name="companykey" value="#arguments.securitycontext.mycompanykey#">
</cfinvoke>

<cfif Len(a_str_option_createdbyuserkey) GT 0>
	<cfset a_str_userkeys_created_by = a_str_option_createdbyuserkey>
<cfelse>
	<cfset a_str_userkeys_created_by = ValueList(q_select_users.entrykey)>
</cfif>

<cfquery name="q_select_followups" datasource="#request.a_str_db_tools#">
SELECT
	followups.objecttitle,
	followups.comment,
	followups.done,
	followups.objectkey,
	followups.userkey,
	followups.dt_created
FROM
	followups
WHERE
	(followups.userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkeys_created_by#" list="yes">))
	AND
	(followups.dt_due BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_date)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_option_start_end)#">)
	AND
	<!--- address book --->
	(followups.servicekey = '52227624-9DAA-05E9-0892A27198268072')
;
</cfquery>

<cflog text="connected followups: #q_select_followups.recordcount#" type="Information" log="Application" file="ib_crm_reports">

<cfloop query="q_select_followups">
	<!--- add a new row to the output table --->
	<cfset QueryAddRow(q_select_data, 1)>
	
	<!--- set the address book key --->
	<cfset QuerySetCell(q_select_data, 'addressbookkey', q_select_followups.objectkey, q_select_data.recordcount)>
	
	<!--- set common data like subject, item_Type ... these fields have ALWAYS to exist! --->
	<cfset QuerySetCell(q_select_data, 'VIRT_ITEMTYPE', request.a_cmp_lang.GetLangValExt(entryid = 'crm_wd_follow_up', langno = arguments.usersettings.language), q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'VIRT_SUBJECT', q_select_followups.objecttitle, q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'VIRT_createdbyuserkey', q_select_followups.userkey, q_select_data.recordcount)>
	<cfset QuerySetCell(q_select_data, 'virt_itemcreated', q_select_followups.dt_created, q_select_data.recordcount)>

	<cfsavecontent variable="a_str_description">
		<cfoutput>
		#q_select_followups.comment#
		</cfoutput>
	</cfsavecontent>
		
	<cfset QuerySetCell(q_select_data, 'virt_description', trim(a_str_description), q_select_data.recordcount)>

<cflog text="row added" type="Information" log="Application" file="ib_crm_reports">

</cfloop>

<!--- add information ... load contact data of the found contacts too! --->		
<cfset sEntrykeys_of_contacts_2_load = ListAppend(sEntrykeys_of_contacts_2_load, ValueList(q_select_followups.objectkey))>