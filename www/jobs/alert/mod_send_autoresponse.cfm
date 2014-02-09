<!--- //

	send out the autoresponse
	
	// --->
<cfprocessingdirective pageencoding="ISO-8859-1"> 
	
<cfparam name="attributes.afrom" type="string" default="">
<cfparam name="attributes.username" type="string" default="">
<cfparam name="attributes.awaymsg" type="string" default="">
<cfparam name="attributes.recipient" type="string" default="">

<cfif len(attributes.awaymsg) is 0>
	<cfset attributes.awaymsg = "Ihre Nachricht ist eingetroffen und wird so bald als m�glich bearbeitet.">
</cfif>

<cftry>
<cfmail from="#attributes.afrom#" mailerid="Autoresponder Software" to="#attributes.recipient#"  subject="Automatische Antwort/Autoresponse">
<cfmailparam name="Sender" value="#attributes.username#">
<cfmailparam name="Content-Type" value="text/plain;charset=ISO-8859-1">
#attributes.awaymsg#

-----------------------------------------------------------------
Wichtiger Hinweis: Dies ist eine automatisch generierte Antwort
    Please notice: This is an answer sent by an autoresponder
-----------------------------------------------------------------

powered by openTeamWare (http://www.openTeamWare.com/) 
</cfmail>

<cfcatch type="any">

</cfcatch>
</cftry>