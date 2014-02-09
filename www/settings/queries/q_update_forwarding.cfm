
<!--- delete old item ... --->
<cfquery name="q_update_forwarding" datasource="#request.a_str_db_mailusers#">
DELETE FROM forwarding WHERE
(id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_email_account.emailadr#">);
</cfquery>

<!--- insert new one ... --->
<cfquery name="q_update_forwarding" datasource="#request.a_str_db_mailusers#">
INSERT INTO forwarding
(id,destination,leavecopy)
VALUES
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_email_account.emailadr#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmforwardingdestination#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmleavecopy#">);
</cfquery>