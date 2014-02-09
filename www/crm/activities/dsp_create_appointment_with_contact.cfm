<!--- //

	Module:		CRM
	Action:		CreateAppointmentWithContact
	Description:Create a new appointment with an assigned contact
	

// --->

<cfparam name="url.addressbookkeys" type="string" default="">
<cfparam name="url.assigned_userkey" type="string" default="">

<!--- check if a user has been defined as responsible person ...

	a) no user selected = let this use take the event (and inform)
	
	b) this user is defined as contact = let this use take the event
	
	c) more than one user is responsible ... let the use select which one to take
	
	--->

<cfinvoke component="#application.components.cmp_assigned_items#" method="GetAssignments" returnvariable="q_select_assignments">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkeys" value="#url.addressbookkeys#">
</cfinvoke>	

<cfset a_str_event_subject = '' />
<cfset a_str_event_location = '' />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_filter.entrykeys = url.addressbookkeys />
	
<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#ListGetAt(url.addressbookkeys, 1)#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfset q_select_contact = stReturn.q_select_contact />
<cfset a_str_event_subject = GetLangVal('cal_wd_event') & ' ' & stReturn.q_select_contact.surname />

<!--- default ... forward ... if not assigned to a special person--->
<cfif q_select_assignments.recordcount IS 0>
	<cflocation addtoken="no" url="/calendar/?action=NewEvent&assigned_addressbookkeys=#urlencodedformat(url.addressbookkeys)#&title=#urlencodedformat(a_str_event_subject)#">
</cfif>

<!--- assigned to a certain person ... take the first one --->
<cfif q_select_assignments.recordcount GT 0>
	<cflocation addtoken="no" url="/calendar/?action=NewEvent&assigned_addressbookkeys=#urlencodedformat(url.addressbookkeys)#&assigned_userkey=#q_select_assignments.userkey#&title=#urlencodedformat(a_str_event_subject)#">
</cfif>

<cfif q_select_assignments.recordcount GT 1 AND url.assigned_userkey NEQ ''>
	<cflocation addtoken="no" url="/calendar/?action=NewEvent&assigned_addressbookkeys=#urlencodedformat(url.addressbookkeys)#&assigned_userkey=#url.assigned_userkey#&title=#urlencodedformat(a_str_event_subject)#">
</cfif>

