
	

<cfset a_str_person_entryvalue1 = GetUserPrefPerson('calendar', 'display.includeusercalendars', '', '', false) />
	
<!--- cache security contexts of other users ... --->
<cfparam name="session.a_struct_other_securitycontext" type="struct" default="#StructNew()#">
	
<cfset a_struct_user_calendars = StructNew()>

<!--- check if the selected calendars still exist (and permission is given ... --->

<cfif NOT StructKeyExists(request, 'a_cmp_calendar')>
	<cfset request.a_cmp_calendar = application.components.cmp_calendar>
</cfif>

<cfif NOT StructKeyExists(request, 'a_cmp_users')>
	<cfset request.a_cmp_users = application.components.cmp_user>
</cfif>

<cfloop list="#a_str_person_entryvalue1#" delimiters="," index="a_str_userkey">

	<cfinvoke component="#request.a_cmp_users#" method="UserkeyExists" returnvariable="a_bol_user_exists">
		<cfinvokeargument name="userkey" value="#a_str_userkey#">
	</cfinvoke>
	
	<cfif a_bol_user_exists>
	
		<!--- check if if security context is already saved ... --->
		<cfif NOT StructKeyExists(session.a_struct_other_securitycontext, a_str_userkey)>
		
			<!--- reload --->
			<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn_userkey">
				<cfinvokeargument name="userkey" value="#a_str_userkey#">
			</cfinvoke>
			
			<cfset session.a_struct_other_securitycontext[a_str_userkey] = stReturn_userkey>
		<cfelse>
			<cfset stReturn_userkey = session.a_struct_other_securitycontext[a_str_userkey]>
		</cfif>
		
		<cfinvoke component="#request.a_cmp_users#" method="GetUsersettings" returnvariable="stReturn_usersettings">
			<cfinvokeargument name="userkey" value="#a_str_userkey#">
		</cfinvoke>	
	
		<cfinvoke component="#request.a_cmp_calendar#" method="GetEventsFromTo" returnvariable="a_struct_user_return">
			<cfinvokeargument name="startdate" value="#request.a_dt_utc_current_date#">
			<cfinvokeargument name="enddate" value="#DateAdd('d', 1, request.a_dt_utc_current_date)#">
			<cfinvokeargument name="securitycontext" value="#stReturn_userkey#">
			<cfinvokeargument name="usersettings" value="#stReturn_usersettings#">
            <cfinvokeargument name="loadeventofsubscribedcalendars" value="false">
		</cfinvoke>
		
		<cfset a_struct_user_calendars[a_str_userkey] = a_struct_user_return>
		
		<!--- ? select meeting members ... ? --->
		<cfset SelectMeetingMembersAtOnline.q_select_events = a_struct_user_return.q_select_events>
		<cfinclude template="inc_select_meeting_members_at_once.cfm">
	
	<!---<cfif cgi.REMOTE_ADDR IS '62.99.232.51'>
		<cfdump var="#a_struct_user_return#" expand="no">
	</cfif>--->
	
	</cfif>
</cfloop>
