

<cfsetting requesttimeout="20000">

xjf8<br><br>

<cfset a_cmp_nl = CreateObject('component', request.a_str_component_newsletter)>

<cfquery name="q_select" datasource="#request.a_str_db_crm#">
SELECT
	status,
	dt_created,
	subject,
	body_html,
	body_text,
	recipient,
	entrykey,
	listkey,
	issuekey,
	contactkey,
	attachments,
	sender_value,
	replyto,
	open_tracking,
	test_sending
FROM
	newsletter_recipients
WHERE
	status = -1
ORDER BY
	RAND() 
LIMIT
	45
;
</cfquery>

<cfdump var="#ValueList(q_select.recipient)#">

<cfloop query="q_select">
<cfoutput>#q_select.currentrow#: #q_select.recipient#</cfoutput>

<cfset a_str_body_text = q_select.body_text>
<cfset a_str_body_html = q_select.body_html>

<cfif q_select.open_tracking IS 1>
	<!---<cfset a_str_tracking_code = '<div style="height:1px;width:100px;background-URL:(''http://www.openTeamWare.com/nl/t/index.cfm/#q_select.entrykey#/spacer.gif'');"></div></body>'>--->
	<cfset a_str_tracking_code = '<table background="http://www.openTeamWare.com/nl/t/index.cfm/#q_select.entrykey#/spacer.gif" width=100 height=1 border=0/><tr><td>&nbsp;</td></tr></table></body>' />
	<cfset a_str_body_html = ReplaceNoCase(a_str_body_html, '</body>', a_str_tracking_code, 'ONE') />
</cfif>

<cfset a_str_to = q_select.recipient>
<br>
<cftry>
	
	<!--- failed to tag is responsible for gmail spam rating --->
<!--- failto="#q_select.entrykey#@nlbounce.openTeamware.com" --->
<!--- send ... --->
<cfmail mailerid="openTeamware.com Engine" server="mail.inode.at" replyto="#q_select.replyto#" from="#q_select.sender_value#" to="#a_str_to#" subject="#q_select.subject#" charset="utf-8">
<cfif Len(q_select.replyto) GT 0>
	<cfmailparam name="Reply-To" value="#q_select.replyto#">
</cfif>

<!---<cfmailparam name="X-Priority" value="3">--->

<!---<cfmailparam name="Precedence" value="bulk">--->

<cfloop list="#q_select.attachments#" index="a_str_attachment" delimiters=",">
	<!--- attachment ... --->
	<cfset a_struct_attachments = a_cmp_nl.GetNewsletterAttachmentProperties(entrykey = a_str_attachment) />
	
	<!--- <cflog text="a_struct_attachments (fn): #a_struct_attachments.filename_on_disk# (#a_struct_attachments.contenttype#)" type="Information" log="Application" file="ib_newsletter"> --->
	
	<cfif FileExists(a_struct_attachments.filename_on_disk)>
		<cfmailparam file="#a_struct_attachments.filename_on_disk#" type="#a_struct_attachments.contenttype#">
	</cfif>
</cfloop>

<cfmailpart type="text" wraptext="72" charset="utf-8">#a_str_body_text#</cfmailpart>
<cfmailpart type="html" charset="utf-8">#a_str_body_html#</cfmailpart>
</cfmail>

<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>

<cfif q_select.test_sending IS 0>
	<!--- update --->
	<cfquery name="q_update_status" datasource="#request.a_str_db_crm#">
	UPDATE
		newsletter_recipients
	SET
		status = 1,
		dt_sent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.entrykey#">
	;
	</cfquery>
<cfelse>
	<!--- this was just a test sending ... so delete the item now ... --->
	<cfquery name="q_delete_test_sending" datasource="#request.a_str_db_crm#">
	DELETE FROM
		newsletter_recipients
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.entrykey#">
	;
	</cfquery>
</cfif>

</cfloop>