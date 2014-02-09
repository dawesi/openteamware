<!--- email adresse --->
<cfparam name="url.subaction" default="ShowAll">

<cfswitch expression="#url.subaction#">
	
	<cfcase value="ShowAll">
	<!--- alle anzeigen --->
	<cfinclude template="dsp_email_all_accounts.cfm">	
	</cfcase>
	
	<cfcase value="CreateNewEmailAdr">
	<!--- neuen account erstellen --->
	<cfinclude template="dsp_email_all_create_account.cfm">
	</cfcase>
	
	<cfcase value="RequestConfirmCode">
	<!--- code schicken --->
	<cfmodule template="mod_send_email_confirm.cfm" id=#val(url.id)# userid=#request.stSecurityContext.myuserid# username=#request.stSecurityContext.myuserid#>
	<cflocation addtoken="No" url="default.cfm?action=ExternalEmail">
	</cfcase>
	
	<cfcase value="DeleteAccount">
	<!--- account l&ouml;schen --->
	<cfinclude template="dsp_email_delete.cfm">
	</cfcase>
	
	<cfcase value="checkconfirmcode">
	<!--- code checken --->
	<cfinclude template="dsp_email_check_confirm_code.cfm">
	</cfcase>
	
	<cfcase value="EditAccount">
	<!--- account editieren --->
	<cfinclude template="dsp_email_edit_account.cfm">
	</cfcase>
	
	<cfcase value="ChangeInBoxccEmailAccount">
	<cfinclude template="dsp_email_edit_inboxcc_account.cfm">
	</cfcase>



</cfswitch>