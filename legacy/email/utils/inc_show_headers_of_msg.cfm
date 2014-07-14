<cfparam name="url.mailbox" type="string">
<cfparam name="url.uid" type="integer">

<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfinclude template="inc_load_imap_access_data.cfm">

<cfinvoke component="/components/email/cmp_loadmsg" method="LoadMessage" returnvariable="stReturn">
	<cfinvokeargument name="server" value="#request.a_str_imap_host#">
	<cfinvokeargument name="username" value="#request.a_str_imap_username#">
	<cfinvokeargument name="password" value="#request.a_str_imap_password#">
	<cfinvokeargument name="foldername" value="#url.mailbox#">
	<cfinvokeargument name="uid" value="#url.uid#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory_local#">
	<cfinvokeargument name="savecontenttypes" value="hello/you">
</cfinvoke>

<cfset q_select_headers = stReturn.headers>

<div style="height:300px;overflow:scroll; ">
<cfoutput query="q_select_headers">

<b>#htmleditformat(q_select_headers.feld)#</b>
<div style="padding-left:10px; ">#htmleditformat(q_select_headers.wert)#</div>
</cfoutput>
</div>

<div style="padding:10px;text-align:center; ">
	<input type="button" class="btn btn-primary" onClick="CloseSimpleModalDialog();" value="<cfoutput>#GetLangVal('cm_wd_close_btn_caption')#</cfoutput>">
</div>