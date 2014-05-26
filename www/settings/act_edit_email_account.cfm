<!--- &auml;nderung durchf&uuml;hren --->
<cfinclude template="../login/check_logged_in.cfm">



<cfquery name="q_update" datasource="#request.a_str_db_users#">
UPDATE
	pop3_data
SET
	pop3server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPop3server#">,
	pop3username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPop3username#">,
	displayname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdisplayname#">, 
	autocheckminutes = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmAutoCheckEachMinutes)#">,
	deletemsgonserver = 
<cfif isdefined("form.frmDeleteMsgOnServer") is true>
  1
  <cfelse>
  0
</cfif>
<cfif form.frmpop3password neq "">
  ,pop3password = 
  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3password#">
</cfif>
WHERE (userid = 
<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">
) AND (id = 
<cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmid)#">
); 
</cfquery>
<cflocation addtoken="No" url="index.cfm?action=ExternalEmail">
