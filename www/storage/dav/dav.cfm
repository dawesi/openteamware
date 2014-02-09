<!--- //

	Component:	Service
	Function:	Function
	Description:
	
	Header:	

// --->


<!--- parse request ... --->
<cfinclude template="inc/inc_parse_request.cfm">


<!--- security ... --->

<cfswitch expression="#request.a_struct_action.a_str_action#">
	<cfcase value="GET">
	
	</cfcase>
	<cfcase value="PROPFIND">
	
	</cfcase>
	
	<cfcase value="OPTIONS">
		<cfinclude template="commands/inc_cmd_options.cfm">
	</cfcase>
	<cfcase value="PUT">
	
	</cfcase>
	<cfcase value="PROPPATCH">
	
	</cfcase>
	<cfcase value="DELETE">
	
	</cfcase>
</cfswitch>

