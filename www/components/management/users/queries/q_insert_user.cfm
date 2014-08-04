<!--- //

	Component:	Users
	Function:	CreateUser
	Description:Insert new user

	Header:

// --->

<cflock name="lck_insert_new_user" timeout="30" type="exclusive">

<cfquery name="q_select_max_userid">
SELECT
	MAX(userid) AS max_userid
FROM
	users
;
</cfquery>

<cfset a_int_userid = (Val(q_select_max_userid.max_userid) + 1) />

<cfquery name="q_insert_user">
INSERT INTO
	users
	(
	userid,
	entrykey,
	defaultlanguage,
	productkey,
	username,
	pwd,
	firstname,
	surname,
	department,
	aposition,
	title,
	zipcode,
	address1,
	city,
	utcdiff,
	daylightsavinghours,
	sex,
	country,
	email,
	date_subscr,
	companykey

	<cfif isDate(arguments.birthday)>
		,birthday
	</cfif>
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_userid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.surname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.department#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.position#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zipcode#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.address1#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.utcdiff#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.daylightsavinghours#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sex#">,
	<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.country#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.externalemail#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">

	<cfif isDate(arguments.birthday)>
		,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(arguments.birthday)#">
	</cfif>

	)
;
</cfquery>

</cflock>

