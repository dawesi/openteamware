

<cfdump var="#form#">

<!--- check if first user exists ... --->

<cfquery name="q_select_user_exists">
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

<cfquery name="q_select_user_exists">
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
<cfquery name="q_select_new_user">
SELECT
	*
FROM
	users
WHERE
	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmnewusername#">
;
</cfquery>

<!--- ok, here we go ... first of all make backups of old user ... --->
<cfquery name="q_select_user">
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

<cfquery name="q_insert_log">
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



<cfquery name="q_select_pop3_data">
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

<cfquery name="q_insert_log">
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




<!--- select MAX new userid ... --->
<cfquery name="q_select_new_userid">
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

<cfquery name="q_update_old_user">
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

<!--- NOW, edit the new account in order to reflect the data of the old account

	we do that by using the entrykey and userid of the old user

	--->
<cfquery name="q_update_new_user">
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
