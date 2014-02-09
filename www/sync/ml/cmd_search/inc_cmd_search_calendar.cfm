<!--- //

	Module:		WebDAV Service for syncML Server
	Description:Search appointments
	

// --->
<!--- load restrictions for calendar ... --->
<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_calendar"
	defaultvalue1 = "private"
	savesettings = true
	userid = #request.a_struct_security_context.myuserid#	
	setcallervariable1 = "a_str_restriction_calendar">	
	
<cfmodule template="/common/person/getuserpref.cfm"
	entrysection = "mobilesync"
	entryname = "restrictions_calendar_timeframe"
	defaultvalue1 = "futureandlatepast"
	savesettings = true
	userid = #request.a_struct_security_context.myuserid#	
	setcallervariable1 = "a_str_restriction_calendar_timeframe">

<!--- timeframe ... --->
<cfswitch expression="#a_str_restriction_calendar_timeframe#">
	
	<cfcase value="futureonly">
		<!--- future only ... --->
		<cfset a_dt_start_date = CreateDate(Year(Now()), Month(Now()), Day(Now())) />		
		<cfset a_dt_end_date = CreateDate(2020, 1, 1) />
	</cfcase>
	
	<cfcase value="all">
		<cfset a_dt_start_date = CreateDate(1900, 1, 1) />
		<cfset a_dt_end_date = CreateDate(2020, 1, 1) />
	</cfcase>
	
	<cfdefaultcase>
		<!--- default = futureandlatepast ... go back 14 days --->
		<cfset a_dt_start_date = DateAdd('d', -14, Now()) />
		<cfset a_dt_start_date = CreateDate(Year(a_dt_start_date), Month(a_dt_start_date), Day(a_dt_start_date)) />
		
		<cfset a_dt_end_date = CreateDate(2020, 1, 1) />
	</cfdefaultcase>
	
</cfswitch>

<cfset stReturn_calendar = application.components.cmp_calendar.GetEventsFromTo(securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					startdate = a_dt_start_date,
					enddate = a_dt_end_date,
					filter = a_struct_filter,
					loadcalendarofuserkeystoo = '',
					loadvirtualcalendars = true,
					loadeventsofinheritedworkgroups = false,
					calculaterepeatingevents = false,
					loadutctimes = true) />
			
<cfset q_select_calendar = stReturn_calendar.q_select_events />

<cflog text="--------- q_select_calendar.recordcount: #q_select_calendar.recordcount#" type="Information" log="Application" file="ib_syncml_calendar">

<cfoutput query="q_select_calendar">
	<cflog text="--------- title: #q_select_calendar.title#" type="Information" log="Application" file="ib_syncml_calendar">
</cfoutput>

<cfswitch expression="#a_str_restriction_calendar#">
	<cfcase value="all">
		<!--- all events ... --->
	</cfcase>
	<cfcase value="private">
		<!--- private events only ... --->
		<cfset sEntrykeys_to_load = 'dummyentry' />
		
		<cfloop query="q_select_calendar">
			<cfif CompareNoCase(request.a_struct_security_context.myuserkey, q_select_calendar.userkey) IS 0>
				<cfset sEntrykeys_to_load = ListAppend(sEntrykeys_to_load, q_select_calendar.entrykey) />
			</cfif>
		</cfloop>
		
		<cfquery name="q_select_calendar" dbtype="query">
		SELECT
			*
		FROM
			q_select_calendar
		WHERE
			entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys_to_load#" list="yes">)
		;
		</cfquery>
		
	</cfcase>
</cfswitch>


<cfquery name="q_select_calendar" dbtype="query">
SELECT
	*,0 AS int_end_num
FROM
	q_select_calendar
;
</cfquery>

<cfloop query="q_select_calendar">
	<cfset querySetCell(q_select_calendar, 'int_end_num', DateFormat(q_select_calendar.date_end, 'yyyymmdd') & TimeFormat(q_select_calendar.date_end, 'hhmm'), q_select_calendar.currentrow)>
</cfloop>

<!--- remove ignore items ... --->
<cfif q_select_ignore_items.recordcount GT 0>

	<cfquery name="q_select_calendar" dbtype="query">
	SELECT
		*
	FROM
		q_select_calendar
	WHERE
		NOT entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_ignore_items.entrykey)#" list="yes">)
	;
	</cfquery>
</cfif>


<cfif StructCount(a_struct_internal_filter) GT 0>
	<!--- ... --->
	
	<cflog text="internal filter applies ..." type="information" log="application" file="ib_syncml">
	<cflog text="original q_select_calendar.recordcount: #q_select_calendar.recordcount#" type="information" log="application" file="ib_syncml">
	
	<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="q_select_calendar" type="html">
		<cfdump var="#q_select_calendar#" label="q_select_calendar">
		<cfdump var="#a_struct_internal_filter#" label="a_struct_internal_filter">
	</cfmail>--->
	
	<cfloop query="q_select_calendar">
		<cflog text="    original query a_int_dt_start: #q_select_calendar.INT_START_NUM#" type="information" log="application" file="ib_syncml">
	</cfloop>
	
	<cfquery name="q_select_calendar" dbtype="query">
	SELECT
		*
	FROM
		q_select_calendar
	WHERE
		(INT_START_NUM > 0)

	<!--- loop through the provided search parameters ... --->	
	<cfloop list="#StructKeyList(a_struct_internal_filter)#" index="a_str_item">
	
		<cflog text=" --- item #a_str_item#: #a_struct_internal_filter[a_str_item]#" type="information" log="application" file="ib_syncml">
		
		<cfif Len(a_struct_internal_filter[a_str_item]) GT 0>
		
			<cflog text="internal filter applies ... parameter #a_str_item#: #a_struct_internal_filter[a_str_item]#" type="information" log="application" file="ib_syncml">
		
			<cfswitch expression="#a_str_item#">
				<cfcase value="date_start">
					<cfset a_int_dt_start = DateFormat(a_struct_internal_filter[a_str_item], 'yyyymmdd') & TimeFormat(a_struct_internal_filter[a_str_item], 'hhmm')>
					
					AND (INT_START_NUM = #a_int_dt_start#)
					
					<cflog text="a_int_dt_start: #a_int_dt_start#" type="information" log="application" file="ib_syncml">
					
				</cfcase>
				<cfcase value="date_end">
					
					<cfset a_int_dt_end = DateFormat(a_struct_internal_filter[a_str_item], 'yyyymmdd') & TimeFormat(a_struct_internal_filter[a_str_item], 'hhmm')>
					
					AND (int_end_num = #a_int_dt_end#)
					
					<cflog text="a_int_dt_end: #a_int_dt_end#" type="information" log="application" file="ib_syncml">
					
				</cfcase>
				<cfcase value="location">
				
					<cfif Len(a_struct_internal_filter[a_str_item]) GT 0>
						AND (location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_struct_internal_filter[a_str_item]#">)
					</cfif>
				</cfcase>
			</cfswitch>
		
		</cfif>

	</cfloop>
	;
	</cfquery>
	
	<cflog text="internal filter applies ... q_select_calendar.recordcount: #q_select_calendar.recordcount#" type="information" log="application" file="ib_syncml">

</cfif>

<?xml version="1.0" ?> 
<!--- changed --->
<a:multistatus xmlns:a="DAV:" xmlns="<cfoutput>#xmlformat(request.a_struct_action.path_info)#</cfoutput>">
	<cfif q_select_calendar.recordcount EQ 0>
		<cfif a_bol_select_by_id>
			<cfheader statuscode="404">
			<cfset request.a_struct_response_headers.statuscode = 404>
		</cfif>
	<cfelse>
		<cfoutput query="q_select_calendar">
		
		<!---
		<cfif FindNoCase('Nokia_6', request.q_select_device.manufactor_model) IS 1>
			<!--- 60-series ... make date/time local time --->
			<cfset tmp = QuerySetCell(q_select_calendar, 'date_start', DateAdd('h', -request.stUserSettings.utcdiff, q_select_calendar.date_start), q_select_calendar.currentrow)>
			<cfset tmp = QuerySetCell(q_select_calendar, 'date_end', DateAdd('h', -request.stUserSettings.utcdiff, q_select_calendar.date_end), q_select_calendar.currentrow)>
		</cfif>
		--->
		
		<a:response> 
			<a:href>#xmlformat('http://' & cgi.SERVER_NAME & request.a_struct_action.path_info & q_select_calendar.entrykey)#</a:href>
			<a:propstat>
				<a:status>HTTP/1.1 200 OK</a:status>
				<a:prop>
					<repluid>rid:#q_select_calendar.entrykey#</repluid>
					<isfolder>0</isfolder>
					<getlastmodified>#DateFormat(q_select_calendar.dt_lastmodified, "yyyy-mm-dd")# #TimeFormat(q_select_calendar.dt_lastmodified, "HH:mm:ss")#</getlastmodified>
				<cfif a_bol_diff_select>
					<creationdate>#DateFormat(q_select_calendar.dt_created, "yyyy-mm-dd")# #TimeFormat(q_select_calendar.dt_created, "HH:mm:ss")#</creationdate>
					<href>#q_select_calendar.entrykey#</href>
				<cfelse>
					<location>#XMLFormat(q_select_calendar.location)#</location>
					<subject>#XMLFormat(q_select_calendar.title)#</subject>
					<textdescription>#XMLFormat(q_select_calendar.description)#</textdescription>
					<cflog text="dtstart: #DateFormat(q_select_calendar.date_start, 'yyyymmdd')#T#TimeFormat(q_select_calendar.date_start, 'HHmmss')#Z" type="information" log="application" file="ib_syncml">
					<dtstart>#DateFormat(q_select_calendar.date_start, 'yyyy-mm-dd')#T#TimeFormat(q_select_calendar.date_start, 'HH:mm:ss')#Z</dtstart>
					<!---<dtstart>#DateFormat(q_select_calendar.date_start, "yyyy-mm-dd")# #TimeFormat(q_select_calendar.date_start, "HH:mm:ss")#</dtstart>--->
					<!---<dtend>#DateFormat(q_select_calendar.date_end, "yyyy-mm-dd")# #TimeFormat(q_select_calendar.date_end, "HH:mm:ss")#</dtend>--->
					<dtend>#DateFormat(q_select_calendar.date_end, 'yyyy-mm-dd')#T#TimeFormat(q_select_calendar.date_end, 'HH:mm:ss')#Z</dtend>
					<timezoneid>#request.stUserSettings.utcdiff#</timezoneid>
					<alldayevent/>
					<sequence/>
					<duration/>
					<busystatus/>
				</cfif>  
				</a:prop>
			</a:propstat>
		</a:response>
		</cfoutput>
	</cfif>
</a:multistatus>


