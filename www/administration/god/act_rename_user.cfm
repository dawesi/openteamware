

<cfdump var="#form#">

<!--- check if first user exists ... --->

<cfquery name="q_select_user_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(userid) AS count_id
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmoldusername#">
;
</cfquery>

<cfif q_select_user_exists.count_id IS 0>
	User does not exist.
	<cfabort>
</cfif>

<!--- check if second user exists ... --->

<cfquery name="q_select_user_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(userid) AS count_id
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmnewusername#">
;
</cfquery>

<cfif q_select_user_exists.count_id IS 0>
	User does not exist.
	<cfabort>
</cfif>

<!--- select the new user ... --->
<cfquery name="q_select_new_user" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmnewusername#">
;
</cfquery>

<!--- ok, here we go ... first of all make backups of old user ... --->
<cfquery name="q_select_user" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmoldusername#">
;
</cfquery>

<cfset q_select_old_user = q_select_user>

<cfdump var="#q_select_user#">

<cfwddx action="cfml2wddx" input="#q_select_user#" output="a_str_wddx">

<cfquery name="q_insert_log" datasource="#request.a_Str_db_log#">
INSERT INTO
	renameuser_log
	(
	userid,
	userkey,
	wddx,
	tablename,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_user.userid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	'users',
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>



<cfquery name="q_select_pop3_data" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	pop3_data
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">
;
</cfquery>

<cfdump var="#q_select_pop3_data#">


<cfwddx action="cfml2wddx" input="#q_select_user#" output="a_str_wddx">

<cfquery name="q_insert_log" datasource="#request.a_Str_db_log#">
INSERT INTO
	renameuser_log
	(
	userid,
	userkey,
	wddx,
	tablename,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_user.userid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	'pop3_data',
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>


<cfquery name="q_select_postfix" datasource="#request.a_str_db_mailusers#">
SELECT
	*
FROM
	users
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">
;
</cfquery>

<cfdump var="#q_select_postfix#">


<cfwddx action="cfml2wddx" input="#q_select_postfix#" output="a_str_wddx">

<cfquery name="q_insert_log" datasource="#request.a_Str_db_log#">
INSERT INTO
	renameuser_log
	(
	userid,
	userkey,
	wddx,
	tablename,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_user.userid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	'postfix',
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>


<cfquery name="q_select_fetchmail_accounts" datasource="#request.a_str_db_mailusers#">
SELECT
	*
FROM
	emailaccount
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">
;
</cfquery>

<cfdump var="#q_select_fetchmail_accounts#" label="q_select_fetchmail_accounts">


<cfwddx action="cfml2wddx" input="#q_select_fetchmail_accounts#" output="a_str_wddx">

<cfquery name="q_insert_log" datasource="#request.a_Str_db_log#">
INSERT INTO
	renameuser_log
	(
	userid,
	userkey,
	wddx,
	tablename,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_user.userid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	'fetchmailaccounts',
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>


<!--- select MAX new userid ... --->
<cfquery name="q_select_new_userid" datasource="#request.a_str_db_users#">
SELECT
	MAX(userid) AS max_userid
FROM
	users
;
</cfquery>

<!--- this is the new userid for the old account ... --->
<cfset a_int_new_userid = q_select_new_userid.max_userid + 5>

<!--- let the UPDATES begin ...

	update the old user to the new entrykey (old entrykey + __) plus a new userid

	--->
	
<cfquery name="q_update_old_user" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	<!--- set new entrykey --->
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="__#q_select_old_user.entrykey#">,
	<!--- set new userid --->
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_userid#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.entrykey#">
;
</cfquery>

<!--- update pop3_data item with origin = 0 ... that means the main address ... --->
<cfquery name="q_update_pop3_data" datasource="#request.a_str_db_users#">
UPDATE
	pop3_data
SET
	<!--- set new userkey --->
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="__#q_select_old_user.entrykey#">,
	<!--- set new userid --->
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_new_userid#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.entrykey#">
	AND
	origin = 0
;
</cfquery>

<!--- update postfix table ... set the new invalid userkey --->
<cfquery name="q_update_postfix" datasource="#request.a_str_db_mailusers#">
UPDATE
	users
SET
	<!--- set new userkey --->
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="__#q_select_old_user.entrykey#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.username#">
;
</cfquery>

<!--- NOW, edit the new account in order to reflect the data of the old account

	we do that by using the entrykey and userid of the old user

	--->
<cfquery name="q_update_new_user" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	<!--- set new entrykey --->
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.entrykey#">,
	<!--- set new userid --->
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_old_user.userid#">
WHERE
	<!--- update the item of the new user ... --->
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.entrykey#">
;
</cfquery>

<cfquery name="q_update_pop3_data" datasource="#request.a_str_db_users#">
UPDATE
	pop3_data
SET
	<!--- set new userkey --->
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.entrykey#">,
	<!--- set new userid --->
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_old_user.userid#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.entrykey#">
	AND
	origin = 0
;
</cfquery>

<cfquery name="q_update_postfix" datasource="#request.a_str_db_mailusers#">
UPDATE
	users
SET
	<!--- set new userkey --->
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.entrykey#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.username#">
;
</cfquery>

<!--- update email target of external accounts ... --->
<cfquery name="q_update_emailaccount" datasource="#request.a_str_db_mailusers#">
UPDATE
	emailaccount
SET
	<!--- update field "email" --->
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.username#">
WHERE
	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.username#">
;
</cfquery>

<!--- update alias adresses table ... --->
<cfquery name="q_update_alias_table" datasource="#request.a_str_db_users#">
UPDATE
	emailaliases
SET
	destinationaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.username#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.entrykey#">
;
</cfquery>



<!--- create a forwarding of the old email address to the new account (as alias) --->

<!--- misc cleanup tasks --->
<cfquery name="q_delete_mailspeed_data" datasource="#request.a_Str_db_email#">
DELETE FROM
	folders
WHERE
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.username#">
;
DELETE FROM
	folderdata
WHERE
	account = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_user.username#">
;
</cfquery>

<!--- migrate spamasassin settings ... --->
<cfquery name="q_delete_old_sa_setting" datasource="#request.a_str_db_mailusers#">
DELETE FROM
	spamassassin
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.username#">
;
</cfquery>

<cfquery name="q_update_sa_settings" datasource="#request.a_str_db_mailusers#">
UPDATE
	spamassassin
SET
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.username#">
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.username#">
;
</cfquery>

<!--- uidl table ... --->
<cfquery name="q_update_uidl" datasource="#request.a_str_db_mailusers#">
UPDATE
	uidl
SET
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_new_user.username#">
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_old_user.username#">
;
</cfquery>

<!--- re-write mail config ... --->


