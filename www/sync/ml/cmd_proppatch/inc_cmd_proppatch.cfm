<!--- //

	Module:		WebDAV SyncML
	Description: 
	

// --->
<cfcontent type="text/xml">
<cfset request.a_struct_response_headers.type = 'text/xml'>
<cfheader statuscode="207">
<cfset request.a_struct_response_headers.statuscode = 207>

<cfset a_bool_create = false />
<cfset a_bool_result = false />

<!--- recongize if it is create request or update request. In case of create - new UUID will be created --->
<cfif not IsDefined('request.a_struct_action.a_str_item_entry_key')>
	<cfset request.a_struct_action.a_str_item_entry_key = CreateUUID() />
	<cfset a_bool_create = true />
</cfif>

<cfheader name="Repl-UID" value="<rid:#request.a_struct_action.a_str_item_entry_key#>">
<cfset request.a_struct_response_headers.ReplUID = '<rid:#request.a_struct_action.a_str_item_entry_key#>'>

<!--- create/update contacts --->
<cfif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_contacts) IS 0>
	<cfinclude template="inc_parse_contact.cfm">
	
	<cfif StructKeyExists(request.a_struct_contact, 'categories')>
		<cfif ListFindNoCase(request.a_struct_contact.categories, 'mobile') IS 0>
			<cfset request.a_struct_contact.categories = ListAppend(request.a_struct_contact.categories, 'mobile')>
		</cfif>
	<cfelse>
		<cfset request.a_struct_contact.categories = 'mobile'>
	</cfif>
	
	<cfif NOT a_bool_create>
		<!--- save wddx copy of this element! --->
		<cfwddx action="cfml2wddx" input="#request.a_struct_contact#" output="a_str_wddx" usetimezoneinfo="yes">
		
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="cfml 2 wddx" type="html">
			<cfdump var="#a_str_Wddx#">
		</cfmail>
	
	</cfif>
			
	<cfif a_bool_create>
	
		<cfset a_bool_result = application.components.cmp_addressbook.CreateContact(entrykey = request.a_struct_action.a_str_item_entry_key,
					securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					firstname = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'firstname'),
					surname = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'surname'),
					company = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'company'),
					department = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'department'),
					position = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'position'),
					title = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'title'),
					sex = val(CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'sex')),
					email_prim = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'email_prim'),
					email_adr = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'email_adr'),
					birthday = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'birthday'),
					categories = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'categories'),
					b_street = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_street'),
					b_city = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_city'),
					b_zipcode = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_zipcode'),
					b_country = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_country'),
					b_telephone = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_telephone'),
					b_fax = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_fax'),
					b_mobile = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_mobile'),
					b_url = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'b_url'),
					p_street = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_street'),
					p_city = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_city'),
					p_zipcode = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_zipcode'),
					p_country = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_country'),
					p_telephone = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_telephone'),
					p_fax = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_fax'),
					p_mobile = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_mobile'),
					p_url = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'p_url'),
					notice = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'notice'),
					archiveentry = val(CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'archiveentry')),
					sender = 'syncml',
					contacttype = val(CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'contacttype')),
					parentcontactkey = CheckStructkeyExistsAndReturnValue(request.a_struct_contact, 'parentcontactkey')
					).result />
	<cfelse>
	
		<cfset a_bool_result = application.components.cmp_addressbook.UpdateContact(entrykey = request.a_struct_action.a_str_item_entry_key,
					securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					newvalues = request.a_struct_contact,
					updatelastmodified = true,
					sender = 'syncml').result />
	</cfif>

<!--- create/update calendar --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_calendar) IS 0>
	<cfinclude template="inc_parse_calendar.cfm">
	
	<cfif StructKeyExists(request.a_struct_calendar, 'categories')>
		<cfif ListFindNoCase(request.a_struct_calendar.categories, 'mobile') IS 0>
			<cfset request.a_struct_calendar.categories = ListAppend(request.a_struct_calendar.categories, 'mobile')>
		</cfif>
	<cfelse>
		<cfset request.a_struct_calendar.categories = 'mobile'>
	</cfif>
		
	<cfif a_bool_create>
		<cfset a_bool_result = application.components.cmp_calendar.CreateEvent(entrykey = request.a_struct_action.a_str_item_entry_key,
					securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					userkey = request.a_struct_security_context.myuserkey,
					secretarykey = '',
					date_start = request.a_struct_calendar.date_start,
					date_end = request.a_struct_calendar.date_end,
					title = CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'title'),
					description = CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'description'),
					location = CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'location'),
					priority = val(CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'priority')), 
					categories = CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'categories'), 
					privateevent = val(CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'privateevent')), 
					type = val(CheckStructkeyExistsAndReturnValue(request.a_struct_calendar, 'type')), 
					virtualcalendarkey = '') />
					
					<!--- repeat_type = request.a_struct_calendar.repeat_type,
					repeat_weekdays = request.a_struct_calendar.repeat_weekdays,
					repeat_weekday = request.a_struct_calendar.repeat_weekday, 
					repeat_day = request.a_struct_calendar.repeat_day, 
					repeat_month = request.a_struct_calendar.repeat_month, 
					repeat_until = request.a_struct_calendar.repeat_until, 
					repeat_day_1 = request.a_struct_calendar.repeat_day_1, 
					repeat_day_2 = request.a_struct_calendar.repeat_day_2, 
					repeat_day_3 = request.a_struct_calendar.repeat_day_3, 
					repeat_day_4 = request.a_struct_calendar.repeat_day_4,
					repeat_day_5 = request.a_struct_calendar.repeat_day_5, 
					repeat_day_6 = request.a_struct_calendar.repeat_day_6, 
					repeat_day_7 = request.a_struct_calendar.repeat_day_7, 
					meetingmemberscount = request.a_struct_calendar.meetingmemberscount, 
					color = request.a_struct_calendar.color--->
	<cfelse>
		<cfset a_bool_result = application.components.cmp_calendar.UpdateEvent(entrykey = request.a_struct_action.a_str_item_entry_key,
					securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					newvalues = request.a_struct_calendar).result />
	</cfif>

<!--- create/update tasks --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_tasks) IS 0>
	<cfinclude template="inc_parse_task.cfm">
	<cfif a_bool_create>
		<cfset a_bool_result = application.components.cmp_tasks.CreateTask(entrykey = request.a_struct_action.a_str_item_entry_key,
					securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					title = request.a_struct_task.title,
					notice = request.a_struct_task.notice,
					priority = request.a_struct_task.priority,
					percentdone = request.a_struct_task.percentdone,
					status = request.a_struct_task.status,
					projectkeys = request.a_struct_task.projectkeys,
					actualwork = request.a_struct_task.actualwork,
					totalwork = request.a_struct_task.totalwork,
					categories = request.a_struct_task.categories,
					due = request.a_struct_task.due,
					linked_contacts = request.a_struct_task.linked_contacts,
					linked_files = request.a_struct_task.linked_files,
					assignedtouserkeys = request.a_struct_task.assignedtouserkeys,
					dt_start = request.a_struct_task.dt_start)>
	<cfelse>
		<cfset a_bool_result = application.components.cmp_tasks.UpdateEvent(entrykey = request.a_struct_action.a_str_item_entry_key,
					securitycontext = request.a_struct_security_context,
					usersettings = request.stUserSettings,
					newvalues = request.a_struct_task)>
	</cfif>

<!--- create/update notes --->
<cfelseif CompareNoCase(request.a_struct_action.a_str_itemtype, request.a_str_url_identifier_notes) IS 0>
	<cfheader statuscode="404">
	<cfset request.a_struct_response_headers.statuscode = 404>

<cfelse>
	<cfthrow message="Invalid request" detail="Requested type '#request.a_struct_action.a_str_itemtype#' is not supported."/>
</cfif>

<cfif not a_bool_result>
	<cfheader statuscode="409">
	<cfset request.a_struct_response_headers.statuscode = 409>
</cfif>

