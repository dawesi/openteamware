<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfquery name="q_select_company" datasource="#request.a_str_db_users#">
SELECT
	companyname,entrykey,description,telephone,contactperson,email,resellerkey,customerid
FROM
	companies
WHERE
	customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.frmcustomerid#">
;
</cfquery>

<cfdump var="#q_select_company#">


<cfset SelectAccounts.CompanyKey = q_select_company.entrykey>
<cfinclude template="../queries/q_select_accounts.cfm">

<cfwddx action="cfml2wddx" input="#q_select_accounts#" output="a_str_wddx">

<cfif StructKeyExists(url, 'confirmed')>

<!--- disable all accounts ... --->

<cfquery name="q_update" datasource="#request.a_str_db_users#">
UPDATE
	companies
SET
	disabled = 1,
	dt_disabled = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	disabled_reason = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmreason#">,
	oldpasswords = '#a_str_wddx#'
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_company.entrykey#">
;
</cfquery>

<cfoutput query="q_select_accounts">

<cfinvoke component="#application.components.cmp_user#" method="UpdateAllowLoginStatus" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#q_select_accounts.entrykey#">
	<cfinvokeargument name="companykey" value="#q_select_company.entrykey#">
	<cfinvokeargument name="allowlogin" value="0">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="UpdatePassword" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#q_select_accounts.entrykey#">
	<cfinvokeargument name="companykey" value="#q_select_company.entrykey#">
	<cfinvokeargument name="password" value="#CreateUUID()#">
	<cfinvokeargument name="updatepop3password" value="true">
</cfinvoke>

</cfoutput>

<b>Es wurden alle Konten gesperrt.</b>

<br /><br /><br />
<h4>Disable further customers?</h4>
<cfinclude template="dsp_disable_customer.cfm">
<cfelse>

Sind Sie sicher?
<br><br>
<b><cfoutput>#q_select_company.companyname#</cfoutput></b>
<br><br>
<form method="post" action="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>&confirmed=1">
Grund: <input type="text" name="frmreason" size="30"><br>
<input type="submit" value="Ja, sperren">
</form>
<br><br>
<a href="javascript:history.go(-1);">Nein</a>

</cfif>
<br><br><br><br>
<i>Konten</i>
<table border="0" cellspacing="0" cellpadding="4">
  <cfoutput query="q_select_accounts">
  <tr>
    <td>#q_select_accounts.surname#, #q_select_accounts.firstname#</td>
    <td>#q_select_accounts.username#</td>
    <td>&nbsp;</td>
  </tr>
  </cfoutput>
</table>

</body>
</html>
