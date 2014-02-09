<!--- //

	someone wants to unsubscribe ...
	
	// --->
	

<!--- the listkey --->
<cfparam name="url.l" type="string" default="">

<!--- the recipient key (entrykey) --->
<cfparam name="url.e" type="string" default="">
	
<!--- display message or forward to a specified page? --->

<cfinvoke component="#application.components.cmp_newsletter#" method="UnsubscribeUser" returnvariable="a_return">
	<cfinvokeargument name="listkey" value="#url.l#">
	<cfinvokeargument name="recipientkey" value="#url.e#">
</cfinvoke>

<cfif NOT a_return.result>
	<h4>You have not been found in our database. Please contact feedback@openTeamWare.com for further instructions.</h4>
	<cfabort>
</cfif>

<!--- load profile ... --->
<cfinvoke component="#application.components.cmp_newsletter#" method="GetSimpleNewsletterprofile" returnvariable="stReturn_profile">
	<cfinvokeargument name="entrykey" value="#url.l#">	
</cfinvoke>

<cfif Len(stReturn_profile.confirmation_url_unsubscribed) GT 0>
<!--- load newsletter_profile properties ... --->

<html>
	<head>
		<title>Unsubscribed.</title>
		
		<script type="text/javascript">
			function ForwardToConfirmationPage()
				{
				document.form_forward.submit();
				}
		</script>
	</head>
	<body onLoad="ForwardToConfirmationPage();">
		
		<form action="<cfoutput>#stReturn_profile.confirmation_url_unsubscribed#</cfoutput>" method="post" name="form_forward">
			<input type="hidden" name="frm_emailadr" value="<cfoutput>#htmleditformat(a_return.q_Select_recipient.recipient)#</cfoutput>">
			<a href="javascript:ForwardToConfirmationPage();">Click here to continue ...</a>
		</form>
		
	</body>
</html>
<cfelse>
	<html>
		<head>
			<cfinclude template="/style_sheet.cfm">
			<title>Unsubscribed.</title>
		</head>
		<body style="padding:40px; ">
			<h4>Sie wurden erfolgreich abgemeldet / You have been successfully unsubscribed.</h4>
			<br><br>
			
		</body>		
	</html>
</cfif>