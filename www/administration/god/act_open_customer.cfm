<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfquery name="q_select_company">
SELECT
	companyname,entrykey,description,telephone,contactperson,email,resellerkey,customerid,oldpasswords
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<cfwddx action="wddx2cfml" input="#q_select_company.oldpasswords#" output="q_select_pwds">

<cfdump var="#q_select_pwds#">

<cfset SelectAccounts.CompanyKey = q_select_company.entrykey>
<cfinclude template="../queries/q_select_accounts.cfm">

<cfquery name="q_update">
UPDATE
	companies
SET
	disabled = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>


<cfoutput query="q_select_accounts">

<cfinvoke component="#application.components.cmp_user#" method="UpdateAllowLoginStatus" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#q_select_accounts.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="allowlogin" value="1">
</cfinvoke>

</cfoutput>


<br><br><br>
<cfoutput>#q_select_company.companyname#</cfoutput> wurde wieder geoeffnet.

</body>
</html>
