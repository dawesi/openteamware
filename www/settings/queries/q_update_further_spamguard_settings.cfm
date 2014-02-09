<!--- //



	whitelist, required hits

	

	// --->

<!--- delete high rated spam! ... --->
<cfquery name="q_delete_preferences"  datasource="#request.a_str_db_mailusers#">
DELETE FROM
	userpref
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
	AND
	preference = 'delete_h_rated_spam_msg'
;
</cfquery>

<cfquery name="q_insert_delete_high_score_spam"  datasource="#request.a_str_db_mailusers#">
INSERT INTO
	userpref
	(
	username,
	preference,
	value)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="delete_h_rated_spam_msg">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmautodeletehighratedmessages#">
	)
;
</cfquery>

<!--- required hits ... --->
<cfquery name="q_delete_preferences"  datasource="#request.a_str_db_mailusers#">
DELETE FROM
	userpref
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
	AND
	preference = 'required_hits'
;
</cfquery>

<cfquery name="q_insert_whitelist"  datasource="#request.a_str_db_mailusers#">
INSERT INTO
	userpref
	(
	username,
	preference,
	value)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="required_hits">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmscore#">
	)
;
</cfquery>

<!--- razor list ... --->
<cfquery name="q_delete_preferences"  datasource="#request.a_str_db_mailusers#">
DELETE FROM
	userpref
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
	AND
	preference = 'use_razor2'
;
</cfquery>

<!--- required hits ... --->
<cfquery name="q_insert_whitelist"  datasource="#request.a_str_db_mailusers#">
INSERT INTO
	userpref
	(
	username,
	preference,
	value)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="use_razor2">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmrazorenabled#">
	)
;
</cfquery>

<!--- greylisting ... --->
<cfquery name="q_delete_greylisting_item" datasource="#request.a_str_db_greylisting#">
DELETE FROM
	optin_email
WHERE
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
;
</cfquery>

<cfif form.frmgreylistingenabled IS 1>
	<cfquery name="q_insert_greylisting_item" datasource="#request.a_str_db_greylisting#">
	INSERT INTO
		optin_email
		(email)
	VALUES
		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">)
	;
	</cfquery>
</cfif>