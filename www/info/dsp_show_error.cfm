<!--- //

	Module:		Info
	Action:		ShowError
	Description:Show an error message

// --->

<cfparam name="url.errorno" type="string" default="">
<cfparam name="url.additionalmessage" type="string" default="">

<!--- log exception ... --->
<cfset a_str_exception_key = application.components.cmp_log.LogException(error = url,
				session = session, message = url.errorno,
				cgi = cgi) />

<cfset a_str_error_msg = GetLangVal('cm_ph_error_msg_' & url.errorno) />

<cfif Len(a_str_error_msg) GT 0>
	<cfoutput>#a_str_error_msg#</cfoutput>
</cfif>
<cfdump var="#request#">
<h4>An error occured / Ein Fehler ist aufgetreten</h4>
<cfoutput>
<a href="default.cfm?action=FileBugReport&exceptionkey=#a_str_exception_key#&errorno=#urlencodedformat(url.errorno)#"><img src="/images/si/bug.png" class="si_img" /> Klicken Sie hier um den Bug zu melden.</a>
</cfoutput>