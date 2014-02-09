<!--- //

	Module:		WebDAV Service for SyncML Server
	Description:Default file
	

// --->
<cfparam name="cgi.REQUEST_METHOD" type="string">

<cfinclude template="log/inc_log.cfm">

<!--- structure of the request --->
<cfset request.a_struct_action = StructNew()>

<cfset request.a_ws_contacts = application.components.cmp_addressbook />
<cfset request.a_ws_calendar = application.components.cmp_calendar />
<cfset request.a_ws_tasks = application.components.cmp_tasks />
<cfset request.a_ws_syncml = CreateObject('component', 'cmp_syncml') />

<!--- parse --->
<cfinclude template="inc_parse_request.cfm">

<!--- check security --->
<cfinclude template="inc_check_security.cfm">

<cfswitch expression="#request.a_struct_action.a_str_action#">
	
	<!--- search items ... --->
	<cfcase value="SEARCH">
		<cfinclude template="cmd_search/inc_cmd_search.cfm">
	</cfcase>

	<!--- add/edit properties ... --->
	<cfcase value="PROPPATCH">
		<cfinclude template="cmd_proppatch/inc_cmd_proppatch.cfm">
	</cfcase>
	
	<!--- delete an item --->
	<cfcase value="DELETE">
		<cfinclude template="cmd_delete/inc_cmd_delete.cfm">
	</cfcase>
	
	<cfdefaultcase>
		<cfthrow message="Invalid request" detail="Request method #request.a_struct_action.action# is not supported."/>
	</cfdefaultcase>
</cfswitch>


