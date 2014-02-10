<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
	<cfinvokeargument name="entrykey" value="#arguments.securitycontext.myuserkey#">
</cfinvoke>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_other_userdata">
	<cfinvokeargument name="entrykey" value="#arguments.userkey#">
</cfinvoke>

<!--- get standard address of RECIPIENT --->
<cfinvoke component="/components/email/cmp_accounts" method="GetStandardAddressFromTag" returnvariable="a_str_from_adr">
	<cfinvokeargument name="userkey" value="#arguments.userkey#">
</cfinvoke>

<cfif arguments.urge>
	<cfset a_str_subject_add = 'URGENZ/UEBERFAELLIG: '>
<cfelse>
	<cfset a_str_subject_add = ''>
</cfif>

<cfset a_str_contact_assigned = ''>

<cfif q_select_contact_connections.recordcount GT 0>
	<!--- display contact connections ... --->
	<cfset a_struct_filter = StructNew()>
	<cfset a_struct_filter.entrykeys = valuelist(q_select_contact_connections.contactkey)>

	<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn_contacts">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">	
		<cfinvokeargument name="filter" value="#a_struct_filter#">
		<cfinvokeargument name="convert_lastcontact_utc" value="false">
	</cfinvoke>
	
	<cfset q_select_contacts = stReturn_contacts.q_select_contacts>
	
	<cfsavecontent variable="a_str_contact_assigned">
		<cfoutput query="q_select_contacts">
			#q_select_contacts.surname#, #q_select_contacts.firstname# (#q_select_contacts.company#)
			https://www.openTeamWare.com/rd/c/?#q_select_contacts.entrykey#
		</cfoutput>
	</cfsavecontent>
</cfif>

<cfmail from="#ReplaceNoCase(a_struct_load_userdata.query.firstname, ',', '', 'ALL')# #ReplaceNoCase(a_struct_load_userdata.query.surname, ',', '', 'ALL')# <#a_struct_load_userdata.query.username#>" to="#ReplaceNoCase(a_str_from_adr,',','','ALL')#" subject="#a_str_subject_add# Neue Aufgabe: #htmleditformat(q_select_task.title)#">
<cfmailparam name="X-openTeamWare-notify" value="None">
<cfmailparam name="X-openTeamWare-mailtype" value="Notification">
Guten Tag!

Soeben wurde Ihnen eine Aufgabe von #a_struct_load_userdata.query.username# zugewiesen:

Betreff: #q_select_task.title#

Beschreibung: #q_select_task.notice#

<cfif Len(a_str_contact_assigned) GT 0>
Kontakte: #a_str_contact_assigned#
</cfif>

Faellig: <cfif IsDate(q_select_task.dt_due)>#dateformat(q_select_task.dt_due, 'dd.mm.yyyy')#<cfelse>n/a</cfif>

Kategorien: #q_select_task.categories#

Eintrag online: https://www.openTeamWare.com/rd/t/e/?#urlencodedformat(arguments.taskkey)#
</cfmail>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="q_select_contact_connections" type="html">
<cfdump var="#q_select_contact_connections#">
</cfmail>--->