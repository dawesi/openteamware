<cfcomponent output=false>
	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfsetting requesttimeout="20000">
	
	<cfset sServiceKey = "5222B55D-B96B-1960-70BF55BD1435D273">	
	
	<cffunction access="remote" name="CreateEvent" output="false" returntype="boolean" hint="create a new event">
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings (UTC ... ) --->
		<cfargument name="usersettings" type="struct" required="true">
		<!--- userkey of owner ... --->
		<cfargument name="userkey" type="string" default="" required="false" hint="userkey of the owner (use securitycontext.myuserkey)">
		<!--- secretary key --->
		<cfargument name="secretarykey" type="string" default="" required="false" hint="event is created by a secretary (default=empty)">
		<!--- start - UTC --->
		<cfargument name="date_start" type="date" required="true" hint="start date (UTC)">
		<!--- end ... UTC --->
		<cfargument name="date_end" type="date" required="true" hint="end date (UTC)">
		<cfargument name="title" type="string" required="true" default="#CheckZerostring()#" hint="title of the event">
		<cfargument name="description" type="string" required="false" default="" hint="description of the event">
		<cfargument name="location" type="string" required="false" default="" hint="location">
		<cfargument name="priority" type="numeric" default="2" required="false" hint="priority ... 0 = low, 2 = default; 5 = important">
		<cfargument name="categories" type="string" required="false" default="" hint="categories">
		<cfargument name="privateevent" type="numeric" default="0" required="false" hint="private event (default = 0)">
		<cfargument name="entrykey" type="string" default="#CreateUUID()#" required="false" hint="entrykey of item">
		<cfargument name="type" type="numeric" default="0" required="false" hint="ignore">
		<cfargument name="virtualcalendarkey" type="string" required="false" default="" hint="virtual calendar key, leave emptry">
		
		<!--- repeating properties ... --->
		<cfargument name="repeat_type" type="numeric" default="0" required="false" hint="repating event? (0 = no; 1 = daily; 2 = weekly; 3 = monthly; 4 = yearly)">
		<cfargument name="repeat_weekdays" type="string" default="" required="false">
		<cfargument name="repeat_weekday" type="numeric" default="0" required="false" hint="if weekly, the day of the week (0 = sunday)">
		<cfargument name="repeat_day" type="numeric" default="0" required="false" hint="if monthly, day of month">
		<cfargument name="repeat_month" type="numeric" default="0" required="false" hint="if monthly, month">
		<cfargument name="repeat_until" type="date" required="false" hint="end (if empty, no end)">
		<cfargument name="repeat_day_1" type="numeric" default="0" required="false" hint="if daily, repeat on monday (NOT zero based!)">
		<cfargument name="repeat_day_2" type="numeric" default="0" required="false" hint="tuesday ...">
		<cfargument name="repeat_day_3" type="numeric" default="0" required="false">
		<cfargument name="repeat_day_4" type="numeric" default="0" required="false">
		<cfargument name="repeat_day_5" type="numeric" default="0" required="false">
		<cfargument name="repeat_day_6" type="numeric" default="0" required="false">
		<cfargument name="repeat_day_7" type="numeric" default="0" required="false">
		<cfargument name="meetingmemberscount" type="numeric" default="0" required="false" hint="number of meeting members (0 by default)">
		<cfargument name="color" type="string" default="" required="no" hint="color of item, empty by default">
		
		<cfinvoke component="#application.components.cmp_calendar#" method="CreateEvent" returnvariable="a_bol_return" argumentcollection="#arguments#"/>
		
		<cfreturn a_bol_return>
		
	</cffunction>
	
	<cffunction access="remote" name="DeleteEvent" output="false" returntype="boolean" hint="delete an event">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of event">
		<!--- the securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<!--- delete outlook sync information too? --->
		<cfargument name="clearoutlooksyncmetadata" type="boolean" required="false" default="true" hint="clear certain meta data">		
		<cfset var stReturn = 0 />
		<cfinvoke component="#application.components.cmp_calendar#" method="DeleteEvent" returnvariable="stReturn" argumentcollection="#arguments#"/>
		
		<cfreturn stReturn.result />
	</cffunction>
	
	<cffunction access="remote" name="GetEvent" output="false" returntype="struct" hint="return an event">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of event">
		<!--- the securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- the user context ... --->
		<cfargument name="usersettings" type="struct" required="true">	
		
		
		
	</cffunction>		
	
	<cffunction access="remote" name="GetEventsFromTo" output="false" returntype="struct" hint="get all events in a certain timeframe">
		<!--- start date (UTC!!) --->
		<cfargument name="startdate" type="date" required="true" hint="start date (UTC!)">
		<!--- end date --->
		<cfargument name="enddate" type="date" required="true" hint="end date (UTC!)">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings (UTC ... ) --->
		<cfargument name="usersettings" type="struct" required="true">
		<!--- search for something? --->
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false" hint="filters">
		<!--- load calendars of co-workers too?? 
		
			a comma delimtered list of userkeys of workgroup collegues --->
		<cfargument name="loadcalendarofuserkeystoo" type="string" default="" required="false" hint="n/a yet">
		<!--- load included virtual calendars? --->
		<cfargument name="loadvirtualcalendars" type="boolean" default="true" required="false" hint="n/a yet">
		<!--- load only events of workgroups where this user is REALLY a member --->
		<cfargument name="loadeventsofinheritedworkgroups" type="boolean" default="false" required="false" hint="always set to false">
		<!--- calculate repeating events? --->
		<cfargument name="calculaterepeatingevents" type="boolean" default="true" required="false" hint="create repeating events as own items in the return table (=calculate recurrencies) ... set to false if possible (true only when used for output">
		<!--- load utc times (no user adjusted times) --->
		<cfargument name="loadutctimes" type="boolean" default="false" required="false" hint="load UTC times and not user adjusted values">
			
		<cfinvoke component="#application.components.cmp_calendar#" method="GetEventsFromTo" returnvariable="stReturn" argumentcollection="#arguments#"/>
		
		<cfreturn stReturn>	
	</cffunction>			
	
	<cffunction access="remote" name="UpdateEvent" output="false" returntype="boolean" hint="update an event">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of item">
		<!--- security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">	
		<!--- usersettings --->
		<cfargument name="usersettings"	type="struct" required="yes">
		<!--- the new values ... --->
		<cfargument name="newvalues" type="struct" required="true" hint="coldfusion structure holding the data (field names are the same as in CreateEvent)">
		
		<cfinvoke component="#application.components.cmp_calendar#" method="UpdateEvent" returnvariable="stReturn" argumentcollection="#arguments#"/>
		
		<cfreturn stReturn>	
	</cffunction>
	
	<cffunction access="remote" name="CreateReminder" output="false" returntype="string" hint="Create an reminder item">
		<!--- eventkey ... --->
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of event">
		<!--- the security context ... --->
		<cfargument name="securitycontext" type="struct" required="true">		
		<!--- type
			
			1 = SMS; 0 = E-Mail; 2 = Reminder --->
		<cfargument name="type" type="numeric" default="0" required="false" hint="type ... 0 = email; 1 = sms; 2 = openTeamWare reminder (buddy)">
		<!--- UTC time to send alert --->
		<cfargument name="dt_remind" type="date" required="true" hint="UTC time to send out alert">
		<!--- email address to send to remind ... --->
		<cfargument name="emailaddress" type="string" required="false" default="" hint="email address to send alert to">
		<!--- title of the event --->
		<cfargument name="eventtitle" type="string" required="true" hint="title of event">
		<!--- eventstart --->
		<cfargument name="eventstart" type="date" required="true" hint="start of event (user adjusted time)">	
		
		<cfinvoke component="#application.components.cmp_calendar#" method="CreateReminder" returnvariable="a_string_return" argumentcollection="#arguments#"/>
		
		<cfreturn a_string_return>	
	</cffunction>		
</cfcomponent>