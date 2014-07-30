
<cfparam name="form.frmpermissions" type="string" default="">
<cfdump var="#form#">

<!--- insert --->

<cfquery name="q_select">
SELECT
	*
FROM
	resellerusers
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">
	AND
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">
;
</cfquery>

<cfif q_select.recordcount IS 1>
	<h4>user already exists ...</h4>
	<cfabort>
</cfif>

<cfquery name="q_insert_reseller_user">
INSERT INTO
	resellerusers
	(
	resellerkey,
	userkey,
	permissions,
	contacttype,
	dt_created,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpermissions#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcontacttype#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	)
;
</cfquery>

<cflocation addtoken="no" url="index.cfm?action=resellerusers&resellerkey=#urlencodedformat(form.frmresellerkey)#">