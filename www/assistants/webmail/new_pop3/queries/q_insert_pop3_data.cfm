<cfset sEntrykey = CreateUUID()>


<cfset form.frmPOPUsername = ReplaceNoCase(form.frmPOPUsername, '\', '\\', 'ALL')>

<cfquery name="q_insert" datasource="#request.a_str_db_users#">
INSERT INTO
	pop3_data

(userid,userkey,displayname,emailadr,pop3server,pop3username,pop3password,deletemsgonserver,confirmed,confirmcode,autocheckminutes,entrykey)

values

(<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmDisplayname#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmEmail#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPOPServer#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPOPUsername#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmPOPPassword#">,

<cfqueryparam cfsqltype="cf_sql_integer" value="#ADelMsgOnServer#">,

-1,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#AConfirmCode#">,30,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">);

</cfquery>



<cfquery name="q_select_newid" datasource="#request.a_str_db_users#">

SELECT id FROM pop3_data WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">;

</cfquery>