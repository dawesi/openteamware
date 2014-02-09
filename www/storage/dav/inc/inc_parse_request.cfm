<!--- //

	Component:	Service
	Function:	Function
	Description:
	
	Header:	

// --->
<!--- set the request action --->
<cfset request.a_struct_action.a_str_action = cgi.REQUEST_METHOD />

<!--- <cfif Len(cgi.PATH_INFO) IS 0>
	<cfthrow message="Invalid Request."  detail="Empty cgi.PATH_INFO"/> 
</cfif>
 --->
<cfset request.a_struct_action.path_info = cgi.PATH_INFO />

<!--- <cfif Right(request.a_struct_action.path_info, 1) NEQ '/'>
	<cfset request.a_struct_action.path_info = request.a_struct_action.path_info & '/'>
</cfif> --->

<!--- parse the original request URI to Exchange server and set the item_entry_key if presented --->
<!--- <cfif request.a_struct_action.a_str_action EQ 'SEARCH' AND ListLen(request.a_struct_action.path_info, '/') NEQ 3>
	<cfthrow message="Invalid Request."  detail="SEARCH request doesn't contain proper value in the query string"/> 
</cfif> --->


