
<cfquery name="q_select_all_email_data">
SELECT pop3username,pop3password,pop3server,id,origin,deletemsgonserver,confirmed,sendawaymsg,displayname,autocheckminutes,markcolor,emailadr,enabled FROM pop3_data
WHERE userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">;
</cfquery>