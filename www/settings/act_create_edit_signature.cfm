<cfinclude template="/login/check_logged_in.cfm">

<!---<cfif form.frmformat IS 1>
	<cfset form.frm_sig_data = ReplaceNoCase(form.frm_sig_data, '<p>', '', 'ALL')>
	<cfset form.frm_sig_data = ReplaceNoCase(form.frm_sig_data, '</p>', '<br/>', 'ALL')>
	<cfset form.frm_sig_data = ReplaceNoCase(form.frm_sig_data, '<p dir="ltr">', '<br/>', 'ALL')>
	
</cfif>--->

<cfinvoke component="#application.components.cmp_content#" method="CreateUpdateSignature" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="format" value="#val(form.frmformat)#">
	<cfinvokeargument name="email_adr" value="#form.frmemail_adr#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="sig_data" value="#form.frm_sig_data#">
</cfinvoke>

<cflocation addtoken="no" url="index.cfm?action=signatures">