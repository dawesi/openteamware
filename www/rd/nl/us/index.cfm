<cfparam name="url.k" type="string" default="">
<cfparam name="url.e" type="string" default="">

<cfif len(url.k) IS 0>
	unknown userid
	<cfabort>
</cfif>

<cfif len(url.e) IS 0>
	unknown userid
	<cfabort>
</cfif>

<cfquery name="q_delete" datasource="mynewsletter">
DELETE FROM
	ibinterestedparties
WHERE
	emailadr = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.e#">
	AND
	secretkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.k#">
;
</cfquery>

<h4>Sie wurden soeben erfolgreich abgemeldet.</h4>

<a href="/">Jetzt zur Startseite wechseln ...</a>