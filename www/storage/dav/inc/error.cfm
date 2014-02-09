<!--- //

	Module:		WebDAV Error handling
	Description: 
	

// --->

<cfset tmp = application.components.cmp_log.LogException(error = error,
				session = session,
				message = error.message,
				url = url,
				form = form,
				cgi = cgi) />

