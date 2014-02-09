

<cfquery name="q_select" dbtype="query">
SELECT
	*
FROM
	q_select_reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.frmresellerkey#">
;
</cfquery>

<cfquery name="q_select_company" datasource="#request.a_str_db_users#">
SELECT
	companyname,description,telephone,contactperson,email
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.frmcompanykey#">
;
</cfquery>

<cfif Len(ExtractEmailAdr(q_select.emailadr)) GT 0>

<cfmail from="sales@openTeamWare.com" to="#q_select.emailadr#" subject="Kontakt zugewiesen">

Soeben wurde Ihnen ein neuer Kundenkontakt im Administrations-Tool
zur Weiterbearbeitung zugewiesen.

Klicken Sie bitte hier:

https://www.openTeamWare.com/administration/

Kundenverwaltung - Interessenten

<cfloop list="#q_select_company.columnlist#" index="a_str_column">
#lcase(a_str_column)#: #q_select_company[a_str_column][1]##chr(13)##chr(10)#
</cfloop>

<cfif Len(url.frmcomment) GT 0>
------------------------------
Anmerkung: #url.frmcomment#
</cfif>
</cfmail>
</cfif>

<!--- update customer --->
<cfquery name="q_update_company" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.frmresellerkey#">,
	assignedtoreseller = 1
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.frmcompanykey#">
;
</cfquery>

<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">