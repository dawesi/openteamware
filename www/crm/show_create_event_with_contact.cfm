<cfinclude template="../login/check_logged_in.cfm">

<cfparam name="url.addressbookkeys" type="string" default="">
<cfparam name="url.assigned_userkey" type="string" default="">

<!--- check if a user has been defined as responsible person ...

	a) no user selected = let this use take the event (and inform)
	
	b) this user is defined as contact = let this use take the event
	
	c) more than one user is responsible ... let the use select which one to take
	
	--->

<cfinvoke component="#request.a_str_component_assigned_items#" method="GetAssignments" returnvariable="q_select_assignments">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkeys" value="#url.addressbookkeys#">
</cfinvoke>	

<cfset a_str_event_subject = ''>
<cfset a_str_event_location = ''>

<cfif ListLen(url.addressbookkeys)  IS 1>
	<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#url.addressbookkeys#">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	</cfinvoke>
	
	<cfset a_str_event_subject = 'Termin ' & stReturn.q_select_contact.surname>
	
	<cfset a_str_event_location = stReturn.q_select_contact.b_city>
</cfif>

<cfif q_select_assignments.recordcount IS 0>
	<!--- default ... forward ... --->
	<cflocation addtoken="no" url="/calendar/?action=NewEvent&assigned_addressbookkeys=#urlencodedformat(url.addressbookkeys)#&title=#urlencodedformat(a_str_event_subject)#&location=#urlencodedformat(a_str_event_location)#">
</cfif>

<cfif q_select_assignments.recordcount IS 1>
	<cflocation addtoken="no" url="/calendar/?action=NewEvent&assigned_addressbookkeys=#urlencodedformat(url.addressbookkeys)#&assigned_userkey=#q_select_assignments.userkey#&title=#urlencodedformat(a_str_event_subject)#&location=#urlencodedformat(a_str_event_location)#">
</cfif>

<cfif q_select_assignments.recordcount GT 1 AND url.assigned_userkey NEQ ''>
	<cflocation addtoken="no" url="/calendar/?action=NewEvent&assigned_addressbookkeys=#urlencodedformat(url.addressbookkeys)#&assigned_userkey=#url.assigned_userkey#&title=#urlencodedformat(a_str_event_subject)#&location=#urlencodedformat(a_str_event_location)#">
</cfif>

<html>
<head>
<cfinclude template="../style_sheet.cfm">
<title>Termin erstellen</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body style="padding:20px; ">

<cfif request.a_struct_personal_properties.mysex IS 0>
	<cfset a_str_sex = 'Herr '>
<cfelse>
	<cfset a_str_sex = 'Frau '>	
</cfif>
<h4><cfoutput>#a_str_sex##request.a_struct_personal_properties.mysurname#</cfoutput>, in wessen Kalender m&ouml;chten Sie diesen Termin eintragen?</h4>

<ul style="line-height:20px; ">
<cfoutput query="q_select_assignments">
	<li>
		<a href="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&assigned_userkey=#q_select_assignments.userkey#">#application.components.cmp_user.GetUsernamebyentrykey(q_select_assignments.userkey)#</a>
	</li>
</cfoutput>

	<cfif ListFind(ValueList(q_select_assignments.userkey), request.stSecurityContext.myuserkey) IS 0>
	<!--- add to own calendar ... --->
	<li>
		<cfoutput>
		<a href="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&assigned_userkey=#request.stSecurityContext.myuserkey#">In meinen eigenen Kalender</a>	
		</cfoutput>
	</li>
	</cfif>
</ul>

</body>
</html>
