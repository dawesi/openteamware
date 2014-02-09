<cfinclude template="../login/check_logged_in.cfm">



<!--- //



	edit settings for an openTeamWare email address

	

	maybe set a forwarding target

	

	// --->

	

<cfparam name="url.id" default="0" type="numeric">


<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	emailadr
FROM
	pop3_data
WHERE
	(emailadr = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.stSecurityContext.myusername#">)
	AND
	(id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmid)#">)
	AND
	(origin = 0)
;
</cfquery>


<cfif q_select.recordcount is 0><cfabort></cfif>

<!--- openTeamWare adresse ... allgemeine daten ... danach postfix db --->

<cfquery name="q_update" datasource="#request.a_str_db_users#">
UPDATE
	pop3_data
SET
	displayname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmDisplayname#">,
	deletemsgonserver = <cfif isdefined("form.frmDeleteMsgOnServer") is true>1<cfelse>0</cfif>
	
	<cfif len(form.frmpop3password) gt 0>
	,pop3password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3password#">
	</cfif>
	
WHERE
	(userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)
	AND
	(emailadr = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.stSecurityContext.myusername#">)
	AND
	(origin = 0)
;
</cfquery>



<!--- courier passwort setzen --->
<cfif len(form.frmpop3password) gt 0>
	
	<!--- update postfix password ... --->
	<cfquery name="q_update_postfix_pwd" datasource="#request.a_str_db_mailusers#">
	UPDATE
		users
	SET
		clear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3password#">
	WHERE
		id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#request.stSecurityContext.myusername#">
	;
	</cfquery>
</cfif>


<!--- alle umleitungsregeln l&ouml;schen --->

<cfquery name="q_delete_redirects" debug datasource="#request.a_str_db_mailusers#">
DELETE FROM
	forwarding
WHERE
	(id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">);
</cfquery>



<!--- einf&uuml;gen wenn gefragt --->

<cfif isdefined("form.frmForwardingEnabled") and

	(form.frmForwardingDestination neq "") and

	(FindNocase("@", form.frmForwardingDestination, 1) gt 0)>

	

	<!--- kopie belassen? --->

	<cfif IsDefined("form.frmForwardingLeaveCopy")>

		<cfset aLeaveCopy = 1>

	<cfelse>

		<cfset aLeaveCopy = 0>

	</cfif>



	<cfquery name="q_insert_redirect" datasource="#request.a_str_db_mailusers#">
	INSERT INTO
		forwarding
		(
		id,
		destination,
		leavecopy
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_Select.emailadr#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmForwardingDestination#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#aLeaveCopy#">
		)
	;
	</cfquery>

</cfif>


<!---
<cfmodule template="utils/mod_create_mailsystem_config.cfm"

	username = #q_Select.emailadr#>
--->
<cfinvoke component="/components/email/cmp_filter" method="CreateProcmailconfig" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#request.stSecurityContext.myusername#">
</cfinvoke>



<!--- redirect --->

<cflocation addtoken="No" url="default.cfm?action=ExternalEmail">