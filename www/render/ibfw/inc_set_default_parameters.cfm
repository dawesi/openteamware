<!--- //

	Module:        Framework
	Description:   Set default parameters defined in Service Action XML
	

// --->

<cfloop from="1" to="#ArrayLen(request.a_struct_current_service_action.parameters)#" index="a_int_param_id">

	<cfset a_struct_default_param = request.a_struct_current_service_action.parameters[a_int_param_id]>
	
	<!--- get the scope where to set the variable ... --->
	<cfset a_struct_param_scope = GetScopeByScopeName(a_struct_default_param.scope)>
	
	<cfif NOT StructKeyExists(a_struct_param_scope, a_struct_default_param.name)>
		<cflog text="does not exist (required: #a_struct_default_param.required#)" type="Information" log="Application" file="ib_fw_param">		
		
		<!--- if the given variable does not exist, set it! if required but not given, abort request! --->	
		<cfif a_struct_default_param.required IS 1>
		
			<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="invalid call - aborted." type="html">
				current param: <cfdump var="#a_struct_default_param#">
				<cfdump var="#cgi#" label="cgi"><cfdump var="#session#" label="session"><cfdump var="#url#" label="url">
			</cfmail>
			Invalid call to this module. Request has been aborted.
			<br/>
			Ungültiger Aufruf dieses Moduls, Anfrage wurde abgebrochen.
			<cfabort>
			
		<cfelse>
		
			<!--- set to default value ... --->
			<cfset a_struct_param_scope[a_struct_default_param.name] = a_struct_default_param.default>
			
		</cfif>
		
	</cfif>
	
</cfloop>

