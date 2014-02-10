<!--- //

	Module:		Addressbook
	Function.	ReturnSubItems
	Description:Return sub items
	

// --->

<cfquery name="q_select_sub_items" datasource="#GetDSName()#">
SELECT
	addressbook.entrykey,
	addressbook.firstname,
	addressbook.surname,
	addressbook.email_prim,
	addressbook.department,
	addressbook.aposition,
	addressbook.b_telephone,
	addressbook.b_city,
	addressbook.b_country,
	addressbook.superiorcontactkey,
	activity_count_followups,
	activity_count_appointments,
	activity_count_tasks,
	activity_count_salesprojects,
	CONCAT(addressbook.title, ' ', addressbook.firstname, ' ', addressbook.surname) AS displayname
FROM
	addressbook
WHERE
	addressbook.parentcontactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
ORDER BY
	addressbook.surname,addressbook.firstname
;
</cfquery>


