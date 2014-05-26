<cfparam name="url.email" default="">

<cfparam name="url.code" default="">



<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id 
FROM
	pop3_data
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
	AND
	confirmcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.code#">
	AND
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.email#">
;
</cfquery>



<cf_disp_navigation mytextleft="Externe Adresse einbinden">



<cfif q_select.count_id is 0>

	<br><br><br>

	<b>Der Code stimmt leider nicht &uuml;berein!</b>

	<br>

	<br>

	Fordern Sie ihn bitte nochmals an - klicken Sie dazu bitte hier: <a href="index.cfm?action=ExternalEmail">&Uuml;bersicht</a>

	<cfexit method="EXITTEMPLATE">

</cfif>



<!--- passt so ... --->

<cfquery name="q_update" datasource="#request.a_str_db_users#" dbtype="ODBC">

update pop3_data

set confirmed = 1

where userid = #request.stSecurityContext.myuserid#

and confirmcode = '#url.code#'

and emailadr = '#url.email#';

</cfquery>



<br>

<br>

Die E-Mail Adresse <cfoutput>#url.email#</cfoutput> wurde erfolgreich freigeschalten und kann nun verwendet werden!

<br>

<br>

<a href="index.cfm?action=ExternalEmail">&Uuml;bersicht</a>