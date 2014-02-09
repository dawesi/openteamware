<!--- //

	Module:		Email
	Description:cancel a message
	

// --->
<!--- cancel a message ... --->
<cfif val(form.frmDraftId) gt 0>
	<!--- delete now draft message --->
	<cfinvoke component="#application.components.cmp_email#" method="deletemessages" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="INBOX.Drafts">
		<cfinvokeargument name="uids" value="#form.frmDraftId#">
	</cfinvoke>
</cfif>

<html>
	<head>
		<title>Mail</title>
		<script type="text/javascript">
			function doClose() {window.close();}
		</script>
	</head>
<body onload="doClose();">
<a href="#" onclick="doClose();return false;">Close</a>
</body>
</html>

