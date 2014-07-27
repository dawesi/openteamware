<cfinclude template="../../login/check_logged_in.cfm">
<!--- // 

	load vcalendar, either from local file or from web (http address) 
	
	procedure: 
	
	- load file
	- invoke the parser
	- insert into database
	- maybe create a recurring refreshment routine (
	
	// --->
	
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>openTeamWare.com</title>
</head>
<body>
<cfset form.frmUrl = ReplaceNoCase(form.frmURL, "webcal://", "http://", "ALL")>

<!--- load cal now / request http file --->
<cftry>
<cflock timeout="3" throwontimeout="No" type="EXCLUSIVE">
	<cfhttp url="#form.frmURL#" method="GET"  username="#form.frmhttpusername#" password="#form.frmhttppassword#" resolveurl="false">
	<cfset a_str_ical_content = cfhttp.FileContent>
</cflock>

<cfcatch type="any">
<h4>error on contacting server</h4>
<cfabort>
</cfcatch>
</cftry>

<cffile action="write" file="#request.a_str_temp_directory#events.downloaded.ics" output="#a_str_ical_content#" addnewline="no">
<cfmail to="#request.appsettings.properties.NotifyEmail#" from="donotreply@openTeamWare.com" subject="ics" mimeattach="#request.a_str_temp_directory#events.downloaded.ics">vCal</cfmail>
<cfmodule template="mod_parse_vcal.cfm" vCalendarEvents=#a_str_ical_content# utcdiff=#session.utcdiff#>

<cfdump var="#a_array_events#">
<cfif ArrayLen(a_array_events) is 0>
	<h4>invalid ICS file</h4><cfabort>
</cfif>

<cfif len(trim(form.frmDisplayName)) is 0>
	<cfset form.frmDisplayName = a_cal_title>
</cfif>

<cfabort>

<!--- uuid for this entry --->
<cfset a_Str_entryid = CreateUUID()>

<cfquery name="q_select_properties" datasource="myCalendar" dbtype="ODBC">
INSERT INTO VirtualCalendars
(Ownerusername,OwnerUserid,Displayname,description,dt_lastrefresh,
remote,location,filename,dt_created,
httpusername,httppassword,EntryID,CalRelCalID)
VALUES
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmDisplayName#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmDescription#">,
current_timestamp,
1,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmURL#">,
'',
current_timestamp,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmHTTPUsername#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmHTTPPassword#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_Str_entryid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_cal_calid#">);
</cfquery>

<!--- select key now --->
<cfquery name="q_select_key" datasource="myCalendar">
SELECT ID FROM VirtualCalendars WHERE EntryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_Str_entryid#">;
</cfquery>

<!--- // subscribe this user to his own calendar 

	set status to 1 = active // --->
<cfquery name="q_insert_vcal_subscr" datasource="myCalendar">
INSERT INTO VirtualCalendarSubscriptions
(userid,displayname,VirtualCalendarID,status)
VALUES
(<cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmDisplayName#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_key.id#">,
1);
</cfquery>

<!--- the values are now stored in a structure ... --->
<cfloop index="ii" from="1" to="#ArrayLen(a_array_events)#">
<cfset a_Struct_tmp = a_array_events[ii]>

<!--- insert into the database --->
<cfset AddEventRequest.userid = request.stSecurityContext.myuserid>
<cfset AddEventRequest.workgroup_id = -1>
<cfset AddEventRequest.CalendarID = q_select_key.id>
<cfset AddEventRequest.title = a_Struct_tmp["title"]>
<cfset AddEventRequest.description = a_Struct_tmp["description"]>
<cfset AddEventRequest.date_start = a_struct_tmp["start"]>
<cfset AddEventRequest.date_end = a_struct_tmp["end"]>
<cfset AddEventRequest.uid = a_struct_tmp["uid"]>
<cftry>
<cfinclude template="../queries/q_insert_simple_event.cfm">
<cfcatch type="any"><cfoutput><h4>#cfcatch.Message#</h4></cfoutput></cfcatch></cftry>
<h4>description: <cfoutput>#a_Struct_tmp["description"]#</cfoutput></h4>
<b>Eintrag "<cfoutput>#AddEventRequest.title#</cfoutput>" erfolgreich importiert ...</b>
<hr size="1" noshade>
</cfloop>



</body>
</html>
