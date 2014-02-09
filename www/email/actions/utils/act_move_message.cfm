
<cfinclude template="../../utils/inc_load_imap_access_data.cfm">

<cfinvoke component="/components/email/cmp_tools"
		method="moveorcopymessage"
		returnvariable="sReturn">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="sourcefolder" value="#a_struct_parse.data.foldername#">
		<cfinvokeargument name="destinationfolder" value="#a_struct_parse.data.targetmailbox#">
		<cfinvokeargument name="copymode" value="0">
		<cfinvokeargument name="uid" value="#a_struct_parse.data.uid#">
</cfinvoke>