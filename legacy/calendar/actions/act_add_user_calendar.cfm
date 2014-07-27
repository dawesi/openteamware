<!--- //

	Component:	Calendar
	Function:	DoAddUserCalendarDisplay
	Description:Add a user/resource calendar to display
	
	Header:	

// --->
<cfparam name="url.userkeys" type="string" default="">

<cfif StructKeyExists(url, 'resourcekey')>
	<cfset url.userkeys = url.resourcekey />
</cfif>
	
<!--- load values ... --->

<!--- session timeout? --->
<cfset a_str_person_entryvalue1 = GetUserPrefPerson('calendar', 'display.includeusercalendars', '', '', false) />
	
<cfif Len(a_str_person_entryvalue1) GT 0>
	
	<cfloop list="#url.userkeys#" delimiters="," index="a_str_userkey">
		
		<cfif ListFindNoCase(a_str_person_entryvalue1, a_str_userkey) IS 0>
			<!--- userkey does not exist, add to list now ... --->
			<cfset a_str_person_entryvalue1 = ListPrepend(a_str_person_entryvalue1, a_str_userkey) />
		</cfif>
		
	</cfloop>
<cfelse>
	<cfset a_str_person_entryvalue1 = url.userkeys />
</cfif>

<cfset a_str_person_entryvalue1 = ReplaceNoCase(a_str_person_entryvalue1, request.stSecurityContext.myuserkey, '', 'ALL') />

<cfset a_str_person_entryvalue1 = ReplaceNoCase(a_str_person_entryvalue1, ',,', ',', 'ALL') />
<cfset a_str_person_entryvalue1 = ReplaceNoCase(a_str_person_entryvalue1, ',,', ',', 'ALL') />
<cfset a_str_person_entryvalue1 = ReplaceNoCase(a_str_person_entryvalue1, ',,', ',', 'ALL') />

<!--- set new values ... --->
<cfmodule template="/common/person/saveuserpref.cfm"
	entrysection = "calendar"
	entryname = "display.includeusercalendars"
	entryvalue1 = #a_str_person_entryvalue1#>
	
<cflocation addtoken="false" url="#ReturnRedirectURL()#">
	
