<!--- 

	send an email alert to the desired address
	
	--->
<cfinclude template="../../common/scripts/script_utils.cfm">
	
<cfparam name="attributes.recipient" type="string" default="">
<cfparam name="attributes.userid" type="numeric" default="0">
<cfparam name="attributes.subject" type="string" default="">
<cfparam name="attributes.account" type="string" default="">
<cfparam name="attributes.afrom" type="string" default="">

<cfif Len(extractemailadr(attributes.recipient)) is 0>
	<cfexit method="exittemplate">
</cfif>


<!--- select firstname/surname --->
<cfquery name="q_select_name" datasource="#request.a_str_db_users#">
SELECT firstname,surname,sex FROM users
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">;
</cfquery>

<cfmail to="#attributes.recipient#" from="openTeamWare <KeineAntwortAdresse@openTeamWare.com>" subject="Neue Nachricht auf openTeamWare eingetroffen">
Guten Tag <cfif q_select_name.sex is 0>Herr<cfelse>Frau</cfif> #q_select_name.surname#!

Soeben ist in Ihrem Postfach #attributes.account# eine
neue Nachricht eingetroffen:

      Absender: #attributes.afrom#
       Betreff: #attributes.subject#
	   
Klicken Sie bitte hier um zu Ihrem openTeamWare Postfach zu wechseln:

      http://www.openTeamWare.com/rd/email/inbox/

Ihr openTeamWare Buddy
</cfmail>