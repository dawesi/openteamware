<cfparam name="url.confirmed" type="string" default="0">

<cfif url.confirmed IS 1>
	
<cfset a_str_userkey = '22A0DE1B-B240-CB38-1D7E4EFD3A351969'>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="22A0DE1B-B240-CB38-1D7E4EFD3A351969">
</cfinvoke>

<cfset variables.stSecurityContext = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="22A0DE1B-B240-CB38-1D7E4EFD3A351969">
</cfinvoke>

<cfset variables.stUserSettings = a_struct_settings>

<cfquery name="q_select_contacts_count" datasource="#request.a_str_db_tools#">
DELETE FROM
	addressbook
WHERE
	userkey = '22A0DE1B-B240-CB38-1D7E4EFD3A351969'
;
</cfquery>

<cfsetting requesttimeout="2000">

<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	users.username,
	users.email,
	users.subscrnewsletteraddress,
	users.sex,
	users.surname,
	users.firstname,
	users.entrykey,
	users.defaultlanguage,
	companies.companyname
FROM
	users
LEFT JOIN companies ON (companies.entrykey = users.companykey)
WHERE
	(users.allow_login = 1)
	AND
	(users.subscrnewsletter = 1)
ORDER BY
	users.userid
;
</cfquery>

<cfset a_cmp_contacts = application.components.cmp_addressbook>

<cfloop query="q_select">
<cfoutput>#q_select.currentrow# #q_select.email# #q_select.username#<br></cfoutput>
<cfif Len(q_select.SUBSCRNEWSLETTERADDRESS) GT 0>
	<cfset a_str_to = q_select.SUBSCRNEWSLETTERADDRESS>
<cfelseif Len(q_select.email) GT 0>
	<cfset a_str_to = q_select.email>
<cfelse>
	<cfset a_str_to = q_select.username>
</cfif>

<cfset tmp = a_cmp_contacts.CreateContact(categories = '', entrykey = createUUID(), securitycontext = variables.stSecurityContext, usersettings = variables.stUserSettings, firstname = q_select.firstname, surname = q_select.surname, email_prim = a_str_to, sex = q_select.sex)>

<cfflush>
</cfloop>

<cfelse>
<h4>Are you sure?</h4>
<a href="default.cfm?action=copynlsubscribers&confirmed=1">Yes, copy nl subscribers</a>

</cfif>