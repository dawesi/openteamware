
<cfif NOT CheckSimpleLoggedIn()>
	<cfabort>
</cfif>

<!--- user/resource --->
<cfparam name="url.type" type="string" default="user">
<cfparam name="url.ressourcekeys" type="string" default="">

<cfparam name="url.entrykey" type="string" default="">
<cfparam name="url.userkeys" type="string" default="">
<cfparam name="url.servicekey" type="string" default="">

<cfparam name="url.startdatetime" type="string" default="">
<cfparam name="url.enddatetime" type="string" default="">
<cfparam name="url.objectname" type="string" default="">


<cfset a_dt_start = LSParseDateTime(url.startdatetime)>

<!--- add one hour ... --->
<cfset a_dt_end = DateAdd('h', 1, a_dt_start)>

<cfset a_dt_today = CreateDate(Year(a_dt_start), Month(a_dt_start), Day(a_dt_start))>

<cfinclude template="/common/scripts/script_utils.cfm">
<html>
<head>
<cfinclude template="../../../../style_sheet.cfm">
<title>Verfuegbarkeit pruefen</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<div class="mischeader bb" style="padding:8px;"><b>Verfuegbarkeit pruefen</b></div><br>

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td align="right">Geplanter Eintrag:</td>
    <td>
	<b><cfoutput>#CheckZerostring(url.objectname)#</cfoutput></b>
	</td>
  </tr>
  <tr>
    <td align="right">Geplanter Start:</td>
    <td>
	<cfoutput>#TimeFormat(a_dt_start, 'HH:mm')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right">Geplante Dauer:</td>
    <td>
	1h
	</td>
  </tr>
</table>
<br>
<cfif Len(url.userkeys) IS 0>
	<b>Sie haben keine Teilnehmer ausgewaehlt</b>
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_start_display = Hour(a_dt_start) - 3>
<cfset a_int_end_display = a_int_start_display + 12>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
  	<td class="bb bt">
	Teilnehmer
	</td>
	<cfloop from="#a_int_start_display#" to="#a_int_end_display#" step="1" index="a_int_hour">
	
	<cfset a_dt_display = DateAdd('h', a_int_hour, a_dt_today)>
    <td width="15" class="bl bb bt" align="center">
	<cfoutput>#Hour(a_dt_display)#</cfoutput>
	</td>
	</cfloop>
  </tr>
  <cfloop list="#url.userkeys#" delimiters="," index="a_str_userkey">
  
  <!--- load events for this user of this day ... --->
  <cfinvoke component="/components/management/users/cmp_load_userdata"  method="LoadUserData" returnvariable="a_struct_userdata">
  	<cfinvokeargument name="entrykey" value="#a_str_userkey#">
  </cfinvoke>
  
  <cfset q_select_user = a_struct_userdata.query>
  
	<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_userkey">
		<cfinvokeargument name="userkey" value="#a_str_userkey#">
	</cfinvoke>
	
	<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stReturn_usersettings">
		<cfinvokeargument name="userkey" value="#a_str_userkey#">
	</cfinvoke>	

	<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="a_struct_user_return">
		<cfinvokeargument name="startdate" value="#a_dt_start#">
		<cfinvokeargument name="enddate" value="#DateAdd('d', 1, a_dt_start)#">
		<cfinvokeargument name="securitycontext" value="#stReturn_userkey#">
		<cfinvokeargument name="usersettings" value="#stReturn_usersettings#">
	</cfinvoke>  
  
  <cfset q_select_events = a_struct_user_return.q_select_events>  
  <tr>
    <td width="100" class="bb">
	<cfoutput>	
	<cfif q_select_user.smallphotoavaliable IS 1>
		<img src="/tools/img/show_small_userphoto.cfm?entrykey=#urlencodedformat(q_select_user.entrykey)#">
		<br>
	</cfif>
	#q_select_user.surname#, #q_select_user.firstname#
	</cfoutput>
	</td>
	
	<cfloop from="#a_int_start_display#" to="#a_int_end_display#" step="1" index="a_int_hour">

	<cfset a_bol_event_found = false>	
	
	<cfloop query="q_select_events">
		<cfset a_int_hour_start = q_select_events.starthour>
		<cfset a_int_hours_diff = DateDiff('h', q_select_events.date_start, q_select_events.date_end)>
		
		<cfset a_int_hour_end = a_int_hours_diff+a_int_hour_start>
	
		<cfif (Compare(a_int_hour, a_int_hour_start) IS 0) OR
			  (
			  	(a_int_hour LTE a_int_hour_end)
				AND
				(a_int_hour GTE a_int_hour_start)
				
			  )>
			<cfset a_bol_event_found = true>
		</cfif>
	</cfloop>	
	<cfset a_int_rand_range = RandRange(1, 5)>
	
	<cfif NOT a_bol_event_found>
		<cfset a_str_colour = 'lightgreen'>
	<cfelse>
		<cfset a_str_colour = 'red'>		
	</cfif>
	
    <td width="15" class="bl bb" style="background-color:<cfoutput>#a_str_colour#</cfoutput>;">&nbsp;	
	</td>
	</cfloop>
	
  </tr>
  </cfloop>
</table>

</body>
</html>
