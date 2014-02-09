<!--- //

	Module:		
	Action:		Update an issue
	Description:	
	

// --->

<cfparam name="form.frmapproved" type="numeric" default="0">
<cfparam name="form.frmautogenerate_text_version" type="numeric" default="0">
<cfparam name="form.frmattachmentkeys" type="string" default="">
<cfparam name="form.frmbody_text" type="string" default="">

<!--- auto-generate text or not? --->
<cfif frmautogenerate_text_version IS 1>
	<!--- auto - generate the text version --->
	<cfset form.frmbody_text = StripHTML(form.frmbody_html) />
	<cfset form.frmbody_text = ReplaceNoCase(form.frmbody_text, '&nbsp;', ' ', 'ALL') />
</cfif>

<!--- save or update issue ... --->
<cfinvoke component="#request.a_str_component_newsletter#" method="SaveOrUpdateIssue" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="listkey" value="#form.frmlistkey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="approved" value="#form.frmapproved#">
	<cfinvokeargument name="dt_send" value="#form.frm_date#">
	<cfinvokeargument name="attachmentkeys" value="#form.frmattachmentkeys#">
	<cfinvokeargument name="subject" value="#form.frmsubject#">
	
	<cfinvokeargument name="body_html" value="#form.frmbody_html#">
	<cfinvokeargument name="body_text" value="#form.frmbody_text#">
	<cfinvokeargument name="auto_generate_text_version" value="#form.frmautogenerate_text_version#">
	
	<cfinvokeargument name="issue_name" value="#form.frmissue_name#">
	<cfinvokeargument name="description" value="#form.frmdescription#">
</cfinvoke>

