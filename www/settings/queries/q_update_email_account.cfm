<!--- 
	update
--->


<cfquery name="q_update_email_account">
UPDATE
	pop3_data
SET
	markcolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmmarkcolor#">,
	displayname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdisplayname#">
	
	<cfif isdefined("form.frmPop3server")>
	,pop3server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPop3server#">
	</cfif>

	<cfif isdefined("form.frmPop3username") AND (len(form.frmPop3username) gt 0)>
	,pop3username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPop3username#">
	</cfif>

	<cfif isdefined("form.frmAutoCheckEachMinutes")>
	,autocheckminutes = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmAutoCheckEachMinutes)#">
	</cfif>

	<cfif IsDefined("form.frmdestinationfolder")>
	,destinationfolder = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmdestinationfolder#">
	</cfif>

	<cfif Isdefined("form.frmdeletemsgonserver")>
	,deletemsgonserver = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmdeletemsgonserver#">
	</cfif>

	<cfif isDefined("form.frmpop3password") AND (Len(form.frmpop3password) gt 0)>
	,pop3password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpop3password#">
	</cfif>
	
	,usessl = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmcbusessl#">
	
	<cfif StructKeyExists(form, "frmpop3port")>
	,port = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmpop3port#">
	</cfif>


WHERE (userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">)

AND (id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(form.frmid)#">);

</cfquery>