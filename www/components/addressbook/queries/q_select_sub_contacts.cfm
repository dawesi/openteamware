<!--- select all records which are accounts ... --->

<cfquery name="q_select_accounts" dbtype="query">
SELECT
	entrykey
FROM
	q_select_contacts
WHERE
	contacttype = 1
;
</cfquery>

<cfset a_struct_accounts = StructNew()>

<cfloop query="q_select_accounts">
	<cfset a_struct_accounts[q_select_accounts.entrykey] = ArrayNew(1)>
</cfloop>

<cfset a_str_accounts = ValueList(q_select_accounts.entrykey)>
<cfset a_str_accounts = ListAppend(a_str_accounts, 'dummyitem')>

<cfquery name="q_select_sub_contacts">
SELECT
	firstname,surname,department,aposition,entrykey,parentcontactkey
FROM
	addressbook
WHERE
	parentcontactkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_accounts#" list="yes">)
ORDER BY
	surname,firstname
;
</cfquery>

<cfloop query="q_select_sub_contacts">
	<cfset a_int_index = ArrayLen(a_struct_accounts[q_select_sub_contacts.parentcontactkey]) + 1>
	<cfset a_struct_accounts[q_select_sub_contacts.parentcontactkey][a_int_index] = StructNew()>
	<cfset a_struct_accounts[q_select_sub_contacts.parentcontactkey][a_int_index].firstname = q_select_sub_contacts.firstname>
	<cfset a_struct_accounts[q_select_sub_contacts.parentcontactkey][a_int_index].surname = q_select_sub_contacts.surname>
	<cfset a_struct_accounts[q_select_sub_contacts.parentcontactkey][a_int_index].department = q_select_sub_contacts.department>
	<cfset a_struct_accounts[q_select_sub_contacts.parentcontactkey][a_int_index].aposition = q_select_sub_contacts.aposition>
	<cfset a_struct_accounts[q_select_sub_contacts.parentcontactkey][a_int_index].entrykey = q_select_sub_contacts.entrykey>
</cfloop>