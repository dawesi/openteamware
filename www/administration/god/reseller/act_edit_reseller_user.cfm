
<cfparam name="form.FRMPERMISSIONS" type="string" default="">

<cfdump var="#form#">

<cfquery name="q_insert_reseller_user" datasource="#request.a_str_db_users#">
UPDATE
	resellerusers
SET
	contacttype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmcontacttype#">,
	permissions = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpermissions#">
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmresellerkey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmuserkey#">
;
</cfquery>

<cflocation addtoken="no" url="index.cfm?action=resellerusers&resellerkey=#urlencodedformat(form.frmresellerkey)#">