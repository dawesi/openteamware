<cfquery name="q_select_sms_remind" datasource="#request.a_str_db_users#">

SELECT mobilenr,userid FROM users

WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_open_alerts.userkey#">;

</cfquery>	

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_sc">
	<cfinvokeargument name="userkey" value="#q_select_open_alerts.userkey#">
</cfinvoke>

<cfinvoke component="/components/mobile/cmp_sms" method="SendSMSEx" returnvariable="stReturn_sms">
	<cfinvokeargument name="securitycontext" value="#variables.stReturn_sc#">
	<cfinvokeargument name="body" value="Achtung: Der Termin #htmleditformat(q_select_open_alerts.eventtitle)# startet um #Timeformat(q_select_open_alerts.EventStart, "HH:mm")# - Ihr openTeamWare Buddy">
	<cfinvokeargument name="sender" value="openTeamWare">
	<cfinvokeargument name="recipient" value="#q_select_sms_remind.mobilenr#">
	<cfinvokeargument name="dt_send" value="#Now()#">
</cfinvoke> 