<!--- //

	send out calendar alerts ...
	
	// --->
	
	
<cfexit method="exittemplate">

<cfset a_dt_check = DateAdd("n", 2, now())>
<cfset ACheckDT = DateAdd("n", "2", now())>

<cfquery name="q_select" debug datasource="#request.a_str_db_tools#">
SELECT * FROM cal_remind
WHERE status = 0
AND remind_Type in (0,1)
AND dt_remind < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_check)#">
</cfquery>

<cfdump var="#q_select#">

<cfloop query="q_select">

<!--- select event data --->
<cfquery name="q_select_event" datasource="#request.a_str_db_tools#">
SELECT
	title,id
FROM
	calendar
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.eventkey#">
;
</cfquery>

<cfswitch expression="#q_Select.remind_type#">
	<cfcase value="0">
	<!--- email schicken --->
<cfmail to="#q_select.remind_email_adr#"
			from="KeineAntwortAdresse@openTeamware.com"
			subject="Terminerinnerung: #q_Select_event.title#">
Guten Tag!

Der Termin #q_Select_event.title# startet um #Timeformat(q_select.EventStart, "HH:mm")#.

Klicken Sie hier fuer weitere Termin-Informationen:
http://www.openTeamWare.com/calendar/

Ihr openTeamWare Buddy
</cfmail>	
	</cfcase>
	
	<cfcase value="1">
	<!--- sms schicken --->
	
	<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_sc">
		<cfinvokeargument name="userkey" value="#q_select.userkey#">
	</cfinvoke>
	
		<cfquery name="q_select_sms_remind" datasource="#request.a_str_db_users#">
		SELECT mobilenr FROM users
		WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select.userid#">;
		</cfquery>	
		
		<cfinvoke component="/components/mobile/cmp_sms" method="SendSMSEx" returnvariable="stReturn_sms_send">
			<cfinvokeargument name="securitycontext" value="#variables.stReturn_sc#">
			<cfinvokeargument name="body" value="Achtung: Der Termin #htmleditformat(q_Select_event.title)# startet um #Timeformat(q_select.EventStart, "HH:mm")# - Ihr openTeamWare Buddy">
			<cfinvokeargument name="sender" value="openTeamWare">
			<cfinvokeargument name="recipient" value="#q_select_sms_remind.mobilenr#">
			<cfinvokeargument name="dt_send" value="#Now()#">
		</cfinvoke> 			
	
	</cfcase>
	<cfcase value="2">
		<!--- reminder ... --->
	</cfcase>
</cfswitch>

</cfloop>

<!--- updaten --->
<cfif q_select.recordcount gt 0>
<cfquery debug name="q_update" datasource="#request.a_str_db_tools#">
UPDATE cal_remind SET status = 1 WHERE id IN (0<cfoutput query="q_select">,#q_select.id#</cfoutput>)
AND remind_Type IN (0,1);
</cfquery>
</cfif>