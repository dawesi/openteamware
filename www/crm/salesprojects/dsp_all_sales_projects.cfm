<!--- //

	display an overview of all open sales projects
	
	// --->
	
<cfset SetHeaderTopInfoString(GetLangVal('crm_ph_sales_projects'))>

<br/>


<cfparam name="url.editmode" type="boolean" default="false">
<cfparam name="url.entrykeys" type="string" default="">
<cfparam name="url.rights" type="string" default="read">
<cfparam name="url.contactkeys" type="string" default="">


<cfsavecontent variable="a_str_buttons">

</cfsavecontent>


<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.responsibleuserkeys = request.stSecurityContext.myuserkey>

<cfinvoke component="#request.a_str_component_crm_sales#" method="DisplaySalesProjects" returnvariable="a_str_sales_projects">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.contactkeys#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="managemode" value="#url.editmode#">
	<cfinvokeargument name="rights" value="#url.rights#">
	<cfinvokeargument name="parameters" value="displayallcolumns">
</cfinvoke>

<cfoutput>#WriteNewContentBox(GetLangval('crm_ph_sales_projects'), a_str_buttons, a_str_sales_projects)#</cfoutput>
<br/>

<!--- display pie bar ... --->

