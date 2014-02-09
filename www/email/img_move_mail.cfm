<!--- //

	move a mail from folder a to b
	
	
	the clou: this happens in the background so
	that the original screen is NOT touched!!
	
	
	very speedy!! ;-)
	
	// --->
<cfif IsDefined("request.stSecurityContext.myuserid") is false><cfabort></cfif>

<!--- load imap access data ... --->
<cfinclude template="utils/inc_load_imap_access_data.cfm">
	
<cfparam name="url.mailbox" default="" type="string">
<cfparam name="url.id" default="0" type="numeric">
<cfparam name="url.destinationmailbox" default="INBOX.Trash" type="string">
	
<cfinvoke component="/components/email/cmp_tools" method="moveorcopymessage" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="uid" value="#url.id#">
		<cfinvokeargument name="sourcefolder" value="#url.mailbox#">
		<cfinvokeargument name="destinationfolder" value="#url.destinationmailbox#">
		<cfinvokeargument name="copymode" value="false">		
</cfinvoke>

<!--- if we are in the "speed mode", we've also to delete the row from the
	virtual table --->
	
<!--- deliver the dummy image --->
<cfcontent deletefile="no" file="#request.a_str_img_1_1_pixel_location#" type="image/gif">