<!--- //

	Component:	Addressbook
	Description:Select contact ...
// --->

<cfquery name="q_select_contact" datasource="#GetDSName()#">
SELECT
	addressbook.firstname,
	addressbook.surname,
	addressbook.company,
	addressbook.department,
	addressbook.aposition,
	addressbook.userkey,
	addressbook.entrykey,
	addressbook.criteria,
	addressbook.birthday,
	addressbook.archiveentry,
	addressbook.title,
	addressbook.sex,
	addressbook.birthday,
	addressbook.notice,
	addressbook.contacttype,
	addressbook.skypeusername,
	addressbook.categories,
	addressbook.email_prim,
	addressbook.email_adr,
	addressbook.b_telephone,
	addressbook.b_telephone_2,
	addressbook.b_mobile,
	addressbook.p_mobile,
	addressbook.b_street,addressbook.b_zipcode,addressbook.b_country,addressbook.b_country,addressbook.b_fax,addressbook.b_city,addressbook.b_url,
	addressbook.p_street,addressbook.p_zipcode,addressbook.p_country,addressbook.p_country,addressbook.p_telephone,addressbook.p_fax,addressbook.p_city,addressbook.p_url,
	LENGTH(CONCAT(addressbook.p_street,addressbook.p_zipcode,addressbook.p_country,addressbook.p_country,addressbook.p_telephone,addressbook.p_fax,addressbook.p_city,addressbook.p_url)) AS length_private_data,
	addressbook.lasteditedbyuserkey,
	addressbook.createdbyuserkey,
	addressbook.parentcontactkey,
	addressbook.superiorcontactkey,
	addressbook.lang,
	addressbook.ownfield1,
	addressbook.ownfield2,
	addressbook.ownfield3,
	addressbook.ownfield4,
	DATE_ADD(addressbook.dt_lastmodified, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-addressbook.daylightsavinghoursoncreate HOUR) AS dt_lastmodified,
	DATE_ADD(addressbook.dt_created, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-addressbook.daylightsavinghoursoncreate HOUR) AS dt_created,
	DATE_ADD(addressbook.dt_lastcontact, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-addressbook.daylightsavinghoursoncreate HOUR) AS dt_lastcontact,
	DATE_ADD(addressbook.dt_remoteedit_last_update, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-addressbook.daylightsavinghoursoncreate HOUR) AS dt_remoteedit_last_update,
	addressbook.nace_code,
	addressbook.employees,
	addressbook.photoavailable,
	LENGTH(redata.id) AS is_re_data_available,
	LENGTH(remoteedit.entrykey) AS id_re_job_available,
	/*  pseudo display fields ... these fields are display values of real fields */
	'' AS nace_code_displayvalue,
	'' AS criteria_displayvalue,
	'' AS criteria_displayvalue,
	'' AS superiorcontactkey_displayvalue,
	'' AS parentcontactkey_displayvalue,
	/* workgroup shares ... has NO reference to the original table, therefore the "virtual_" prefix "*/
	'' AS virtual_workgroupshares_data,
	'' AS virtual_workgroupshares_data_displayvalue,
	/* assigned people ... */
	'' AS virtual_assignedusers_data,
	'' AS virtual_assignedusers_data_displayvalue
FROM
	addressbook
LEFT JOIN
	redata ON (redata.entrykey = addressbook.entrykey)
LEFT JOIN
	remoteedit ON (remoteedit.objectkey = addressbook.entrykey)
WHERE
	addressbook.entrykey = '#arguments.entrykey#'
;
</cfquery>

<cfquery name="q_select_parent_contact" datasource="#GetDSName()#">
SELECT
	addressbook.company,
	addressbook.surname,
	addressbook.firstname,
	addressbook.b_city,
	addressbook.department,
	addressbook.contacttype
FROM
	addressbook
WHERE
	(addressbook.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_contact.parentcontactkey#">)
;
</cfquery>