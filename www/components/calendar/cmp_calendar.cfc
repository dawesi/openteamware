<!--- //

	Module:		Import
	Action:		Action
	Description:	Show possible fields mappings


// --->
<cfcomponent output=false hint="Calendar component">

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cfset sServiceKey = "5222B55D-B96B-1960-70BF55BD1435D273" />

	<cffunction access="public" name="GetEventsFromTo" output="false" returntype="struct" hint="get all events in a certain timeframe">
		<cfargument name="startdate" type="date" required="true"
			hint="start date (UTC!)">
		<cfargument name="enddate" type="date" required="true"
			hint="end date (UTC!)">
		<cfargument name="securitycontext" type="struct"
			required="true">
		<cfargument name="usersettings" type="struct"
			required="true">
		<cfargument name="filter" type="struct" default="#StructNew()#" required="false"
			hint="various filters">
		<cfargument name="loadeventofsubscribedcalendars" type="boolean" default="true" required="false"
			hint="load events from virtual calendars the user is subscribed into">
		<cfargument name="loadeventsofinheritedworkgroups" type="boolean" default="false" required="false"
			hint="load only events of workgroups where this user is REALLY a member">
		<cfargument name="calculaterepeatingevents" type="boolean" default="true" required="false"
			hint="create repeating events as own items in the return table (=calculate recurrencies) ... set to false if possible (true only when used for output)">
		<cfargument name="loadutctimes" type="boolean" default="false" required="false"
			hint="load UTC times and not user adjusted values">

		<cfset var a_str_uuid = CreateUUID() />
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var stWGInfo = StructNew() />
		<cfset var q_select_events = 0 />
		<cfset var begin = GetTickCount() />
		<cfset var a_dt_start = 0 />
		<cfset var a_dt_end = 0 />
		<cfset var a_int_converted_day_start = 0 />
		<cfset var a_int_converted_day_end = 0 />
		<cfset var a_int_converted_month_start = 0 />
		<cfset var a_int_converted_month_end = 0 />
		<cfset var a_int_days_diff = 0 />
		<cfset var a_bol_workgroups_avaliable = false />
		<cfset var a_bol_vcal_avaliable = false />
		<cfset var a_bol_meeting_members_avaliable = false />
		<cfset var a_str_virtual_calendar_subscriptions = 0 />
		<cfset var q_select_workgroups = 0 />
		<cfset var q_select_meeting_members_eventskeys_by_parameter = 0 />
		<cfset var q_select_workgroup_entrykeys = 0 />
		<cfset var q_select_private_entrykeys = 0 />
		<cfset var q_select_virtual_calendars = 0 />
		<cfset var sIDList = '' />
		<cfset var sEntrykeys = '' />
		<cfset var a_str_weekday_list = '' />
		<cfset var a_int_dayofweek_start = 0 />
		<cfset var a_int_dayofweek_end = 0 />
		<cfset var a_dt_tmp_start = 0 />
		<cfset var a_dt_tmp_end = 0 />
		<cfset var q_select_collect_items_to_load = 0 />
		<cfset var q_select_meeting_members_entrykeys = 0 />
		<!--- repeating events calculation variables --->
		<cfset var a_dt_until = 0 />
		<cfset var a_dt_start_date = 0 />
		<cfset var a_int_hours_diff = 0 />
		<cfset var a_int_diff = 0 />
		<cfset var ii_day = 0 />
		<cfset var a_dt_RecurDailyTmpDate = 0 />
		<cfset var a_bol_recur_found = false />
		<cfset var ARecurFound = false />
		<cfset var a_dt_tmp_weekly_repeat_date = 0 />
		<cfset var EventCloneRequest = StructNew() />
		<cfset var a_dt_tmp_monthly_repeat_date = 0 />
		<cfset var a_dt_tmp_yearly_repeat_date = 0 />
		<cfset var a_dt_original_start = 0 />
		<cfset var a_dt_original_end = 0 />
		<cfset var a_int_col_number = 0 />
		<cfset var a_str_colname = '' />
		<cfset var a_int_add_hours_diff = 0 />

		<cfinvoke component="#application.components.cmp_security#" method="LoadPossibleWorkgroupsForAction" returnvariable="q_select_workgroups">
			<cfinvokeargument name="q_workgroup_permissions" value="#arguments.securitycontext.q_select_workgroup_permissions#">
			<cfinvokeargument name="desiredactions" value="read">
		</cfinvoke>

		<cfinclude template="queries/q_select_events.cfm">

		<cflog application="false" file="ib_load_events" log="Application" text="count: #q_select_events.recordcount#" type="information">

		<!--- include repeating events (clone events ...) ... --->
		<cfif arguments.calculaterepeatingevents>
			<cfinclude template="utils/inc_check_repeating_events.cfm">
		</cfif>

		<cfinclude template="utils/inc_select_events.cfm">

		<cfset stReturn.q_select_events = q_select_events />

		<cfif IsQuery(q_select_workgroup_entrykeys)>
			<cfset stReturn.q_select_workgroup_entrykeys = q_select_workgroup_entrykeys />
		</cfif>

		<cfif IsQuery(q_select_meeting_members_entrykeys)>
			<cfset stReturn.q_select_meeting_members_entrykeys = q_select_meeting_members_entrykeys />
		</cfif>

		<cfset stReturn.q_select_meeting_members_eventskeys_by_parameter = q_select_meeting_members_eventskeys_by_parameter />

		<cfset stReturn.q_select_private_entrykeys = q_select_private_entrykeys />

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="GetEvent" output="false" returntype="struct"
			hint="return an event">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of event">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var stReturn = GenerateReturnStruct()>
        <cfset var q_select_event = 0 />
        <cfset var q_select_meeting_members = 0 />
		<cfset var stReturn_rights = StructNew() />

		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="neededaction" value="read">
		</cfinvoke>

		<cfset stReturn.rights = stReturn_rights />

		<cfif NOT stReturn_rights.read>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<!--- load event ... --->
		<cfinclude template="queries/q_select_event.cfm">

		<!--- select meeting members ... --->
		<cfinclude template="queries/q_select_meeting_members.cfm">

		<cfset stReturn.q_select_event = q_select_event />
		<cfset stReturn.q_select_meeting_members = q_select_meeting_members />

		<cfset stReturn.rights = stReturn_rights />

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<cffunction access="public" name="DeleteEvent" output="false" returntype="struct"
			hint="delete an event">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of event">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="clearoutlooksyncmetadata" type="boolean" required="false" default="true"
			hint="delete outlook sync information too?">

		<cfset var stReturn = GenerateReturnStruct() />
        <cfset var q_delete_all_attendees = 0 />

		<!--- did the operation fail? default is yes ... --->
		<cfset var a_int_failed = 1>
		<cfset var q_select_event_raw = 0 />
		<cfset var stReturn_rights = 0 />
		<cfset var a_str_title = "" />

		<cfset var a_bol_return_save_deleted = 0 />

		<!--- check if we can now really delete the task ... --->
		<cfinvoke component="#application.components.cmp_security#" method="CheckIfActionIsAllowed" returnvariable="stReturn_rights">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="neededaction" value="delete">
		</cfinvoke>

		<cfif NOT stReturn_rights.result>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<!--- continue ... --->
		<cfinclude template="queries/q_select_event_raw.cfm">

		<cfset a_Str_title = q_select_event_raw.title />

		<cfinvoke component="#request.a_str_component_logs#" method="SaveDeletedRecord" returnvariable="a_bol_return_save_deleted">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="datakey" value="#arguments.entrykey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="query" value="#q_select_event_raw#">
			<cfinvokeargument name="title" value="#a_str_title#">
		</cfinvoke>

		<!--- call delete now ... --->
		<cfinclude template="queries/q_delete_event.cfm">
		<cfinclude template="queries/q_delete_shareddata.cfm">
		<cfinclude template="queries/q_delete_all_attendees.cfm">

		<!--- delete reminders ... --->
		<cfset DeleteReminders(securitycontext = arguments.securitycontext, eventkey = arguments.entrykey) />

		<cfif arguments.clearoutlooksyncmetadata is true>
			<!--- clear outlook sync information for all users ... --->
			<cfinclude template="queries/q_delete_outlook_meta_data.cfm">
		</cfif>

		<cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="performedaction" value="delete">
			<cfinvokeargument name="failed" value="0">
			<cfinvokeargument name="additionalinformation" value="#a_Str_title#">
		</cfinvoke>

		<!--- return the result ... --->
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<!--- edit an event ... --->
	<cffunction access="public" name="UpdateEvent" output="false" returntype="boolean"
					hint="update an event">
		<cfargument name="entrykey" type="string" required="true"
					hint="entrykey of item">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings"	type="struct" required="yes">
		<cfargument name="newvalues" type="struct" required="true"
					hint="coldfusion structure holding the data (field names are the same as in CreateEvent)">

        <cfset var q_update_event = 0 />
		<cfset var stReturn_rights = 0 />
		<!--- check if description,start,end,location or title have changed --->
        <cfset var a_bool_update_notification = false />
        <cfset var a_str_changes_desc = '' />
		<cfset var a_bol_return = true />
		<cfset var a_int_failed = 1 />
		<cfset var a_bol_return_save_deleted = false />
		<cfset var a_bol_protocol = false />

		<!--- is this user the owner of this item ... then he can do what he wants to do ... --->
		<cfif GetOwnerUserkey(arguments.entrykey) IS arguments.securitycontext.myuserkey>
			<!--- this user is the owner ... --->

			<cfset stReturn_rights = StructNew()>
			<cfset stReturn_rights.edit = true>
			<cfset stReturn_rights.managepermissions = true>

		<cfelse>

			<!--- check security ... --->
			<cfinvoke component="#application.components.cmp_security#" method="GetPermissionsForObject" returnvariable="stReturn_rights">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="object_entrykey" value="#arguments.entrykey#">
			  </cfinvoke>

		</cfif>

		 <!--- update now ... --->
		 <cfif stReturn_rights.edit>

			<!--- save original version ... --->
			<cfinclude template="queries/q_select_event_raw.cfm">

			<cfinvoke component="#request.a_str_component_logs#" method="SaveEditedRecordOldVersion" returnvariable="a_bol_return_save_deleted">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="datakey" value="#arguments.entrykey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="query" value="#q_select_event_raw#">
				<cfinvokeargument name="title" value="#q_select_event_raw.title# #q_select_event_raw.date_start#">
			</cfinvoke>

            <cfif q_select_event_raw.description NEQ arguments.newvalues.description>
                <cfset a_bool_update_notification = true>
                <cfset a_str_changes_desc = a_str_changes_desc & GetLangVal('cm_wd_description') & ':' & q_select_event_raw.description & ' -> ' & arguments.newvalues.description & '\n'>
            </cfif>
            <cfif q_select_event_raw.date_start NEQ arguments.newvalues.date_start>
                <cfset a_bool_update_notification = true>
                <cfset a_str_changes_desc = a_str_changes_desc & GetLangVal('cal_wd_start') & ':' & q_select_event_raw.date_start & ' -> ' & arguments.newvalues.date_start & '\n'>
            </cfif>
            <cfif q_select_event_raw.date_end NEQ arguments.newvalues.date_end>
                <cfset a_bool_update_notification = true>
                <cfset a_str_changes_desc = a_str_changes_desc & GetLangVal('cal_wd_end') & ':' & q_select_event_raw.date_end & ' -> ' & arguments.newvalues.date_end & '\n'>
            </cfif>
            <cfif q_select_event_raw.location NEQ arguments.newvalues.location>
                <cfset a_bool_update_notification = true>
                <cfset a_str_changes_desc = a_str_changes_desc & GetLangVal('cal_wd_location') & ':' & q_select_event_raw.location & ' -> ' & arguments.newvalues.location & '\n'>
            </cfif>
            <cfif q_select_event_raw.title NEQ arguments.newvalues.title>
                <cfset a_bool_update_notification = true>
                <cfset a_str_changes_desc = a_str_changes_desc & GetLangVal('cal_wd_title') & ':' & q_select_event_raw.title & ' -> ' & arguments.newvalues.title & '\n'>
            </cfif>


            <!--- selects new and modified meeting members preceeding to update event because after update there are no temporary meeting members --->
            <cfinclude template="queries/q_select_meeting_members_to_notify.cfm">
            <cfif a_bool_update_notification>
                <cfinclude template="queries/q_select_old_meeting_members_to_notify.cfm">
            </cfif>


		 	<!--- call update function ... --->
			<cfinclude template="queries/q_update_event.cfm">

			<!--- update outlook meta information --->
			<cfinclude template="queries/q_update_outlook_meta_data.cfm">


			<!--- send invitations to newly added meeting members and to those that has been just invited --->
			<cfloop query="q_select_meeting_members_to_notify">
				<cfinvoke component="#application.components.cmp_calendar#" method="SendInvitation" returnvariable="a_bol_return">
					<cfinvokeargument name="eventkey" value="#arguments.entrykey#">
					<cfinvokeargument name="type" value="#q_select_meeting_members_to_notify.type#">
					<cfinvokeargument name="parameter" value="#q_select_meeting_members_to_notify.parameter#">
					<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
					<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
				</cfinvoke>
			</cfloop>

			<!--- send update notification to 'old' meeting members --->
            <cfif a_bool_update_notification>
				<cfloop query="q_select_old_meeting_members_to_notify">
					<cfinvoke component="#application.components.cmp_calendar#" method="SendInvitation" returnvariable="a_bol_return">
						<cfinvokeargument name="eventkey" value="#arguments.entrykey#">
						<cfinvokeargument name="type" value="#q_select_old_meeting_members_to_notify.type#">
						<cfinvokeargument name="parameter" value="#q_select_old_meeting_members_to_notify.parameter#">
						<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
						<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
                        <cfinvokeargument name="changesDescription" value="#a_str_changes_desc#">
					</cfinvoke>
				</cfloop>
            </cfif>


			<cfif CompareNoCase(arguments.securitycontext.myuserkey, q_select_event_raw.userkey) NEQ 0>
				<!--- insert protocol --->
				<cfinvoke component="#request.a_str_component_protocol#" method="CreateProtocolEntry" returnvariable="a_bol_protocol">
					<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
					<cfinvokeargument name="servicekey" value="#sServiceKey#">
					<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
					<cfinvokeargument name="userkey" value="#q_select_event_raw.userkey#">
					<cfinvokeargument name="action" value="edit">
				</cfinvoke>
			</cfif>

			<!--- return true ... --->
			<cfset a_bol_return = true>
			<cfset a_int_failed = 0>
		 <cfelse>
		 	<!--- no right to update ... --->
			<cfset a_bol_return = false>
			<cfset a_int_failed = 1>
		 </cfif>

		 <cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
			<cfinvokeargument name="servicekey" value="#sServiceKey#">
			<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
			<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
			<cfinvokeargument name="performedaction" value="edit">
			<cfinvokeargument name="failed" value="#a_int_failed#">
		</cfinvoke>

		<cfif StructKeyExists(arguments.newvalues, 'userkey') AND Len(arguments.newvalues.userkey) GT 0>

			 <cfinvoke component="#request.a_str_component_logs#" method="CreateLogEntry">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
				<cfinvokeargument name="userkey" value="#arguments.securitycontext.myuserkey#">
				<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
				<cfinvokeargument name="performedaction" value="takeoverownership">
				<cfinvokeargument name="failed" value="#a_int_failed#">
			</cfinvoke>

		</cfif>

		<cfreturn a_bol_return>
	</cffunction>

	<cffunction access="public" name="GetSecretarykeyofevent" output="false" returntype="string">
		<cfargument name="entrykey" type="string" required="yes">

		<cfset var q_select_secretarykey_of_event = 0 />

		<cfinclude template="queries/q_select_secretarykey_of_event.cfm">

		<cfreturn q_select_secretarykey_of_event.createdbysecretarykey>
	</cffunction>

	<!--- create an event ... --->
	<cffunction access="public" name="CreateEvent" output="false" returntype="boolean" hint="create a new event">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="userkey" type="string" default="" required="false"
					hint="userkey of the owner (use securitycontext.myuserkey)">
		<cfargument name="secretarykey" type="string" default="" required="false"
					hint="event is created by a secretary (default=empty)">
		<cfargument name="date_start" type="date" required="true" hint="start date (UTC)">
		<cfargument name="date_end" type="date" required="true" hint="end date (UTC)">
		<cfargument name="date_start_end_is_utc" type="boolean" required="false" default="false"
			hint="if false, date will be converted to utc according to user settings, otherwise left as it is">
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
		<cfargument name="color" type="string" default="" required="no" hint="color of item, empty by default">
		<cfargument name="showtimeas" type="numeric" default="0">

        <cfset var q_insert_event = 0 />

		<!--- daily repeating event ... no day selected -> set all days to YES --->
		<cfif (arguments.repeat_type IS 1) AND
			  (arguments.repeat_day_1 IS 0) AND
			  (arguments.repeat_day_2 IS 0) AND
			  (arguments.repeat_day_3 IS 0) AND
			  (arguments.repeat_day_4 IS 0) AND
			  (arguments.repeat_day_5 IS 0) AND
			  (arguments.repeat_day_6 IS 0) AND
			  (arguments.repeat_day_7 IS 0)>

			  <cfset arguments.repeat_day_1 = 1>
			  <cfset arguments.repeat_day_2 = 1>
			  <cfset arguments.repeat_day_3 = 1>
			  <cfset arguments.repeat_day_4 = 1>
			  <cfset arguments.repeat_day_5 = 1>
			  <cfset arguments.repeat_day_6 = 1>
			  <cfset arguments.repeat_day_7 = 1>

		</cfif>

		<!--- insert now ... --->
		<cfinclude template="queries/q_insert_event.cfm">

		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="IsAttendeeOfEvent" output="false" returntype="boolean">
		<cfargument name="eventkey" type="string" required="true">
		<cfargument name="userkey" type="string" required="true">

        <cfset var q_select_is_attendee_of_event = 0 />
		<cfinclude template="queries/q_select_is_attendee_of_event.cfm">

		<cfif q_select_is_attendee_of_event.count_id IS 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>

	</cffunction>

    <cffunction access="public" name="CleanUpAndCloneMeetingMembers" output="false">
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of event">
        <cfinclude template="queries/q_begin_temporary_attendees.cfm"/>
    </cffunction>

	<cffunction access="public" name="AddAttendeeToEvent" output="false" returntype="struct"
        	hint="adds an attendee to an event if such doesn't exist yet (works always just with temporary attendees). Adds contact (type 1) if type was email (2) and there's contact with such email">
		<cfargument name="eventkey" type="string" required="true"
			hint="entrykey of event">
		<cfargument name="type" type="numeric" default="0"
			hint="0 = workgroup_member; 1 = Address Book; 2 = Simple E-Mail Address, 4 = resource">
		<cfargument name="parameter" type="string" required="true"
			hint="parenter ... depends on type (entrykey of f.e. (2: the email address)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var stReturn = GenerateReturnStruct() />
        <cfset var q_insert_attendee = 0 />
		<cfset var stCRMFilter = 0 />

		<cfset var stReturn_search_contact = 0 />

		<cfset stReturn.a_bol_new = false />

        <!--- if it is email address we want to add than check if there's contact
			with such email address and if yes add contact -> type 1 --->

        <cfif arguments.type EQ 2>

			<cfset stCRMFilter = StructNew() />
			<cfset stCRMFilter = application.components.cmp_crmsales.AddTempCRMFilterStructureCriteria(CRMFilterStructure = stCRMFilter,
									operator = 0,
									internalfieldname = 'email_prim',
									comparevalue = ExtractEmailAdr(arguments.parameter)) />

			<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_search_contact">
				<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
				<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
				<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
				<!--- only select accounts ... --->
				<cfinvokeargument name="filterdatatypes" value="0">
				<cfinvokeargument name="CacheLookupData" value="false">
			</cfinvoke>

			<cfif stReturn_search_contact.q_select_contacts.recordcount IS 1>
				<!--- there is an contact for this email address so add the meeting member as contact --->
                <cfset arguments.type = 1 />
                <cfset arguments.parameter = stReturn_search_contact.q_select_contacts.entrykey />
			</cfif>
        </cfif>


        <!--- was such participant already added (of same type and parameter value)? --->
		<cfinclude template="queries/q_select_check_already_invited.cfm">

		<cfif q_select_check_already_invited.count_id IS 0>
			<cfset stReturn.a_bol_new = true />
			<cfinclude template="queries/q_insert_attendee.cfm">

			<!--- update activity index of contact ... --->
			<cfif arguments.type IS 1>
				<cfset application.components.cmp_crmsales.UpdateActivityCountOfContact(objectkey = arguments.parameter,
														servicekey = '52227624-9DAA-05E9-0892A27198268072',
														itemtype = 'appointments') />
			</cfif>

		<cfelse>
			<cfset stReturn.a_bol_new = false />
		</cfif>

		<!--- set the result to true --->
		<cfset stReturn.result = true />
		<cfreturn stReturn />

	</cffunction>

	<!--- remove an attendee from an event ... --->
	<cffunction access="public" name="DeleteAttendeeFromEvent" output="false" returntype="struct">
		<!--- the eventkey ... --->
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of event">
		<!--- the type ... 0 = workgroup member; 1 = address book; 2 = email only--->
		<cfargument name="type" type="numeric" required="true" hint="0 = workgroup_member; 1 = Address Book; 2 = Simple E-Mail Address ...">
		<!--- the parameter (entrykey or email address) or if not specified all records of the provided type will be deleted --->
		<cfargument name="parameter" type="string" required="true" hint="parameter ... depends on type (entrykey of f.e. (2: the email address)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="yes">

		<cfset var stReturn = GenerateReturnStruct() />

		<cfset var q_delete_attendee = 0 />

		<cfinclude template="queries/q_delete_attendee.cfm">

		<!--- update activity index of contact ... --->
		<cfif arguments.type IS 1>
			<cfset application.components.cmp_crmsales.UpdateActivityCountOfContact(objectkey = arguments.parameter,
													servicekey = '52227624-9DAA-05E9-0892A27198268072',
													itemtype = 'appointments') />
		</cfif>

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="GetInvitations" output="false" returntype="query">
		<cfargument name="securitycontext" type="struct" required="yes">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="filer" type="struct" required="no" default="#StructNew()#">

		<cfset var q_select_invitations = 0 />

		<cfinclude template="queries/q_select_invitations.cfm">

		<cfreturn q_select_invitations />
	</cffunction>

	<!--- send invitations ... --->
	<cffunction access="public" name="SendInvitation" output="false" returntype="boolean" hint="Send out an invitation by email">
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of event">
		<cfargument name="type" type="numeric" default="0" hint="same as addAttendee (0 = workgroup member; 1 = address book; 2 = email only)">
		<cfargument name="parameter" type="string" required="true" hint="the parameter (entrykey or email address)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="changesDescription" type="string" required="false" default=""
			hint="Description which fields have been updated/changed (user has received already invitation)">
		<cfargument name="isreminder" type="boolean" default="false" required="false"
			hint="is this a first time invitation or a reminder?">

        <cfset var a_bol_isUpdate = (LEN(arguments.changesDescription) GT 0) />
		<cfset var a_str_reminder_methods = 'email' />
		<cfset var stReturn = 0 />
		<cfset var q_select_event = 0 />
		<cfset var a_str_recipient = '' />
		<cfset var q_select_inviting_user = 0 />
		<cfset var q_select_meeting_members = 0 />
		<cfset var a_struct_load_mm_userdata = 0 />
		<cfset var a_str_name = '' />
		<cfset var stReturn_contact = 0 />
		<cfset var q_select_invited_user = 0 />
		<cfset var iLangNo = 0 />
		<cfset var a_str_text_part = '' />
		<cfset var a_str_mail_subject = '' />
		<cfset var a_str_from_adr = '' />
		<!--- get used style ... --->
		<cfset var a_str_user_style = application.components.cmp_user.GetUserCustomStyle(userkey = arguments.securitycontext.myuserkey) />
		<cfset var a_str_sender_address = application.components.cmp_customize.GetCustomStyleData(usersettings = arguments.usersettings, entryname = 'mail').FeedbackMailSender />
		<cfset var a_str_base_url = application.components.cmp_customize.GetCustomStyleData(usersettings = arguments.usersettings, entryname = 'main').BaseURL />
		<cfset var a_str_product_name = application.components.cmp_customize.GetCustomStyleData(usersettings = arguments.usersettings, entryname = 'main').Productname />
		<cfset var a_struct_medium_logo = application.components.cmp_customize.GetCustomStyleData(usersettings = arguments.usersettings, entryname = 'medium_logo') />
		<cfset var a_str_header = application.components.cmp_content.GetCompanyCustomElement(companykey = arguments.securitycontext.mycompanykey, elementname = 'mail_header') />
		<cfset var a_str_footer = application.components.cmp_content.GetCompanyCustomElement(companykey = arguments.securitycontext.mycompanykey, elementname = 'mail_footer') />

		<!--- is this user interested in such an reminder? all other: use email --->
		<cfif arguments.type IS 0>
			<cfinvoke component="#application.components.cmp_user#" method="GetAlertOnNewItemsSettings" returnvariable="a_str_reminder_methods">
				<cfinvokeargument name="userkey" value="#arguments.parameter#">
				<cfinvokeargument name="servicekey" value="#sServiceKey#">
			</cfinvoke>
		</cfif>

		<cfif Len(a_str_reminder_methods) IS 0>
			<cfreturn false />
		</cfif>

		<!--- load the event --->
		<cfset stReturn = GetEvent(entrykey = arguments.eventkey, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings) />

		<cfif NOT stReturn.result>
			<cfreturn false />
		</cfif>

		<cfset q_select_event = stReturn.q_select_event />

		<!--- send invitation ... --->
		<cfif ListFind(a_str_reminder_methods, 'email') GT 0>
			<cfinclude template="utils/inc_sendinvitation.cfm">
		</cfif>

		<cfif ListFind(a_str_reminder_methods, 'sms') GT 0>
			<cfinclude template="utils/inc_send_sms.cfm">
		</cfif>

		<cfreturn true />
	</cffunction>

	<!--- load all reminders ... --->
	<cffunction name="GetReminders" access="public" output="false" returntype="query" hint="Return reminders for an event">
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of event">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var q_select_reminders = 0 />

		<cfinclude template="queries/q_select_reminders.cfm">

		<cfreturn q_select_reminders />
	</cffunction>

	<cffunction access="public" name="CreateReminder" output="false" returntype="string" hint="Create an reminder item">
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of event">
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- type

			1 = SMS; 0 = E-Mail; 2 = Reminder --->
		<cfargument name="type" type="numeric" default="0" required="false" hint="type ... 0 = email; 1 = sms; 2 = openTeamware.com reminder (buddy)">
		<!--- UTC time to send alert --->
		<cfargument name="dt_remind" type="date" required="true" hint="UTC time to send out alert">
		<!--- email address to send to remind ... --->
		<cfargument name="emailaddress" type="string" required="false" default="" hint="email address to send alert to">
		<!--- title of the event --->
		<cfargument name="eventtitle" type="string" required="true" hint="title of event">
		<!--- eventstart --->
		<cfargument name="eventstart" type="date" required="true" hint="start of event (user adjusted time)">

		<cfset var sEntrykey = CreateUUID() />
		<cfset var q_insert_reminder = 0 />

		<cfinclude template="queries/q_insert_reminder.cfm">

		<cfreturn sEntrykey />
	</cffunction>

	<cffunction access="public" name="DeleteReminders" output="false" returntype="boolean" hint="delete all reminders for a certain appointment">
		<cfargument name="eventkey" type="string" required="true" hint="entrykey of the appointment">
		<cfargument name="securitycontext" type="struct" required="true">

		<cfset var q_delete_reminders = 0 />
		<cfinclude template="queries/q_delete_reminders.cfm">

		<cfreturn true />

	</cffunction>

	<!--- transfer the ownership of an item ... --->
	<cffunction access="public" name="TransferOwnership" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of object">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="newuserkey" type="string" default="">

		<cfset var a_struct = StructNew() />
		<cfset var a_bol_return = false />
		<cfset a_struct.userkey = arguments.newuserkey />



		<cfreturn a_bol_return />
	</cffunction>

	<!--- get the userkey of the owner of an object ... --->
	<cffunction access="public" name="GetOwnerUserkey" returntype="string" output="false">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the calendar item">

		<cfset var q_select_owner_userkey = 0 />

		<cfinclude template="queries/q_select_owner_userkey.cfm">

		<cfreturn q_select_owner_userkey.userkey />
	</cffunction>

	<cffunction access="public" name="GetMeetingMembers" returntype="query" output="false">
		<!--- the entrykey ... --->
		<cfargument name="entrykey" type="string" default="" required="false">
		<!--- optional ... --->
		<cfargument name="entrykeys" type="string" default="" required="false">
        <cfargument name="temporary" type="boolean" default="false" required="false">

        <cfset var q_select_meeting_members = 0 />
		<cfinclude template="queries/q_select_meeting_members.cfm">

		<cfreturn q_select_meeting_members>
	</cffunction>

	<cffunction access="public" name="SetSendInvitationFlag" returntype="boolean" output="false"
			hint="Update SendInvitation flag (0 or 1) for temporary meeting member">
		<cfargument name="eventkey" type="string" required="true">
		<cfargument name="parameter" type="string" required="true">
		<cfargument name="type" type="numeric" required="true" >
		<cfargument name="sendinvitation" type="boolean" required="true">

		<cfset var q_update_send_invitation_flag = 0 />
		<cfset var sendinvitationnr = 0 />

		<cfif arguments.sendinvitation>
    		<cfset sendinvitationnr = 1 />
		</cfif>

		<cfinclude template="queries/q_update_send_invitation_flag.cfm">
		<cfreturn true />
	</cffunction>


	<cffunction access="public" name="SetAttendeeStatus" returntype="boolean" output="false">
		<cfargument name="eventkey" type="string" required="true">
		<cfargument name="parameter" type="string" required="true">
		<cfargument name="type" type="numeric" required="true" default="0">
		<cfargument name="status" type="numeric" required="false" default="0">
		<cfargument name="comment" type="string" required="false" default="">

		<cfset var q_update_attendee_status = 0 />

		<cfinclude template="queries/q_update_attendee_status.cfm">

		<cfreturn true />
	</cffunction>

	<cffunction access="public" name="GetOpenInvitations" returntype="query" output="false">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="yes">

		<cfinclude template="queries/q_select_open_invitations.cfm">

		<cfreturn q_select_open_invitations>
	</cffunction>

	<!--- return the total number of own records ... --->
	<cffunction access="public" name="GetOwnRecordsRecordcount" output="false" returntype="numeric">
		<cfargument name="userkey" type="string" required="true">

		<cfinclude template="queries/q_select_own_events_recordcount.cfm">

		<cfreturn VAL(q_select_own_events_recordcount.count_id)>
	</cffunction>

	<cffunction access="public" name="SendAppointmentReminder" output="false" returntype="struct"
				hint="Send out an reminder for an event">
		<cfargument name="eventkey" type="string" hint="entrykey of item in event">
		<cfargument name="type" type="numeric" default="0" hint="same as addAttendee (0 = workgroup member; 1 = address book; 2 = email only)">
		<cfargument name="parameter" type="string" required="true" hint="the parameter (entrykey or email address)">
		<cfargument name="userkey" type="string" hint="userkey of the event">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_str_ownerkey_of_event = '' />

		<cfinclude template="utils/inc_send_appointment_reminder.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="GetCalendarItemsWithoutReports" output="false" returntype="struct"
			hint="Return _open_ calendar events in the past which are not yet set to 'done'">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="yes">

		<cfset var stReturn = GenerateReturnStruct()>

		<cfinclude template="utils/inc_load_appointments_meeting_members_undone.cfm">

		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>

	<cffunction name="SetTodayNotice" returntype="struct" output="false" access="public"
			hint="set the today notice for a certain data">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="dt_date" type="date" required="true">
		<cfargument name="shortnotice" type="string" required="true">

		<cfset var stReturn = GenerateReturnStruct()>


		call query ...

		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>

	<cffunction access="public" name="DeleteTodayNotice" output="false"
			hint="delete a today notice" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="yes">
		<cfargument name="entrykey" type="string" required="true">

		<cfset var stReturn = GenerateReturnStruct()>


		call query ...

		<cfset stReturn.result = true>
		<cfreturn stReturn>
	</cffunction>

</cfcomponent>
