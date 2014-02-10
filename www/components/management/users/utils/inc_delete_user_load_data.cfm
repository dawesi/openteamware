<cfparam name="LoadDataRequest.userkey" type="string" default="">

<cfif Len(LoadDataRequest.userkey) IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- load address book --->
<cfinclude template="queries/q_select_contacts.cfm">

<!--- calendar --->
<cfinclude template="queries/q_select_events.cfm">

<!--- email --->

<!--- files --->

<!--- tasks --->
<cfinclude template="queries/q_select_tasks.cfm">


<!--- bookmarks --->

<!--- followups --->

<!--- instant messenger history --->