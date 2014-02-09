<!--- set the request action --->
<cfset request.a_struct_action.a_str_action = cgi.REQUEST_METHOD>

<cfif cgi.REQUEST_METHOD IS 'GET'>
	<cfheader statuscode="500" statustext="Method not supported.">
	<cfabort>
</cfif>

<cfif Len(cgi.PATH_INFO) IS 0>
	<cfthrow message="Invalid Request."  detail="Empty cgi.PATH_INFO"/> 
</cfif>

<cfset request.a_struct_action.path_info = cgi.PATH_INFO>

<cfif Right(request.a_struct_action.path_info, 1) NEQ '/'>
	<cfset request.a_struct_action.path_info = request.a_struct_action.path_info & '/'>
</cfif>

<!--- parse the original request URI to Exchange server and set the item_entry_key if presented --->
<cfif request.a_struct_action.a_str_action EQ 'SEARCH' AND ListLen(request.a_struct_action.path_info, '/') NEQ 3>
	<cfthrow message="Invalid Request."  detail="SEARCH request doesn't contain proper value in the query string"/> 
</cfif>

<cfif request.a_struct_action.a_str_action IS 'PROPFIND'>
	<cfinclude template="cmp_propfind/inc_cmd_propfind.cfm">
	
	<cfabort>
</cfif>

<!--- PROPPATCH or DELETE --->
<cfif (request.a_struct_action.a_str_action EQ 'PROPPATCH') OR (request.a_struct_action.a_str_action EQ 'DELETE')>


	<cfif ListLen(cgi.PATH_INFO, '/') NEQ 4 >
		<cfthrow message="Invalid Request."  detail="PROPPATCH or DELETE request doesn't contain proper value in the query string"> 
	</cfif>
	
	<cfset a_str_entry_key = Trim(ListGetAt(cgi.PATH_INFO, 4, '/'))>
	
	<cfif (Len(a_str_entry_key) GT 0) AND Right(a_str_entry_key, 4) NEQ '.eml'>
		<cfset request.a_struct_action.a_str_item_entry_key = a_str_entry_key>
	</cfif>
	
</cfif>

<!--- set the item type: contacts,calendar,tasks,notes --->
<cfset a_str_item_type = 'unknown'>
<cfset a_str_item_type = ListGetAt(cgi.PATH_INFO, 3, '/')>
<cfif ListFind('contacts,calendar,tasks,notes', a_str_item_type) IS 0>
	<cfthrow message="Invalid Request."  detail="query string doesn't match any of the predefined targets (contacts, calendar, tasks, notes)"/> 
</cfif>
<cfset request.a_struct_action.a_str_itemtype = a_str_item_type>

<!--- set the user name --->
<cfset request.a_struct_action.a_str_username = ListGetAt(cgi.PATH_INFO, 2, '/')>

<!--- parse request body... --->
<cfif request.a_struct_action.a_str_action NEQ 'DELETE'>
	<cfset a_request_body = GetHttpRequestData().content>
	<cftry>
		<cfset request.a_struct_action.a_xml_obj = XmlParse(a_request_body)>
		
		<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="incoming xml request" type="html">
			<cfdump var="#request.a_struct_action#">
		</cfmail>--->
	<cfcatch type="any"> 
		<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="incoming invalid xml request (syncml)" type="html">
			<cfdump var="#cgi#" label="cgi">
			<cfdump var="#GetHttpRequestData()#" label="a_request_body">
		</cfmail>
		<cfthrow message="Invalid Request" detail="Message body doesn't contain valid XML"/>
	</cfcatch>
	</cftry>
</cfif>

