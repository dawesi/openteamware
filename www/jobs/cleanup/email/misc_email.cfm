<!---

	Clean various email data
	
	a) select uidl data where the original account does not exist any more
	
	b) clear spamassassin userpreferences

--->


<cfquery name="q_select_distinct_accounts" datasource="#request.a_str_db_mailusers#">
SELECT
	DISTINCT(uidl.email) AS email_distinct,
	CONCAT(emailaccount.emailaddresstocheck, '@', emailaccount.host) AS email_exists
FROM
	uidl
LEFT JOIN
	emailaccount ON (CONCAT(emailaccount.emailaddresstocheck, '@', emailaccount.host) = uidl.email)
WHERE
	CONCAT(emailaccount.emailaddresstocheck, '@', emailaccount.host) IS NULL
LIMIT
	50
;
</cfquery>

<cfdump var="#q_select_distinct_accounts#">

<cfloop query="q_select_distinct_accounts">
	
	<!--- delete now --->
	<cfquery name="q_select_count_uidl" datasource="#request.a_str_db_mailusers#">
	DELETE FROM
		uidl
	WHERE
		email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_accounts.email_distinct#">
	;
	</cfquery>
	
</cfloop>

<cfquery name="q_select_distinct_accounts" datasource="#request.a_str_db_mailusers#">
SELECT
	DISTINCT(userpref.username) AS email_distinct,
	users.id
FROM
	userpref
LEFT JOIN
	users ON (users.id = userpref.username)
WHERE
	users.id IS NULL
LIMIT
	100
;
</cfquery>

<cfloop query="q_select_distinct_accounts">
		<!--- delete now --->
	<cfquery name="q_select_count_uidl" datasource="#request.a_str_db_mailusers#">
	DELETE FROM
		userpref
	WHERE
		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_accounts.email_distinct#">
	;
	</cfquery>
</cfloop>


<cfdump var="#q_Select_distinct_accounts#">

<cfquery name="q_select_distinct_accounts" datasource="#request.a_str_db_mailusers#">
SELECT
	DISTINCT(spamassassin.id) AS email_distinct,
	users.id
FROM
	spamassassin
LEFT JOIN
	users ON (users.id = spamassassin.id)
WHERE
	users.id IS NULL
LIMIT
	100
;
</cfquery>

<cfloop query="q_select_distinct_accounts">
		<!--- delete now --->
	<cfquery name="q_select_count_uidl" datasource="#request.a_str_db_mailusers#">
	DELETE FROM
		spamassassin
	WHERE
		id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_accounts.email_distinct#">
	;
	</cfquery>
</cfloop>


<cfdump var="#q_Select_distinct_accounts#">

<cfquery name="q_select_distinct_accounts" datasource="#request.a_str_db_mailusers#">
SELECT
	DISTINCT(quota.id) AS email_distinct,
	users.id
FROM
	quota
LEFT JOIN
	users ON (users.id = quota.id)
WHERE
	users.id IS NULL
LIMIT
	500
;
</cfquery>

<cfloop query="q_select_distinct_accounts">
		<!--- delete now --->
	<cfquery name="q_delete_quota_item" datasource="#request.a_str_db_mailusers#">
	DELETE FROM
		quota
	WHERE
		id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_accounts.email_distinct#">
	;
	</cfquery>
</cfloop>

<cfdump var="#q_select_distinct_accounts#">