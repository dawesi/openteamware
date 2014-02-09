<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfif IsDefined("form.frmcustomerid") IS FALSE>
<form action="default.cfm" method="post">
	<input type="text" name="frmcustomerid" value="" size="10">
	&nbsp;
	<input type="submit" value="Speichern">
</form>
<cfelse>

	<cfdump var="#form#">
	
	<cfset a_dt_contract_end = DateAdd('yyyy', 1, Now())>
	
	<cfquery name="q_update" datasource="#request.a_str_db_users#">
	UPDATE
		companies
	SET
		status = 0,
		dt_contractend = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_contract_end)#">
	WHERE
		customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcustomerid#">
	;
	</cfquery>
	
	Ist nun Kunde; Laufzeit = 1 Jahr
	
</cfif>

</body>
</html>
