<!--- //

	Module:		CRM
	Action:		DisplayAddresBookItemHistory
	Description:Display activities and history
	

// --->


<!--- area: emailfaxsms,overview,activities,opportunities,tasks,appointments,all,overview --->
<cfparam name="url.area" type="string" default="summary">

<cfif url.area IS ''>
	<cfset url.area = 'overview'>
</cfif>

<!--- go back how many days?
	0 = all
	--->
<cfparam name="url.days" type="numeric" default="90">

<!--- address book entrykeys (normally, just one) --->
<cfparam name="url.entrykeys" type="string" default="">

<!--- load data of subcontacts? --->
<cfparam name="url.load_data_of_sub_contacts" type="boolean" default="false">

<!--- in manage mode? --->
<cfparam name="url.managemode" type="boolean" default="false">

<!--- rights of user ... --->
<cfparam name="url.rights" type="string" default="read">


<!--- return the simple html to the gethttpobject ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="GetContactActitivitesData" returnvariable="stReturn_history">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykeys" value="#url.entrykeys#">
	<cfinvokeargument name="area" value="#url.area#">
	<cfinvokeargument name="days" value="#url.days#">
	<cfinvokeargument name="managemode" value="#url.managemode#">
	<cfinvokeargument name="rights" value="#url.rights#">
</cfinvoke>

<cfoutput>#stReturn_history.output#</cfoutput>

