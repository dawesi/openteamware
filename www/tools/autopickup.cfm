<!--- //

	Module:        Forms
	Description:   Autopickup module
					This templates catches all given content (form.xxx) and
					stores it into the database for further use (e.g. if user
					needs to re - login)
					
					The data is stored and forwarded to the real given action
					page
					
	
	Parameters		form.frmRequestEntrykey
					the request entrykey of the forms module

// --->

<cfparam name="form.frmRequestEntrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_forms#" method="DoAutoPickupData" returnvariable="a_struct_result_autopickup">
	<cfinvokeargument name="requestkey" value="#form.frmRequestEntrykey#">
	<cfinvokeargument name="form_scope" value="#form#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cfif NOT a_struct_result_autopickup.result>
	
	<cfdump var="#a_struct_result_autopickup#">

	<cfswitch expression="#a_struct_result_autopickup.error#">
		<cfcase value="5202">

			<cfset a_str_url = cgi.http_referer />
			<cfset a_str_url = ReplaceOrAddURLParameter(a_Str_url, 'missingfields', a_struct_result_autopickup.missing_fields) />
			<cfset a_str_url = ReplaceOrAddURLParameter(a_Str_url, 'loaddatafromrequestkey', a_struct_result_autopickup.a_str_requestkey) />
			
			<cflocation addtoken="false" url="#a_str_url#">
			<a href="<cfoutput>#a_str_url#</cfoutput>">back to form</a>
		</cfcase>
	</cfswitch>
	
	<cfexit method="exittemplate">
</cfif>

<cflocation addtoken="false" url="#form.frmhttpreferer#">

